from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import date, timedelta
from accounts.models import DriverProfile, UserProfile
from ambulances.models import Ambulance, AmbulanceAssignment
from reservations.models import Reservation
from maintenance.models import MaintenanceRequest, MaintenanceSchedule

class Command(BaseCommand):
    help = 'Setup initial data for RescueGo system'

    def add_arguments(self, parser):
        parser.add_argument(
            '--skip-users',
            action='store_true',
            help='Skip creating users',
        )

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Setting up initial data...'))

        if not options['skip_users']:
            self.create_users()
        
        self.create_ambulances()
        self.create_sample_reservations()
        self.create_maintenance_schedules()
        
        self.stdout.write(self.style.SUCCESS('Initial data setup completed!'))

    def create_users(self):
        self.stdout.write('Creating users...')
        
        # Create admin user
        admin, created = User.objects.get_or_create(
            username='admin',
            defaults={
                'email': 'admin@rescuego.com',
                'first_name': 'System',
                'last_name': 'Administrator',
                'is_staff': True,
                'is_superuser': True
            }
        )
        if created:
            admin.set_password('admin123')
            admin.save()
            self.stdout.write(f'  Created admin user: {admin.username}')

        # Create drivers
        drivers_data = [
            {
                'username': 'driver1',
                'email': 'driver1@rescuego.com',
                'first_name': 'Ahmad',
                'last_name': 'Sutanto',
                'driver_license_number': 'DRV001',
                'phone_number': '081234567001',
                'city': 'Jakarta',
                'address': 'Jl. Gatot Subroto No. 123',
                'date_of_birth': date(1980, 5, 15),
                'experience_years': 10
            },
            {
                'username': 'driver2',
                'email': 'driver2@rescuego.com',
                'first_name': 'Budi',
                'last_name': 'Prasetyo',
                'driver_license_number': 'DRV002',
                'phone_number': '081234567002',
                'city': 'Jakarta',
                'address': 'Jl. Sudirman No. 456',
                'date_of_birth': date(1985, 8, 20),
                'experience_years': 7
            },
            {
                'username': 'driver3',
                'email': 'driver3@rescuego.com',
                'first_name': 'Citra',
                'last_name': 'Dewi',
                'driver_license_number': 'DRV003',
                'phone_number': '081234567003',
                'city': 'Bandung',
                'address': 'Jl. Braga No. 789',
                'date_of_birth': date(1990, 3, 10),
                'experience_years': 5
            }
        ]

        for driver_data in drivers_data:
            user_data = {
                'username': driver_data['username'],
                'email': driver_data['email'],
                'first_name': driver_data['first_name'],
                'last_name': driver_data['last_name']
            }
            
            user, created = User.objects.get_or_create(
                username=user_data['username'],
                defaults=user_data
            )
            
            if created:
                user.set_password('driver123')
                user.save()
                
                # Create driver profile
                driver_profile_data = {
                    'user': user,
                    'driver_license_number': driver_data['driver_license_number'],
                    'phone_number': driver_data['phone_number'],
                    'city': driver_data['city'],
                    'address': driver_data['address'],
                    'date_of_birth': driver_data['date_of_birth'],
                    'experience_years': driver_data['experience_years'],
                    'emergency_contact_name': f"Emergency Contact {driver_data['first_name']}",
                    'emergency_contact_phone': '081999888777'
                }
                
                DriverProfile.objects.create(**driver_profile_data)
                self.stdout.write(f'  Created driver: {user.username}')

        # Create regular users
        users_data = [
            {
                'username': 'user1',
                'email': 'user1@example.com',
                'first_name': 'John',
                'last_name': 'Doe',
                'city': 'Jakarta',
                'phone_number': '081234567101'
            },
            {
                'username': 'user2',
                'email': 'user2@example.com',
                'first_name': 'Jane',
                'last_name': 'Smith',
                'city': 'Bandung',
                'phone_number': '081234567102'
            }
        ]

        for user_data in users_data:
            user, created = User.objects.get_or_create(
                username=user_data['username'],
                defaults={
                    'email': user_data['email'],
                    'first_name': user_data['first_name'],
                    'last_name': user_data['last_name']
                }
            )
            
            if created:
                user.set_password('user123')
                user.save()
                
                # Update user profile
                profile, created = UserProfile.objects.get_or_create(
                    user=user,
                    defaults={
                        'city': user_data['city'],
                        'phone_number': user_data['phone_number']
                    }
                )
                
                self.stdout.write(f'  Created user: {user.username}')

    def create_ambulances(self):
        self.stdout.write('Creating ambulances...')
        
        ambulances_data = [
            {
                'license_plate': 'B 1234 AMB',
                'ambulance_type': 'advanced',
                'brand': 'Toyota',
                'model': 'Hiace',
                'year': 2022,
                'capacity': 2,
                'base_location': 'Jakarta',
                'equipment_list': 'Defibrillator, Oxygen tank, Stretcher, First aid kit, IV equipment'
            },
            {
                'license_plate': 'B 5678 AMB',
                'ambulance_type': 'basic',
                'brand': 'Toyota',
                'model': 'Avanza',
                'year': 2021,
                'capacity': 1,
                'base_location': 'Jakarta',
                'equipment_list': 'Stretcher, First aid kit, Oxygen tank'
            },
            {
                'license_plate': 'D 9012 AMB',
                'ambulance_type': 'critical',
                'brand': 'Mercedes-Benz',
                'model': 'Sprinter',
                'year': 2023,
                'capacity': 2,
                'base_location': 'Bandung',
                'equipment_list': 'ICU equipment, Ventilator, Defibrillator, Advanced life support'
            }
        ]

        for ambulance_data in ambulances_data:
            ambulance, created = Ambulance.objects.get_or_create(
                license_plate=ambulance_data['license_plate'],
                defaults=ambulance_data
            )
            
            if created:
                self.stdout.write(f'  Created ambulance: {ambulance.license_plate}')

    def create_sample_reservations(self):
        self.stdout.write('Creating sample reservations...')
        
        # Get users and drivers
        try:
            user1 = User.objects.get(username='user1')
            driver1 = DriverProfile.objects.get(driver_license_number='DRV001')
            ambulance1 = Ambulance.objects.get(license_plate='B 1234 AMB')
            
            reservation_data = {
                'user': user1,
                'emergency_type': 'medical',
                'priority': 'high',
                'patient_name': 'Sarah Johnson',
                'patient_age': 45,
                'patient_gender': 'female',
                'patient_condition': 'Chest pain and shortness of breath',
                'current_symptoms': 'Severe chest pain, difficulty breathing',
                'pickup_address': 'Jl. Thamrin No. 123, Jakarta Pusat',
                'pickup_city': 'Jakarta',
                'destination_address': 'RSUP Cipto Mangunkusumo, Jakarta Pusat',
                'destination_city': 'Jakarta',
                'emergency_contact_name': 'John Doe',
                'emergency_contact_phone': '081234567101',
                'emergency_contact_relationship': 'Spouse',
                'status': 'completed',
                'assigned_driver': driver1,
                'assigned_ambulance': ambulance1,
                'requested_at': timezone.now() - timedelta(hours=2),
                'accepted_at': timezone.now() - timedelta(hours=1, minutes=45),
                'completed_at': timezone.now() - timedelta(minutes=15)
            }
            
            reservation, created = Reservation.objects.get_or_create(
                user=user1,
                patient_name='Sarah Johnson',
                defaults=reservation_data
            )
            
            if created:
                self.stdout.write(f'  Created sample reservation: {reservation.reservation_id}')
                
        except (User.DoesNotExist, DriverProfile.DoesNotExist, Ambulance.DoesNotExist) as e:
            self.stdout.write(f'  Skipped sample reservations: {e}')

    def create_maintenance_schedules(self):
        self.stdout.write('Creating maintenance schedules...')
        
        ambulances = Ambulance.objects.all()
        
        for ambulance in ambulances:
            schedules = [
                {
                    'schedule_type': 'weekly',
                    'description': 'Weekly safety inspection and basic maintenance',
                    'frequency_days': 7,
                    'next_due': timezone.now() + timedelta(days=7)
                },
                {
                    'schedule_type': 'monthly',
                    'description': 'Monthly comprehensive check and oil change',
                    'frequency_days': 30,
                    'next_due': timezone.now() + timedelta(days=30)
                }
            ]
            
            for schedule_data in schedules:
                schedule, created = MaintenanceSchedule.objects.get_or_create(
                    ambulance=ambulance,
                    schedule_type=schedule_data['schedule_type'],
                    defaults=schedule_data
                )
                
                if created:
                    self.stdout.write(f'  Created maintenance schedule for {ambulance.license_plate}: {schedule.schedule_type}')