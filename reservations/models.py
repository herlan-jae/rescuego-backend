# reservations/models.py

from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from ambulances.models import Ambulance
from accounts.models import DriverProfile

class Reservation(models.Model):
    """Model untuk reservasi ambulans"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('picking_up', 'Picking Up Patient'),
        ('on_route', 'On Route to Destination'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
        ('rejected', 'Rejected'),
    ]
    
    PRIORITY_CHOICES = [
        ('low', 'Low Priority'),
        ('medium', 'Medium Priority'),
        ('high', 'High Priority'),
        ('critical', 'Critical Emergency'),
    ]
    
    EMERGENCY_TYPE_CHOICES = [
        ('medical', 'Medical Emergency'),
        ('accident', 'Traffic Accident'),
        ('transfer', 'Hospital Transfer'),
        ('routine', 'Routine Transport'),
        ('other', 'Other'),
    ]
    
    # Data Reservasi
    reservation_id = models.CharField(max_length=20, unique=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reservations')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    priority = models.CharField(max_length=20, choices=PRIORITY_CHOICES, default='medium')
    emergency_type = models.CharField(max_length=20, choices=EMERGENCY_TYPE_CHOICES)
    
    # Informasi Pasien
    patient_name = models.CharField(max_length=100)
    patient_age = models.PositiveIntegerField()
    patient_gender = models.CharField(max_length=10, choices=[('male', 'Male'), ('female', 'Female')])
    patient_condition = models.TextField()  # kondisi pasien
    medical_history = models.TextField(blank=True)  # riwayat medis
    current_symptoms = models.TextField()  # gejala saat ini
    
    # Lokasi
    pickup_address = models.TextField()
    pickup_city = models.CharField(max_length=100)
    pickup_latitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    pickup_longitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    
    destination_address = models.TextField()
    destination_city = models.CharField(max_length=100)
    destination_latitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    destination_longitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    
    # Assignment
    assigned_ambulance = models.ForeignKey(
        Ambulance, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='reservations'
    )
    assigned_driver = models.ForeignKey(
        DriverProfile, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='reservations'
    )
    
    # Kontak Darurat
    emergency_contact_name = models.CharField(max_length=100)
    emergency_contact_phone = models.CharField(max_length=15)
    emergency_contact_relationship = models.CharField(max_length=50)
    
    # Timestamps
    requested_at = models.DateTimeField(default=timezone.now)
    accepted_at = models.DateTimeField(null=True, blank=True)
    pickup_started_at = models.DateTimeField(null=True, blank=True)
    patient_picked_up_at = models.DateTimeField(null=True, blank=True)
    arrived_at_destination = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    # Additional Info
    special_requirements = models.TextField(blank=True)  # kebutuhan khusus
    estimated_cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    actual_cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    payment_status = models.CharField(
        max_length=20, 
        choices=[
            ('pending', 'Pending'),
            ('paid', 'Paid'),
            ('failed', 'Failed')
        ],
        default='pending'
    )
    notes = models.TextField(blank=True)
    driver_notes = models.TextField(blank=True)  # catatan dari driver
    
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def save(self, *args, **kwargs):
        # Generate reservation ID
        if not self.reservation_id:
            from datetime import datetime
            timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
            self.reservation_id = f"RES{timestamp}"
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.reservation_id} - {self.patient_name} ({self.get_status_display()})"
    
    def get_duration(self):
        """Hitung durasi dari pickup sampai selesai"""
        if self.patient_picked_up_at and self.completed_at:
            return self.completed_at - self.patient_picked_up_at
        return None
    
    class Meta:
        verbose_name = "Reservation"
        verbose_name_plural = "Reservations"
        ordering = ['-requested_at']


class ReservationStatusLog(models.Model):
    """Log untuk tracking perubahan status reservasi"""
    reservation = models.ForeignKey(Reservation, on_delete=models.CASCADE, related_name='status_logs')
    previous_status = models.CharField(max_length=20, blank=True)
    new_status = models.CharField(max_length=20)
    changed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    timestamp = models.DateTimeField(default=timezone.now)
    notes = models.TextField(blank=True)
    
    def __str__(self):
        return f"{self.reservation.reservation_id}: {self.previous_status} → {self.new_status}"
    
    class Meta:
        verbose_name = "Reservation Status Log"
        verbose_name_plural = "Reservation Status Logs"
        ordering = ['-timestamp']