SELECT
    projects.id AS id,
    projects.title AS title,
    count(*) AS module_count,
    count(CASE WHEN modules.status = 'completed' THEN 1 END) AS completed_count,
    round((count(CASE WHEN modules.status = 'completed' THEN 1 END)::numeric / count(*)) * 100, 2) AS completion_rate
FROM projects
INNER JOIN modules
ON projects.id = modules.project_id
GROUP BY projects.id, projects.title
ORDER BY completion_rate DESC