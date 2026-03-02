-- =========================================
-- DAY 2: JOIN + AGGREGATION + WINDOW FUNCTIONS
-- =========================================



use ecommerce_db
    
    SELECT 
    o.order_id,
    c.name AS customer_name,
    p.title AS product_title,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    o.order_status
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id

ORDER BY o.order_id;
    
SELECT 
    o.order_id,
    c.name AS customer_name,
    cat.name as category_name,
    p.title AS product_title,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    o.order_status
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id
order by order_id;


select cat.name,
      sum(oi.subtotal) as total_revenue,
      count(distinct o.order_id) as number_of_orders
from orders o
join order_items oi
      on o.order_id = oi.order_id
join products p
      on oi.product_id = p.product_id
join categories cat
      on p.category_id = cat.category_id
where o.order_status <> 'cancelled'
group by cat.name
order by total_revenue desc;



select c.name as customer_name,
       sum(oi.subtotal) as total_spent,
       count(distinct o.order_id) as total_orders
from orders o
join customers c
        on o.customer_id = c.customer_id
join order_items oi
        on o.order_id = oi.order_id
where o.order_status <> 'cancelled'
group by c.name
order by total_spent desc
limit 3;



select order_id,
       customer_name,
       total_order_value,
       rank() over (order by total_order_value desc) as rank_of_order_by_value
 from (
       select 
          o.order_id,
          c.name as customer_name,
          sum(oi.subtotal) as total_order_value
from orders o
join customers c 
		  on o.customer_id = c.customer_id
join order_items oi
          on o.order_id = oi.order_id
          group by o.order_id, c.name
          )
          as order_totals;
       
    
    