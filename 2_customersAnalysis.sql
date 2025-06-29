WITH
  OrderTotals AS (
    SELECT
      order_id,
      SUM(amount) AS order_total
    FROM
      order_items
    GROUP BY
      order_id
  ),
  CustomerTotals AS (
    SELECT
      o.customer_id,
      SUM(oi.amount) AS total_spent,
      COUNT(DISTINCT o.id) AS order_count
    FROM
      orders o
      JOIN order_items oi ON o.id = oi.order_id
    GROUP BY
      o.customer_id
  )
SELECT
  o.customer_id,
  o.id AS order_id,
  o.order_date,
  ot.order_total,
  ct.total_spent,
  (
    ct.total_spent / ct.order_count
  ) AS avg_order_amount,
  ot.order_total - (
    ct.total_spent / ct.order_count
  ) AS difference_from_avg
FROM
  orders o
  JOIN OrderTotals ot ON o.id = ot.order_id
  JOIN CustomerTotals ct ON o.customer_id = ct.customer_id
ORDER BY
  o.customer_id,
  o.order_date;
