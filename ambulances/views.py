from rest_framework import generics, permissions, status
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from .models import Ambulance, AmbulanceAssignment
from .serializers import AmbulanceSerializer, AmbulanceAssignmentSerializer
from .permissions import IsAdminOrAssignedDriver

class AmbulanceListCreateView(generics.ListCreateAPIView):
    """List ambulances or create new ambulance (Admin only for create)"""
    queryset = Ambulance.objects.all()
    serializer_class = AmbulanceSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['ambulance_type', 'status', 'base_location', 'is_active']
    search_fields = ['license_plate', 'brand', 'model']
    ordering_fields = ['license_plate', 'ambulance_type', 'status']
    ordering = ['license_plate']
    
    def get_permissions(self):
        if self.request.method == 'POST':
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated()]

class AmbulanceDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Ambulance detail, update, delete (Admin or Assigned Driver only for modify)"""
    queryset = Ambulance.objects.all()
    serializer_class = AmbulanceSerializer
    permission_classes = [IsAdminOrAssignedDriver] 

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)

class AmbulanceAssignmentListView(generics.ListCreateAPIView):
    """List and create ambulance assignments (Admin only)"""
    queryset = AmbulanceAssignment.objects.all()
    serializer_class = AmbulanceAssignmentSerializer
    permission_classes = [permissions.IsAdminUser]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['driver', 'ambulance', 'is_active']
    ordering = ['-assigned_date']