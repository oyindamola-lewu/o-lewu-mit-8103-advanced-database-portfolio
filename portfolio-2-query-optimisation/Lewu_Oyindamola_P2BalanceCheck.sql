-- One row per customer account. Signed ledger entries are summed in kobo.
SELECT a.account_number, c.full_name,
       COALESCE(SUM(le.amount_kobo), 0) AS balance_kobo
FROM accounts AS a
JOIN customers AS c ON c.customer_id = a.customer_id
LEFT JOIN ledger_entries AS le ON le.account_id = a.account_id
WHERE a.account_type = 'customer'
GROUP BY a.account_id, a.account_number, c.full_name
ORDER BY a.account_number;
