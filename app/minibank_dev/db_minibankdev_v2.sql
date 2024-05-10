-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 10, 2024 at 11:32 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_mybank`
--
CREATE DATABASE IF NOT EXISTS `db_mybank` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_mybank`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `UpdateSaldo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSaldo` (`id_nasabah_param` INT, `jenis_transaksi` VARCHAR(10), `jumlah_transaksi` DECIMAL(10,2))   BEGIN
    DECLARE biaya_admin DECIMAL(10, 2);

    IF jenis_transaksi = 'debet' THEN
        UPDATE Nasabah SET saldo = saldo - jumlah_transaksi WHERE id_nasabah = id_nasabah_param;
    ELSEIF jenis_transaksi = 'kredit' THEN
        UPDATE Nasabah SET saldo = saldo + jumlah_transaksi WHERE id_nasabah = id_nasabah_param;
    ELSEIF jenis_transaksi = 'admin' THEN
        SET biaya_admin = 500.00; -- Biaya admin per bulan
        UPDATE Nasabah SET saldo = saldo - biaya_admin WHERE id_nasabah = id_nasabah_param;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Laporan`
--

DROP TABLE IF EXISTS `Laporan`;
CREATE TABLE `Laporan` (
  `id_laporan` int(11) NOT NULL,
  `id_nasabah` int(11) DEFAULT NULL,
  `tanggal_laporan` date DEFAULT NULL,
  `total_transaksi` int(11) DEFAULT NULL,
  `saldo_awal` decimal(10,2) DEFAULT NULL,
  `saldo_akhir` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Laporan`:
--   `id_nasabah`
--       `Nasabah` -> `id_nasabah`
--

-- --------------------------------------------------------

--
-- Table structure for table `Nasabah`
--

DROP TABLE IF EXISTS `Nasabah`;
CREATE TABLE `Nasabah` (
  `id_nasabah` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `jenis_kelamin` varchar(10) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `saldo` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Nasabah`:
--

--
-- Dumping data for table `Nasabah`
--

INSERT INTO `Nasabah` (`id_nasabah`, `nama`, `alamat`, `jenis_kelamin`, `tanggal_lahir`, `saldo`) VALUES
(1, 'John Doe', 'Jalan Raya 123', 'Male', '1990-01-01', '1000.00');

-- --------------------------------------------------------

--
-- Table structure for table `Passbook_Print`
--

DROP TABLE IF EXISTS `Passbook_Print`;
CREATE TABLE `Passbook_Print` (
  `id_print` int(11) NOT NULL,
  `id_nasabah` int(11) DEFAULT NULL,
  `tanggal_print` date DEFAULT NULL,
  `transaksi_terakhir` varchar(255) DEFAULT NULL,
  `saldo_terakhir` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Passbook_Print`:
--   `id_nasabah`
--       `Nasabah` -> `id_nasabah`
--

-- --------------------------------------------------------

--
-- Table structure for table `Rekapitulasi`
--

DROP TABLE IF EXISTS `Rekapitulasi`;
CREATE TABLE `Rekapitulasi` (
  `id_rekapitulasi` int(11) NOT NULL,
  `id_nasabah` int(11) DEFAULT NULL,
  `total_deposit` decimal(10,2) DEFAULT NULL,
  `total_withdrawal` decimal(10,2) DEFAULT NULL,
  `saldo_akhir` decimal(10,2) DEFAULT NULL,
  `bulan` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Rekapitulasi`:
--   `id_nasabah`
--       `Nasabah` -> `id_nasabah`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `Saldo_Nasabah_View`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `Saldo_Nasabah_View`;
CREATE TABLE `Saldo_Nasabah_View` (
`id_nasabah` int(11)
,`nama` varchar(255)
,`saldo` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `Transaksi`
--

DROP TABLE IF EXISTS `Transaksi`;
CREATE TABLE `Transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_nasabah` int(11) DEFAULT NULL,
  `jenis_transaksi` varchar(10) DEFAULT NULL,
  `tanggal_transaksi` date DEFAULT NULL,
  `jumlah` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `Transaksi`:
--   `id_nasabah`
--       `Nasabah` -> `id_nasabah`
--

--
-- Dumping data for table `Transaksi`
--

INSERT INTO `Transaksi` (`id_transaksi`, `id_nasabah`, `jenis_transaksi`, `tanggal_transaksi`, `jumlah`) VALUES
(1, 1, 'debet', '2024-05-10', '100.00'),
(2, 1, 'kredit', '2024-05-11', '50.00'),
(3, 1, 'admin', '2024-05-12', '0.00');

--
-- Triggers `Transaksi`
--
DROP TRIGGER IF EXISTS `UpdateRekap`;
DELIMITER $$
CREATE TRIGGER `UpdateRekap` AFTER INSERT ON `Transaksi` FOR EACH ROW BEGIN
    DECLARE saldo_akhir DECIMAL(10, 2);
    DECLARE biaya_admin DECIMAL(10, 2);
    SELECT saldo INTO saldo_akhir FROM Nasabah WHERE id_nasabah = NEW.id_nasabah;

    IF NEW.jenis_transaksi = 'debet' THEN
        INSERT INTO Rekapitulasi (id_nasabah, total_deposit, saldo_akhir, bulan)
        VALUES (NEW.id_nasabah, 0, saldo_akhir - NEW.jumlah, MONTH(NEW.tanggal_transaksi));
    ELSEIF NEW.jenis_transaksi = 'kredit' THEN
        INSERT INTO Rekapitulasi (id_nasabah, total_withdrawal, saldo_akhir, bulan)
        VALUES (NEW.id_nasabah, 0, saldo_akhir + NEW.jumlah, MONTH(NEW.tanggal_transaksi));
    ELSEIF NEW.jenis_transaksi = 'admin' THEN
        SET biaya_admin = 500.00; -- Admin fee per month
        INSERT INTO Rekapitulasi (id_nasabah, total_deposit, saldo_akhir, bulan)
        VALUES (NEW.id_nasabah, biaya_admin, saldo_akhir - biaya_admin, MONTH(NEW.tanggal_transaksi));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `Saldo_Nasabah_View` exported as a table
--
DROP TABLE IF EXISTS `Saldo_Nasabah_View`;
CREATE TABLE`Saldo_Nasabah_View`(
    `id_nasabah` int(11) NOT NULL,
    `nama` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `saldo` decimal(10,2) DEFAULT NULL
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Laporan`
--
ALTER TABLE `Laporan`
  ADD PRIMARY KEY (`id_laporan`),
  ADD KEY `id_nasabah` (`id_nasabah`);

--
-- Indexes for table `Nasabah`
--
ALTER TABLE `Nasabah`
  ADD PRIMARY KEY (`id_nasabah`);

--
-- Indexes for table `Passbook_Print`
--
ALTER TABLE `Passbook_Print`
  ADD PRIMARY KEY (`id_print`),
  ADD KEY `id_nasabah` (`id_nasabah`);

--
-- Indexes for table `Rekapitulasi`
--
ALTER TABLE `Rekapitulasi`
  ADD PRIMARY KEY (`id_rekapitulasi`),
  ADD KEY `id_nasabah` (`id_nasabah`);

--
-- Indexes for table `Transaksi`
--
ALTER TABLE `Transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_nasabah` (`id_nasabah`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Laporan`
--
ALTER TABLE `Laporan`
  ADD CONSTRAINT `Laporan_ibfk_1` FOREIGN KEY (`id_nasabah`) REFERENCES `Nasabah` (`id_nasabah`);

--
-- Constraints for table `Passbook_Print`
--
ALTER TABLE `Passbook_Print`
  ADD CONSTRAINT `Passbook_Print_ibfk_1` FOREIGN KEY (`id_nasabah`) REFERENCES `Nasabah` (`id_nasabah`);

--
-- Constraints for table `Rekapitulasi`
--
ALTER TABLE `Rekapitulasi`
  ADD CONSTRAINT `Rekapitulasi_ibfk_1` FOREIGN KEY (`id_nasabah`) REFERENCES `Nasabah` (`id_nasabah`);

--
-- Constraints for table `Transaksi`
--
ALTER TABLE `Transaksi`
  ADD CONSTRAINT `Transaksi_ibfk_1` FOREIGN KEY (`id_nasabah`) REFERENCES `Nasabah` (`id_nasabah`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
