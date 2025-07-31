from django.contrib import admin
from .models import Ambulance, AmbulanceAssignment

@admin.register(Ambulance)
class AmbulanceAdmin(admin.ModelAdmin):
    list_display = ['license_plate', 'ambulance_type', 'brand', 'model', 'status', 'current_driver', 'is_active']
    list_filter = ['ambulance_type', 'status', 'brand', 'is_active']
    search_fields = ['license_plate', 'brand', 'model']
    readonly_fields = ['created_at', 'updated_at']

@admin.register(AmbulanceAssignment)
class AmbulanceAssignmentAdmin(admin.ModelAdmin):
    list_display = ['driver', 'ambulance', 'assigned_date', 'end_date', 'is_active']
    list_filter = ['is_active', 'assigned_date']
    search_fields = ['driver__user__username', 'ambulance__license_plate']