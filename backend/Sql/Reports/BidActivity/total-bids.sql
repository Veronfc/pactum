WITH temp AS (
    SELECT
        coalesce(@StartDate,
            CASE
                WHEN @TimeRange = 'day' THEN (now() - '24 hours'::interval)
                WHEN @TimeRange = 'week' THEN (now() - '7 days'::interval)
                WHEN @TimeRange = 'month' THEN (now() - '30 days'::interval)
                WHEN @TimeRange = 'year' THEN (now() - '1 year'::interval)
                ELSE NULL
            END) AS start_date,
        coalesce(@EndDate, now()) AS end_date
)
SELECT
    users.id AS id,
    users.username AS username,
    count(*) AS total_bids
FROM users
INNER JOIN bids
ON users.id = bids.bidder_id
CROSS JOIN temp
WHERE 
    (@ContractorId IS NULL OR users.id = @ContractorId::uuid)
    AND (temp.start_date IS NULL OR bids.submitted_on >= temp.start_date)
    AND (temp.end_date IS NULL OR bids.submitted_on <= temp.end_date)
GROUP BY users.id, users.username
ORDER BY total_bids
