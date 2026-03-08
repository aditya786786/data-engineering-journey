
use ecommerce_db


SHOW INDEX FROM orders;

create index idx_orders_customer on orders(customer_id);

create index idx_order_items_order on order_items(order_id);

create index idx_order_items_product on order_items(product_id);

create index idx_products_category on products(category_id);



select * from orders where customer_id = 3;


select 
     c.name,
     o.order_id
from customers c
join orders o
on c.customer_id = o.customer_id;


create index idx_orders_date on orders(order_date);

