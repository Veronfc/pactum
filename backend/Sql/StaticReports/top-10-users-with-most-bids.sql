SELECT
    users.id AS id,
    username,
    count(*) as total_bids
FROM users
INNER JOIN bids
ON users.id = bids.bidder_id
GROUP BY users.id, username
ORDER BY total_bids DESC
LIMIT 10