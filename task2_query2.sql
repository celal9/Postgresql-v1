SELECT total.seller_id, total.avg_duration
FROM (
  SELECT AVG(DISTINCT (oo1.order_delivered_carrier_date - oo1.order_purchase_timestamp)) AS avg_duration, oo.seller_id
  FROM (
    SELECT DISTINCT o1.order_id, s2.seller_id
    FROM products p, sellers s2, order_items o1
    WHERE p.product_id = o1.product_id
      AND s2.seller_id = o1.seller_id
      AND s2.seller_city = 'curitiba'
      AND p.product_category_name = 'beleza_saude'
  ) s3, order_items oo, orders oo1
  WHERE oo.seller_id = s3.seller_id
    AND oo1.order_id = oo.order_id
    AND oo1.order_status = 'delivered'
  GROUP BY oo.seller_id
) total
WHERE total.avg_duration <= INTERVAL '2 days'
ORDER BY avg_duration DESC