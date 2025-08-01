SELECT
    users.id AS id,
    username,
    sum(
        CASE
            WHEN payments.status = 'completed' THEN payments.amount
            ELSE 0
        END
    ) AS total_earnings
FROM users 
LEFT JOIN contracts 
ON users.id = contracts.contractor_id 
LEFT JOIN payments
ON contracts.id = payments.contract_id 
GROUP BY users.id
ORDER BY total_earnings;