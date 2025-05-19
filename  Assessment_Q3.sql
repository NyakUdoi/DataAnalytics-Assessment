# Question 3

SELECT
    pp.id AS plan_id,
    pp.owner_id,
    CASE
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other' -- Handle cases that are neither explicitly savings nor investment
    END AS type,
    MAX(ssa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(ssa.transaction_date)) AS inactivity_days
FROM
    adashi_staging.plans_plan pp
LEFT JOIN
    adashi_staging.savings_savingsaccount ssa ON pp.id = ssa.plan_id
WHERE
    pp.is_deleted = 0 -- Assuming is_deleted = 0 indicates an active plan
    AND pp.is_archived = 0 -- Assuming is_archived = 0 indicates a non-archived plan
GROUP BY
    pp.id, pp.owner_id, type
HAVING
    MAX(ssa.transaction_date) IS NULL OR DATEDIFF(CURDATE(), MAX(ssa.transaction_date)) > 365
ORDER BY
    inactivity_days DESC;