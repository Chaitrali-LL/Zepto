Select * from dataset;

-- sample data
select * from dataset limit 10;

-- null values
select *from dataset
where name is null
or 
ï»¿Category is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

-- different product categories
select distinct ï»¿Category
from dataset
order by ï»¿Category;

-- products in stock vs out of stock
select outOfStock, count(*) as product_count
from dataset
group by outOfStock;

-- rename column
ALTER TABLE dataset
CHANGE COLUMN ï»¿Category category VARCHAR(255);

-- product present multiple times
select name, count(*) as "Multiple_products"
from dataset
group by name 
having count("Multiple_products") > 1
order by count("Multiple_products") desc;

-- data cleaning 
-- price with 0 price 
select * from dataset
where mrp = 0 or discountedSellingPrice = 0;

delete from dataset
where mrp = 0;

select mrp, discountedSellingPrice from dataset;


-- convert to rupees 
update dataset
set mrp = mrp/100.0;

update dataset
set discountedSellingPrice= discountedSellingPrice/100.0;

-- data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM dataset
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM dataset
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM dataset
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM dataset
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM dataset
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM dataset
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM dataset;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM dataset
GROUP BY category
ORDER BY total_weight;
