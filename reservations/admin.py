# reservations/admin.py
from django.contrib import admin
from .models import Reservation, ReservationStatusLog

@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = ['reservation_id', 'patient_name', 'user', 'status', 'priority', 'assigned_driver', 'requested_at']
    list_filter = ['status', 'priority', 'emergency_type', 'payment_status', 'requested_at']
    search_fields = ['reservation_id', 'patient_name', 'user__username', 'pickup_city', 'destination_city']
    readonly_fields = ['reservation_id', 'created_at', 'updated_at']
    date_hierarchy = 'requested_at'

@admin.register(ReservationStatusLog)
class ReservationStatusLogAdmin(admin.ModelAdmin):
    list_display = ['reservation', 'previous_status', 'new_status', 'changed_by', 'timestamp']
    list_filter = ['new_status', 'timestamp']
    search_fields = ['reservation__reservation_id']
    readonly_fields = ['timestamp']