from django.urls import path
from . import views
from rest_framework_simplejwt.views import TokenRefreshView

app_name = 'accounts'

urlpatterns = [
    path('api/register/', views.UserRegistrationView.as_view(), name='api_register'),
    path('api/login/', views.UserLoginView.as_view(), name='api_login'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='api_token_refresh'),
    path('api/profile/', views.UserProfileView.as_view(), name='api_profile'),
    path('api/driver/profile/', views.DriverProfileView.as_view(), name='api_driver_profile'),
    path('api/driver/status/', views.change_driver_status, name='api_driver_status'),
    path('api/drivers/', views.DriverListCreateView.as_view(), name='api_drivers'),
    path('api/drivers/<int:pk>/', views.DriverDetailView.as_view(), name='api_driver_detail'),
    path('api/dashboard/', views.user_dashboard_data, name='api_dashboard'),
]