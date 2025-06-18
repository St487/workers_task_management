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
-- Table structure for table `tbl_workers`
--

CREATE TABLE `tbl_workers` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_workers`
--

INSERT INTO `tbl_workers` (`id`, `full_name`, `gender`, `email`, `password`, `phone`, `address`) VALUES
(1001, 'Ong Siew Nie', 'Not specified', 'siewnie@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '01032978910', 'Jalan A Taman B'),
(1002, 'Aman bin Abu', NULL, 'aman@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0198248781', 'Jalan B Taman C'),
(1003, 'Low Yong Liang', NULL, 'liang@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0128374921', 'Jalan C Taman A'),
(1004, 'Erica Anthony', NULL, 'erica@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0183859271', 'Jalan Z Taman B'),
(1005, 'Ayuni binti Ahmad', NULL, 'ayuni@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0183498211', 'Jalan F Taman T'),
(1006, 'Alia Irdina binti Ahmad', NULL, 'alia@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0189382918', 'Jalan X Taman Y');

ALTER TABLE tbl_workers
ADD COLUMN gender VARCHAR(15) DEFAULT NULL;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_workers`
--
ALTER TABLE `tbl_workers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_workers`
--
ALTER TABLE `tbl_workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
