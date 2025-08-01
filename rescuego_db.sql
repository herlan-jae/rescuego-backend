-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 01, 2025 at 05:17 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rescuego_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts_driverprofile`
--

CREATE TABLE `accounts_driverprofile` (
  `id` bigint NOT NULL,
  `driver_license_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` date NOT NULL,
  `hire_date` date NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `experience_years` int UNSIGNED NOT NULL,
  `emergency_contact_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_contact_phone` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL
) ;

--
-- Dumping data for table `accounts_driverprofile`
--

INSERT INTO `accounts_driverprofile` (`id`, `driver_license_number`, `phone_number`, `city`, `address`, `date_of_birth`, `hire_date`, `status`, `experience_years`, `emergency_contact_name`, `emergency_contact_phone`, `is_active`, `created_at`, `updated_at`, `user_id`) VALUES
(13, '08123456789', '08123456789', 'Tangerang', 'Tangerang', '2003-03-20', '2025-07-31', 'available', 0, 'Epni', '08123456789', 1, '2025-07-31 02:40:59.925580', '2025-07-31 06:20:14.469215', 25);

-- --------------------------------------------------------

--
-- Table structure for table `accounts_userprofile`
--

CREATE TABLE `accounts_userprofile` (
  `id` bigint NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `emergency_contact_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_contact_phone` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `accounts_userprofile`
--

INSERT INTO `accounts_userprofile` (`id`, `phone_number`, `city`, `address`, `date_of_birth`, `emergency_contact_name`, `emergency_contact_phone`, `created_at`, `updated_at`, `user_id`) VALUES
(21, '', '', '', NULL, '', '', '2025-07-31 02:40:59.907666', '2025-07-31 02:40:59.914843', 25),
(22, '08123456789', 'Jakarta', 'Kemayoran', NULL, '', '', '2025-07-31 02:43:53.118756', '2025-07-31 02:44:22.256602', 26);

-- --------------------------------------------------------

--
-- Table structure for table `ambulances_ambulance`
--

CREATE TABLE `ambulances_ambulance` (
  `id` bigint NOT NULL,
  `license_plate` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ambulance_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int UNSIGNED NOT NULL,
  `capacity` int UNSIGNED NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `base_location` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_location` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_maintenance_date` date DEFAULT NULL,
  `next_maintenance_date` date DEFAULT NULL,
  `mileage` int UNSIGNED NOT NULL,
  `fuel_capacity` decimal(10,2) NOT NULL,
  `equipment_list` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `current_driver_id` bigint DEFAULT NULL
) ;

--
-- Dumping data for table `ambulances_ambulance`
--

INSERT INTO `ambulances_ambulance` (`id`, `license_plate`, `ambulance_type`, `brand`, `model`, `year`, `capacity`, `status`, `base_location`, `current_location`, `last_maintenance_date`, `next_maintenance_date`, `mileage`, `fuel_capacity`, `equipment_list`, `notes`, `is_active`, `created_at`, `updated_at`, `current_driver_id`) VALUES
(25, 'B 1234 TST', 'basic', 'Toyota', 'Hiache', 2020, 1, 'available', 'Jakarta', '', NULL, NULL, 0, 0.00, '-', '', 1, '2025-07-31 03:04:59.758465', '2025-07-31 06:20:14.471655', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ambulances_ambulanceassignment`
--

CREATE TABLE `ambulances_ambulanceassignment` (
  `id` bigint NOT NULL,
  `assigned_date` datetime(6) NOT NULL,
  `end_date` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `ambulance_id` bigint NOT NULL,
  `driver_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add Driver Profile', 7, 'add_driverprofile'),
(26, 'Can change Driver Profile', 7, 'change_driverprofile'),
(27, 'Can delete Driver Profile', 7, 'delete_driverprofile'),
(28, 'Can view Driver Profile', 7, 'view_driverprofile'),
(29, 'Can add User Profile', 8, 'add_userprofile'),
(30, 'Can change User Profile', 8, 'change_userprofile'),
(31, 'Can delete User Profile', 8, 'delete_userprofile'),
(32, 'Can view User Profile', 8, 'view_userprofile'),
(33, 'Can add Reservation', 9, 'add_reservation'),
(34, 'Can change Reservation', 9, 'change_reservation'),
(35, 'Can delete Reservation', 9, 'delete_reservation'),
(36, 'Can view Reservation', 9, 'view_reservation'),
(37, 'Can add Reservation Status Log', 10, 'add_reservationstatuslog'),
(38, 'Can change Reservation Status Log', 10, 'change_reservationstatuslog'),
(39, 'Can delete Reservation Status Log', 10, 'delete_reservationstatuslog'),
(40, 'Can view Reservation Status Log', 10, 'view_reservationstatuslog'),
(41, 'Can add Maintenance Request', 11, 'add_maintenancerequest'),
(42, 'Can change Maintenance Request', 11, 'change_maintenancerequest'),
(43, 'Can delete Maintenance Request', 11, 'delete_maintenancerequest'),
(44, 'Can view Maintenance Request', 11, 'view_maintenancerequest'),
(45, 'Can add Maintenance Schedule', 12, 'add_maintenanceschedule'),
(46, 'Can change Maintenance Schedule', 12, 'change_maintenanceschedule'),
(47, 'Can delete Maintenance Schedule', 12, 'delete_maintenanceschedule'),
(48, 'Can view Maintenance Schedule', 12, 'view_maintenanceschedule'),
(49, 'Can add Maintenance Status Log', 13, 'add_maintenancestatuslog'),
(50, 'Can change Maintenance Status Log', 13, 'change_maintenancestatuslog'),
(51, 'Can delete Maintenance Status Log', 13, 'delete_maintenancestatuslog'),
(52, 'Can view Maintenance Status Log', 13, 'view_maintenancestatuslog'),
(53, 'Can add Ambulance', 14, 'add_ambulance'),
(54, 'Can change Ambulance', 14, 'change_ambulance'),
(55, 'Can delete Ambulance', 14, 'delete_ambulance'),
(56, 'Can view Ambulance', 14, 'view_ambulance'),
(57, 'Can add Ambulance Assignment', 15, 'add_ambulanceassignment'),
(58, 'Can change Ambulance Assignment', 15, 'change_ambulanceassignment'),
(59, 'Can delete Ambulance Assignment', 15, 'delete_ambulanceassignment'),
(60, 'Can view Ambulance Assignment', 15, 'view_ambulanceassignment'),
(61, 'Can add blacklisted token', 16, 'add_blacklistedtoken'),
(62, 'Can change blacklisted token', 16, 'change_blacklistedtoken'),
(63, 'Can delete blacklisted token', 16, 'delete_blacklistedtoken'),
(64, 'Can view blacklisted token', 16, 'view_blacklistedtoken'),
(65, 'Can add outstanding token', 17, 'add_outstandingtoken'),
(66, 'Can change outstanding token', 17, 'change_outstandingtoken'),
(67, 'Can delete outstanding token', 17, 'delete_outstandingtoken'),
(68, 'Can view outstanding token', 17, 'view_outstandingtoken');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(2, 'pbkdf2_sha256$870000$irogeRiiUvcjYyeljSZmLQ$dC1a9vc+v6GA86qjfSyLDWWyBq02ZUIl5HjE5FkCYwQ=', '2025-07-30 17:49:03.564195', 1, 'admin', 'System', 'Administrator', 'admin@rescuego.com', 1, 1, '2025-06-23 08:15:25.286913'),
(25, 'pbkdf2_sha256$870000$GFNjRAbMDFZb84vvQXEjgB$b0B0xhrZQ/RamypNvjC4Ausk5cfTl0R/FxP4C8910kI=', NULL, 0, 'sadeli', 'Hasan', 'Sadeli', 'hasan@driver.com', 0, 1, '2025-07-31 02:40:57.230278'),
(26, 'pbkdf2_sha256$870000$g7ZFQWfCCcSZJUBPp7NZ71$5//JcAFY2gNGDhPlIXWDxjyVDyMA561xVk394zMTa/M=', NULL, 0, 'farelyo', 'La', 'Nesta', 'farelyo@user.com', 0, 1, '2025-07-31 02:43:51.006370');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(3, '2025-07-16 07:20:51.612233', '7', 'Driver: Herlan Jaelani - DRV123456', 3, '', 7, 2),
(4, '2025-07-16 07:20:51.612552', '6', 'Driver: Nachem Mohaini - DRV12345', 3, '', 7, 2),
(5, '2025-07-16 07:20:51.613006', '5', 'Driver: Hashim Ahmed - 12-13-14-100', 3, '', 7, 2),
(6, '2025-07-16 07:20:51.613258', '4', 'Driver: New Driver - DRV999', 3, '', 7, 2),
(7, '2025-07-16 15:45:36.666015', '12', 'Hashim Ahmed - ', 3, '', 8, 2),
(8, '2025-07-16 15:45:36.666139', '11', 'Herlan Jaelani - ', 3, '', 8, 2),
(9, '2025-07-16 15:45:36.666202', '10', 'Nachem Mohaini - ', 3, '', 8, 2),
(10, '2025-07-16 15:45:36.666255', '9', 'Hashim Ahmed - ', 3, '', 8, 2),
(11, '2025-07-17 13:09:50.810178', '14', 'Hashim Ahmed - Bogor', 3, '', 8, 2),
(12, '2025-07-17 13:09:50.810216', '13', 'Hasyim Ahmad - Jakarta Pusat', 3, '', 8, 2),
(13, '2025-07-17 13:09:50.810231', '6', 'Herlan Jaelani - Jakarta Pusat', 3, '', 8, 2),
(14, '2025-07-17 13:10:27.987809', '18', 'ahmedhashim', 3, '', 4, 2),
(15, '2025-07-17 13:10:27.987892', '12', 'Hashim', 3, '', 4, 2),
(16, '2025-07-17 13:10:27.987918', '16', 'Hashimai', 3, '', 4, 2),
(17, '2025-07-17 13:10:27.987938', '15', 'Hashimo', 3, '', 4, 2),
(18, '2025-07-17 13:10:27.987955', '17', 'hasyim', 3, '', 4, 2),
(19, '2025-07-17 13:10:27.987972', '8', 'herlanjae', 3, '', 4, 2),
(20, '2025-07-17 13:10:27.987991', '13', 'Nachem', 3, '', 4, 2),
(21, '2025-07-17 13:11:59.951436', '3', 'driver1', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 4, 2),
(22, '2025-07-18 18:19:35.480187', '11', 'adminbaru', 3, '', 4, 2),
(23, '2025-07-18 18:19:35.480227', '19', 'herlan1', 3, '', 4, 2),
(24, '2025-07-18 18:19:35.480241', '1', 'rescuegouser', 3, '', 4, 2),
(25, '2025-07-30 18:14:42.661017', '19', 'Nesta Parelo - ', 3, '', 8, 2),
(26, '2025-07-30 18:14:42.661148', '18', 'Hasan Sadeli - ', 3, '', 8, 2),
(27, '2025-07-30 18:14:42.661210', '17', 'Kamran Sulaiman - ', 3, '', 8, 2),
(28, '2025-07-30 18:14:42.661264', '16', 'Ahmad Kasim - Jakarta', 3, '', 8, 2),
(29, '2025-07-30 18:14:42.661316', '8', 'New Driver - ', 3, '', 8, 2),
(30, '2025-07-30 18:14:42.661365', '7', 'John Doe - Jakarta', 3, '', 8, 2),
(31, '2025-07-30 18:14:42.661413', '5', 'Jane Smith - ', 3, '', 8, 2),
(32, '2025-07-30 18:14:42.661459', '4', 'John Doe - ', 3, '', 8, 2),
(33, '2025-07-30 18:14:42.661504', '3', 'Citra Dewi - ', 3, '', 8, 2),
(34, '2025-07-30 18:14:42.661549', '2', 'Budi Prasetyo - ', 3, '', 8, 2),
(35, '2025-07-30 18:14:42.661594', '1', 'Ahmad Sutanto - ', 3, '', 8, 2),
(36, '2025-07-30 18:15:58.528378', '10', 'driver_new', 3, '', 4, 2),
(37, '2025-07-30 18:15:58.528649', '3', 'driver1', 3, '', 4, 2),
(38, '2025-07-30 18:15:58.528815', '4', 'driver2', 3, '', 4, 2),
(39, '2025-07-30 18:15:58.528963', '5', 'driver3', 3, '', 4, 2),
(40, '2025-07-30 18:15:58.529097', '9', 'john_doe', 3, '', 4, 2),
(41, '2025-07-30 18:15:58.529232', '21', 'kamran', 3, '', 4, 2),
(42, '2025-07-30 18:15:58.529363', '20', 'kasimahmad', 3, '', 4, 2),
(43, '2025-07-30 18:15:58.529601', '22', 'ngepni', 3, '', 4, 2),
(44, '2025-07-30 18:15:58.529730', '23', 'parelo', 3, '', 4, 2),
(45, '2025-07-30 18:15:58.529856', '6', 'user1', 3, '', 4, 2),
(46, '2025-07-30 18:15:58.529978', '7', 'user2', 3, '', 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int NOT NULL,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(7, 'accounts', 'driverprofile'),
(8, 'accounts', 'userprofile'),
(1, 'admin', 'logentry'),
(14, 'ambulances', 'ambulance'),
(15, 'ambulances', 'ambulanceassignment'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(11, 'maintenance', 'maintenancerequest'),
(12, 'maintenance', 'maintenanceschedule'),
(13, 'maintenance', 'maintenancestatuslog'),
(9, 'reservations', 'reservation'),
(10, 'reservations', 'reservationstatuslog'),
(6, 'sessions', 'session'),
(16, 'token_blacklist', 'blacklistedtoken'),
(17, 'token_blacklist', 'outstandingtoken');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-06-23 06:08:27.265155'),
(2, 'auth', '0001_initial', '2025-06-23 06:08:29.151840'),
(3, 'accounts', '0001_initial', '2025-06-23 06:08:29.752763'),
(4, 'admin', '0001_initial', '2025-06-23 06:08:30.137014'),
(5, 'admin', '0002_logentry_remove_auto_add', '2025-06-23 06:08:30.146083'),
(6, 'admin', '0003_logentry_add_action_flag_choices', '2025-06-23 06:08:30.160619'),
(7, 'ambulances', '0001_initial', '2025-06-23 06:08:30.785393'),
(8, 'contenttypes', '0002_remove_content_type_name', '2025-06-23 06:08:31.001531'),
(9, 'auth', '0002_alter_permission_name_max_length', '2025-06-23 06:08:31.095186'),
(10, 'auth', '0003_alter_user_email_max_length', '2025-06-23 06:08:31.241544'),
(11, 'auth', '0004_alter_user_username_opts', '2025-06-23 06:08:31.274174'),
(12, 'auth', '0005_alter_user_last_login_null', '2025-06-23 06:08:31.522293'),
(13, 'auth', '0006_require_contenttypes_0002', '2025-06-23 06:08:31.529291'),
(14, 'auth', '0007_alter_validators_add_error_messages', '2025-06-23 06:08:31.562481'),
(15, 'auth', '0008_alter_user_username_max_length', '2025-06-23 06:08:31.870730'),
(16, 'auth', '0009_alter_user_last_name_max_length', '2025-06-23 06:08:32.183480'),
(17, 'auth', '0010_alter_group_name_max_length', '2025-06-23 06:08:32.293436'),
(18, 'auth', '0011_update_proxy_permissions', '2025-06-23 06:08:32.330195'),
(19, 'auth', '0012_alter_user_first_name_max_length', '2025-06-23 06:08:32.748104'),
(20, 'maintenance', '0001_initial', '2025-06-23 06:08:33.956385'),
(21, 'reservations', '0001_initial', '2025-06-23 06:08:35.122542'),
(22, 'sessions', '0001_initial', '2025-06-23 06:08:35.232185'),
(23, 'token_blacklist', '0001_initial', '2025-07-30 16:51:09.298498'),
(24, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2025-07-30 16:51:09.419351'),
(25, 'token_blacklist', '0003_auto_20171017_2007', '2025-07-30 16:51:09.495752'),
(26, 'token_blacklist', '0004_auto_20171017_2013', '2025-07-30 16:51:09.919295'),
(27, 'token_blacklist', '0005_remove_outstandingtoken_jti', '2025-07-30 16:51:10.182258'),
(28, 'token_blacklist', '0006_auto_20171017_2113', '2025-07-30 16:51:10.246421'),
(29, 'token_blacklist', '0007_auto_20171017_2214', '2025-07-30 16:51:11.216310'),
(30, 'token_blacklist', '0008_migrate_to_bigautofield', '2025-07-30 16:51:12.219917'),
(31, 'token_blacklist', '0010_fix_migrate_to_bigautofield', '2025-07-30 16:51:12.296914'),
(32, 'token_blacklist', '0011_linearizes_history', '2025-07-30 16:51:12.304612'),
(33, 'token_blacklist', '0012_alter_outstandingtoken_user', '2025-07-30 16:51:12.327055'),
(34, 'accounts', '0002_alter_driverprofile_hire_date', '2025-07-30 17:46:40.172855'),
(35, 'ambulances', '0002_alter_ambulance_capacity', '2025-07-31 06:41:15.797347');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('g7pwqxzzossbmkee9frjm28jbraqw8o9', '.eJxVjL0OwiAYRd-F2RBKhYKju89Avh-QqoGktJPx3S1JB13ucM7JfYsA25rD1uISZhYXocXplyHQM5Yu-AHlXiXVsi4zyp7IwzZ5qxxf16P9O8jQcr9Fx3HwQ7RjVOBAs3GknEGvCVCNO7WYzDS5876WTDIeLaNJRMiWxecL7Dw4nA:1uebd3:4fcAxpzD7Y0Vdq08ngOWhFk_XwTKfnUW-_BwW8woojA', '2025-08-06 15:43:37.422449'),
('ho0bomkfi4d8fkulsv10r3plviybjixb', '.eJxVjL0OwiAYRd-F2RBKhYKju89Avh-QqoGktJPx3S1JB13ucM7JfYsA25rD1uISZhYXocXplyHQM5Yu-AHlXiXVsi4zyp7IwzZ5qxxf16P9O8jQcr9Fx3HwQ7RjVOBAs3GknEGvCVCNO7WYzDS5876WTDIeLaNJRMiWxecL7Dw4nA:1uhAvH:fU0Tg1WQ0yR5i0UuXf3WoaVxWqGbDp0s-MMDuPnj1H8', '2025-08-13 17:49:03.578361'),
('wgb462ck1f3ewg9y2qo5livkxiw5l2jl', '.eJxVjDsOwjAQBe_iGll21l9Kes4Qrb27JIAcKZ8KcXeIlALaNzPvpXrc1qHfFp77kdRZWXX63QrWB7cd0B3bbdJ1aus8Fr0r-qCLvk7Ez8vh_h0MuAzfurPBCNmcIFvwCYqRChLBB-xSZsmE3lAU7mIU4RCdMBlwCBAc2KjeH8oLN1c:1uVQff:ueEKnzp5hRcLppeQnWL_m1YVKxwff8Jh5j-t2z1WAIQ', '2025-07-12 08:12:23.599526');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_maintenancerequest`
--

CREATE TABLE `maintenance_maintenancerequest` (
  `id` bigint NOT NULL,
  `request_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `symptoms` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_mileage` int UNSIGNED NOT NULL,
  `estimated_cost` decimal(10,2) DEFAULT NULL,
  `actual_cost` decimal(10,2) DEFAULT NULL,
  `estimated_duration` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parts_needed` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_vendor` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `rejection_reason` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` datetime(6) NOT NULL,
  `reviewed_at` datetime(6) DEFAULT NULL,
  `work_started_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `work_performed` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `parts_used` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `technician_notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_ambulance_operational` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `ambulance_id` bigint NOT NULL,
  `requested_by_id` bigint NOT NULL,
  `reviewed_by_id` int DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_maintenanceschedule`
--

CREATE TABLE `maintenance_maintenanceschedule` (
  `id` bigint NOT NULL,
  `schedule_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `frequency_days` int UNSIGNED NOT NULL,
  `last_performed` datetime(6) DEFAULT NULL,
  `next_due` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `ambulance_id` bigint NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_maintenancestatuslog`
--

CREATE TABLE `maintenance_maintenancestatuslog` (
  `id` bigint NOT NULL,
  `previous_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by_id` int DEFAULT NULL,
  `maintenance_request_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations_reservation`
--

CREATE TABLE `reservations_reservation` (
  `id` bigint NOT NULL,
  `reservation_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patient_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patient_age` int UNSIGNED NOT NULL,
  `patient_gender` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `patient_condition` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `medical_history` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_symptoms` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_address` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_latitude` decimal(10,7) DEFAULT NULL,
  `pickup_longitude` decimal(10,7) DEFAULT NULL,
  `destination_address` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_latitude` decimal(10,7) DEFAULT NULL,
  `destination_longitude` decimal(10,7) DEFAULT NULL,
  `emergency_contact_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_contact_phone` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_contact_relationship` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` datetime(6) NOT NULL,
  `accepted_at` datetime(6) DEFAULT NULL,
  `pickup_started_at` datetime(6) DEFAULT NULL,
  `patient_picked_up_at` datetime(6) DEFAULT NULL,
  `arrived_at_destination` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `special_requirements` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `estimated_cost` decimal(10,2) DEFAULT NULL,
  `actual_cost` decimal(10,2) DEFAULT NULL,
  `payment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `driver_notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `assigned_ambulance_id` bigint DEFAULT NULL,
  `assigned_driver_id` bigint DEFAULT NULL,
  `user_id` int NOT NULL
) ;

--
-- Dumping data for table `reservations_reservation`
--

INSERT INTO `reservations_reservation` (`id`, `reservation_id`, `status`, `priority`, `emergency_type`, `patient_name`, `patient_age`, `patient_gender`, `patient_condition`, `medical_history`, `current_symptoms`, `pickup_address`, `pickup_city`, `pickup_latitude`, `pickup_longitude`, `destination_address`, `destination_city`, `destination_latitude`, `destination_longitude`, `emergency_contact_name`, `emergency_contact_phone`, `emergency_contact_relationship`, `requested_at`, `accepted_at`, `pickup_started_at`, `patient_picked_up_at`, `arrived_at_destination`, `completed_at`, `special_requirements`, `estimated_cost`, `actual_cost`, `payment_status`, `notes`, `driver_notes`, `created_at`, `updated_at`, `assigned_ambulance_id`, `assigned_driver_id`, `user_id`) VALUES
(8, 'RES20250731110144', 'completed', 'high', 'routine', 'La Nesta', 30, 'male', 'Patah kaki', '', 'tidak ada', 'Kemayoran', 'Jakarta', NULL, NULL, 'Kebon Jeruk', 'Jakarta', NULL, NULL, 'Farelyo', '08123456789', 'Teman', '2025-07-31 04:01:44.002752', '2025-07-31 04:08:20.507175', '2025-07-31 05:18:31.591654', '2025-07-31 05:18:42.011459', NULL, '2025-07-31 05:18:47.648102', '', NULL, NULL, 'pending', '', '', '2025-07-31 04:01:44.002935', '2025-07-31 05:18:47.648678', 25, 13, 26),
(9, 'RES20250731131358', 'completed', 'high', 'accident', 'La Nesta', 60, 'male', 'Sakit Dada', '', 'Sesak Hati', 'Kemayoran', 'Jakarta', NULL, NULL, 'Rumah Sakit Ukrida', 'Jakarta', NULL, NULL, 'Farelyo', '08123456789', 'Teman', '2025-07-31 06:13:58.310161', '2025-07-31 06:14:49.191860', '2025-07-31 06:19:18.741578', '2025-07-31 06:19:44.978256', NULL, '2025-07-31 06:20:14.466332', '', NULL, NULL, 'pending', '', '', '2025-07-31 06:13:58.310351', '2025-07-31 06:20:14.466459', 25, 13, 26);

-- --------------------------------------------------------

--
-- Table structure for table `reservations_reservationstatuslog`
--

CREATE TABLE `reservations_reservationstatuslog` (
  `id` bigint NOT NULL,
  `previous_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `notes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by_id` int DEFAULT NULL,
  `reservation_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reservations_reservationstatuslog`
--

INSERT INTO `reservations_reservationstatuslog` (`id`, `previous_status`, `new_status`, `timestamp`, `notes`, `changed_by_id`, `reservation_id`) VALUES
(15, 'pending', 'accepted', '2025-07-31 04:08:20.557428', 'Assigned to driver Hasan Sadeli and ambulance B 1234 TST', 2, 8),
(16, 'accepted', 'picking_up', '2025-07-31 05:18:31.584404', '', 25, 8),
(17, 'picking_up', 'on_route', '2025-07-31 05:18:42.005855', '', 25, 8),
(18, 'on_route', 'completed', '2025-07-31 05:18:47.642702', '', 25, 8),
(19, 'pending', 'accepted', '2025-07-31 06:14:49.240636', 'Assigned to driver Hasan Sadeli and ambulance B 1234 TST', 2, 9),
(20, 'accepted', 'picking_up', '2025-07-31 06:19:18.736751', '', 25, 9),
(21, 'picking_up', 'on_route', '2025-07-31 06:19:44.972019', '', 25, 9),
(22, 'on_route', 'completed', '2025-07-31 06:20:14.465269', '', 25, 9);

-- --------------------------------------------------------

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

INSERT INTO `token_blacklist_blacklistedtoken` (`id`, `blacklisted_at`, `token_id`) VALUES
(1, '2025-07-30 16:51:48.872857', 1),
(2, '2025-07-30 16:52:25.801571', 2),
(3, '2025-07-30 16:54:11.190984', 3),
(4, '2025-07-30 16:54:24.469260', 4),
(5, '2025-07-30 16:58:03.478563', 5),
(6, '2025-07-30 17:02:04.946673', 6),
(7, '2025-07-30 17:24:09.710365', 7),
(8, '2025-07-30 17:55:55.030740', 8),
(9, '2025-07-30 17:58:07.834930', 10),
(10, '2025-07-31 02:42:40.375340', 12),
(11, '2025-07-31 03:01:35.320933', 15),
(12, '2025-07-31 03:43:28.059105', 17),
(13, '2025-07-31 03:58:55.989777', 19),
(14, '2025-07-31 04:19:16.667852', 24),
(15, '2025-07-31 05:50:30.473807', 29),
(16, '2025-07-31 06:10:42.418964', 30),
(17, '2025-07-31 06:14:10.736500', 31),
(18, '2025-07-31 06:15:12.431795', 32),
(19, '2025-07-31 07:14:03.976709', 34);

-- --------------------------------------------------------

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL,
  `token` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` int DEFAULT NULL,
  `jti` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

INSERT INTO `token_blacklist_outstandingtoken` (`id`, `token`, `created_at`, `expires_at`, `user_id`, `jti`) VALUES
(1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTEwMywiaWF0IjoxNzUzODk0MzAzLCJqdGkiOiI5NjBiYjFjZDE1ZmI0MDg2YWI2Y2Y2OWYxZDk3NWZkOCIsInVzZXJfaWQiOjJ9.vVS5rsNu3xolOPN6hjNc5GGaGOuHNQFdlr998ZmlViw', '2025-07-30 16:51:43.661348', '2025-08-06 16:51:43.000000', 2, '960bb1cd15fb4086ab6cf69f1d975fd8'),
(2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTExNSwiaWF0IjoxNzUzODk0MzE1LCJqdGkiOiJlZDY0MjZiY2M2OTk0N2IyYTVhMTlmMDZjZGVlMDJkOSIsInVzZXJfaWQiOjJ9.BBGFXJ2tQQoGZqGc1w2S3wi8rGKrJIHJjUplGIjmkXM', '2025-07-30 16:51:55.400547', '2025-08-06 16:51:55.000000', 2, 'ed6426bcc69947b2a5a19f06cdee02d9'),
(3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTIxMCwiaWF0IjoxNzUzODk0NDEwLCJqdGkiOiJjNWRhOWE4MDA0MTQ0NmQxYTEzOWQ2NjUwY2YwYjRjMCIsInVzZXJfaWQiOjJ9.ERr_e4BPcH0KGBPmrKkE_LQIdqat4YwPGtN8uaJcVSU', '2025-07-30 16:53:30.976708', '2025-08-06 16:53:30.000000', 2, 'c5da9a80041446d1a139d6650cf0b4c0'),
(4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTI1NywiaWF0IjoxNzUzODk0NDU3LCJqdGkiOiIwMWZlMmQ4YjhjY2Y0NjgwOWEyY2QyMzFlNGUwMjI2ZSIsInVzZXJfaWQiOjJ9.PdtZ_CrowqvysAXWj5KoYJoq_BiRoegZWu59o2mCmEQ', '2025-07-30 16:54:17.853050', '2025-08-06 16:54:17.000000', 2, '01fe2d8b8ccf46809a2cd231e4e0226e'),
(5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTQ0NywiaWF0IjoxNzUzODk0NjQ3LCJqdGkiOiJiNjI4YTM1OWJlYmE0ZDE5YmFmYzIzYjdmODc5NzFlZiIsInVzZXJfaWQiOjJ9.wuzeucW-dlRoe60OlzPJKRncKLZEury3izIBqcrTJE4', '2025-07-30 16:57:27.008417', '2025-08-06 16:57:27.000000', 2, 'b628a359beba4d19bafc23b7f87971ef'),
(6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTY5NywiaWF0IjoxNzUzODk0ODk3LCJqdGkiOiI2NThjY2NhYWM4NzU0NmRhYjAwODgzYjM0YTg3MzM5NyIsInVzZXJfaWQiOjJ9.BTHWx1pSohxs4o1VDAfBMsiMa-ioZuavppsNzoVHFvA', '2025-07-30 17:01:37.591963', '2025-08-06 17:01:37.000000', 2, '658cccaac87546dab00883b34a873397'),
(7, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDQ5OTczMSwiaWF0IjoxNzUzODk0OTMxLCJqdGkiOiI1NTAxMDQxOTQ4N2U0NmI3YTFmYTMzZmM1ZTMxNTE3MiIsInVzZXJfaWQiOjJ9.B5YpaEoufZITv82BFSQEYPu26Cmy3aRDscfcFbQfv90', '2025-07-30 17:02:11.210143', '2025-08-06 17:02:11.000000', 2, '55010419487e46b7a1fa33fc5e315172'),
(8, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUwMTcwMSwiaWF0IjoxNzUzODk2OTAxLCJqdGkiOiI0M2Y5NTAxZTI2NDM0MjcyOTVkZTc3Y2U0NjA3NGVkMSIsInVzZXJfaWQiOjJ9.R7BRsVIF83r-oQ1e7PvH-HgE4gsFnxJlhXZBUpYI_4I', '2025-07-30 17:35:01.750015', '2025-08-06 17:35:01.000000', 2, '43f9501e2643427295de77ce46074ed1'),
(9, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUwMjk3OSwiaWF0IjoxNzUzODk4MTc5LCJqdGkiOiJkYTYyNzkwMGZmOWM0MjVmYjFlNmMzNmVmOGYzYzYxMyIsInVzZXJfaWQiOjI0fQ.nnxymtppiQDGmSVz_oj20rQjmHuaQM2YHaRcvpWywSk', '2025-07-30 17:56:19.974991', '2025-08-06 17:56:19.000000', NULL, 'da627900ff9c425fb1e6c36ef8f3c613'),
(10, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUwMzA4MiwiaWF0IjoxNzUzODk4MjgyLCJqdGkiOiIzM2FmYzUxZGRhMTg0MmU5YjdhNzg4ZjBhZWExYWM5OSIsInVzZXJfaWQiOjJ9.nBQy1HVa65u-hBWF_LRPZo072LmeiWqabX84DrNvZ6w', '2025-07-30 17:58:02.751100', '2025-08-06 17:58:02.000000', 2, '33afc51dda1842e9b7a788f0aea1ac99'),
(11, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUwMzA5MiwiaWF0IjoxNzUzODk4MjkyLCJqdGkiOiIwNDI0YTFjZDA0Zjg0MWQ1OTdhM2U1MGQ3NTA1MWE3NSIsInVzZXJfaWQiOjJ9.v5hR0QYrDo1pzN36Dz1kld_CpjhJS1NsyuKo7IKzs4g', '2025-07-30 17:58:12.370816', '2025-08-06 17:58:12.000000', 2, '0424a1cd04f841d597a3e50d75051a75'),
(12, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNDM4NiwiaWF0IjoxNzUzOTI5NTg2LCJqdGkiOiIzZTQ5YzcxYTRlN2E0YmUzYjZlYmY3MDQzZjFhM2MzNSIsInVzZXJfaWQiOjJ9.LaMhHJnolNgMFqeCRboo2mtKcgtk95UhNTU5hwXKJg0', '2025-07-31 02:39:46.956572', '2025-08-07 02:39:46.000000', 2, '3e49c71a4e7a4be3b6ebf7043f1a3c35'),
(13, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNDYzMywiaWF0IjoxNzUzOTI5ODMzLCJqdGkiOiIyZmY0NWIyYWNiOTc0M2I1ODlkYzQ3M2QyZDhhYmRkMCIsInVzZXJfaWQiOjI2fQ.XM6TfaMIeZPtbNDhP1SwOjm08MP16vyyQdtn2TKTErY', '2025-07-31 02:43:53.135263', '2025-08-07 02:43:53.000000', 26, '2ff45b2acb9743b589dc473d2d8abdd0'),
(14, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNDY0NiwiaWF0IjoxNzUzOTI5ODQ2LCJqdGkiOiJiYzQwMzRkMGQ3YTg0Mjg0OWZjNzMwNWZhNzFlMTgyMSIsInVzZXJfaWQiOjI2fQ.zY9raJTBZNcameWp7PuRiq32QS8noTVAb8xRtodLyEc', '2025-07-31 02:44:06.076257', '2025-08-07 02:44:06.000000', 26, 'bc4034d0d7a842849fc7305fa71e1821'),
(15, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNDY4NiwiaWF0IjoxNzUzOTI5ODg2LCJqdGkiOiI3YTkxMWY3MTk0MmY0ODkxOTlhZWY2MTlkYzk5ZTQxOCIsInVzZXJfaWQiOjJ9.43j4QWgitBsH5iKzNbmscOjCbyjty1tQ77Rm0GfsdOQ', '2025-07-31 02:44:46.093854', '2025-08-07 02:44:46.000000', 2, '7a911f71942f489199aef619dc99e418'),
(16, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNTcyMCwiaWF0IjoxNzUzOTMwOTIwLCJqdGkiOiIzNmUyMzc0YWUzZDA0MDMyYjM5ZmMwNGRiNGQwNGZkYSIsInVzZXJfaWQiOjI1fQ.KvEu8owx52_oXn6_Gg4CFxjyfxjUXJizIR27cETAoPY', '2025-07-31 03:02:00.994693', '2025-08-07 03:02:00.000000', 25, '36e2374ae3d04032b39fc04db4d04fda'),
(17, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzNTc1NSwiaWF0IjoxNzUzOTMwOTU1LCJqdGkiOiI2Y2Y2NmM0ZDliOTY0NTU0ODdiZTMwODFhNzI1MjkzOCIsInVzZXJfaWQiOjJ9.c1gI4I-cqSnnqhDpYTyyVud_OGSLxEnvlBl_-8nwZo4', '2025-07-31 03:02:35.179054', '2025-08-07 03:02:35.000000', 2, '6cf66c4d9b96455487be3081a7252938'),
(18, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzODIzNiwiaWF0IjoxNzUzOTMzNDM2LCJqdGkiOiIwMDA5YmY2N2FkNjA0ZGUyODY2OGJlMmZmYmY2NGUzZiIsInVzZXJfaWQiOjI1fQ.OwbPBnqvQnS4l0tj6SdHrZkgpSD8zJ1nMoXV--qDR30', '2025-07-31 03:43:56.367652', '2025-08-07 03:43:56.000000', 25, '0009bf67ad604de28668be2ffbf64e3f'),
(19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzODI5MiwiaWF0IjoxNzUzOTMzNDkyLCJqdGkiOiI0NDIzMTg5ZTUwMGY0Y2YwOGVhNzYwZjRjZTEwNDIyZSIsInVzZXJfaWQiOjJ9.ZnW87_FSJEGfj4_-FaXrTX3w8UDnMvsNS62DQcnVG28', '2025-07-31 03:44:52.431729', '2025-08-07 03:44:52.000000', 2, '4423189e500f4cf08ea760f4ce10422e'),
(20, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzOTIyNiwiaWF0IjoxNzUzOTM0NDI2LCJqdGkiOiJlZDQ4NzFkMzQ3OTQ0NTUwYWM2OTM5NTI4YzQ5ZmQwYSIsInVzZXJfaWQiOjI2fQ.P3Y-_7l9Cuq46ivlHxW8TEpin0EuW9Ahu4YQ4bfvakY', '2025-07-31 04:00:26.615392', '2025-08-07 04:00:26.000000', 26, 'ed4871d347944550ac6939528c49fd0a'),
(21, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzOTMzMCwiaWF0IjoxNzUzOTM0NTMwLCJqdGkiOiI1Yzk2OTcxODRjZmI0OTRjOTM4Zjc2OWEzNmQ4M2ZiZCIsInVzZXJfaWQiOjJ9.MGBrdyQU31R4M2kRBDmlIa2oAHK4akMP51yt_kBTMkg', '2025-07-31 04:02:10.064950', '2025-08-07 04:02:10.000000', 2, '5c9697184cfb494c938f769a36d83fbd'),
(22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzOTc3OCwiaWF0IjoxNzUzOTM0OTc4LCJqdGkiOiI5NzY4ZWQ3N2RhYzE0ODQ1Yjg3NDdmNDEzOTY4ODZkNyIsInVzZXJfaWQiOjI2fQ.cuHYwLHxsxN044GK_OFv3yyESj4dVpgokVUL5gRF70Y', '2025-07-31 04:09:38.207158', '2025-08-07 04:09:38.000000', 26, '9768ed77dac14845b8747f41396886d7'),
(23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzOTgxNiwiaWF0IjoxNzUzOTM1MDE2LCJqdGkiOiIwNjk1NjcyM2UxZTc0MGUyYTA1YTZiYTFlOTFiNmNkMSIsInVzZXJfaWQiOjI1fQ.33AaGlGO9fnO8nsVbgUAHadQOFaWUJxoRlLY9S0RvBk', '2025-07-31 04:10:16.360529', '2025-08-07 04:10:16.000000', 25, '06956723e1e740e2a05a6ba1e91b6cd1'),
(24, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDUzOTg2OSwiaWF0IjoxNzUzOTM1MDY5LCJqdGkiOiIwOGVhMzM2M2QyMzM0NTFhOWNhY2JlMmMzYjE2ZThlOCIsInVzZXJfaWQiOjJ9.wzHZfdPeZrryI6Z_ERS9Y-6tjKrJtjV886AT1JHmvlo', '2025-07-31 04:11:09.774842', '2025-08-07 04:11:09.000000', 2, '08ea3363d233451a9cacbe2c3b16e8e8'),
(25, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0MDM3NSwiaWF0IjoxNzUzOTM1NTc1LCJqdGkiOiI0ODMxZTQ3NDBiM2Y0OWI0OTNiMGM2N2ZjZDZjNmNiZCIsInVzZXJfaWQiOjI1fQ.XjwtWgb_X3QxajKMKpU6ZSexvtRASL2_uHIJ8cGIJKY', '2025-07-31 04:19:35.864336', '2025-08-07 04:19:35.000000', 25, '4831e4740b3f49b493b0c67fcd6c6cbd'),
(26, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0MzIwOCwiaWF0IjoxNzUzOTM4NDA4LCJqdGkiOiI5NjBlMDJkY2FhNjA0ZmFkYTk0NzZjOTAzNDZhOWJiMyIsInVzZXJfaWQiOjI1fQ.An-MMZLuTUV9gqYTFIqd21sXrtZ9ynHdKQIDsep6YzM', '2025-07-31 05:06:48.988239', '2025-08-07 05:06:48.000000', 25, '960e02dcaa604fada9476c90346a9bb3'),
(27, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0Mzk4NSwiaWF0IjoxNzUzOTM5MTg1LCJqdGkiOiI4NTcyMThmZDZmOTk0OTk5OWIyMzg4MDE0NTNlNjZiMSIsInVzZXJfaWQiOjI2fQ.rdLfgbtrdO_xe0zmnBxYKWdkmmyhw38WXNaNMyMqm7E', '2025-07-31 05:19:45.533447', '2025-08-07 05:19:45.000000', 26, '857218fd6f9949999b238801453e66b1'),
(28, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NTU1MCwiaWF0IjoxNzUzOTQwNzUwLCJqdGkiOiJlODAxODQ1ZWUwYmM0ZWU3OWQ0NTg2ZmNiNDQ0MzMxNyIsInVzZXJfaWQiOjI2fQ.l7moGHWi5j-oy3kXAxAqsjByjOnIosTSCkjm5p1ApQw', '2025-07-31 05:45:50.807473', '2025-08-07 05:45:50.000000', 26, 'e801845ee0bc4ee79d4586fcb4443317'),
(29, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NTgyMCwiaWF0IjoxNzUzOTQxMDIwLCJqdGkiOiI3ZGM4NzNmYjU4OTY0MTUxYWNlZmY2OTEzOTZiMDRhYyIsInVzZXJfaWQiOjI2fQ.x6TROoQ-JAs-24qcFdh5wI6_K5j41o39sENNzLrpsZA', '2025-07-31 05:50:20.212663', '2025-08-07 05:50:20.000000', 26, '7dc873fb58964151aceff691396b04ac'),
(30, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NTg5MSwiaWF0IjoxNzUzOTQxMDkxLCJqdGkiOiJjYWI2MzQxZTcxOTk0OGY5OWM5M2UwMzI5YWU4MTRkMCIsInVzZXJfaWQiOjI1fQ.-WB5oebfxMSix5lpuquUffCJ-qWEUCMEcXIdA08j-ik', '2025-07-31 05:51:31.974079', '2025-08-07 05:51:31.000000', 25, 'cab6341e719948f99c93e0329ae814d0'),
(31, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NzExMCwiaWF0IjoxNzUzOTQyMzEwLCJqdGkiOiI1YTJkZDUxZDRmNmQ0OWQ1YjI0MWRlNGJiYzc3YTBlNCIsInVzZXJfaWQiOjI2fQ.au2hZy-1SKwnYe43U_BzwJI9m8ATpX4khrxRRMTzkAg', '2025-07-31 06:11:50.297943', '2025-08-07 06:11:50.000000', 26, '5a2dd51d4f6d49d5b241de4bbc77a0e4'),
(32, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NzI3MSwiaWF0IjoxNzUzOTQyNDcxLCJqdGkiOiIxNDE3MTRhOGJhYjI0YzJjODZkYTdmNzhkZWZhNjcwZiIsInVzZXJfaWQiOjJ9.lUcN2aUwEUj7L1pbKEmu-7d8xrBUYzkLV8lXgvP3CrY', '2025-07-31 06:14:31.755113', '2025-08-07 06:14:31.000000', 2, '141714a8bab24c2c86da7f78defa670f'),
(33, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU0NzM0NCwiaWF0IjoxNzUzOTQyNTQ0LCJqdGkiOiI2OTRmOWQxZTNkNTc0YzdiYmUyNTZlMmM5YWJjMzIxMyIsInVzZXJfaWQiOjI1fQ.3qukXHYE1gughxGHWPJfdiSO4QDgb_jc8uT1uMlrrmQ', '2025-07-31 06:15:44.578655', '2025-08-07 06:15:44.000000', 25, '694f9d1e3d574c7bbe256e2c9abc3213'),
(34, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NDU1MDgzNSwiaWF0IjoxNzUzOTQ2MDM1LCJqdGkiOiJjODA3NjAzNTE2YTc0ZTRjYTk5YWY5NTc2ZDJjYWQ5MSIsInVzZXJfaWQiOjI1fQ.sdIzqErSD4qzaoKpTK7Ra2DRsNIuHIG650uajrGwqww', '2025-07-31 07:13:55.459793', '2025-08-07 07:13:55.000000', 25, 'c807603516a74e4ca99af9576d2cad91');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts_driverprofile`
--
ALTER TABLE `accounts_driverprofile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `driver_license_number` (`driver_license_number`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `accounts_userprofile`
--
ALTER TABLE `accounts_userprofile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `ambulances_ambulance`
--
ALTER TABLE `ambulances_ambulance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `license_plate` (`license_plate`),
  ADD KEY `ambulances_ambulance_current_driver_id_30c01bf1_fk_accounts_` (`current_driver_id`);

--
-- Indexes for table `ambulances_ambulanceassignment`
--
ALTER TABLE `ambulances_ambulanceassignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ambulances_ambulanceassi_driver_id_ambulance_id_a_57c8c46d_uniq` (`driver_id`,`ambulance_id`,`assigned_date`),
  ADD KEY `ambulances_ambulance_ambulance_id_76a43040_fk_ambulance` (`ambulance_id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `maintenance_maintenancerequest`
--
ALTER TABLE `maintenance_maintenancerequest`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_id` (`request_id`),
  ADD KEY `maintenance_maintena_ambulance_id_3ae3446a_fk_ambulance` (`ambulance_id`),
  ADD KEY `maintenance_maintena_requested_by_id_2ef77a05_fk_accounts_` (`requested_by_id`),
  ADD KEY `maintenance_maintena_reviewed_by_id_6b87705c_fk_auth_user` (`reviewed_by_id`);

--
-- Indexes for table `maintenance_maintenanceschedule`
--
ALTER TABLE `maintenance_maintenanceschedule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `maintenance_maintena_ambulance_id_a59d38cf_fk_ambulance` (`ambulance_id`);

--
-- Indexes for table `maintenance_maintenancestatuslog`
--
ALTER TABLE `maintenance_maintenancestatuslog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `maintenance_maintena_changed_by_id_74f536f8_fk_auth_user` (`changed_by_id`),
  ADD KEY `maintenance_maintena_maintenance_request__817b2fdb_fk_maintenan` (`maintenance_request_id`);

--
-- Indexes for table `reservations_reservation`
--
ALTER TABLE `reservations_reservation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reservation_id` (`reservation_id`),
  ADD KEY `reservations_reserva_assigned_ambulance_i_f4702d4f_fk_ambulance` (`assigned_ambulance_id`),
  ADD KEY `reservations_reserva_assigned_driver_id_b5640998_fk_accounts_` (`assigned_driver_id`),
  ADD KEY `reservations_reservation_user_id_6ed5b1c9_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `reservations_reservationstatuslog`
--
ALTER TABLE `reservations_reservationstatuslog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservations_reserva_changed_by_id_9b206782_fk_auth_user` (`changed_by_id`),
  ADD KEY `reservations_reserva_reservation_id_d63eccd8_fk_reservati` (`reservation_id`);

--
-- Indexes for table `token_blacklist_blacklistedtoken`
--
ALTER TABLE `token_blacklist_blacklistedtoken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_id` (`token_id`);

--
-- Indexes for table `token_blacklist_outstandingtoken`
--
ALTER TABLE `token_blacklist_outstandingtoken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  ADD KEY `token_blacklist_outs_user_id_83bc629a_fk_auth_user` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts_driverprofile`
--
ALTER TABLE `accounts_driverprofile`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounts_userprofile`
--
ALTER TABLE `accounts_userprofile`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `ambulances_ambulance`
--
ALTER TABLE `ambulances_ambulance`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ambulances_ambulanceassignment`
--
ALTER TABLE `ambulances_ambulanceassignment`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `maintenance_maintenancerequest`
--
ALTER TABLE `maintenance_maintenancerequest`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_maintenanceschedule`
--
ALTER TABLE `maintenance_maintenanceschedule`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_maintenancestatuslog`
--
ALTER TABLE `maintenance_maintenancestatuslog`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reservations_reservation`
--
ALTER TABLE `reservations_reservation`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations_reservationstatuslog`
--
ALTER TABLE `reservations_reservationstatuslog`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `token_blacklist_blacklistedtoken`
--
ALTER TABLE `token_blacklist_blacklistedtoken`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `token_blacklist_outstandingtoken`
--
ALTER TABLE `token_blacklist_outstandingtoken`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts_driverprofile`
--
ALTER TABLE `accounts_driverprofile`
  ADD CONSTRAINT `accounts_driverprofile_user_id_b7e4cabc_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `accounts_userprofile`
--
ALTER TABLE `accounts_userprofile`
  ADD CONSTRAINT `accounts_userprofile_user_id_92240672_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `ambulances_ambulance`
--
ALTER TABLE `ambulances_ambulance`
  ADD CONSTRAINT `ambulances_ambulance_current_driver_id_30c01bf1_fk_accounts_` FOREIGN KEY (`current_driver_id`) REFERENCES `accounts_driverprofile` (`id`);

--
-- Constraints for table `ambulances_ambulanceassignment`
--
ALTER TABLE `ambulances_ambulanceassignment`
  ADD CONSTRAINT `ambulances_ambulance_ambulance_id_76a43040_fk_ambulance` FOREIGN KEY (`ambulance_id`) REFERENCES `ambulances_ambulance` (`id`),
  ADD CONSTRAINT `ambulances_ambulance_driver_id_97e5c423_fk_accounts_` FOREIGN KEY (`driver_id`) REFERENCES `accounts_driverprofile` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `maintenance_maintenancerequest`
--
ALTER TABLE `maintenance_maintenancerequest`
  ADD CONSTRAINT `maintenance_maintena_ambulance_id_3ae3446a_fk_ambulance` FOREIGN KEY (`ambulance_id`) REFERENCES `ambulances_ambulance` (`id`),
  ADD CONSTRAINT `maintenance_maintena_requested_by_id_2ef77a05_fk_accounts_` FOREIGN KEY (`requested_by_id`) REFERENCES `accounts_driverprofile` (`id`),
  ADD CONSTRAINT `maintenance_maintena_reviewed_by_id_6b87705c_fk_auth_user` FOREIGN KEY (`reviewed_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `maintenance_maintenanceschedule`
--
ALTER TABLE `maintenance_maintenanceschedule`
  ADD CONSTRAINT `maintenance_maintena_ambulance_id_a59d38cf_fk_ambulance` FOREIGN KEY (`ambulance_id`) REFERENCES `ambulances_ambulance` (`id`);

--
-- Constraints for table `maintenance_maintenancestatuslog`
--
ALTER TABLE `maintenance_maintenancestatuslog`
  ADD CONSTRAINT `maintenance_maintena_changed_by_id_74f536f8_fk_auth_user` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `maintenance_maintena_maintenance_request__817b2fdb_fk_maintenan` FOREIGN KEY (`maintenance_request_id`) REFERENCES `maintenance_maintenancerequest` (`id`);

--
-- Constraints for table `reservations_reservation`
--
ALTER TABLE `reservations_reservation`
  ADD CONSTRAINT `reservations_reserva_assigned_ambulance_i_f4702d4f_fk_ambulance` FOREIGN KEY (`assigned_ambulance_id`) REFERENCES `ambulances_ambulance` (`id`),
  ADD CONSTRAINT `reservations_reserva_assigned_driver_id_b5640998_fk_accounts_` FOREIGN KEY (`assigned_driver_id`) REFERENCES `accounts_driverprofile` (`id`),
  ADD CONSTRAINT `reservations_reservation_user_id_6ed5b1c9_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `reservations_reservationstatuslog`
--
ALTER TABLE `reservations_reservationstatuslog`
  ADD CONSTRAINT `reservations_reserva_changed_by_id_9b206782_fk_auth_user` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `reservations_reserva_reservation_id_d63eccd8_fk_reservati` FOREIGN KEY (`reservation_id`) REFERENCES `reservations_reservation` (`id`);

--
-- Constraints for table `token_blacklist_blacklistedtoken`
--
ALTER TABLE `token_blacklist_blacklistedtoken`
  ADD CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`);

--
-- Constraints for table `token_blacklist_outstandingtoken`
--
ALTER TABLE `token_blacklist_outstandingtoken`
  ADD CONSTRAINT `token_blacklist_outs_user_id_83bc629a_fk_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
