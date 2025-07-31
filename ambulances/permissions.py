from rest_framework import permissions

class IsAdminOrAssignedDriver(permissions.BasePermission):
    """
    Permission kustom yang mengizinkan akses jika:
    - Pengguna adalah admin/staff.
    - Pengguna adalah supir yang sedang ditugaskan ke ambulans (obj).
    """
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True

        is_admin = request.user and request.user.is_staff
        
        is_assigned_driver = False
        if hasattr(request.user, 'driver_profile'):
            is_assigned_driver = obj.current_driver == request.user.driver_profile

        return is_admin or is_assigned_driver