SELECT t1.seller_id, t1.total_earned 
FROM (
  SELECT oi.seller_id, SUM(oi.price :: NUMERIC) AS total_earned 
  FROM order_items oi, orders o 
  WHERE o.order_id = oi.order_id 
    AND o.order_purchase_timestamp >= '2018-01-01 00:00:00' 
    AND o.order_purchase_timestamp <= '2018-04-01 00:00:00' 
  GROUP BY oi.seller_id
) t1, (
  SELECT w1.seller_id 
  FROM (
    SELECT 
      oi.seller_id, 
      EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
      EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
      COUNT(*) AS count_all,
      SUM(oi.price :: NUMERIC) AS price
    FROM order_items oi, orders o 
    WHERE o.order_id = oi.order_id 
      AND o.order_purchase_timestamp >= '2018-01-01 00:00:00' 
      AND o.order_purchase_timestamp <= '2018-04-01 00:00:00'  
    GROUP BY oi.seller_id, year, month
    HAVING COUNT(*) >= 50
  ) w1
  GROUP BY w1.seller_id
  HAVING COUNT(*) = 3
) t2 
WHERE t1.seller_id = t2.seller_id 
ORDER BY t1.total_earned DESC