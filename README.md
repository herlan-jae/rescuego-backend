# 🚑 RescueGo Backend API

Sistema de Reservasi Ambulans Online - Backend API menggunakan Django REST Framework

## 📋 Overview

RescueGo adalah sistem reservasi ambulans online yang memungkinkan:
- **Users** untuk membuat reservasi ambulans
- **Drivers** untuk mengelola dan merespon reservasi
- **Admins** untuk mengatur seluruh sistem

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- MySQL atau SQLite
- Git

### Installation
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/rescuego-backend.git
cd rescuego-backend

# Create virtual environment
python -m venv rescuego_env

# Activate virtual environment
# Windows:
rescuego_env\Scripts\activate
# Mac/Linux:
# source rescuego_env/bin/activate

# Install dependencies
pip install -r requirements.txt

# Setup database (MySQL)
mysql -u root -p
CREATE DATABASE rescuego_db;
EXIT;

# Run migrations
python manage.py migrate

# Create initial data
python manage.py setup_initial_data

# Start server
python manage.py runserver
```

## 🔗 Access Points

| Service | URL | Credentials |
|---------|-----|-------------|
| Homepage | http://localhost:8000/ | - |
| API Documentation | http://localhost:8000/api/docs/ | - |
| Admin Panel | http://localhost:8000/admin/ | admin / admin123 |

## 👥 Test Accounts

### Admin
- **Username**: `admin`
- **Password**: `admin123`

### Drivers
- **Username**: `driver1` | **Password**: `driver123`
- **Username**: `driver2` | **Password**: `driver123`

### Users
- **Username**: `user1` | **Password**: `user123`
- **Username**: `user2` | **Password**: `user123`

## 🔑 API Authentication

```bash
# Login and get JWT token
curl -X POST http://localhost:8000/accounts/api/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Use token in subsequent requests
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/accounts/api/dashboard/
```

## 📚 Key API Endpoints

### Authentication
- `POST /accounts/api/register/` - Register new user
- `POST /accounts/api/login/` - Login and get JWT tokens
- `GET /accounts/api/dashboard/` - Get dashboard data

### Reservations
- `POST /reservations/api/create/` - Create new reservation
- `GET /reservations/api/` - List reservations
- `POST /reservations/api/{id}/assign/` - Assign driver & ambulance (Admin)
- `PATCH /reservations/api/{id}/status/` - Update reservation status

### Ambulances
- `GET /ambulances/api/` - List ambulances
- `POST /ambulances/api/` - Create ambulance (Admin)

### Maintenance
- `POST /maintenance/api/create/` - Create maintenance request (Driver)
- `POST /maintenance/api/{id}/approve/` - Approve maintenance (Admin)

## 🏗️ Project Structure

```
rescuego-backend/
├── rescuego_api/          # Main project settings
├── accounts/              # User & authentication management
├── ambulances/            # Ambulance management
├── reservations/          # Reservation system
├── maintenance/           # Maintenance management
├── static/                # Static files
├── media/                 # Upload files
└── requirements.txt       # Dependencies
```

## 🔧 Configuration

### Database (MySQL)
Edit `rescuego_api/settings.py`:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'rescuego_db',
        'USER': 'root',
        'PASSWORD': 'your_password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

### CORS for Frontend
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",    # React
    "http://localhost:8080",    # Vue
    "http://localhost:4200",    # Angular
]
```

## 🧪 Testing

### Manual Testing
```bash
# Test server health
curl http://localhost:8000/

# Test login
curl -X POST http://localhost:8000/accounts/api/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### Automated Testing
```bash
# Run Python test script
python test_api.py

# Or use the provided test script
chmod +x test_api.sh
./test_api.sh
```

### Postman Testing
Import `postman_collection.json` untuk testing lengkap dengan Postman.

## 🛠️ Development

### Making Changes
```bash
# After modifying models
python manage.py makemigrations
python manage.py migrate

# Create new superuser
python manage.py createsuperuser
```

### Reset Database
```bash
# WARNING: This deletes all data
python manage.py flush
python manage.py setup_initial_data
```

## 📋 Features

### ✅ Implemented
- JWT Authentication
- Role-based permissions (User, Driver, Admin)
- Complete reservation workflow
- Driver and ambulance management
- Maintenance request system
- Real-time status tracking
- API documentation (Swagger)
- Admin interface
- Filtering, searching, pagination

### 🚧 Future Enhancements
- Real-time notifications (WebSocket)
- SMS/Email notifications
- Payment integration
- Mobile app optimization
- Advanced analytics
- File upload for documents

## 🐛 Troubleshooting

### Common Issues

**MySQL Connection Error**:
```bash
# Check MySQL service is running
# Windows: services.msc
# Mac: brew services start mysql
# Linux: sudo service mysql start
```

**Module Not Found**:
```bash
# Ensure virtual environment is active
pip install -r requirements.txt
```

**Port Already in Use**:
```bash
# Run on different port
python manage.py runserver 8001
```

## 📞 Support

- **API Documentation**: http://localhost:8000/api/docs/
- **Issues**: Create GitHub issue
- **Django Docs**: https://docs.djangoproject.com/
- **DRF Docs**: https://www.django-rest-framework.org/

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

**Ready for Frontend Development! 🎉**

Backend API is fully functional and ready to be consumed by any frontend framework (React, Vue, Angular, Flutter, etc.)
