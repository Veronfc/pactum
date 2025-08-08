SELECT
    projects.id AS id,
    projects.title AS title,
    count(*) AS total_bids
FROM projects
LEFT JOIN bids
ON projects.id = bids.project_id
CROSS JOIN dates
WHERE 
    (@ProjectStatus IS NULL OR projects.status = @ProjectStatus::projectstatus)
    AND (dates.start_date IS NULL OR bids.submitted_on >= dates.start_date)
    AND (dates.end_date IS NULL OR bids.submitted_on <= dates.end_date)
GROUP BY projects.id, projects.title
ORDER BY total_bids DESC