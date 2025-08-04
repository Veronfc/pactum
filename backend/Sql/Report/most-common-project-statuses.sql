SELECT
    status,
    count(*) as frequency
FROM projects
GROUP BY status
ORDER BY frequency DESC