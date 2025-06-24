from django.urls import path
from . import views

app_name = 'maintenance'

urlpatterns = [
    path('api/',views.MaintenanceRequestListView.as_view(), name='api_list'),
    path('api/create/',views.MaintenanceRequestCreateView.as_view(), name='api_create'),
    path('api/<int:pk>/',views.MaintenanceRequestDetailView.as_view(), name='api_detail'),
    path('api/<int:pk>/update/',views.MaintenanceRequestUpdateView.as_view(), name='api_update'),
    path('api/<int:pk>/approve/',views.approve_maintenance_request, name='api_approve'),
    path('api/<int:pk>/reject/',views.reject_maintenance_request, name='api_reject'),
    path('api/schedules/', views.MaintenanceScheduleListView.as_view(), name='api_schedules'),
    path('api/overdue/',views.overdue_maintenance, name='api_overdue'),
    path('api/stats/',views.maintenance_stats, name='api_stats'),
]