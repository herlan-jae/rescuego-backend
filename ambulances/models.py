from django.db import models
from django.utils import timezone
from accounts.models import DriverProfile

class Ambulance(models.Model):
    """Model untuk data ambulans"""
    AMBULANCE_TYPE_CHOICES = [
        ('basic', 'Basic Life Support (BLS)'),
        ('advanced', 'Advanced Life Support (ALS)'),
        ('critical', 'Critical Care Transport (CCT)'),
        ('emergency', 'Emergency Response Vehicle'),
    ]
    
    STATUS_CHOICES = [
        ('available', 'Available'),
        ('in_use', 'In Use'),
        ('maintenance', 'Under Maintenance'),
        ('out_of_service', 'Out of Service'),
    ]
    
    license_plate = models.CharField(max_length=20, unique=True)
    ambulance_type = models.CharField(max_length=20, choices=AMBULANCE_TYPE_CHOICES)
    brand = models.CharField(max_length=50)
    model = models.CharField(max_length=50)
    year = models.PositiveIntegerField()
    capacity = models.PositiveIntegerField(default=1)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='available')
    current_driver = models.ForeignKey(
        DriverProfile, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='current_ambulance'
    )
    base_location = models.CharField(max_length=100)
    current_location = models.CharField(max_length=200, blank=True)
    last_maintenance_date = models.DateField(null=True, blank=True)
    next_maintenance_date = models.DateField(null=True, blank=True)
    mileage = models.PositiveIntegerField(default=0)
    fuel_capacity = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    equipment_list = models.TextField(blank=True)
    notes = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.license_plate} - {self.get_ambulance_type_display()}"
    
    def is_available(self):
        return self.status == 'available' and self.is_active
    
    class Meta:
        verbose_name = "Ambulance"
        verbose_name_plural = "Ambulances"
        ordering = ['license_plate']


class AmbulanceAssignment(models.Model):
    """Model untuk assignment driver ke ambulans"""
    driver = models.ForeignKey(DriverProfile, on_delete=models.CASCADE)
    ambulance = models.ForeignKey(Ambulance, on_delete=models.CASCADE)
    assigned_date = models.DateTimeField(default=timezone.now)
    end_date = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    notes = models.TextField(blank=True)
    
    def __str__(self):
        return f"{self.driver} assigned to {self.ambulance}"
    
    class Meta:
        verbose_name = "Ambulance Assignment"
        verbose_name_plural = "Ambulance Assignments"
        unique_together = ['driver', 'ambulance', 'assigned_date']