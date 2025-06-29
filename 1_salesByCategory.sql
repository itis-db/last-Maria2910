WITH CategorySales AS (
    SELECT
        p.category,
        SUM(oi.amount) AS total_sales
    FROM
        order_items oi
    JOIN
        products p ON oi.product_id = p.id
    GROUP BY
        p.category
),
OrderAverages AS (
    SELECT
        p.category,
        AVG(oi.amount) AS avg_per_order
    FROM
        order_items oi
    JOIN
        products p ON oi.product_id = p.id
    GROUP BY
        p.category
),
TotalSales AS (
    SELECT SUM(total_sales) AS grand_total FROM CategorySales
)
SELECT
    cs.category,
    cs.total_sales,
    oa.avg_per_order,
    (cs.total_sales / ts.grand_total) * 100 AS category_share
FROM
    CategorySales cs
JOIN
    OrderAverages oa ON cs.category = oa.category
JOIN
    TotalSales ts ON 1=1
ORDER BY
    cs.category;
