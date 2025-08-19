drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- data exploration

-- count of rows

select COUNT(*) FROM zepto;

-- sample data 

SELECT * FROM zepto
LIMIT 10;

-- check null
SELECT * FROM zepto
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountpercent IS NULL
OR availablequantity IS NULL
OR discountedsellingprice IS NULL
OR weightInGms IS NULL
OR outofstock IS NULL
OR quantity IS NULL;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock vs outof stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product name present multiple times

SELECT name, COUNT(sku_id) AS "Nmuber of sku"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

SELECT * FROM zepto;

-- data cleaning
-- product with price = 0

SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- Convert paisa into rupees

Update zepto
SET mrp = mrp/100.0, 
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

-- 1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- 2. What are the Products with High MRP but Out of Stock.
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- 3. Calculate estimated revenue for each category.
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- 4. Find all Products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- 5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms, 2) AS price_per_gram
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gram;

-- 7. Group the Products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

-- 8. What is the Total Inventory weight per category.
SELECT category,
SUM(weightingms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;