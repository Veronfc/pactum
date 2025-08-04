SELECT 
    users.id AS id,
    username,
    count(projects.id) AS projects_created_count
FROM users
LEFT JOIN projects
ON users.id = projects.creator_id
GROUP BY users.id, username
ORDER BY projects_created_count DESC