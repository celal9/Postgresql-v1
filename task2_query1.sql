SELECT DISTINCT w1.customer_city
FROM (
  SELECT o.customer_id, c.customer_city, op.payment_type
  FROM orders o, customers c, order_payments op
  WHERE o.order_id = op.order_id
    AND c.customer_id = o.customer_id
    AND op.payment_type = 'voucher'
) w1
WHERE NOT EXISTS (
  SELECT o.customer_id, c.customer_city, op.payment_type
  FROM orders o, customers c, order_payments op
  WHERE o.order_id = op.order_id
    AND c.customer_id = o.customer_id
    AND op.payment_type != 'voucher'
    AND w1.customer_id = o.customer_id
)