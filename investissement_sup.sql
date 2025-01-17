/* Identifier les clients avec un
   total d'investissements supérieur à leur solde total.
 */
use bankapp;

SELECT clients.id_client, comptes.solde, SUM(transactions.montant) as total_transactions
FROM clients
JOIN comptes ON clients.id_client = comptes.id_client
JOIN transactions ON transactions.id_compte = comptes.id_compte
WHERE transactions.statut = 'validé'
GROUP BY clients.id_client, comptes.solde
HAVING SUM(transactions.montant) > comptes.solde