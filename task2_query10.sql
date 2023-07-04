SELECT 
  oi.product_id, 
  COUNT(*) AS total_sales, 
  RANK() OVER (PARTITION BY p.product_category_name ORDER BY COUNT(*) DESC), 
  p.product_category_name 
FROM order_items oi, products p 
WHERE oi.product_id = p.product_id 
  AND p.product_category_name <> '' 
GROUP BY p.product_category_name, oi.product_id 
HAVING COUNT(*) >= 10