USE inventory;

DROP PROCEDURE IF EXISTS GetMonthlySalesForEachStore;
DROP PROCEDURE IF EXISTS GetAggregateSalesForCompany;
DROP PROCEDURE IF EXISTS GetTopSellingProductsByCategory;
DROP PROCEDURE IF EXISTS GetTopSellingProductByStore;

DELIMITER $$

CREATE PROCEDURE GetMonthlySalesForEachStore(IN year_param INT, IN month_param INT)
BEGIN
    SELECT od.store_id,
           SUM(DISTINCT od.total_price) AS total_sales,
           MONTH(od.date) AS sale_month,
           YEAR(od.date)  AS sale_year
    FROM order_details od
    WHERE YEAR(od.date) = year_param
      AND MONTH(od.date) = month_param
    GROUP BY od.store_id, MONTH(od.date), YEAR(od.date)
    ORDER BY total_sales DESC;
END$$

CREATE PROCEDURE GetAggregateSalesForCompany(IN year_param INT, IN month_param INT)
BEGIN
    SELECT SUM(DISTINCT od.total_price) AS total_sales,
           MONTH(od.date) AS sale_month,
           YEAR(od.date)  AS sale_year
    FROM order_details od
    WHERE YEAR(od.date) = year_param
      AND MONTH(od.date) = month_param
    GROUP BY MONTH(od.date), YEAR(od.date);
END$$

CREATE PROCEDURE GetTopSellingProductsByCategory(IN target_month INT, IN target_year INT)
BEGIN
SELECT s.category, s.name, s.total_quantity_sold, s.total_sales
FROM (SELECT p.category AS category, p.name AS name, SUM(oi.quantity) AS total_quantity_sold, SUM(oi.price*oi.quantity) AS total_sales FROM order_item oi JOIN product p ON p.id=oi.product_id JOIN order_details od ON od.id=oi.order_id WHERE MONTH(od.date)=target_month AND YEAR(od.date)=target_year GROUP BY p.category, p.name) s
JOIN (SELECT t.category, MAX(t.q) AS mx FROM (SELECT p.category AS category, p.name AS name, SUM(oi.quantity) AS q FROM order_item oi JOIN product p ON p.id=oi.product_id JOIN order_details od ON od.id=oi.order_id WHERE MONTH(od.date)=target_month AND YEAR(od.date)=target_year GROUP BY p.category, p.name) t GROUP BY t.category) m
ON m.category=s.category AND m.mx=s.total_quantity_sold
ORDER BY s.category, s.name;
END$$

CREATE PROCEDURE GetTopSellingProductByStore(IN target_month INT, IN target_year INT)
BEGIN
SELECT s.name AS product_name, s.store_id, s.total_quantity_sold, s.total_sales
FROM (SELECT p.name AS name, od.store_id AS store_id, SUM(oi.quantity) AS total_quantity_sold, SUM(oi.price*oi.quantity) AS total_sales FROM order_item oi JOIN product p ON p.id=oi.product_id JOIN order_details od ON od.id=oi.order_id WHERE MONTH(od.date)=target_month AND YEAR(od.date)=target_year GROUP BY od.store_id, p.name) s
JOIN (SELECT t.store_id, MAX(t.q) AS mx FROM (SELECT od.store_id AS store_id, p.name AS name, SUM(oi.quantity) AS q FROM order_item oi JOIN product p ON p.id=oi.product_id JOIN order_details od ON od.id=oi.order_id WHERE MONTH(od.date)=target_month AND YEAR(od.date)=target_year GROUP BY od.store_id, p.name) t GROUP BY t.store_id) m
ON m.store_id=s.store_id AND m.mx=s.total_quantity_sold
ORDER BY s.store_id, s.name;
END$$

DELIMITER ;
