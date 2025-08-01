SELECT
    projects.id AS id,
    title,
    count(*) AS bids,
    round(avg(bids.amount), 2) AS average_bid
FROM projects
INNER JOIN bids
ON projects.id = bids.project_id
GROUP BY projects.id
ORDER BY average_bid;