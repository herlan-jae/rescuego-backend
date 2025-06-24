from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .models import UserProfile, DriverProfile
from .serializers import (
    UserRegistrationSerializer, UserLoginSerializer, UserProfileSerializer,
    DriverProfileSerializer, DriverCreateSerializer, UserDetailSerializer
)

class UserRegistrationView(generics.CreateAPIView):
    """Register new user"""
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'message': 'User registered successfully',
            'user': UserDetailSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)

class UserLoginView(generics.GenericAPIView):
    """Login user"""
    serializer_class = UserLoginSerializer
    permission_classes = [permissions.AllowAny]
    
    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = serializer.validated_data['user']
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'message': 'Login successful',
            'user': UserDetailSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        })

class UserProfileView(generics.RetrieveUpdateAPIView):
    """Get and update user profile"""
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        profile, created = UserProfile.objects.get_or_create(user=self.request.user)
        return profile

class DriverListCreateView(generics.ListCreateAPIView):
    """List drivers or create new driver (Admin only)"""
    queryset = DriverProfile.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return DriverCreateSerializer
        return DriverProfileSerializer
    
    def get_permissions(self):
        if self.request.method == 'POST':
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated()]

class DriverDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Driver detail, update, delete (Admin only)"""
    queryset = DriverProfile.objects.all()
    serializer_class = DriverProfileSerializer
    permission_classes = [permissions.IsAdminUser]

class DriverProfileView(generics.RetrieveUpdateAPIView):
    """Get current driver profile"""
    serializer_class = DriverProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        if not hasattr(self.request.user, 'driver_profile'):
            raise permissions.PermissionDenied("User is not a driver")
        return self.request.user.driver_profile

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def change_driver_status(request):
    """Change driver status (available, busy, offline)"""
    if not hasattr(request.user, 'driver_profile'):
        return Response(
            {'error': 'User is not a driver'}, 
            status=status.HTTP_403_FORBIDDEN
        )
    
    new_status = request.data.get('status')
    valid_statuses = ['available', 'busy', 'offline']
    
    if new_status not in valid_statuses:
        return Response(
            {'error': f'Invalid status. Must be one of: {valid_statuses}'}, 
            status=status.HTTP_400_BAD_REQUEST
        )
    
    driver_profile = request.user.driver_profile
    old_status = driver_profile.status
    driver_profile.status = new_status
    driver_profile.save()
    
    return Response({
        'message': f'Status changed from {old_status} to {new_status}',
        'status': new_status
    })

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_dashboard_data(request):
    """Get dashboard data for current user"""
    user = request.user
    
    if hasattr(user, 'driver_profile'):
        # Driver dashboard
        from reservations.models import Reservation
        from maintenance.models import MaintenanceRequest
        
        driver_reservations = Reservation.objects.filter(assigned_driver=user.driver_profile)
        pending_reservations = driver_reservations.filter(status='pending').count()
        active_reservations = driver_reservations.filter(
            status__in=['accepted', 'picking_up', 'on_route']
        ).count()
        completed_reservations = driver_reservations.filter(status='completed').count()
        
        pending_maintenance = MaintenanceRequest.objects.filter(
            requested_by=user.driver_profile,
            status='pending'
        ).count()
        
        return Response({
            'role': 'driver',
            'driver_status': user.driver_profile.status,
            'stats': {
                'pending_reservations': pending_reservations,
                'active_reservations': active_reservations,
                'completed_reservations': completed_reservations,
                'pending_maintenance': pending_maintenance,
            }
        })
    
    elif user.is_staff:
        # Admin dashboard
        from reservations.models import Reservation
        from maintenance.models import MaintenanceRequest
        from ambulances.models import Ambulance
        
        total_reservations = Reservation.objects.count()
        pending_reservations = Reservation.objects.filter(status='pending').count()
        active_reservations = Reservation.objects.filter(
            status__in=['accepted', 'picking_up', 'on_route']
        ).count()
        
        total_ambulances = Ambulance.objects.filter(is_active=True).count()
        available_ambulances = Ambulance.objects.filter(
            status='available', is_active=True
        ).count()
        
        pending_maintenance = MaintenanceRequest.objects.filter(status='pending').count()
        
        return Response({
            'role': 'admin',
            'stats': {
                'total_reservations': total_reservations,
                'pending_reservations': pending_reservations,
                'active_reservations': active_reservations,
                'total_ambulances': total_ambulances,
                'available_ambulances': available_ambulances,
                'pending_maintenance': pending_maintenance,
            }
        })
    
    else:
        # Regular user dashboard
        from reservations.models import Reservation
        
        user_reservations = Reservation.objects.filter(user=user)
        pending_reservations = user_reservations.filter(status='pending').count()
        active_reservations = user_reservations.filter(
            status__in=['accepted', 'picking_up', 'on_route']
        ).count()
        completed_reservations = user_reservations.filter(status='completed').count()
        
        return Response({
            'role': 'user',
            'stats': {
                'pending_reservations': pending_reservations,
                'active_reservations': active_reservations,
                'completed_reservations': completed_reservations,
            }
        })