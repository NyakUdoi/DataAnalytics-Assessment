# Question 2

SELECT
    CASE
        WHEN avg_monthly_verifications >= 10 THEN 'High Frequency'
        WHEN avg_monthly_verifications BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(DISTINCT owner_id) AS customer_count,
    AVG(avg_monthly_verifications) AS avg_transactions_per_month
FROM (
    SELECT
        owner_id,
        AVG(monthly_verification_count) AS avg_monthly_verifications
    FROM (
        SELECT
            owner_id,
            DATE_FORMAT(verification_transaction_date, '%Y-%m') AS transaction_month,
            COUNT(*) AS monthly_verification_count
        FROM
            adashi_staging.savings_savingsaccount
        WHERE verification_transaction_date IS NOT NULL
        GROUP BY
            owner_id,
            transaction_month
    ) AS monthly_counts
    GROUP BY
        owner_id
) AS user_averages
GROUP BY
    frequency_category
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;