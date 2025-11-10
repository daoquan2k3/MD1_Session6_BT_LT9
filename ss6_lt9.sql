CREATE TABLE ss6_lt9.product (
    id serial primary key ,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE ss6_lt9.orderdetail (
    id serial primary key ,
    order_id int,
    product_id int REFERENCES ss6_lt9.product(id),
    quantity int
);

--1
SELECT
    p.name AS product_name,
    SUM(p.price * od.quantity) AS total_sales
FROM ss6_lt9.product p
JOIN ss6_lt9.orderdetail od ON p.id = od.product_id
GROUP BY p.id, p.name;


--2, 3
SELECT
    p.category,
    AVG(p.price * od.quantity) AS avg_category_sales
FROM ss6_lt9.product p
JOIN ss6_lt9.orderdetail od ON p.id = od.product_id
GROUP BY p.category
HAVING AVG(p.price * od.quantity) > 20000000;

--4
SELECT
    p.name,
    SUM(p.price * od.quantity) AS total_sales
FROM ss6_lt9.product p
JOIN ss6_lt9.orderdetail od ON p.id = od.product_id
GROUP BY p.id, p.name
HAVING SUM(p.price * od.quantity) > (
    SELECT AVG(total_per_product)
    FROM (
             SELECT SUM(p2.price * od2.quantity) AS total_per_product
             FROM ss6_lt9.product p2
                      JOIN ss6_lt9.orderdetail od2 ON p2.id = od2.product_id
             GROUP BY p2.id
         ) sub
);

--5
SELECT
    p.name AS product_name,
    COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
FROM ss6_lt9.product p
LEFT JOIN ss6_lt9.orderdetail od ON p.id = od.product_id
GROUP BY p.id, p.name;