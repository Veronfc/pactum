SELECT 
    coalesce(bids.module_id, bids.project_id) AS id,
    coalesce(modules.title, projects.title) AS title,
    count(*) AS bids_count
FROM bids
LEFT JOIN modules
ON bids.module_id = modules.id
LEFT JOIN projects
ON bids.project_id = projects.id
GROUP BY coalesce(bids.module_id, bids.project_id), coalesce(modules.title, projects.title)
ORDER BY bid_count DESC