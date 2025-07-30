SELECT
    projects.id as id,
    title,
    count(*) as bids,
    round(avg(bids.amount), 2) as average_bid
FROM projects
INNER JOIN bids
ON projects.id = bids.project_id
GROUP BY projects.id
ORDER BY average_bid;