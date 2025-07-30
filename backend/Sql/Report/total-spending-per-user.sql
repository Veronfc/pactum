SELECT
    users.id as id,
    username,
    sum(
        CASE
            WHEN payments.status = 'completed' THEN payments.amount
            ELSE 0
        END
    ) AS total_spending
FROM users
LEFT JOIN projects
ON users.id = projects.creator_id
LEFT JOIN contracts
ON projects.id = contracts.project_id
LEFT JOIN payments
ON contracts.id = payments.contract_id
GROUP BY users.id
ORDER BY total_spending;