SELECT 
  DISTINCT p.product_id, 
  COUNT(or2.review_score) AS review_count, 
  AVG(or2.review_score :: NUMERIC) AS review_avg 
FROM order_items oi, order_reviews or2, products p 
WHERE 
  p.product_id = oi.product_id 
  AND or2.order_id = oi.order_id 
  AND p.product_category_name = 'eletronicos' 
GROUP BY p.product_id 
HAVING COUNT(or2.review_score) >= 5 
ORDER BY review_avg DESC, review_count DESC 
LIMIT 10