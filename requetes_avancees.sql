use bankapp;

/* Identifier les clients avec un
   total d'investissements supérieur à leur solde total.
 */
SELECT clients.id_client, comptes.solde, SUM(transactions.montant) as total_transactions
FROM clients
         JOIN comptes ON clients.id_client = comptes.id_client
         JOIN transactions ON transactions.id_compte = comptes.id_compte
WHERE transactions.statut = 'validé'
GROUP BY clients.id_client, comptes.solde
HAVING SUM(transactions.montant) > comptes.solde

/*
 Trouver les comptes ayant le plus haut taux de transactions réussies
 */
SELECT DISTINCT comptes.id_compte, comptes.id_client, c.prenom, c.nom, /* Récupérer les infos à afficher */
                COUNT(transactions.id_transaction) as transactions_reussies, /* récupération des transactions */
                COUNT(transactions.id_transaction) * 100.0 /
                (SELECT COUNT(*) FROM transactions WHERE transactions.id_compte = comptes.id_compte) as taux_reussite /* Calcul du % de réussite des transactions */
FROM comptes /* Les infos sont à récupérer depuis la table "comptes". */
         JOIN transactions ON comptes.id_compte = transactions.id_compte /* On a besoin également des infos de la table "transactions". */
         JOIN clients c ON c.id_client = comptes.id_client /* Également besoin des infos de la table "clients". */
WHERE transactions.statut = 'validé' /* Pour le calcul du % de transactions réussies, on veut uniquement les transactions avec le status "validé". */
GROUP BY comptes.id_compte, comptes.id_client, c.prenom /* Regrouper les résultats par client via son compte */
ORDER BY taux_reussite DESC, transactions_reussies DESC /* On applique un tri pour que les % de réussites plus élevées soient en tête de liste */;

/*
 Lister les clients qui n'ont pas utilisé de services de prêt ou d'investissement
 */
SELECT DISTINCT c.id_client, c.nom, c.prenom /* On récupère l'ID, le nom et prénom du client, en indiquant qu'on veut un résultat unique par client */
FROM clients c /* Sélection de la table "clients" */
         LEFT JOIN comptes co ON c.id_client = co.id_client /* Récupération des infos dans la table des comptes */
         LEFT JOIN prets p ON c.id_client = p.id_client /* Récupération des infos dans la table des prêts */
         LEFT JOIN transactions t ON co.id_compte = t.id_compte AND t.type = 'investissement' /* Récupération des infos dans la table des transactions */
WHERE p.id_pret IS NULL /* On veut que les prêts soient nuls (vides) */
  AND t.id_transaction IS NULL /* et aussi qu'aucune transaction ne soit enregistrée */;

/*
 Déterminer le montant total des intérêts générés par les prêts - VERSION ANNUELLE
 */
SELECT SUM(montant * taux_interet) AS total_interets_annuels /* Addition de la multiplication du montant de chaque prêt avec le taux d'intérêt  */
FROM prets; /* À partir de la table "prets". Permet de calculer sur l'année */

/*
 Déterminer le montant total des intérêts générés par les prêts - SUR LA TOTALITÉ DU PRÊT
 */
SELECT SUM(montant * taux_interet * (duree / 12)) AS total_interets
FROM prets;

/*
 Déterminer le montant total des intérêts générés par les prêts - MENSUEL
 */
SELECT
    id_pret, /* Sélectionne l'identifiant du prêt */
    montant, /* Avec le montant */
    taux_interet, /* Et le taux d'intérêt */
    montant * (taux_interet / 12) AS interets_mensuels /* Calcul des intérêts pour un mois */
FROM prets; /* À partir de la table des prêts */

/* Calculer la variation mensuelle du nombre de transactions */

WITH transactions_mensuelles AS (
    /* Définition d'une Common Table Expression : "transactions_mensuelles" */
    SELECT
        DATE_FORMAT(date_transaction, '%Y-%m-01') AS mois,
        /* Convertit la date de transaction en format 'YYYY-MM-01', pour regrouper toutes les transactions du même mois */
        COUNT(*) AS nombre_transactions
    /* On compte le nombre de transactions pour chaque mois */
    FROM transactions
    /* À partir de la table "transactions" */
    GROUP BY DATE_FORMAT(date_transaction, '%Y-%m-01')
    /* On regroupe les résultats par mois */
),
     transactions_avec_mois_precedent AS (
         /* Définition d'une deuxième Common Table Expression */
         SELECT
             mois,
             nombre_transactions,
             LAG(nombre_transactions) OVER (ORDER BY mois) AS nombre_transactions_mois_precedent
         /* Utilise la fonction LAG pour obtenir le nombre de transactions du mois précédent */
         FROM transactions_mensuelles
         /* Utilise les résultats de la première Common Table Expression */
     )
SELECT
    mois,
    nombre_transactions,
    nombre_transactions_mois_precedent,
    nombre_transactions - nombre_transactions_mois_precedent AS variation_absolue,
    /* Calcule la variation du nombre de transactions */
    IF(nombre_transactions_mois_precedent = 0, NULL,
       (nombre_transactions - nombre_transactions_mois_precedent) * 100.0 / nombre_transactions_mois_precedent) AS variation_pourcentage
/* Calcule la variation en %, en gérant le cas où le mois précédent aurait 0 transaction pour éviter les erreurs de calcul */
FROM transactions_avec_mois_precedent
ORDER BY mois;
/* Trie les résultats par ordre chronologique */
