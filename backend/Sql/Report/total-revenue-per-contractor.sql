SELECT
    users.id AS id,
    username,
    round(sum(contracts.agreed_value), 2) AS total_revenue
FROM users
INNER JOIN contracts
ON users.id = contracts.contractor_id
GROUP BY users.id, username
ORDER BY total_revenue DESC