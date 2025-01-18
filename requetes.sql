/* Requêtes SQL */
use bankapp;

/* Requêtes Read */

/* Sélectionner les clients ayant un solde supérieur à 10 000 € */
SELECT *
FROM comptes
JOIN clients ON comptes.id_client = clients.id_client /* On joint la table clients pour récupérer les informations du client */
WHERE comptes.solde > 10000;

/* Afficher toutes les transactions effectuées le mois dernier (les 30 derniers jours) */
SELECT *
FROM transactions
WHERE date_transaction BETWEEN CURRENT_DATE - INTERVAL 1 MONTH AND CURRENT_DATE;

/* Lister tous les comptes avec un découvert autorisé */
SELECT *
FROM comptes
JOIN clients ON comptes.id_client = clients.id_client
WHERE decouvert_autorise > 0;


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


/* Requêtes Delete */

/* Delete les comptes inactifs depuis 2 ans */
DELETE FROM comptes
WHERE date_ouverture < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR);


/* Delete les comptes inactifs depuis 2 ans */
DELETE FROM comptes
WHERE id_compte NOT IN (
  SELECT DISTINCT id_compte
  FROM transactions
  WHERE date_transaction >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
);

/* Effacer les transactions refusées et annulées */
DELETE FROM transactions
WHERE statut IN ('refusé', 'annulé');

/*Supprime les clients n'ayant pas de compte avec des transactions actives*/
DELETE FROM clients
WHERE id_client NOT IN (
  SELECT DISTINCT id_client
  FROM comptes
  WHERE id_compte IN (
    SELECT DISTINCT id_compte
    FROM transactions
    WHERE statut = 'validé'
  )
);

/* Requêtes complexes */

/* Trouver les 5 clients les plus actifs en termes de transactions. */
SELECT clients.id_client, clients.nom, clients.prenom,
COUNT(transactions.id_transaction) AS nb_transactions /* On compte le nombre de transactions */
FROM transactions
INNER JOIN comptes ON transactions.id_compte = comptes.id_compte /* On joint les tables transactions et comptes */
INNER JOIN clients ON comptes.id_client = clients.id_client /* On joint la table clients */
GROUP BY clients.id_client, clients.nom, clients.prenom /* On groupe par client */
ORDER BY nb_transactions DESC /* Et enfin on trie par nombre de transactions décroissant et limite à 5 */
LIMIT 5;


/* Lister les prêts dont la durée restante est inférieure à un an. */
SELECT *
FROM prets
INNER JOIN clients ON prets.id_client = clients.id_client
WHERE prets.duree < 12;


/* Affichage total pret par conseiller */
SELECT c.nom AS conseiller_nom, c.prenom AS conseiller_prenom, 
SUM(p.montant) AS total_prets
FROM conseillers c
JOIN clients cl ON cl.id_client = c.id_conseiller
JOIN prets p ON p.id_client = cl.id_client
GROUP BY c.id_conseiller;
