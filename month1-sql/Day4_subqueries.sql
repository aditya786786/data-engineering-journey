use ecommerce_db


SELECT 
    customer_name,
    total_spent
FROM (
    SELECT 
        c.name AS customer_name,
        SUM(oi.subtotal) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.name
) AS customer_totals
WHERE total_spent > (
    
    SELECT AVG(total_customer_spend)
    FROM (
        SELECT SUM(subtotal) AS total_customer_spend
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        GROUP BY o.customer_id
    ) AS avg_table
)
ORDER BY total_spent DESC;




SELECT 
    p.product_id,
    p.title
FROM products p
WHERE NOT EXISTS (
    SELECT 1 
    FROM order_items oi 
    WHERE oi.product_id = p.product_id
);




SELECT 
     c.customer_id,
     c.name AS customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);









select 
      customer_name,
      total_spent,
      (total_spent / total_company_revenue) * 100 as revenue_percent
from (
      select
           c.name as customer_name,
           sum(oi.subtotal) as total_spent
      from customers c
      join orders o on c.customer_id = o.customer_id
      join order_items oi on o.order_id = oi.order_id
      group by c.customer_id, c.name
	) as customer_totals
	cross join (
	select sum(subtotal) as total_company_revenue
    from order_items
    ) as grand_total
    order by total_spent desc;
      
      


