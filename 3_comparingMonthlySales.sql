WITH
  MonthlySales AS (
    SELECT
      TO_CHAR(order_date, 'YYYY-MM') AS year_month,
      SUM(oi.amount) AS total_sales
    FROM
      orders o
      JOIN order_items oi ON o.id = oi.order_id
    GROUP BY
      TO_CHAR(order_date, 'YYYY-MM')
  ),
  LaggedSales AS (
    SELECT
      year_month,
      total_sales,
      LAG(total_sales, 1, 0) OVER (
        ORDER BY
          year_month
      ) AS prev_month_sales,
      LAG(total_sales, 12, 0) OVER (
        ORDER BY
          year_month
      ) AS prev_year_sales
    FROM
      MonthlySales
  )
SELECT
  year_month,
  total_sales,
  (
    (
      total_sales - prev_month_sales
    ) / prev_month_sales
  ) * 100 AS prev_month_diff,
  (
    (
      total_sales - prev_year_sales
    ) / prev_year_sales
  ) * 100 AS prev_year_diff
FROM
  LaggedSales
ORDER BY
  year_month;
