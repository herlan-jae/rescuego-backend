# ambulans_reservation/urls.py

from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import HttpResponse
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

def home_view(request):
    """Temporary home view"""
    return HttpResponse("""
    <h1>RescueGo - Sistem Reservasi Ambulans Online</h1>
    <p>Backend API is ready!</p>
    <ul>
        <li><a href='/admin/'>Admin Panel</a></li>
        <li><a href='/api/docs/'>API Documentation (Swagger)</a></li>
        <li><a href='/api/redoc/'>API Documentation (ReDoc)</a></li>
    </ul>
    """)

# Swagger/OpenAPI configuration
schema_view = get_schema_view(
    openapi.Info(
        title="RescueGo API",
        default_version='v1',
        description="API for Ambulance Reservation System",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="admin@rescuego.com"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
    permission_classes=[permissions.AllowAny],
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home_view, name='home'),
    
    # App URLs
    path('accounts/', include('accounts.urls')),
    path('reservations/', include('reservations.urls')),
    path('maintenance/', include('maintenance.urls')),
    path('ambulances/', include('ambulances.urls')),
    
    # API Documentation
    path('api/docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('api/redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    path('api/schema/', schema_view.without_ui(cache_timeout=0), name='schema-json'),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATICFILES_DIRS[0])