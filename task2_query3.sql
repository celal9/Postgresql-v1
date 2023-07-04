SELECT *
FROM (
  SELECT 
    CASE 
      WHEN (GROUPING(p.product_category_name) = 1) THEN 'Total'
      WHEN p.product_category_name IS NULL THEN '<empty>'
      ELSE p.product_category_name
    END AS product_category_name, 
    COUNT(*) AS late_delivery_count 
  FROM orders o, customers c, products p, order_items oi 
  WHERE 
    o.order_estimated_delivery_date - o.order_delivered_customer_date <= INTERVAL '0' 
    AND c.customer_id = o.customer_id 
    AND c.customer_city = 'rio de janeiro' 
    AND o.order_purchase_timestamp >= '2018-06-01 00:00:00' 
    AND o.order_purchase_timestamp <= '2018-09-01 00:00:00' 
    AND p.product_id = oi.product_id  
    AND oi.order_id = o.order_id 
  GROUP BY p.product_category_name
) sss
ORDER BY sss.late_delivery_count DESC, sss.product_category_name ASC