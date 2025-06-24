# maintenance/models.py

from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from ambulances.models import Ambulance
from accounts.models import DriverProfile

class MaintenanceRequest(models.Model):
    """Model untuk request maintenance ambulans"""
    REQUEST_TYPE_CHOICES = [
        ('routine', 'Routine Maintenance'),
        ('repair', 'Repair'),
        ('inspection', 'Safety Inspection'),
        ('emergency', 'Emergency Repair'),
        ('preventive', 'Preventive Maintenance'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'Pending Review'),
        ('approved', 'Approved'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
        ('rejected', 'Rejected'),
        ('cancelled', 'Cancelled'),
    ]
    
    PRIORITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]
    
    # Basic Info
    request_id = models.CharField(max_length=20, unique=True, editable=False)
    ambulance = models.ForeignKey(Ambulance, on_delete=models.CASCADE, related_name='maintenance_requests')
    requested_by = models.ForeignKey(DriverProfile, on_delete=models.CASCADE, related_name='maintenance_requests')
    request_type = models.CharField(max_length=20, choices=REQUEST_TYPE_CHOICES)
    priority = models.CharField(max_length=20, choices=PRIORITY_CHOICES, default='medium')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    
    # Description
    title = models.CharField(max_length=200)
    description = models.TextField()
    symptoms = models.TextField(blank=True)  # gejala kerusakan
    current_mileage = models.PositiveIntegerField()
    
    # Maintenance Details
    estimated_cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    actual_cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    estimated_duration = models.CharField(max_length=100, blank=True)  # estimasi waktu (contoh: "2-3 hari")
    parts_needed = models.TextField(blank=True)
    external_vendor = models.CharField(max_length=200, blank=True)  # jika menggunakan vendor luar
    
    # Admin Response
    reviewed_by = models.ForeignKey(
        User, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='reviewed_maintenance_requests'
    )
    admin_notes = models.TextField(blank=True)
    rejection_reason = models.TextField(blank=True)
    
    # Timestamps
    requested_at = models.DateTimeField(default=timezone.now)
    reviewed_at = models.DateTimeField(null=True, blank=True)
    work_started_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    # Completion Info
    work_performed = models.TextField(blank=True)
    parts_used = models.TextField(blank=True)
    technician_notes = models.TextField(blank=True)
    is_ambulance_operational = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def save(self, *args, **kwargs):
        # Generate request ID
        if not self.request_id:
            from datetime import datetime
            timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
            self.request_id = f"MAINT{timestamp}"
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.request_id} - {self.ambulance.license_plate} ({self.get_status_display()})"
    
    def get_duration(self):
        """Hitung durasi maintenance"""
        if self.work_started_at and self.completed_at:
            return self.completed_at - self.work_started_at
        return None
    
    class Meta:
        verbose_name = "Maintenance Request"
        verbose_name_plural = "Maintenance Requests"
        ordering = ['-requested_at']


class MaintenanceStatusLog(models.Model):
    """Log untuk tracking perubahan status maintenance"""
    maintenance_request = models.ForeignKey(
        MaintenanceRequest, 
        on_delete=models.CASCADE, 
        related_name='status_logs'
    )
    previous_status = models.CharField(max_length=20, blank=True)
    new_status = models.CharField(max_length=20)
    changed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    timestamp = models.DateTimeField(default=timezone.now)
    notes = models.TextField(blank=True)
    
    def __str__(self):
        return f"{self.maintenance_request.request_id}: {self.previous_status} → {self.new_status}"
    
    class Meta:
        verbose_name = "Maintenance Status Log"
        verbose_name_plural = "Maintenance Status Logs"
        ordering = ['-timestamp']


class MaintenanceSchedule(models.Model):
    """Model untuk jadwal maintenance rutin"""
    SCHEDULE_TYPE_CHOICES = [
        ('daily', 'Daily Check'),
        ('weekly', 'Weekly Inspection'),
        ('monthly', 'Monthly Service'),
        ('quarterly', 'Quarterly Maintenance'),
        ('annual', 'Annual Inspection'),
    ]
    
    ambulance = models.ForeignKey(Ambulance, on_delete=models.CASCADE, related_name='maintenance_schedules')
    schedule_type = models.CharField(max_length=20, choices=SCHEDULE_TYPE_CHOICES)
    description = models.TextField()
    frequency_days = models.PositiveIntegerField()  # setiap berapa hari
    last_performed = models.DateTimeField(null=True, blank=True)
    next_due = models.DateTimeField()
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    
    def __str__(self):
        return f"{self.ambulance.license_plate} - {self.get_schedule_type_display()}"
    
    def is_overdue(self):
        return timezone.now() > self.next_due
    
    class Meta:
        verbose_name = "Maintenance Schedule"
        verbose_name_plural = "Maintenance Schedules"
        ordering = ['next_due']