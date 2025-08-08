SELECT
    users.id AS id,
    users.username AS username,
    count(*) AS total_bids
FROM users
LEFT JOIN bids
ON users.id = bids.bidder_id
CROSS JOIN dates
WHERE 
    (@ContractorId IS NULL OR users.id = @ContractorId::uuid)
    AND (dates.start_date IS NULL OR bids.submitted_on >= dates.start_date)
    AND (dates.end_date IS NULL OR bids.submitted_on <= dates.end_date)
GROUP BY users.id, users.username
ORDER BY total_bids
