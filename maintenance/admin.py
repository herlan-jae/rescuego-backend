# maintenance/admin.py
from django.contrib import admin
from .models import MaintenanceRequest, MaintenanceStatusLog, MaintenanceSchedule

@admin.register(MaintenanceRequest)
class MaintenanceRequestAdmin(admin.ModelAdmin):
    list_display = ['request_id', 'ambulance', 'requested_by', 'request_type', 'priority', 'status', 'requested_at']
    list_filter = ['request_type', 'priority', 'status', 'requested_at']
    search_fields = ['request_id', 'ambulance__license_plate', 'title']
    readonly_fields = ['request_id', 'created_at', 'updated_at']
    date_hierarchy = 'requested_at'

@admin.register(MaintenanceStatusLog)
class MaintenanceStatusLogAdmin(admin.ModelAdmin):
    list_display = ['maintenance_request', 'previous_status', 'new_status', 'changed_by', 'timestamp']
    list_filter = ['new_status', 'timestamp']
    readonly_fields = ['timestamp']

@admin.register(MaintenanceSchedule)
class MaintenanceScheduleAdmin(admin.ModelAdmin):
    list_display = ['ambulance', 'schedule_type', 'next_due', 'is_active']
    list_filter = ['schedule_type', 'is_active']
    search_fields = ['ambulance__license_plate']