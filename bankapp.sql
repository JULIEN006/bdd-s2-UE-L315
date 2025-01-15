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
  `decouvert_autorise` DECIMAL(15, 2),
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
  `statut` VARCHAR(20), 
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


/* Requêtes Update */

/* Mettre à jour le numéro de téléphone d'un client spécifique, ici le client avec l'id 1 */
UPDATE clients
SET telephone = '06 00 00 00 00'
WHERE id_client = 1;


/* Augmenter le découvert autorisé pour certains comptes, ici, ceux qui ont un découvert autorisé en dessous de 1000€ par exemple */
UPDATE comptes
SET decouvert_autorise = 1000
WHERE decouvert_autorise < 1000;


/* Modifier le statut des transactions en attente */
UPDATE transactions
SET statut = 'validée'
WHERE statut = 'en attente';
