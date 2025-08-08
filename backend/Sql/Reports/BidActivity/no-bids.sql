SELECT
    modules.id AS id,
    modules.title AS title
FROM modules
INNER JOIN bids
ON modules.id != bids.modules_id
CROSS JOIN dates
GROUP BY modules.id, modules.title
WHERE 
    (@ProjectId IS NULL OR modules.project_id = @ProjectId::uuid)
    AND (dates.start_date IS NULL OR bids.submitted_on >= dates.start_date)
    AND (dates.end_date IS NULL OR bids.submitted_on <= dates.end_date)
GROUP BY projects.id, projects.title