from rest_framework import serializers
from .models import MaintenanceRequest, MaintenanceStatusLog, MaintenanceSchedule

class MaintenanceRequestCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceRequest
        fields = [
            'ambulance', 'request_type', 'priority', 'title', 'description',
            'symptoms', 'current_mileage', 'estimated_duration', 'parts_needed'
        ]
    
    def create(self, validated_data):
        user = self.context['request'].user
        if hasattr(user, 'driver_profile'):
            validated_data['requested_by'] = user.driver_profile
        else:
            raise serializers.ValidationError("Only drivers can create maintenance requests")
        return super().create(validated_data)

class MaintenanceRequestListSerializer(serializers.ModelSerializer):
    ambulance_plate = serializers.CharField(source='ambulance.license_plate', read_only=True)
    requested_by_name = serializers.CharField(source='requested_by.user.get_full_name', read_only=True)
    reviewed_by_name = serializers.CharField(source='reviewed_by.get_full_name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    request_type_display = serializers.CharField(source='get_request_type_display', read_only=True)
    
    class Meta:
        model = MaintenanceRequest
        fields = [
            'id', 'request_id', 'ambulance_plate', 'requested_by_name', 
            'title', 'request_type', 'request_type_display', 'priority', 
            'priority_display', 'status', 'status_display', 'requested_at',
            'reviewed_by_name', 'completed_at'
        ]

class MaintenanceRequestDetailSerializer(serializers.ModelSerializer):
    ambulance_details = serializers.SerializerMethodField()
    requested_by_details = serializers.SerializerMethodField()
    reviewed_by_details = serializers.SerializerMethodField()
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    request_type_display = serializers.CharField(source='get_request_type_display', read_only=True)
    duration = serializers.SerializerMethodField()
    
    class Meta:
        model = MaintenanceRequest
        fields = '__all__'
    
    def get_ambulance_details(self, obj):
        return {
            'id': obj.ambulance.id,
            'license_plate': obj.ambulance.license_plate,
            'type': obj.ambulance.get_ambulance_type_display(),
            'brand': obj.ambulance.brand,
            'model': obj.ambulance.model
        }
    
    def get_requested_by_details(self, obj):
        return {
            'id': obj.requested_by.id,
            'name': obj.requested_by.user.get_full_name(),
            'phone': obj.requested_by.phone_number
        }
    
    def get_reviewed_by_details(self, obj):
        if obj.reviewed_by:
            return {
                'id': obj.reviewed_by.id,
                'name': obj.reviewed_by.get_full_name(),
                'username': obj.reviewed_by.username
            }
        return None
    
    def get_duration(self, obj):
        duration = obj.get_duration()
        if duration:
            total_seconds = int(duration.total_seconds())
            hours = total_seconds // 3600
            minutes = (total_seconds % 3600) // 60
            return f"{hours}h {minutes}m"
        return None

class MaintenanceRequestUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceRequest
        fields = [
            'status', 'admin_notes', 'rejection_reason', 'estimated_cost',
            'actual_cost', 'external_vendor', 'work_performed', 'parts_used',
            'technician_notes', 'is_ambulance_operational'
        ]
    
    def update(self, instance, validated_data):
        old_status = instance.status
        new_status = validated_data.get('status', instance.status)
        
        instance = super().update(instance, validated_data)
        
        if old_status != new_status:
            MaintenanceStatusLog.objects.create(
                maintenance_request=instance,
                previous_status=old_status,
                new_status=new_status,
                changed_by=self.context['request'].user,
                notes=validated_data.get('admin_notes', '')
            )
            
            from django.utils import timezone
            now = timezone.now()
            
            if new_status == 'approved':
                instance.reviewed_at = now
                instance.reviewed_by = self.context['request'].user
            elif new_status == 'in_progress':
                instance.work_started_at = now
            elif new_status == 'completed':
                instance.completed_at = now
                if validated_data.get('is_ambulance_operational', True):
                    instance.ambulance.status = 'available'
                else:
                    instance.ambulance.status = 'out_of_service'
                instance.ambulance.save()
            elif new_status == 'rejected':
                instance.reviewed_at = now
                instance.reviewed_by = self.context['request'].user
            
            instance.save()
        
        return instance

class MaintenanceScheduleSerializer(serializers.ModelSerializer):
    ambulance_plate = serializers.CharField(source='ambulance.license_plate', read_only=True)
    schedule_type_display = serializers.CharField(source='get_schedule_type_display', read_only=True)
    is_overdue_status = serializers.BooleanField(source='is_overdue', read_only=True)
    
    class Meta:
        model = MaintenanceSchedule
        fields = '__all__'