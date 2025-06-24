from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.utils import timezone
from .models import MaintenanceRequest, MaintenanceStatusLog, MaintenanceSchedule
from .serializers import (
    MaintenanceRequestCreateSerializer, MaintenanceRequestListSerializer,
    MaintenanceRequestDetailSerializer, MaintenanceRequestUpdateSerializer,
    MaintenanceScheduleSerializer
)

class MaintenanceRequestCreateView(generics.CreateAPIView):
    """Create maintenance request (Driver only)"""
    serializer_class = MaintenanceRequestCreateSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def perform_create(self, serializer):
        if not hasattr(self.request.user, 'driver_profile'):
            raise permissions.PermissionDenied("Only drivers can create maintenance requests")
        serializer.save()

class MaintenanceRequestListView(generics.ListAPIView):
    """List maintenance requests"""
    serializer_class = MaintenanceRequestListSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'priority', 'request_type', 'ambulance']
    search_fields = ['request_id', 'title', 'ambulance__license_plate']
    ordering_fields = ['requested_at', 'priority', 'status']
    ordering = ['-requested_at']
    
    def get_queryset(self):
        user = self.request.user
        
        if user.is_staff:
            # Admin can see all maintenance requests
            return MaintenanceRequest.objects.all()
        elif hasattr(user, 'driver_profile'):
            # Driver can only see their own requests
            return MaintenanceRequest.objects.filter(requested_by=user.driver_profile)
        else:
            # Regular users cannot see maintenance requests
            return MaintenanceRequest.objects.none()

class MaintenanceRequestDetailView(generics.RetrieveAPIView):
    """Get maintenance request detail"""
    serializer_class = MaintenanceRequestDetailSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        if user.is_staff:
            return MaintenanceRequest.objects.all()
        elif hasattr(user, 'driver_profile'):
            return MaintenanceRequest.objects.filter(requested_by=user.driver_profile)
        else:
            return MaintenanceRequest.objects.none()

class MaintenanceRequestUpdateView(generics.UpdateAPIView):
    """Update maintenance request (Admin only)"""
    serializer_class = MaintenanceRequestUpdateSerializer
    permission_classes = [permissions.IsAdminUser]
    queryset = MaintenanceRequest.objects.all()

@api_view(['POST'])
@permission_classes([permissions.IsAdminUser])
def approve_maintenance_request(request, pk):
    """Approve maintenance request"""
    try:
        maintenance_request = MaintenanceRequest.objects.get(pk=pk)
    except MaintenanceRequest.DoesNotExist:
        return Response({'error': 'Maintenance request not found'}, status=status.HTTP_404_NOT_FOUND)
    
    if maintenance_request.status != 'pending':
        return Response(
            {'error': 'Can only approve pending requests'}, 
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Update status
    old_status = maintenance_request.status
    maintenance_request.status = 'approved'
    maintenance_request.reviewed_at = timezone.now()
    maintenance_request.reviewed_by = request.user
    maintenance_request.admin_notes = request.data.get('admin_notes', '')
    maintenance_request.estimated_cost = request.data.get('estimated_cost')
    maintenance_request.save()
    
    # Update ambulance status
    maintenance_request.ambulance.status = 'maintenance'
    maintenance_request.ambulance.save()
    
    # Create status log
    MaintenanceStatusLog.objects.create(
        maintenance_request=maintenance_request,
        previous_status=old_status,
        new_status='approved',
        changed_by=request.user,
        notes=maintenance_request.admin_notes
    )
    
    return Response({
        'message': 'Maintenance request approved',
        'request': MaintenanceRequestDetailSerializer(maintenance_request).data
    })

@api_view(['POST'])
@permission_classes([permissions.IsAdminUser])
def reject_maintenance_request(request, pk):
    """Reject maintenance request"""
    try:
        maintenance_request = MaintenanceRequest.objects.get(pk=pk)
    except MaintenanceRequest.DoesNotExist:
        return Response({'error': 'Maintenance request not found'}, status=status.HTTP_404_NOT_FOUND)
    
    if maintenance_request.status != 'pending':
        return Response(
            {'error': 'Can only reject pending requests'}, 
            status=status.HTTP_400_BAD_REQUEST
        )
    
    rejection_reason = request.data.get('rejection_reason', '')
    if not rejection_reason:
        return Response(
            {'error': 'Rejection reason is required'}, 
            status=status.HTTP_400_BAD_REQUEST
        )
    
    # Update status
    old_status = maintenance_request.status
    maintenance_request.status = 'rejected'
    maintenance_request.reviewed_at = timezone.now()
    maintenance_request.reviewed_by = request.user
    maintenance_request.rejection_reason = rejection_reason
    maintenance_request.save()
    
    # Create status log
    MaintenanceStatusLog.objects.create(
        maintenance_request=maintenance_request,
        previous_status=old_status,
        new_status='rejected',
        changed_by=request.user,
        notes=rejection_reason
    )
    
    return Response({
        'message': 'Maintenance request rejected',
        'request': MaintenanceRequestDetailSerializer(maintenance_request).data
    })

class MaintenanceScheduleListView(generics.ListCreateAPIView):
    """List and create maintenance schedules (Admin only)"""
    queryset = MaintenanceSchedule.objects.all()
    serializer_class = MaintenanceScheduleSerializer
    permission_classes = [permissions.IsAdminUser]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ambulance', 'schedule_type', 'is_active']
    search_fields = ['ambulance__license_plate', 'description']
    ordering = ['next_due']

@api_view(['GET'])
@permission_classes([permissions.IsAdminUser])
def overdue_maintenance(request):
    """Get overdue maintenance schedules"""
    overdue_schedules = MaintenanceSchedule.objects.filter(
        next_due__lt=timezone.now(),
        is_active=True
    )
    
    data = []
    for schedule in overdue_schedules:
        data.append({
            'id': schedule.id,
            'ambulance': {
                'id': schedule.ambulance.id,
                'license_plate': schedule.ambulance.license_plate,
                'type': schedule.ambulance.get_ambulance_type_display()
            },
            'schedule_type': schedule.get_schedule_type_display(),
            'description': schedule.description,
            'next_due': schedule.next_due,
            'days_overdue': (timezone.now().date() - schedule.next_due.date()).days
        })
    
    return Response({
        'overdue_count': len(data),
        'schedules': data
    })

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def maintenance_stats(request):
    """Get maintenance statistics"""
    if not request.user.is_staff:
        return Response(
            {'error': 'Admin access required'}, 
            status=status.HTTP_403_FORBIDDEN
        )
    
    from django.db.models import Count
    
    # Request stats by status
    status_stats = MaintenanceRequest.objects.values('status').annotate(
        count=Count('id')
    ).order_by('status')
    
    # Request stats by type
    type_stats = MaintenanceRequest.objects.values('request_type').annotate(
        count=Count('id')
    ).order_by('request_type')
    
    # Overdue schedules count
    overdue_count = MaintenanceSchedule.objects.filter(
        next_due__lt=timezone.now(),
        is_active=True
    ).count()
    
    return Response({
        'status_stats': list(status_stats),
        'type_stats': list(type_stats),
        'overdue_schedules': overdue_count,
        'total_requests': MaintenanceRequest.objects.count(),
        'pending_requests': MaintenanceRequest.objects.filter(status='pending').count(),
    })