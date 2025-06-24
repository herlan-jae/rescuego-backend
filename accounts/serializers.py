# accounts/serializers.py

from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .models import UserProfile, DriverProfile

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    password_confirm = serializers.CharField(write_only=True)
    city = serializers.CharField(max_length=100)
    phone_number = serializers.CharField(max_length=15, required=False)
    
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password_confirm', 'first_name', 'last_name', 'city', 'phone_number']
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("Passwords don't match")
        return attrs
    
    def create(self, validated_data):
        # Remove fields yang tidak ada di User model
        city = validated_data.pop('city')
        phone_number = validated_data.pop('phone_number', '')
        validated_data.pop('password_confirm')
        
        # Create user
        user = User.objects.create_user(**validated_data)
        
        # Update atau create UserProfile
        user_profile, created = UserProfile.objects.get_or_create(
            user=user,
            defaults={'city': city, 'phone_number': phone_number}
        )
        if not created:
            user_profile.city = city
            user_profile.phone_number = phone_number
            user_profile.save()
        
        return user

class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()
    
    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')
        
        if username and password:
            user = authenticate(username=username, password=password)
            if not user:
                raise serializers.ValidationError('Invalid credentials')
            if not user.is_active:
                raise serializers.ValidationError('Account is disabled')
            attrs['user'] = user
        else:
            raise serializers.ValidationError('Must include username and password')
        
        return attrs

class UserProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)
    full_name = serializers.SerializerMethodField()
    
    class Meta:
        model = UserProfile
        fields = '__all__'
        read_only_fields = ['user', 'created_at', 'updated_at']
    
    def get_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}".strip()

class DriverProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)
    full_name = serializers.SerializerMethodField()
    
    class Meta:
        model = DriverProfile
        fields = '__all__'
        read_only_fields = ['user', 'created_at', 'updated_at']
    
    def get_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}".strip()

class DriverCreateSerializer(serializers.ModelSerializer):
    # User fields
    username = serializers.CharField()
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=6)
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    
    class Meta:
        model = DriverProfile
        fields = ['username', 'email', 'password', 'first_name', 'last_name',
                 'driver_license_number', 'phone_number', 'city', 'address', 
                 'date_of_birth', 'experience_years', 'emergency_contact_name', 
                 'emergency_contact_phone']
    
    def create(self, validated_data):
        # Extract user data
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'password': validated_data.pop('password'),
            'first_name': validated_data.pop('first_name'),
            'last_name': validated_data.pop('last_name'),
        }
        
        # Create user
        user = User.objects.create_user(**user_data)
        
        # Create driver profile
        driver_profile = DriverProfile.objects.create(user=user, **validated_data)
        
        return driver_profile

class UserDetailSerializer(serializers.ModelSerializer):
    profile = serializers.SerializerMethodField()
    role = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 
                 'is_staff', 'is_active', 'date_joined', 'profile', 'role']
    
    def get_profile(self, obj):
        if hasattr(obj, 'driver_profile'):
            return DriverProfileSerializer(obj.driver_profile).data
        elif hasattr(obj, 'user_profile'):
            return UserProfileSerializer(obj.user_profile).data
        return None
    
    def get_role(self, obj):
        if obj.is_superuser or obj.is_staff:
            return 'admin'
        elif hasattr(obj, 'driver_profile'):
            return 'driver'
        else:
            return 'user'