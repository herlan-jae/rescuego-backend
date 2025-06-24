from django.urls import path
from . import views

app_name = 'ambulances'

urlpatterns = [
    path('api/', views.AmbulanceListCreateView.as_view(), name='api_list'),
    path('api/<int:pk>/', views.AmbulanceDetailView.as_view(), name='api_detail'),
    path('api/assignments/', views.AmbulanceAssignmentListView.as_view(), name='api_assignments'),
]