-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 20, 2023 at 02:13 PM
-- Server version: 10.5.20-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id20890337_barterit`
--
CREATE DATABASE IF NOT EXISTS `id20890337_barterit` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `id20890337_barterit`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `catch_id` varchar(5) NOT NULL,
  `cart_qty` int(5) NOT NULL,
  `cart_price` float NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `cart_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `catch_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_catches`
--

INSERT INTO `tbl_catches` (`catch_id`, `user_id`, `catch_name`, `catch_type`, `catch_desc`, `catch_price`, `catch_qty`, `catch_lat`, `catch_long`, `catch_state`, `catch_locality`, `catch_date`) VALUES
(1, 4, 'laptop', 'Electronics', 'good', '122', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 01:46:36'),
(2, 1, 'New Laptop', 'Electronics', 'New Laptop Good Condition', '1000', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:32:20'),
(3, 1, 'Smartphone', 'Electronics', 'New Smartphone', '1000', '10', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:36:10'),
(4, 1, 'Bicyle', 'Equipment', 'Used Bicyle', '500', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-06-13 02:49:26'),
(5, 1, 'JBL', 'Electronics', 'Headphone JBL', '588', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:30:38'),
(6, 1, 'Controller XBOX', 'Electronics', 'Used Controller XBOX', '250', '2', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:31:58'),
(7, 1, 'Coin Gold', 'Collectibles', 'Canada Coin Gold', '10000', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:33:10'),
(8, 1, 'Silver Stack', 'Collectibles', 'Silver Stack', '2000', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:34:21'),
(9, 1, 'PS5', 'Electronics', 'Used PS5', '2500', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:35:27'),
(10, 1, 'Canon DSLR', 'Electronics', 'Camera DSLR Canon', '25800', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:36:40'),
(11, 1, 'Iphone 13', 'Electronics', 'New IPHONE 13', '15000', '1', '37.421998333333335', '-122.084', 'California', 'Mountain View', '2023-07-05 17:37:52');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(11) NOT NULL,
  `news_title` varchar(255) DEFAULT NULL,
  `news_detail` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_detail`, `created_at`) VALUES
(1, 'Used Laptop to cash', 'You can turn your used laptop to cash by bartering your laptop to money', '2023-07-19 06:08:05'),
(2, 'Bicyle is trending now', 'Its your chance to barter your bicycle to items with higher value that you like because bicycle is in raising trend.', '2023-07-19 10:09:02');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orderdetails`
--

CREATE TABLE `tbl_orderdetails` (
  `orderdetail_id` int(5) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `catch_id` varchar(5) NOT NULL,
  `orderdetail_qty` int(5) NOT NULL,
  `orderdetail_paid` float NOT NULL,
  `buyer_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `orderdetail_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(5) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `order_paid` float NOT NULL,
  `buyer_id` varchar(5) NOT NULL,
  `seller_id` varchar(5) NOT NULL,
  `order_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `order_status` varchar(20) NOT NULL,
  `order_lat` varchar(12) NOT NULL,
  `order_lng` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payment`
--

CREATE TABLE `tbl_payment` (
  `payment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `payment_date` datetime NOT NULL,
  `payment_status` varchar(10) NOT NULL,
  `amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tbl_payment`
--

INSERT INTO `tbl_payment` (`payment_id`, `user_id`, `payment_date`, `payment_status`, `amount`) VALUES
(1, 1, '2023-07-20 07:33:46', 'Success', 250.00),
(2, 1, '2023-07-20 13:30:53', 'Success', 250.00);

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
  `user_datereg` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_credit` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`, `user_credit`) VALUES
(1, 'abdillah@gmail.com', 'Rifki Abdillah', '01232132133', '601f1889667efaebb33b8c12572835da3f027f78', '64358', '2023-05-20 03:57:33', 0),
(2, 'rozak@gmail.com', 'Abdul Rozak', '012313223112', '601f1889667efaebb33b8c12572835da3f027f78', '13146', '2023-05-20 10:50:26', 0),
(3, 'mrifki@gmail.com', 'M Rifki', '0142321222184', '601f1889667efaebb33b8c12572835da3f027f78', '61017', '2023-05-20 11:46:53', 0),
(4, 'muhrifki@gmail.com', 'M Rifki Abdillah', '0202123121', '601f1889667efaebb33b8c12572835da3f027f78', '44855', '2023-06-13 01:45:42', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_catches`
--
ALTER TABLE `tbl_catches`
  ADD PRIMARY KEY (`catch_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_orderdetails`
--
ALTER TABLE `tbl_orderdetails`
  ADD PRIMARY KEY (`orderdetail_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_payment`
--
ALTER TABLE `tbl_payment`
  ADD PRIMARY KEY (`payment_id`);

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
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_catches`
--
ALTER TABLE `tbl_catches`
  MODIFY `catch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_orderdetails`
--
ALTER TABLE `tbl_orderdetails`
  MODIFY `orderdetail_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_payment`
--
ALTER TABLE `tbl_payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
