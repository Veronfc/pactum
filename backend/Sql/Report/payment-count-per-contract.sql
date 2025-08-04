SELECT
    contracts.id AS id,
    count(*) AS payment_count
FROM contracts
LEFT JOIN payments
ON contracts.id = payments.contract_id
GROUP BY contracts.id
ORDER BY payment_count DESC