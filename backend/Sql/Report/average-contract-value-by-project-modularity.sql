SELECT
    (CASE
        WHEN is_modular = TRUE THEN 'modular'
        ELSE 'non-modular'
    END) AS modularity,
    (CASE
        WHEN round(avg(contracts.agreed_value), 2) IS NULL THEN 0
        ELSE round(avg(contracts.agreed_value), 2)
    END) AS average_contract_value
FROM projects
LEFT JOIN contracts
ON projects.id = contracts.project_id
GROUP BY modularity