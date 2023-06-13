-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Jun 13, 2023 at 03:31 AM
-- Server version: 5.7.34
-- PHP Version: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_catches`
--

CREATE TABLE `tbl_catches` (
  `catch_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `catch_name` varchar(255) DEFAULT NULL,
  `catch_type` varchar(255) DEFAULT NULL,
  `catch_desc` varchar(255) DEFAULT NULL,
  `catch_price` varchar(255) DEFAULT NULL,
  `catch_qty` varchar(255) DEFAULT NULL,
  `catch_lat` varchar(255) DEFAULT NULL,
  `catch_long` varchar(255) DEFAULT NULL,
  `catch_state` varchar(255) DEFAULT NULL,
  `catch_locality` varchar(255) DEFAULT NULL,
  `catch_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_catches`
--

INSERT INTO `tbl_catches` (`catch_id`, `user_id`, `catch_name`, `catch_type`, `catch_desc`, `catch_price`, `catch_qty`, `catch_lat`, `catch_long`, `catch_state`, `catch_locality`, `catch_date`) VALUES
(1, 4, 'laptop', 'Electronics', 'good', '122', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 01:46:36'),
(2, 1, 'New Laptop', 'Electronics', 'New Laptop Good Condition', '1000', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:32:20'),
(3, 1, 'Smartphone', 'Electronics', 'New Smartphone', '1000', '10', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:36:10'),
(4, 1, 'Bicyle', 'Equipment', 'Used Bicyle', '500', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:49:26');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `user_phone` varchar(255) DEFAULT NULL,
  `user_password` varchar(255) DEFAULT NULL,
  `user_otp` varchar(255) DEFAULT NULL,
  `user_datereg` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`) VALUES
(1, 'abdillah@gmail.com', 'Abdillah M Rifki', '01232132133', '601f1889667efaebb33b8c12572835da3f027f78', '64358', '2023-05-20 03:57:33'),
(2, 'rozak@gmail.com', 'M Rozak', '012313223112', '601f1889667efaebb33b8c12572835da3f027f78', '13146', '2023-05-20 10:50:26'),
(3, 'mrifki@gmail.com', 'M Rifki', '0142321222184', '601f1889667efaebb33b8c12572835da3f027f78', '61017', '2023-05-20 11:46:53'),
(4, 'muhrifki@gmail.com', 'M Rifki Abdillah', '0202123121', '601f1889667efaebb33b8c12572835da3f027f78', '44855', '2023-06-13 01:45:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_catches`
--
ALTER TABLE `tbl_catches`
  ADD PRIMARY KEY (`catch_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_catches`
--
ALTER TABLE `tbl_catches`
  MODIFY `catch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_catches`
--
ALTER TABLE `tbl_catches`
  ADD CONSTRAINT `tbl_catches_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
