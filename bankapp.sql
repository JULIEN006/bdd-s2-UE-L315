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




CREATE TABLE conseillers (
  `id_conseiller` INTEGER NOT NULL AUTO_INCREMENT, 
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

INSERT INTO clients ('nom', 'prenom', 'mot_de_passe', 'adresse', 'telephone') VALUES
  ('Martin', 'Jacques', 'Citrouille2000', '12 avenue Albert Thomas, 87000 Limoges', '06-12-12-12-12'),
  ('Dubois', 'Jacqueline', 'XT1234xt','3 avenue de Landouge, 87100 Limoges', '05-24-13-14-15'),
  ('Canteloup', 'Grégoire', 'Bidulle84!', '47 avenue du Limousin, 87220 Feytiat', '07-29-30-31-78'),
  ('Carrère', 'Stéphane', 'Gpasdidé', '8, rue de la Garenne, 87430 Verneuil-sur-Vienne', '06-25-95-94-09'),
  ('Vincent', 'Cécile', 'Moinonplus!', '75 rue du Général du Cray, 87000 Limoges', '06-84-65-12-00');