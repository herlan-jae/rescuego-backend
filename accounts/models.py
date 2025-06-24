# accounts/models.py

from django.contrib.auth.models import User
from django.db import models
from django.utils import timezone

class UserProfile(models.Model):
    """Extended user profile untuk user biasa"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='user_profile')
    phone_number = models.CharField(max_length=15, blank=True)
    city = models.CharField(max_length=100)
    address = models.TextField(blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    emergency_contact_name = models.CharField(max_length=100, blank=True)
    emergency_contact_phone = models.CharField(max_length=15, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name} - {self.city}"
    
    class Meta:
        verbose_name = "User Profile"
        verbose_name_plural = "User Profiles"


class DriverProfile(models.Model):
    """Profile untuk driver ambulans"""
    DRIVER_STATUS_CHOICES = [
        ('available', 'Available'),
        ('busy', 'Busy'),
        ('offline', 'Offline'),
        ('maintenance', 'On Maintenance'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='driver_profile')
    driver_license_number = models.CharField(max_length=50, unique=True)
    phone_number = models.CharField(max_length=15)
    city = models.CharField(max_length=100)
    address = models.TextField()
    date_of_birth = models.DateField()
    hire_date = models.DateField(default=timezone.now)
    status = models.CharField(max_length=20, choices=DRIVER_STATUS_CHOICES, default='available')
    experience_years = models.PositiveIntegerField(default=0)
    emergency_contact_name = models.CharField(max_length=100)
    emergency_contact_phone = models.CharField(max_length=15)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Driver: {self.user.first_name} {self.user.last_name} - {self.driver_license_number}"
    
    class Meta:
        verbose_name = "Driver Profile"
        verbose_name_plural = "Driver Profiles"


# Signal untuk auto-create profile
from django.db.models.signals import post_save
from django.dispatch import receiver

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    """Otomatis buat UserProfile saat User baru dibuat (kecuali untuk staff/admin)"""
    if created and not instance.is_staff and not instance.is_superuser:
        UserProfile.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    """Save UserProfile saat User disave"""
    if hasattr(instance, 'user_profile') and not instance.is_staff:
        instance.user_profile.save()