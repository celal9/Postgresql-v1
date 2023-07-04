SELECT 
    p3.product_category_name, 
    COUNT(*) AS past_order_count 
FROM 
    products p3, 
    order_items oi2, 
    orders o, 
    customers c,
    (
        SELECT DISTINCT p2.product_category_name 
        FROM products p2 
        WHERE NOT EXISTS (
            SELECT DISTINCT p.product_category_name 
            FROM sellers s, order_items oi, products p 
            WHERE s.seller_id = oi.seller_id 
            AND p.product_id = oi.product_id 
            AND s.seller_city = 'sao paulo' 
            AND p2.product_category_name = p.product_category_name
        )
    ) w2
WHERE 
    p3.product_category_name = w2.product_category_name 
    AND p3.product_id = oi2.product_id 
    AND oi2.order_id = o.order_id 
    AND o.customer_id = c.customer_id 
    AND c.customer_city = 'sao paulo'
GROUP BY p3.product_category_name 
HAVING (COUNT(*) >= 10)