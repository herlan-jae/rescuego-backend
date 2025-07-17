from django.urls import path
from . import views
from .views import Reservation

app_name = 'reservations'

urlpatterns = [
    path('api/', views.ReservationListView.as_view(), name='api_list'),
    path('api/create/', views.ReservationCreateView.as_view(), name='api_create'),
    path('api/<int:pk>/', views.ReservationDetailView.as_view(), name='api_detail'),
    path('api/<int:pk>/status/', views.ReservationStatusUpdateView.as_view(), name='api_status_update'),
    path('api/<int:pk>/assign/', views.assign_reservation, name='api_assign'),
    path('api/<int:pk>/cancel/', views.cancel_reservation, name='api_cancel'),
    path('api/<int:reservation_id>/logs/', views.ReservationStatusLogView.as_view(), name='api_status_logs'),
    path('api/resources/', views.available_drivers_ambulances, name='api_resources'),
]
