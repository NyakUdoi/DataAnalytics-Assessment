# Question 4
WITH UserTenure AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS customer_name,
        TIMESTAMPDIFF(MONTH, created_on, CURDATE()) AS tenure_months
    FROM
        adashi_staging.users_customuser
),
TransactionValues AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        AVG((confirmed_amount - deduction_amount) / 100000) AS avg_transaction_value
    FROM
        adashi_staging.savings_savingsaccount
    GROUP BY
        owner_id
)
SELECT
    ut.customer_id,
    ut.customer_name,
    ut.tenure_months,
    COALESCE(tv.total_transactions, 0) AS total_transactions,
    ROUND(COALESCE((tv.total_transactions / ut.tenure_months) * 12 * (tv.avg_transaction_value * 0.001), 0), 2) AS estimated_clv
FROM
    UserTenure ut
LEFT JOIN
    TransactionValues tv ON ut.customer_id = tv.owner_id
ORDER BY
    estimated_clv DESC;