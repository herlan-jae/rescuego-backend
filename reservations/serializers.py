from rest_framework import serializers
from .models import Reservation, ReservationStatusLog
from ambulances.models import Ambulance
from accounts.models import DriverProfile

class ReservationCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reservation
        fields = [
            'emergency_type', 'priority', 'patient_name', 'patient_age', 
            'patient_gender', 'patient_condition', 'medical_history', 
            'current_symptoms', 'pickup_address', 'pickup_city',
            'pickup_latitude', 'pickup_longitude', 'destination_address',
            'destination_city', 'destination_latitude', 'destination_longitude',
            'emergency_contact_name', 'emergency_contact_phone', 
            'emergency_contact_relationship', 'special_requirements'
        ]
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)
    
class NestedDriverSerializer(serializers.ModelSerializer):
    """Serializer ringan untuk menampilkan info dasar supir."""
    full_name = serializers.CharField(source='user.get_full_name')
    class Meta:
        model = DriverProfile
        fields = ['id', 'full_name']

class NestedAmbulanceSerializer(serializers.ModelSerializer):
    """Serializer ringan untuk menampilkan info dasar ambulans."""
    class Meta:
        model = Ambulance
        fields = ['id', 'license_plate']

class ReservationListSerializer(serializers.ModelSerializer):
    """Serializer untuk daftar reservasi yang menyertakan detail bersarang."""
    assigned_driver_details = NestedDriverSerializer(source='assigned_driver', read_only=True, allow_null=True)
    assigned_ambulance_details = NestedAmbulanceSerializer(source='assigned_ambulance', read_only=True, allow_null=True)
    patient_name = serializers.CharField(source='user.get_full_name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = Reservation
        fields = [
            'id',
            'patient_name',
            'status',
            'status_display',
            'requested_at',
            'destination_address',
            'assigned_driver_details', 
            'assigned_ambulance_details',
        ]

class AvailableDriverSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = DriverProfile
        fields = ['id', 'full_name', 'status_display']

class AvailableAmbulanceSerializer(serializers.ModelSerializer):
    type = serializers.CharField(source='get_ambulance_type_display', read_only=True)
    class Meta:
        model = Ambulance
        fields = ['id', 'license_plate', 'type']

class ReservationDetailSerializer(serializers.ModelSerializer):
    user_details = serializers.SerializerMethodField()
    assigned_driver_details = serializers.SerializerMethodField()
    assigned_ambulance_details = serializers.SerializerMethodField()
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    priority_display = serializers.CharField(source='get_priority_display', read_only=True)
    emergency_type_display = serializers.CharField(source='get_emergency_type_display', read_only=True)
    duration = serializers.SerializerMethodField()
    
    class Meta:
        model = Reservation
        fields = '__all__'
    
    def get_user_details(self, obj):
        return {
            'id': obj.user.id,
            'name': obj.user.get_full_name(),
            'username': obj.user.username,
            'email': obj.user.email
        }
    
    def get_assigned_driver_details(self, obj):
        if obj.assigned_driver:
            return {
                'id': obj.assigned_driver.id,
                'name': obj.assigned_driver.user.get_full_name(),
                'phone': obj.assigned_driver.phone_number,
                'license_number': obj.assigned_driver.driver_license_number
            }
        return None
    
    def get_assigned_ambulance_details(self, obj):
        if obj.assigned_ambulance:
            return {
                'id': obj.assigned_ambulance.id,
                'license_plate': obj.assigned_ambulance.license_plate,
                'type': obj.assigned_ambulance.get_ambulance_type_display(),
                'brand': obj.assigned_ambulance.brand,
                'model': obj.assigned_ambulance.model
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

class ReservationStatusUpdateSerializer(serializers.ModelSerializer):
    driver_notes = serializers.CharField(required=False, allow_blank=True)
    
    class Meta:
        model = Reservation
        fields = ['status', 'driver_notes']
    
    def update(self, instance, validated_data):
        old_status = instance.status
        new_status = validated_data.get('status', instance.status)
        
        instance = super().update(instance, validated_data)
        
        if old_status != new_status:
            ReservationStatusLog.objects.create(
                reservation=instance,
                previous_status=old_status,
                new_status=new_status,
                changed_by=self.context['request'].user,
                notes=validated_data.get('driver_notes', '')
            )
            
            from django.utils import timezone
            now = timezone.now()
            
            if new_status == 'accepted':
                instance.accepted_at = now
            elif new_status == 'picking_up':
                instance.pickup_started_at = now
            elif new_status == 'on_route':
                instance.patient_picked_up_at = now
            elif new_status == 'completed':
                instance.completed_at = now
            
            instance.save()
        
        return instance

class ReservationAssignmentSerializer(serializers.Serializer):
    driver_id = serializers.IntegerField()
    ambulance_id = serializers.IntegerField()
    
    def validate_driver_id(self, value):
        try:
            driver = DriverProfile.objects.get(id=value, is_active=True)
            if driver.status != 'available':
                raise serializers.ValidationError("Driver is not available")
        except DriverProfile.DoesNotExist:
            raise serializers.ValidationError("Driver not found")
        return value
    
    def validate_ambulance_id(self, value):
        try:
            ambulance = Ambulance.objects.get(id=value, is_active=True)
            if not ambulance.is_available():
                raise serializers.ValidationError("Ambulance is not available")
        except Ambulance.DoesNotExist:
            raise serializers.ValidationError("Ambulance not found")
        return value

class ReservationStatusLogSerializer(serializers.ModelSerializer):
    changed_by_name = serializers.CharField(source='changed_by.get_full_name', read_only=True)
    
    class Meta:
        model = ReservationStatusLog
        fields = '__all__'