create table if not exists user_review_scores as 
select oi.product_id ,avg(or2.review_score :: numeric) as review_score from order_items oi ,order_reviews or2 where oi.order_id =or2.order_id 
group by oi.product_id;

CREATE OR REPLACE FUNCTION update_review_score()
RETURNS TRIGGER AS $$
BEGIN
UPDATE user_review_scores
SET review_score = (SELECT AVG(or2.review_score::numeric) AS review_score FROM order_items oi, order_reviews or2 WHERE oi.order_id = or2.order_id AND oi.order_id = NEW.order_id AND oi.product_id = NEW.product_id GROUP BY oi.product_id)
WHERE product_id = NEW.product_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_update_review_score
AFTER INSERT ON order_reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_score();

CREATE OR REPLACE FUNCTION prevent_zero_zipcode_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.zipcode = '00000' THEN
        RAISE EXCEPTION 'Zip code of the seller CAN NOT be zero!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_zero_zipcode
BEFORE INSERT ON sellers
FOR EACH ROW
EXECUTE FUNCTION prevent_zero_zipcode_trigger();
-- standard view
CREATE VIEW order_product_customer_review AS
SELECT
  oi.order_id,
  oi.product_id,
  o.customer_id,
  or2.review_score
FROM
  order_items oi
  JOIN orders o ON oi.order_id = o.order_id
  JOIN order_reviews or2 ON oi.order_id = or2.order_id AND oi.order_id = or2.order_id ;
--  materialized view
CREATE MATERIALIZED VIEW order_product_customer_review_mv AS
SELECT
  oi.order_id,
  oi.product_id,
  o.customer_id,
  or2.review_score
FROM
  order_items oi
  JOIN orders o ON oi.order_id = o.order_id
  JOIN order_reviews or2 ON oi.order_id = or2.order_id AND oi.order_id = or2.order_id;
  
 
-- The main difference between a standard view and a materialized view is that a standard view runs a query each time it is accessed, 
-- 

 
--while a materialized view stores the results of the query and can be accessed much faster.
-- When you switch to using a materialized view, the run time of the query is reduced because the data has already been precomputed and stored in the materialized view.
-- This means that subsequent queries against the materialized view can be executed much faster than running the underlying query each time. 
-- However, the tradeoff is that the data in the materialized view may not always be up-to-date, and it requires additional storage space to store the precomputed results.
-- Therefore, materialized views are best used in situations where the data changes infrequently or where the performance benefits outweigh the potential staleness of the data.