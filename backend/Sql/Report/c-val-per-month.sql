SELECT concat(
        extract(month FROM accepted_on), 
        '-',
        extract(year FROM accepted_on)
    ) AS month_year,
    sum(agreed_value) AS value_sum
FROM contracts
GROUP BY month_year
ORDER BY month_year;

-- TODO
-- Allow value per [week, month, quarter, year]