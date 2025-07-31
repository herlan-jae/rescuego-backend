from django.contrib import admin
from .models import UserProfile, DriverProfile

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'phone_number', 'city', 'created_at']
    list_filter = ['city', 'created_at']
    search_fields = ['user__username', 'user__first_name', 'user__last_name', 'phone_number']
    readonly_fields = ['created_at', 'updated_at']

@admin.register(DriverProfile)
class DriverProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'driver_license_number', 'phone_number', 'city', 'status', 'is_active']
    list_filter = ['status', 'city', 'is_active', 'hire_date']
    search_fields = ['user__username', 'user__first_name', 'user__last_name', 'driver_license_number']
    readonly_fields = ['created_at', 'updated_at']