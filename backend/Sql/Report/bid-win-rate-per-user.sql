SELECT
    users.id AS id,
    username,
    count(*) AS bid_count,
    count(CASE WHEN bids.status = 'accepted' THEN 1 END) AS win_count,
    round((count(CASE WHEN bids.status = 'accepted' THEN 1 END)::numeric / count(*)) * 100, 2) AS win_rate
FROM users
LEFT JOIN bids
ON users.id = bids.bidder_id
GROUP BY users.id, username
ORDER BY win_rate DESC