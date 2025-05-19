# Question 1

SELECT
    u.id AS owner_id,
    COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name,
    SUM(CASE WHEN pp.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE WHEN pp.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
    ROUND(SUM(ssa.confirmed_amount / 100000), 2) AS total_deposits
FROM
    adashi_staging.users_customuser u
JOIN
    adashi_staging.plans_plan pp ON u.id = pp.owner_id
LEFT JOIN
    adashi_staging.savings_savingsaccount ssa ON pp.id = ssa.plan_id
WHERE
    pp.is_a_goal = 0 -- Assuming non-goal plans are funded savings/investments
GROUP BY
    u.id, name
HAVING
    SUM(CASE WHEN pp.is_regular_savings = 1 THEN 1 ELSE 0 END) > 0 AND
    SUM(CASE WHEN pp.is_a_fund = 1 THEN 1 ELSE 0 END) > 0
ORDER BY
    total_deposits DESC;