/*
 Trouver les comptes ayant le plus haut taux de transactions réussies
 */
use bankapp;

SELECT DISTINCT comptes.id_compte, comptes.id_client, c.prenom,
       COUNT(transactions.id_transaction) as transactions_reussies,
       COUNT(transactions.id_transaction) * 100.0 /
         (SELECT COUNT(*) FROM transactions WHERE transactions.id_compte = comptes.id_compte) as taux_reussite
FROM comptes
JOIN transactions ON comptes.id_compte = transactions.id_compte
JOIN clients c ON c.id_client = comptes.id_client
WHERE transactions.statut = 'validé'
GROUP BY comptes.id_compte, comptes.id_client, c.prenom
ORDER BY taux_reussite DESC, transactions_reussies DESC;

SELECT DISTINCT c.id_client, c.nom, c.prenom
FROM clients c
         LEFT JOIN comptes co ON c.id_client = co.id_client
         LEFT JOIN prets p ON c.id_client = p.id_client
         LEFT JOIN transactions t ON co.id_compte = t.id_compte AND t.type = 'investissement'
WHERE p.id_pret IS NULL
  AND t.id_transaction IS NULL;

/*
 Déterminer le montant total des intérêts générés par les prêts
 */
SELECT SUM(montant * taux_interet * duree / 12) AS total_interets
FROM prets;

/*
 Calculer la variation mensuelle du nombre de transactions
 */
WITH transactions_mensuelles AS (
    SELECT
        DATE_FORMAT(date_transaction, '%Y-%m-01') AS mois,
        COUNT(*) AS nombre_transactions
    FROM transactions
    GROUP BY DATE_FORMAT(date_transaction, '%Y-%m-01')
),
transactions_avec_mois_precedent AS (
    SELECT
        mois,
        nombre_transactions,
        LAG(nombre_transactions) OVER (ORDER BY mois) AS nombre_transactions_mois_precedent
    FROM transactions_mensuelles
)
SELECT
    mois,
    nombre_transactions,
    nombre_transactions_mois_precedent,
    nombre_transactions - nombre_transactions_mois_precedent AS variation_absolue,
    IF(nombre_transactions_mois_precedent = 0, NULL,
       (nombre_transactions - nombre_transactions_mois_precedent) * 100.0 / nombre_transactions_mois_precedent) AS variation_pourcentage
FROM transactions_avec_mois_precedent
ORDER BY mois;
