-- =========================================
-- RESET TABLES (Safe Development Reset)
-- =========================================

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================
-- INSERT ORDERS
-- =========================================

INSERT INTO orders 
(customer_id, total_amount, tax_amount, shipping_amount, shipping_address_snapshot, order_status) 
VALUES 
(1, 385.84, 27.84, 10.00, '123 Tech Lane, San Francisco, CA', 'delivered'),
(2, 128.26, 8.76, 10.00, '456 Denim St, Austin, TX', 'shipped'),
(3, 96.93, 6.44, 10.00, '789 Reader Rd, Seattle, WA', 'paid'),
(4, 332.92, 23.92, 10.00, '101 Muscle Blvd, Miami, FL', 'pending'),
(5, 257.31, 18.32, 10.00, '202 Kitchen Way, Chicago, IL', 'paid');


-- =========================================
-- INSERT ORDER ITEMS
-- =========================================

INSERT INTO order_items 
(order_id, product_id, quantity, unit_price, subtotal) 
VALUES 
(1, 1, 1, 348.00, 348.00),

(2, 3, 1, 79.50, 79.50),
(2, 4, 2, 15.00, 30.00),

(3, 6, 1, 42.50, 42.50),
(3, 5, 1, 12.99, 12.99),
(3, 9, 1, 25.00, 25.00),

(4, 10, 1, 299.00, 299.00),

(5, 7, 1, 129.99, 129.99),
(5, 2, 1, 99.00, 99.00);