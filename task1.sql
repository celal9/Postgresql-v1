create table if not exists geolocation(
geolocation_zip_code_prefix VARCHAR (32) ,
geolocation_lat VARCHAR (32),
geolocation_lng VARCHAR (32),
geolocation_city VARCHAR (48),
geolocation_state VARCHAR (32)
);
create table if not exists customers(
customer_id VARCHAR (32) ,
customer_unique_id VARCHAR (32) ,
customer_zip_code_prefix VARCHAR (32) ,
customer_city VARCHAR (32),
customer_state VARCHAR (32),
primary key(customer_id )
);
create table if not exists orders(
order_id VARCHAR (32) unique not null,
customer_id VARCHAR (32) unique not null,
order_status VARCHAR (32),
order_purchase_timestamp timestamp,
order_approved_at VARCHAR (32),
order_delivered_carrier_date timestamp ,
order_delivered_customer_date timestamp,
order_estimated_delivery_date timestamp,
primary key(order_id),
foreign key(customer_id)
	references customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);
create table if not exists order_reviews(
review_id VARCHAR (32)  not null,
order_id VARCHAR (32)  not null,
review_score VARCHAR (32),
review_comment_title VARCHAR (32),
review_comment_message VARCHAR (256),
review_creation_date timestamp,
review_answer_timestamp timestamp,
UNIQUE (review_id, order_id),
foreign key(order_id)
	references orders (order_id) 
);
create table if not exists order_payments(
order_id VARCHAR (32)  not null,
payment_sequential VARCHAR (32) ,
payment_type VARCHAR (32),
payment_installments VARCHAR (32),
payment_value VARCHAR (32),
UNIQUE (order_id, payment_sequential),
foreign key(order_id)
	references orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE
);


create table if not exists sellers(
seller_id VARCHAR (32) unique not null ,
seller_zip_code_prefix VARCHAR (32) ,
seller_city VARCHAR (48),
seller_state VARCHAR (32),
PRIMARY KEY (seller_id)

);

create table if not exists product_category(
product_category_name VARCHAR (48) unique not null ,
product_category_name_english VARCHAR (48) unique not null,
PRIMARY KEY (product_category_name)
);
create table if not exists products(
product_id VARCHAR (32) unique not null,
product_category_name VARCHAR (48) ,
product_name_length VARCHAR (32),
product_description_length VARCHAR (32),
product_photos_qty VARCHAR (32),
product_weight_g VARCHAR (32),
product_length_cm VARCHAR (32),
product_height_cm VARCHAR (32),
product_width_cm VARCHAR (32),
PRIMARY KEY (product_id)
);
create table if not exists order_items(
order_id VARCHAR (32)  NOT NULL,
order_item_id VARCHAR (32) NOT NULL ,
product_id VARCHAR (32)  not null ,
seller_id VARCHAR (32) not null ,
shipping_limit_date timestamp,
price VARCHAR (32),
freight_value VARCHAR (32),
UNIQUE (order_id, order_item_id),

 FOREIGN KEY (order_id)
      REFERENCES orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (product_id)
      REFERENCES products (product_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (seller_id)
      REFERENCES sellers (seller_id) ON DELETE CASCADE ON UPDATE CASCADE
);
