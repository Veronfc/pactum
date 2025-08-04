SELECT 
    status,
    count(*) AS contract_count
FROM contracts
GROUP BY status
ORDER BY contract_count DESC