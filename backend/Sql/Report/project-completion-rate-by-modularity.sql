SELECT
    (CASE
        WHEN is_modular = TRUE THEN 'modular'
        ELSE 'non-modular'
    END) AS modularity,
    count(*) AS project_count,
    count(CASE WHEN status = 'completed' THEN 1 END) AS completed_count,
    round((count(CASE WHEN status = 'completed' THEN 1 END)::numeric / count(*)) * 100, 2) AS completion_rate
FROM projects
GROUP BY modularity