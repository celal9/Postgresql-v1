SELECT 
  oi.seller_id, 
  EXTRACT(MONTH FROM oi.shipping_limit_date) AS month, 
  SUM(oi.freight_value :: NUMERIC)
FROM order_items oi 
WHERE 
  oi.shipping_limit_date < '2019-01-01 00:00:00' 
  AND oi.shipping_limit_date >= '2018-01-01 00:00:00'
GROUP BY CUBE(oi.seller_id, month)
ORDER BY oi.seller_id, month ASC