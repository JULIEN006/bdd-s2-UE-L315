-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 18, 2025 at 06:45 PM
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
-- Database: `bankapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id_client` int(11) NOT NULL,
  `nom` varchar(20) NOT NULL,
  `prenom` varchar(20) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `telephone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id_client`, `nom`, `prenom`, `mot_de_passe`, `adresse`, `telephone`) VALUES
(1, 'Martin', 'Jacques', 'Citrouille2000', '12 avenue Albert Thomas, 87000 Limoges', '06-12-12-12-12'),
(2, 'Dubois', 'Jacqueline', 'XT1234xt', '3 avenue de Landouge, 87100 Limoges', '05-24-13-14-15'),
(3, 'Canteloup', 'Grégoire', 'Bidulle84!', '47 avenue du Limousin, 87220 Feytiat', '07-29-30-31-78'),
(4, 'Carrère', 'Stéphane', 'Gpasdidé', '8, rue de la Garenne, 87430 Verneuil-sur-Vienne', '06-25-95-94-09'),
(5, 'Vincent', 'Cécile', 'Moinonplus!', '75 rue du Général du Cray, 87000 Limoges', '06-84-65-12-00');

-- --------------------------------------------------------

--
-- Table structure for table `comptes`
--

CREATE TABLE `comptes` (
  `id_compte` int(11) NOT NULL,
  `id_client` int(11) DEFAULT NULL,
  `id_conseiller` int(11) NOT NULL,
  `type_compte` varchar(20) DEFAULT NULL,
  `solde` decimal(15,2) DEFAULT NULL,
  `date_ouverture` date DEFAULT NULL,
  `decouvert_autorise` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comptes`
--

INSERT INTO `comptes` (`id_compte`, `id_client`, `id_conseiller`, `type_compte`, `solde`, `date_ouverture`, `decouvert_autorise`) VALUES
(1, 1, 1, 'courant individuel', 1000.00, '2025-01-01', 100.00),
(2, 1, 1, 'courant commun', 1500.00, '2025-01-01', 100.00),
(3, 1, 1, 'epargne', 10500.00, '2025-01-01', 0.00),
(4, 2, 2, 'courant individuel', 1200.00, '2025-01-01', 500.00),
(5, 2, 2, 'courant commun', 1600.00, '2025-01-01', 200.00),
(6, 2, 2, 'epargne', 2200.00, '2025-01-01', 100.00),
(7, 3, 2, 'courant individuel', 1300.00, '2025-01-01', 0.00),
(8, 3, 2, 'courant commun', 1700.00, '2025-01-01', 0.00),
(9, 3, 2, 'epargne', 8550.00, '2025-01-01', 0.00),
(10, 4, 1, 'courant individuel', 1400.00, '2025-01-01', 0.00),
(11, 4, 1, 'courant commun', 1800.00, '2025-01-01', 1000.00),
(12, 4, 1, 'epargne', 2400.00, '2025-01-01', 2000.00),
(13, 5, 3, 'courant individuel', 1500.00, '2025-01-01', 1.00),
(14, 5, 3, 'courant commun', 1900.00, '2025-01-01', 1.00),
(15, 5, 3, 'epargne', 2500.00, '2025-01-01', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `conseillers`
--

CREATE TABLE `conseillers` (
  `id_conseiller` int(11) NOT NULL,
  `nom` varchar(20) NOT NULL,
  `prenom` varchar(20) NOT NULL,
  `specialisation` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conseillers`
--

INSERT INTO `conseillers` (`id_conseiller`, `nom`, `prenom`, `specialisation`) VALUES
(1, 'Lemoine', 'Sophie', 'Crédit immobilier'),
(2, 'Petitjean', 'Pierre', 'Crédit immobilier'),
(3, 'Durand', 'Corinne', 'Investissements financiers');

-- --------------------------------------------------------

--
-- Table structure for table `prets`
--

CREATE TABLE `prets` (
  `id_pret` int(11) NOT NULL,
  `id_client` int(11) DEFAULT NULL,
  `montant` decimal(15,2) DEFAULT NULL,
  `taux_interet` decimal(5,4) DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `duree` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prets`
--

INSERT INTO `prets` (`id_pret`, `id_client`, `montant`, `taux_interet`, `date_debut`, `duree`) VALUES
(1, 1, 12000.00, 3.5600, '2025-01-02', 24),
(2, 2, 1000000.00, 2.4700, '2025-01-13', 120),
(3, 3, 1200.00, 3.6200, '2025-01-08', 7);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id_transaction` int(11) NOT NULL,
  `id_compte` int(11) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `montant` decimal(15,2) DEFAULT NULL,
  `date_transaction` date DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id_transaction`, `id_compte`, `type`, `montant`, `date_transaction`, `statut`) VALUES
(1, 1, 'debit', 200.00, '2025-01-01', 'validé'),
(2, 1, 'virement', 300.00, '2025-01-05', 'en attente'),
(3, 1, 'virement', 500.00, '2025-01-15', 'enregistré'),
(4, 2, 'debit', 150.00, '2025-01-10', 'annulé'),
(5, 2, 'virement', 300.00, '2025-02-20', 'refusé'),
(6, 3, 'virement', 100.00, '2025-02-05', 'en attente'),
(7, 3, 'virement', 700.00, '2025-02-25', 'en attente'),
(8, 4, 'virement', 250.00, '2025-02-14', 'en attente'),
(9, 4, 'virement', 400.00, '2025-02-28', 'en attente'),
(10, 5, 'debit', 300.00, '2025-02-12', 'en attente'),
(11, 5, 'virement', 350.00, '2025-02-22', 'en attente');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id_client`);

--
-- Indexes for table `comptes`
--
ALTER TABLE `comptes`
  ADD PRIMARY KEY (`id_compte`),
  ADD KEY `id_client` (`id_client`),
  ADD KEY `id_conseiller` (`id_conseiller`);

--
-- Indexes for table `conseillers`
--
ALTER TABLE `conseillers`
  ADD PRIMARY KEY (`id_conseiller`);

--
-- Indexes for table `prets`
--
ALTER TABLE `prets`
  ADD PRIMARY KEY (`id_pret`),
  ADD KEY `id_client` (`id_client`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id_transaction`),
  ADD KEY `id_compte` (`id_compte`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id_client` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `comptes`
--
ALTER TABLE `comptes`
  MODIFY `id_compte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `prets`
--
ALTER TABLE `prets`
  MODIFY `id_pret` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id_transaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comptes`
--
ALTER TABLE `comptes`
  ADD CONSTRAINT `comptes_ibfk_1` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id_client`) ON DELETE SET NULL,
  ADD CONSTRAINT `comptes_ibfk_2` FOREIGN KEY (`id_conseiller`) REFERENCES `conseillers` (`id_conseiller`);

--
-- Constraints for table `prets`
--
ALTER TABLE `prets`
  ADD CONSTRAINT `prets_ibfk_1` FOREIGN KEY (`id_client`) REFERENCES `clients` (`id_client`) ON DELETE SET NULL;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`id_compte`) REFERENCES `comptes` (`id_compte`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
