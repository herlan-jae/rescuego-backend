from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from .models import Reservation, ReservationStatusLog
from .serializers import (
    ReservationCreateSerializer, ReservationListSerializer, ReservationDetailSerializer,
    ReservationStatusUpdateSerializer, ReservationAssignmentSerializer,
    ReservationStatusLogSerializer
)
from ambulances.models import Ambulance
from accounts.models import DriverProfile
from django.db import models
from rest_framework.exceptions import PermissionDenied


class ReservationCreateView(generics.CreateAPIView):
    """Create new reservation (User only)"""
    serializer_class = ReservationCreateSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        # Only regular users can create reservations
        if self.request.user.is_staff or hasattr(self.request.user, 'driver_profile'):
            raise PermissionDenied("Only regular users can create reservations")
        serializer.save(user=self.request.user)


class ReservationListView(generics.ListAPIView):
    """List reservations with filtering"""
    serializer_class = ReservationListSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'priority', 'emergency_type', 'pickup_city', 'destination_city']
    search_fields = ['reservation_id', 'patient_name', 'user__username']
    ordering_fields = ['requested_at', 'priority', 'status']
    ordering = ['-requested_at']

    def get_queryset(self):
        user = self.request.user

        # This check prevents errors during schema generation for anonymous users
        if not user.is_authenticated:
            return Reservation.objects.none()

        if user.is_staff:
            # Admin can see all reservations
            return Reservation.objects.all()
        elif hasattr(user, 'driver_profile'):
            # Driver can see assigned reservations and pending ones in their city
            driver_city = user.driver_profile.city
            return Reservation.objects.filter(
                models.Q(assigned_driver=user.driver_profile) |
                models.Q(status='pending', pickup_city=driver_city)
            )
        else:
            # User can only see their own reservations
            return Reservation.objects.filter(user=user)


class ReservationDetailView(generics.RetrieveAPIView):
    """Get reservation detail"""
    serializer_class = ReservationDetailSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        if not user.is_authenticated:
            return Reservation.objects.none()

        if user.is_staff:
            return Reservation.objects.all()
        elif hasattr(user, 'driver_profile'):
            # A driver should probably only see details of reservations assigned to them
            return Reservation.objects.filter(assigned_driver=user.driver_profile)
        else:
            return Reservation.objects.filter(user=user)


class ReservationStatusUpdateView(generics.UpdateAPIView):
    """Update reservation status (Driver/Admin only)"""
    serializer_class = ReservationStatusUpdateSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        if not user.is_authenticated:
            return Reservation.objects.none()

        if user.is_staff:
            return Reservation.objects.all()
        elif hasattr(user, 'driver_profile'):
            return Reservation.objects.filter(assigned_driver=user.driver_profile)
        else:
            # Use the correct exception import
            raise PermissionDenied("Only drivers and admins can update reservation status")


@api_view(['POST'])
@permission_classes([permissions.IsAdminUser])
def assign_reservation(request, pk):
    """Assign driver and ambulance to reservation"""
    try:
        reservation = Reservation.objects.get(pk=pk)
    except Reservation.DoesNotExist:
        return Response({'error': 'Reservation not found'}, status=status.HTTP_404_NOT_FOUND)

    if reservation.status != 'pending':
        return Response(
            {'error': 'Can only assign pending reservations'},
            status=status.HTTP_400_BAD_REQUEST
        )

    serializer = ReservationAssignmentSerializer(data=request.data)
    if serializer.is_valid():
        driver_id = serializer.validated_data['driver_id']
        ambulance_id = serializer.validated_data['ambulance_id']

        try:
            driver = DriverProfile.objects.get(id=driver_id)
            ambulance = Ambulance.objects.get(id=ambulance_id)
        except (DriverProfile.DoesNotExist, Ambulance.DoesNotExist):
            return Response({'error': 'Invalid driver or ambulance ID'}, status=status.HTTP_404_NOT_FOUND)

        # Update reservation
        reservation.assigned_driver = driver
        reservation.assigned_ambulance = ambulance
        reservation.status = 'accepted'
        reservation.accepted_at = timezone.now()
        reservation.save()

        # Update driver and ambulance status
        driver.status = 'busy'
        driver.save()

        ambulance.status = 'in_use'
        ambulance.current_driver = driver
        ambulance.save()

        # Create status log
        ReservationStatusLog.objects.create(
            reservation=reservation,
            previous_status='pending',
            new_status='accepted',
            changed_by=request.user,
            notes=f'Assigned to driver {driver.user.get_full_name()} and ambulance {ambulance.license_plate}'
        )

        return Response({
            'message': 'Reservation assigned successfully',
            'reservation': ReservationDetailSerializer(reservation).data
        })

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def available_drivers_ambulances(request):
    """Get available drivers and ambulances for assignment"""
    if not request.user.is_staff:
        raise PermissionDenied("Admin access required")

    city = request.GET.get('city')

    drivers_qs = DriverProfile.objects.filter(status='available', is_active=True)
    if city:
        drivers_qs = drivers_qs.filter(city=city)

    ambulances_qs = Ambulance.objects.filter(status='available', is_active=True)
    if city:
        ambulances_qs = ambulances_qs.filter(base_location=city)

    drivers_data = [{'id': driver.id, 'name': driver.user.get_full_name()} for driver in drivers_qs]
    ambulances_data = [{'id': ambulance.id, 'license_plate': ambulance.license_plate} for ambulance in ambulances_qs]

    return Response({
        'drivers': drivers_data,
        'ambulances': ambulances_data
    })


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def cancel_reservation(request, pk):
    """Cancel reservation"""
    try:
        reservation = Reservation.objects.get(pk=pk)
    except Reservation.DoesNotExist:
        return Response({'error': 'Reservation not found'}, status=status.HTTP_404_NOT_FOUND)

    if not (request.user == reservation.user or request.user.is_staff):
        raise PermissionDenied("You do not have permission to cancel this reservation.")

    if reservation.status in ['completed', 'cancelled']:
        return Response(
            {'error': 'Cannot cancel completed or already cancelled reservation'},
            status=status.HTTP_400_BAD_REQUEST
        )

    old_status = reservation.status
    reservation.status = 'cancelled'
    reservation.save()

    if reservation.assigned_driver:
        reservation.assigned_driver.status = 'available'
        reservation.assigned_driver.save()

    if reservation.assigned_ambulance:
        reservation.assigned_ambulance.status = 'available'
        reservation.assigned_ambulance.current_driver = None
        reservation.assigned_ambulance.save()

    ReservationStatusLog.objects.create(
        reservation=reservation,
        previous_status=old_status,
        new_status='cancelled',
        changed_by=request.user,
        notes=f'Cancelled by {request.user.get_full_name()}'
    )

    return Response({'message': 'Reservation cancelled successfully'})


class ReservationStatusLogView(generics.ListAPIView):
    """Get status logs for a reservation"""
    serializer_class = ReservationStatusLogSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        reservation_id = self.kwargs['reservation_id']
        user = self.request.user

        try:
            reservation = Reservation.objects.get(id=reservation_id)

            can_view = (
                    user == reservation.user or
                    user.is_staff or
                    (hasattr(user, 'driver_profile') and user.driver_profile == reservation.assigned_driver)
            )

            if not can_view:
                raise PermissionDenied()

        except Reservation.DoesNotExist:
            return ReservationStatusLog.objects.none()

        return ReservationStatusLog.objects.filter(reservation_id=reservation_id).order_by('-timestamp')
