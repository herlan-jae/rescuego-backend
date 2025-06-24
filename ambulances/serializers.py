from rest_framework import serializers
from .models import Ambulance, AmbulanceAssignment

class AmbulanceSerializer(serializers.ModelSerializer):
    current_driver_name = serializers.CharField(source='current_driver.user.get_full_name', read_only=True)
    ambulance_type_display = serializers.CharField(source='get_ambulance_type_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    is_available_status = serializers.BooleanField(source='is_available', read_only=True)
    
    class Meta:
        model = Ambulance
        fields = '__all__'

class AmbulanceAssignmentSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.user.get_full_name', read_only=True)
    ambulance_plate = serializers.CharField(source='ambulance.license_plate', read_only=True)
    
    class Meta:
        model = AmbulanceAssignment
        fields = '__all__'
