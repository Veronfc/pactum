SELECT
    projects.id AS id,
    title,
    round(avg(
        CASE
            WHEN bids.amount IS NULL THEN 0
            ELSE bids.amount
        END
    ),2) AS average_bid_amount
FROM bids
RIGHT JOIN projects
ON bids.project_id = projects.id
GROUP BY projects.id, title
ORDER BY average_bid_amount DESC