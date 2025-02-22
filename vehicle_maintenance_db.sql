-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2025 at 11:37 AM
-- Server version: 5.7.39-log
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vehicle_maintenance_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_issues`
--

CREATE TABLE `maintenance_issues` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `issue_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `reported_mileage` decimal(10,2) NOT NULL,
  `status` enum('pending','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `reported_by` int(11) NOT NULL,
  `reported_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `maintenance_issues`
--

INSERT INTO `maintenance_issues` (`id`, `vehicle_id`, `issue_type`, `description`, `reported_mileage`, `status`, `reported_by`, `reported_at`, `completed_at`) VALUES
(1, 17, 'engine', 'เครื่องยนต์มีเสียงดังผิดปกติ', 50000.00, 'in_progress', 7, '2025-02-22 09:34:41', NULL),
(2, 18, 'brake', 'เบรกสั่น เสียงดังเวลาเหยียบ', 75000.00, 'pending', 7, '2025-02-22 09:34:41', NULL),
(3, 1, 'tire', 'ยางหน้าซ้ายรั่ว', 5000.00, 'pending', 7, '2025-02-22 09:34:41', NULL),
(4, 2, 'electrical', 'ไฟหน้าไม่ติด', 15000.00, 'pending', 7, '2025-02-22 09:34:41', NULL),
(5, 3, 'suspension', 'ช่วงล่างมีเสียงดัง', 8000.00, 'pending', 7, '2025-02-22 09:34:41', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_records`
--

CREATE TABLE `maintenance_records` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `maintenance_type` enum('engine','brake','suspension','electrical','tire','body','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `cost` decimal(10,2) DEFAULT '0.00',
  `status` enum('pending','in_progress','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `maintenance_records`
--

INSERT INTO `maintenance_records` (`id`, `vehicle_id`, `maintenance_type`, `description`, `cost`, `status`, `created_at`, `updated_at`) VALUES
(1, 17, 'engine', 'เปลี่ยนถ่ายน้ำมันเครื่องและไส้กรอง', 2500.00, 'completed', '2025-02-22 09:07:35', '2025-02-22 09:07:35'),
(2, 17, 'brake', 'เปลี่ยนผ้าเบรกหน้า', 1800.00, 'completed', '2025-02-22 09:07:35', '2025-02-22 09:07:35'),
(3, 18, 'suspension', 'เปลี่ยนโช้คอัพหน้า', 12000.00, 'in_progress', '2025-02-22 09:07:35', '2025-02-22 09:07:35');

-- --------------------------------------------------------

--
-- Table structure for table `parts`
--

CREATE TABLE `parts` (
  `id` int(11) NOT NULL,
  `part_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci,
  `unit` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int(11) DEFAULT '0',
  `min_quantity` int(11) DEFAULT '0',
  `cost` decimal(10,2) DEFAULT '0.00',
  `supplier` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive','deleted') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `part_transactions`
--

CREATE TABLE `part_transactions` (
  `id` int(11) NOT NULL,
  `part_id` int(11) NOT NULL,
  `type` enum('in','out') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int(11) NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `note` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pm_cost_estimates`
--

CREATE TABLE `pm_cost_estimates` (
  `id` int(11) NOT NULL,
  `maintenance_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estimated_cost` decimal(10,2) NOT NULL,
  `valid_from` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pm_cost_estimates`
--

INSERT INTO `pm_cost_estimates` (`id`, `maintenance_type`, `estimated_cost`, `valid_from`, `valid_until`, `created_at`) VALUES
(1, 'เปลี่ยนถ่ายน้ำมันเครื่อง', 1500.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(2, 'เปลี่ยนไส้กรองอากาศ', 800.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(3, 'ตรวจสอบผ้าเบรก', 2500.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(4, 'ตรวจสอบยาง', 500.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(5, 'ตรวจสอบระบบเบรก', 3000.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(6, 'ตรวจสอบคลัตช์', 1000.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(7, 'ตรวจสอบระบบหล่อเย็น', 1500.00, '2024-01-01', NULL, '2025-02-22 05:39:25'),
(8, 'ตรวจเช็คสภาพทั่วไป', 500.00, '2024-01-01', NULL, '2025-02-22 05:39:25');

-- --------------------------------------------------------

--
-- Table structure for table `pm_history`
--

CREATE TABLE `pm_history` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `service_date` date NOT NULL,
  `mileage` int(11) NOT NULL,
  `pm_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `next_service_mileage` int(11) DEFAULT NULL,
  `next_service_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'completed',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pm_plans`
--

CREATE TABLE `pm_plans` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `pm_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `service_interval_km` int(11) NOT NULL,
  `service_interval_months` int(11) NOT NULL,
  `last_service_date` date DEFAULT NULL,
  `next_service_date` date NOT NULL,
  `last_service_mileage` int(11) DEFAULT NULL,
  `next_service_mileage` int(11) NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pm_records`
--

CREATE TABLE `pm_records` (
  `id` int(11) NOT NULL,
  `pm_plan_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `service_date` date NOT NULL,
  `mileage` int(11) NOT NULL,
  `mechanic_id` int(11) NOT NULL,
  `notes` mediumtext COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pm_settings`
--

CREATE TABLE `pm_settings` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `pm_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_mileage` int(11) NOT NULL,
  `last_service_date` date NOT NULL,
  `next_service_mileage` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pm_type_settings`
--

CREATE TABLE `pm_type_settings` (
  `id` int(11) NOT NULL,
  `pm_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mileage_interval` int(11) NOT NULL COMMENT 'ระยะทางที่ต้องทำ PM (กม.)',
  `day_interval` int(11) NOT NULL COMMENT 'จำนวนวันที่ต้องทำ PM',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pm_type_settings`
--

INSERT INTO `pm_type_settings` (`id`, `pm_type`, `mileage_interval`, `day_interval`, `created_at`, `updated_at`) VALUES
(1, 'เปลี่ยนถ่ายน้ำมันเครื่อง', 5000, 90, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(2, 'เปลี่ยนไส้กรองอากาศ', 20000, 180, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(3, 'ตรวจสอบผ้าเบรก', 40000, 180, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(4, 'ตรวจสอบยาง', 50000, 180, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(5, 'ตรวจสอบระบบเบรก', 60000, 365, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(6, 'ตรวจสอบคลัตช์', 80000, 365, '2025-02-22 06:38:41', '2025-02-22 06:38:41'),
(7, 'ตรวจสอบระบบหล่อเย็น', 100000, 365, '2025-02-22 06:38:41', '2025-02-22 06:38:41');

-- --------------------------------------------------------

--
-- Table structure for table `repair_tickets`
--

CREATE TABLE `repair_tickets` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `reported_by` int(11) NOT NULL,
  `mechanic_id` int(11) DEFAULT NULL,
  `issue_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci,
  `priority` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `status` enum('pending','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `completion_note` mediumtext COLLATE utf8mb4_unicode_ci,
  `repair_cost` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','manager','staff','driver') COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `name`, `role`, `email`, `phone`, `status`, `last_login`, `created_at`) VALUES
(4, 'admin', '$2y$10$Nlcw.ErNg7eP3TiBk6MUVOtVRdccWnCudgsl/tQfD9.9Mu5Xk2pdS', 'System Admin', 'admin', 'admin@example.com', NULL, 'active', NULL, '2025-02-22 03:47:03'),
(6, 'manager', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ผู้จัดการระบบ', 'manager', 'manager@localhost', NULL, 'active', NULL, '2025-02-22 04:49:17'),
(7, 'driver1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'พขร. คนที่ 1', 'driver', 'driver1@localhost', '0812345678', 'active', NULL, '2025-02-22 07:58:09');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `vehicle_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `color` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fuel_type` enum('diesel','gasoline','electric','hybrid') COLLATE utf8mb4_unicode_ci NOT NULL,
  `license_plate` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vin` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_mileage` int(11) DEFAULT '0',
  `status` enum('active','inactive','maintenance','retired') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `last_maintenance_date` date DEFAULT NULL,
  `next_maintenance_date` date DEFAULT NULL,
  `notes` mediumtext COLLATE utf8mb4_unicode_ci,
  `driver_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `initial_mileage` int(11) DEFAULT '0',
  `purchase_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `vehicle_code`, `type`, `brand`, `model`, `year`, `color`, `fuel_type`, `license_plate`, `province`, `vin`, `current_mileage`, `status`, `last_maintenance_date`, `next_maintenance_date`, `notes`, `driver_id`, `created_at`, `updated_at`, `initial_mileage`, `purchase_date`) VALUES
(1, 'VH001', 'รถตู้', 'TOYOTA', 'COMMUTER', 2023, 'ขาว', 'diesel', 'กข 1234 กรุงเทพมหานคร', 'กรุงเทพมหานคร', 'JTFSS22P4H0123456', 5000, 'active', NULL, NULL, 'รถตู้รับส่งพนักงาน', NULL, '2025-02-22 04:00:33', '2025-02-22 05:34:06', 0, NULL),
(2, 'VH002', 'รถกระบะ', 'ISUZU', 'D-MAX', 2022, 'เทา', 'diesel', 'กค 5678 กรุงเทพมหานคร', 'กรุงเทพมหานคร', 'MP1TFR85H0789012', 15000, 'maintenance', NULL, NULL, 'รถกระบะขนส่งสินค้า', NULL, '2025-02-22 04:00:33', '2025-02-22 05:34:06', 0, NULL),
(3, 'VH003', 'รถเก๋ง', 'HONDA', 'CIVIC', 2023, 'ดำ', 'gasoline', 'กง 9012 กรุงเทพมหานคร', 'กรุงเทพมหานคร', 'JHMFE1C58H0345678', 8000, 'active', NULL, NULL, 'รถผู้บริหาร', NULL, '2025-02-22 04:00:33', '2025-02-22 05:34:06', 0, NULL),
(8, 'VH004', 'รถตู้', 'TOYOTA', 'COMMUTER', 2023, 'ขาว', 'diesel', 'กท 1234 กรุงเทพมหานคร', 'กรุงเทพมหานคร', 'JTFSS22P4H0123457', 5000, 'active', NULL, NULL, NULL, NULL, '2025-02-22 04:18:40', '2025-02-22 05:34:06', 0, NULL),
(17, 'TRK-001', 'รถบรรทุก 6 ล้อ', 'HINO', '300 Series', NULL, NULL, 'diesel', '1กข 1234', 'กรุงเทพมหานคร', 'HINO123456789001', 50000, 'maintenance', NULL, NULL, NULL, 7, '2025-02-22 08:51:49', '2025-02-22 09:36:09', 0, NULL),
(18, 'VAN-002', 'รถตู้', 'TOYOTA', 'COMMUTER', NULL, NULL, 'diesel', '2ขค 5678', 'กรุงเทพมหานคร', 'TOYOTA123456789002', 75000, 'maintenance', NULL, NULL, NULL, 7, '2025-02-22 08:51:49', '2025-02-22 08:51:49', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_types`
--

CREATE TABLE `vehicle_types` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vehicle_types`
--

INSERT INTO `vehicle_types` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'รถกระบะ', 'รถกระบะสำหรับขนส่งสินค้า', '2025-02-22 03:58:20'),
(2, 'รถตู้', 'รถตู้สำหรับรับส่งพนักงาน', '2025-02-22 03:58:20'),
(3, 'รถเก๋ง', 'รถเก๋งสำหรับผู้บริหาร', '2025-02-22 03:58:20'),
(4, 'รถบรรทุก', 'รถบรรทุกสำหรับขนส่งสินค้าขนาดใหญ่', '2025-02-22 03:58:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `maintenance_issues`
--
ALTER TABLE `maintenance_issues`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_vehicle` (`vehicle_id`);

--
-- Indexes for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- Indexes for table `parts`
--
ALTER TABLE `parts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `part_code` (`part_code`);

--
-- Indexes for table `part_transactions`
--
ALTER TABLE `part_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `part_id` (`part_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `pm_cost_estimates`
--
ALTER TABLE `pm_cost_estimates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pm_history`
--
ALTER TABLE `pm_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- Indexes for table `pm_plans`
--
ALTER TABLE `pm_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `pm_records`
--
ALTER TABLE `pm_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pm_plan_id` (`pm_plan_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `mechanic_id` (`mechanic_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `pm_settings`
--
ALTER TABLE `pm_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- Indexes for table `pm_type_settings`
--
ALTER TABLE `pm_type_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `repair_tickets`
--
ALTER TABLE `repair_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `reported_by` (`reported_by`),
  ADD KEY `mechanic_id` (`mechanic_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vehicle_code` (`vehicle_code`),
  ADD UNIQUE KEY `vin` (`vin`),
  ADD KEY `fk_driver` (`driver_id`);

--
-- Indexes for table `vehicle_types`
--
ALTER TABLE `vehicle_types`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_issues`
--
ALTER TABLE `maintenance_issues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `parts`
--
ALTER TABLE `parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `part_transactions`
--
ALTER TABLE `part_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pm_cost_estimates`
--
ALTER TABLE `pm_cost_estimates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pm_history`
--
ALTER TABLE `pm_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pm_plans`
--
ALTER TABLE `pm_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pm_records`
--
ALTER TABLE `pm_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pm_settings`
--
ALTER TABLE `pm_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pm_type_settings`
--
ALTER TABLE `pm_type_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `repair_tickets`
--
ALTER TABLE `repair_tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `vehicle_types`
--
ALTER TABLE `vehicle_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `maintenance_issues`
--
ALTER TABLE `maintenance_issues`
  ADD CONSTRAINT `fk_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  ADD CONSTRAINT `maintenance_records_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `part_transactions`
--
ALTER TABLE `part_transactions`
  ADD CONSTRAINT `part_transactions_ibfk_1` FOREIGN KEY (`part_id`) REFERENCES `parts` (`id`),
  ADD CONSTRAINT `part_transactions_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `pm_history`
--
ALTER TABLE `pm_history`
  ADD CONSTRAINT `pm_history_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `pm_plans`
--
ALTER TABLE `pm_plans`
  ADD CONSTRAINT `pm_plans_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `pm_plans_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `pm_records`
--
ALTER TABLE `pm_records`
  ADD CONSTRAINT `pm_records_ibfk_1` FOREIGN KEY (`pm_plan_id`) REFERENCES `pm_plans` (`id`),
  ADD CONSTRAINT `pm_records_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `pm_records_ibfk_3` FOREIGN KEY (`mechanic_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `pm_records_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `pm_settings`
--
ALTER TABLE `pm_settings`
  ADD CONSTRAINT `pm_settings_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `repair_tickets`
--
ALTER TABLE `repair_tickets`
  ADD CONSTRAINT `repair_tickets_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `repair_tickets_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `repair_tickets_ibfk_3` FOREIGN KEY (`mechanic_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `fk_driver` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
