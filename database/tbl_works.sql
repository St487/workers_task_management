-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2025 at 10:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `worker_task_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_works`
--

CREATE TABLE `tbl_works` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `date_assigned` date NOT NULL,
  `due_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_works`
--

INSERT INTO `tbl_works` (`id`, `title`, `description`, `assigned_to`, `date_assigned`, `due_date`, `status`) VALUES
(1, 'Prepare Material A', 'Prepare raw material A for assembly.', 1001, '2025-05-25', '2025-06-25', 'completed'),
(2, 'Inspect Machine X', 'Conduct inspection for machine X.', 1002, '2025-05-25', '2025-05-29', 'overdue'),
(3, 'Clean Area B', 'Deep clean work area B before audit.', 1003, '2025-05-25', '2025-05-30', 'overdue'),
(4, 'Test Circuit Board', 'Perform unit test for circuit batch 4.', 1004, '2025-05-25', '2025-05-28', 'overdue'),
(5, 'Document Process', 'Write SOP for packaging unit.', 1005, '2025-05-25', '2025-05-29', 'overdue'),
(6, 'Paint Booth Check', 'Routine check on painting booth.', 1001, '2025-05-25', '2025-05-30', 'overdue'),
(7, 'Label Inventory', 'Label all boxes in section C.', 1002, '2025-05-25', '2025-06-19', 'pending'),
(8, 'Update Database', 'Update inventory in MySQL system.', 1003, '2025-05-25', '2025-05-29', 'overdue'),
(9, 'Maintain Equipment', 'Oil and tune cutting machine.', 1004, '2025-05-25', '2025-05-30', 'overdue'),
(10, 'Prepare Report', 'Prepare monthly performance report.', 1005, '2025-05-25', '2025-05-30', 'overdue'),
(21, 'Configure Router Access', 'Set up VLANs and user roles in router.', 1001, '2025-06-14', '2025-06-18', 'completed'),
(22, 'Clean Air Filters', 'Replace and clean filters in HVAC system.', 1005, '2025-06-10', '2025-06-14', 'overdue'),
(23, 'Audit Material Usage', 'Cross-check material use with stock log.', 1001, '2025-06-12', '2025-06-18', 'completed'),
(24, 'First Aid Kit Refill', 'Replenish first aid supplies across all stations.', 1002, '2025-06-13', '2025-06-15', 'completed'),
(25, 'Update Fire Escape Map', 'Replace outdated floor emergency exit maps.', 1004, '2025-06-11', '2025-06-19', 'pending'),
(26, 'Label Recycle Bins', 'Attach new multilingual labels to all bins.', 1005, '2025-06-14', '2025-06-17', 'overdue'),
(27, 'Staff Schedule Planning', 'Create duty roster for upcoming public holiday week.', 1004, '2025-06-15', '2025-06-20', 'pending'),
(28, 'Security System Check', 'Test alarms and camera feeds on all floors.', 1003, '2025-06-10', '2025-06-15', 'overdue'),
(29, 'Restock Pantry Supplies', 'Order and organize breakroom refreshments.', 1002, '2025-06-13', '2025-06-20', 'completed'),
(30, 'Conduct Peer Evaluation', 'Collect peer feedback for Q2 performance.', 1003, '2025-06-08', '2025-06-11', 'overdue'),
(31, 'Review Safety Protocol', 'Audit current safety protocols and suggest improvements.', 1001, '2025-06-10', '2025-06-17', 'completed'),
(32, 'Organize Storage Area', 'Sort and label all items in storage room A.', 1002, '2025-06-11', '2025-06-18', 'completed'),
(33, 'Update Maintenance Log', 'Record recent maintenance activities into system.', 1003, '2025-06-12', '2025-06-19', 'pending'),
(34, 'Set Up Training Room', 'Prepare materials and setup for training session.', 1004, '2025-06-13', '2025-06-20', 'pending'),
(35, 'Calibrate Measuring Tools', 'Calibrate all digital calipers and gauges.', 1005, '2025-06-14', '2025-06-21', 'pending');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_works`
--
ALTER TABLE `tbl_works`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_works`
--
ALTER TABLE `tbl_works`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
