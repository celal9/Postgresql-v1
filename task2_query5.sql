SELECT DISTINCT ssss1.customer_id, ssss.*
FROM (
  SELECT 
    ww.year, 
    ww.month, 
    MAX(ww.total_sum) AS total_sum 
  FROM (
    SELECT 
      oi.order_id, 
      c.customer_id, 
      EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
      EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
      SUM(oi.price :: NUMERIC) AS total_sum
    FROM order_items oi, customers c, orders o 
    WHERE c.customer_id = o.customer_id AND o.order_id = oi.order_id 
    GROUP BY oi.order_id, c.customer_id, o.order_purchase_timestamp 
  ) ww 
  GROUP BY ww.year, ww.month
) ssss, (
  SELECT 
    oi.order_id, 
    c.customer_id, 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    SUM(oi.price :: NUMERIC) AS total_sum
  FROM order_items oi, customers c, orders o 
  WHERE c.customer_id = o.customer_id AND o.order_id = oi.order_id 
  GROUP BY oi.order_id, c.customer_id, o.order_purchase_timestamp 
) ssss1 
WHERE 
  ssss1.total_sum = ssss.total_sum 
  AND ssss1.year = ssss.year 
  AND ssss.month = ssss1.month
ORDER BY ssss.year, ssss.month ASC