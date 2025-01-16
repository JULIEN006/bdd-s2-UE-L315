 -- Créer une base de données si elle n'existe pas ;)
CREATE DATABASE IF NOT EXISTS bankapp;

-- Utiliser bankapp
USE bankapp;

CREATE TABLE clients (
  `id_client` INTEGER NOT NULL AUTO_INCREMENT, 
  `nom` VARCHAR(20) NOT NULL,
  `prenom` VARCHAR(20) NOT NULL,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  `adresse` VARCHAR(255), 
  `telephone` VARCHAR(15),
  PRIMARY KEY (`id_client`)
);

CREATE TABLE conseillers(
  `id_conseiller` INTEGER NOT NULL, 
  `nom` VARCHAR(20) NOT NULL,
  `prenom` VARCHAR(20) NOT NULL,
  `specialisation` VARCHAR(30), 
  PRIMARY KEY (`id_conseiller`)
);

CREATE TABLE comptes (
  `id_compte` INTEGER NOT NULL AUTO_INCREMENT, 
  `id_client` INTEGER NOT NULL,
  `id_conseiller` INTEGER NOT NULL, 
  `type_compte` VARCHAR(20), 
  `solde` DECIMAL(15, 2), 
  `date_ouverture` DATE, 
  `decouvert_autorise` BOOLEAN,
  PRIMARY KEY (`id_compte`), 
  FOREIGN KEY (`id_client`) REFERENCES clients(`id_client`),     
  FOREIGN KEY (`id_conseiller`) REFERENCES conseillers(`id_conseiller`)
);

CREATE TABLE transactions (
  `id_transaction` INTEGER NOT NULL AUTO_INCREMENT, 
  `id_compte` INTEGER,  
  `type` VARCHAR(20), 
  `montant` DECIMAL(15, 2), 
  `date_transaction` DATE, 
  PRIMARY KEY (`id_transaction`), 
  FOREIGN KEY (`id_compte`) REFERENCES comptes(`id_compte`)
);

CREATE TABLE prets (
  `id_pret` INTEGER NOT NULL AUTO_INCREMENT, 
  `id_client` INTEGER, 
  `montant` DECIMAL(15, 2), 
  `taux_interet` DECIMAL(5, 4), 
  `date_debut` DATE,  
  `duree` INTEGER, 
  PRIMARY KEY (`id_pret`), 
  FOREIGN KEY (`id_client`) REFERENCES clients(`id_client`)
);

INSERT INTO clients (`nom`, `prenom`, `mot_de_passe`, `adresse`, `telephone`) VALUES
  ('Martin', 'Jacques', 'Citrouille2000', '12 avenue Albert Thomas, 87000 Limoges', '06-12-12-12-12'),
  ('Dubois', 'Jacqueline', 'XT1234xt','3 avenue de Landouge, 87100 Limoges', '05-24-13-14-15'),
  ('Canteloup', 'Grégoire', 'Bidulle84!', '47 avenue du Limousin, 87220 Feytiat', '07-29-30-31-78'),
  ('Carrère', 'Stéphane', 'Gpasdidé', '8, rue de la Garenne, 87430 Verneuil-sur-Vienne', '06-25-95-94-09'),
  ('Vincent', 'Cécile', 'Moinonplus!', '75 rue du Général du Cray, 87000 Limoges', '06-84-65-12-00');

INSERT INTO conseillers (`id_conseiller`, `nom`, `prenom`, `specialisation`) VALUES 
(1,'Lemoine', 'Sophie', 'Crédit immobilier'), 
(2,'Petitjean', 'Pierre', 'Crédit immobilier'), 
(3,'Durand', 'Corinne', 'Investissements financiers');

INSERT INTO comptes ( `id_client`, `id_conseiller`, `type_compte`, `solde`, `date_ouverture`, `decouvert_autorise`) VALUES
 (1, 1, 'courant individuel', 1000.00, '2025-01-01', 1), 
 (1, 1, 'courant commun', 1500.00, '2025-01-01', 1), 
 (1, 1, 'epargne', 10500.00, '2025-01-01', 0), 
 (2, 2, 'courant individuel', 1200.00, '2025-01-01',1), 
 (2, 2, 'courant commun', 1600.00, '2025-01-01', 1), 
 (2, 2, 'epargne', 2200.00, '2025-01-01', 1), 
 (3, 2, 'courant individuel', 1300.00, '2025-01-01', 0), 
 (3, 2, 'courant commun', 1700.00, '2025-01-01', 0), 
 (3, 2, 'epargne', 8550.00, '2025-01-01', 0), 
 (4, 1, 'courant individuel', 1400.00, '2025-01-01', 0), 
 (4, 1, 'courant commun', 1800.00, '2025-01-01', 1), 
 (4, 1, 'epargne', 2400.00, '2025-01-01', 1), 
 (5, 3, 'courant individuel', 1500.00, '2025-01-01', 1), 
 (5, 3, 'courant commun', 1900.00, '2025-01-01', 1), 
 (5, 3, 'epargne', 2500.00, '2025-01-01', 0);

INSERT INTO transactions (`id_compte`, `type`, `montant`, `date_transaction`) VALUES
  (1, 'debit', 200.00, '2025-02-01'),
  (1, 'virement', 500.00, '2025-02-15'),
  (2, 'debit', 150.00, '2025-02-10'),
  (2, 'virement', 300.00, '2025-02-20'),
  (3, 'virement', 100.00, '2025-02-05'),
  (3, 'virement', 700.00, '2025-02-25'),
  (4, 'virement', 250.00, '2025-02-14'),
  (4, 'virement', 400.00, '2025-02-28'),
  (5, 'debit', 300.00, '2025-02-12'),
  (5, 'virement', 350.00, '2025-02-22');

--counts transactions by type of account
SELECT comptes.type_compte,
COUNT(transactions.id_transaction) FROM transactions 
--links both tables with id_compte
JOIN comptes ON transactions.id_compte = comptes.id_compte
--sends back the count classified by type of account
GROUP BY comptes.type_compte;
