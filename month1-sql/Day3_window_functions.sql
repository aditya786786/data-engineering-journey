-- =========================================
-- DAY 3: WINDOW FUNCTIONS & ANALYTICAL SQL
-- =========================================


-- =====================================================
-- 1. ROW_NUMBER vs RANK vs DENSE_RANK
-- =====================================================

SELECT 
    order_id,
    total_order_value,
    ROW_NUMBER() OVER (ORDER BY total_order_value DESC) AS row_number_rank,
    RANK() OVER (ORDER BY total_order_value DESC) AS rank_value,
    DENSE_RANK() OVER (ORDER BY total_order_value DESC) AS dense_rank_value
FROM (
    SELECT 
        o.order_id,
        SUM(oi.subtotal) AS total_order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS order_totals
ORDER BY total_order_value DESC;

--output:

order_id, total_order_value, row_number_rank, rank_value, dense_rank_value
1	348.00	1	1	1
4	299.00	2	2	2
5	228.99	3	3	3
2	109.50	4	4	4
3	80.49	5	5	5



-- =====================================================
-- 2. Highest Order Per Customer
-- =====================================================

SELECT 
    customer_name,
    order_id,
    total_order_value
FROM (
    SELECT 
        c.name AS customer_name,
        o.customer_id,
        o.order_id,
        SUM(oi.subtotal) AS total_order_value,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY SUM(oi.subtotal) DESC
        ) AS row_num
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id, c.name, o.order_id
) AS ranked_orders
WHERE row_num = 1
ORDER BY total_order_value DESC;



--output: 

customer_name, order_id, total_order_value
Alice Vance	1	348.00
Bob Miller	2	109.50
Charlie Day	3	80.49
Diana Prince	4	299.00
Evan Wright	5	228.99



-- =====================================================
-- 3. Top 2 Orders Per Customer
-- =====================================================

SELECT 
    customer_name,
    order_id,
    total_order_value
FROM (
    SELECT 
        c.name AS customer_name,
        o.customer_id,
        o.order_id,
        SUM(oi.subtotal) AS total_order_value,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id 
            ORDER BY SUM(oi.subtotal) DESC
        ) AS row_num
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id, c.name, o.order_id
) AS ranked_orders
WHERE row_num <= 2
ORDER BY customer_name, total_order_value DESC;


--output: 
customer_name, order_id, total_order_value
Alice Vance	1	348.00
Bob Miller	2	109.50
Charlie Day	3	80.49
Diana Prince	4	299.00
Evan Wright	5	228.99


-- =====================================================
-- 4. Daily Revenue & Running Total
-- =====================================================

WITH DailyRevenue AS (
    SELECT 
        CAST(o.order_date AS DATE) AS order_date,
        SUM(oi.subtotal) AS daily_revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE o.order_status <> 'cancelled'
    GROUP BY CAST(o.order_date AS DATE)
)

SELECT 
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM DailyRevenue
ORDER BY order_date;


--output:
order_date, daily_revenue, cumulative_revenue
2026-03-01	1065.98	1065.98
