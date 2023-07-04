SELECT *
FROM (
  SELECT 
    total.seller_id, 
    AVG(total.review_score :: int) AS avg_rating, 
    COUNT(*) AS review_count 
  FROM (
    SELECT DISTINCT 
      oi.order_id, 
      s.seller_id, 
      or2.review_score 
    FROM sellers s, order_items oi, order_reviews or2, products p 
    WHERE 
      s.seller_id = oi.seller_id 
      AND oi.order_id = or2.order_id  
      AND oi.product_id = p.product_id 
      AND s.seller_city = 'sao paulo'
      AND p.product_category_name = 'automotivo'
  ) total
  GROUP BY total.seller_id
  ORDER BY avg_rating DESC
) total1
WHERE total1.review_count >= 10