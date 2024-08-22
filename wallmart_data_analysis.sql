select *from wallmart.dbo.sales

---------------- add column time_of_day-------
select time, 
	case
		when time between '00:00:00' and '12:00:00'  then 'morning'
		when time between '12:01:00' and '16:00:00'  then 'afternoon'
		Else 'evening'
	end as time_pf_day
from wallmart.dbo.sales


alter table wallmart.dbo.sales
 add COLUMN time_of_day varchar(20)
-----------
ALTER TABLE wallmart.dbo.sales
 
ADD time_of_day VARCHAR(20);
-----
update wallmart.dbo.sales
 set time_of_day=( case 
									when time between '00:00:00' and '12:0:00:00' then 'Morning'
									when time between '12:01:00' and '16:0:00:00' then 'Afternoon'
									else 'evening'
								end
								)

--------------------add day name of week
select date, DATENAME(weekday,date) as day_name from wallmart.dbo.sales

-----add new column day_name column
alter table wallmart.dbo.sales
 add  day_name varchar(20)
----update Day name
update wallmart.dbo.sales
  set day_name = DATENAME(Weekday,date)

-----add month name
SELECT 
    date, 
    DATENAME(month, date) AS month_name 
FROM 
    wallmart.dbo.sales;

alter table wallmart.dbo.sales add month_name varchar(20)
update wallmart.dbo.sales set month_name= datename(month,date)

-- How many unique cities does the data have?
select distinct city from wallmart.dbo.sales;
-- In which city is each branch?
select distinct city, branch from wallmart.dbo.sales
-- How many unique product lines does the data have?
select distinct Product_line from wallmart.dbo.sales

-- What is the most selling product line
select sum(quantity) as qnt, Product_line from wallmart.dbo.sales group by Product_line order by qnt desc
-- What is the total revenue by month
select month_name,sum(total) as total_rev_month from wallmart.dbo.sales group by month_name order by total_rev_month desc

-- What month had the largest COGS?
select month_name,sum(cogs) as larg_cogs from wallmart.dbo.sales group by month_name order by larg_cogs desc

-- What product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue
FROM wallmart.dbo.sales
GROUP BY product_line
ORDER BY total_revenue DESC; 
-- What is the city with the largest revenue?
select city,Branch, SUM(total) as total_revenue 
FROM wallmart.dbo.sales
group by city,Branch order by total_revenue

-- What product line had the largest VAT?
select Product_line, max(Tax) as laegest_vat 
from wallmart.dbo.sales group by Product_line order by laegest_vat desc

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

select avg(Quantity) as avg_qnt from wallmart.dbo.sales 
select Product_line,
	case 
		when avg(Quantity)>5 then 'good'
		else 'bad'
	end as remark
from wallmart.dbo.sales
group by Product_line, Quantity

alter table wallmart.dbo.sales add remark varchar(20)
 
 update wallmart.dbo.sales 
 set remark=( 
	case 
		when Quantity >(select avg(Quantity)from wallmart.dbo.sales) then 'good'
		else 'bad'
	end )

-- Which branch sold more products than average product sold?
select city,Branch, sum(Quantity)as qnt from wallmart.dbo.sales
group by Branch ,city
having sum(Quantity)>(select avg(Quantity) from wallmart.dbo.sales)

-- What is the most common product line by gender
select gender,Product_line, count(Gender) as total_cnt from wallmart.dbo.sales group by gender, Product_line

-- What is the average rating of each product line
select ROUND(avg(rating),2) as avg_rating, Product_line from wallmart.dbo.sales group by Product_line

-- How many unique customer types does the data have?
select distinct Customer_type from wallmart.dbo.sales
-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM wallmart.dbo.sales;
-- What is the most common customer type?
select Customer_type, count(*) as count from wallmart.dbo.sales group by Customer_type
-- What is the gender of most of the customers?
select Gender, count(*) as Most_gender from wallmart.dbo.sales group by Gender
-- What is the gender distribution per branch?
SELECT Branch,
	gender,
	COUNT(*) as gender_cnt
FROM wallmart.dbo.sales
GROUP BY gender, Branch
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rating from wallmart.dbo.sales group by time_of_day order by  avg_rating  desc

-- Which time of the day do customers give most ratings per branch?
select Branch, time_of_day, 
round(avg(rating),2) as avg_rating 
from wallmart.dbo.sales 
group by Branch, time_of_day order by avg_rating desc

------Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day has the best avg ratings?
select day_name, round(avg(rating),2) as avg_rating from wallmart.dbo.sales group by day_name order by avg_rating desc

---middle of week are not that much of  good ratings

-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?
select day_name,sum(Quantity) as total_sales, round(avg(rating),2) as avg_rating from wallmart.dbo.sales group by day_name order by avg_rating desc
---it seems middle of weeks got high sales but low rating both are not co related

--coundy days of weeks which day get sales and its rating
select day_name,count(day_name) as total_sales, round(avg(rating),2) as avg_rating from wallmart.dbo.sales group by day_name order by avg_rating desc

-- Number of sales made in each time of the day per weekday 
select time, time_of_day,count(time_of_day) as total_sales, 
round(avg(rating),2) as avg_rating from wallmart.dbo.sales group by time_of_day ,time order by total_sales desc
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
select Customer_type,sum(total) as total_revenue from wallmart.dbo.sales group by Customer_type

-- Which city has the largest tax/VAT percent?
select city, round(avg(Tax),2) as largest_tax_percent 
from wallmart.dbo.sales group by City order by largest_tax_percent desc

-- Which customer type pays the most in VAT?
select Customer_type,avg(tax) as total_tax from wallmart.dbo.sales group by Customer_type order by total_tax desc

-----Calculate the average gross income for each product line and filter out the product lines 
--where the average gross income is below avg. Sort the results in descending order of average gross income.
 select Product_line, round(avg(gross_income),2)  as avg_gross_income
 from wallmart.dbo.sales 
 group by Product_line having avg(gross_income)<(select avg(gross_income) from wallmart.dbo.sales)
 order by avg_gross_income desc

 ---------Find the cities with the highest total cogs (Cost of Goods Sold).
 ---Also, show the total cogs for each of these cities.

 select city, round(sum(cogs),2)as total_cogs from wallmart.dbo.sales group by City order by total_cogs desc 

 --For each customer type (Customer_type), calculate the total quantity of products sold and the average rating they gave. 
 --Display the results and sort by the average rating in descending order.

 select Customer_type, sum(Quantity) as total_qnt_product, round(avg(rating),2) as avg_rating
 from wallmart.dbo.sales group by Customer_type order by total_qnt_product,avg_rating desc
 

-----Identify the product line that has the highest percentage increase in sales from one month to the next.
----Display the Product_line, Month, and the percentage increase.
WITH MonthlySales AS (
    SELECT 
        Product_line, 
        month_name, 
        SUM(Total) AS monthly_sales 
    FROM 
        wallmart.dbo.sales 
    GROUP BY 
        Product_line, 
        month_name
),
PercentageIncrease AS (
    SELECT 
        Product_line, 
        month_name, 
        monthly_sales,
        LAG(monthly_sales) OVER (PARTITION BY Product_line ORDER BY month_name) AS prev_monthly_sales
    FROM 
        MonthlySales
)
SELECT 
    Product_line, 
    month_name, 
    ROUND(((monthly_sales - prev_monthly_sales) * 100.0) / prev_monthly_sales, 2) AS percentage_increase
FROM 
    PercentageIncrease
WHERE 
    prev_monthly_sales IS NOT NULL
ORDER BY 
    percentage_increase DESC;

---Determine the average time (in minutes) between transactions for each Branch.
---Display the Branch and the average time in minutes.

WITH LaggedSales AS (
    SELECT 
        Branch, 
        Time, 
        LAG(Time) OVER (PARTITION BY Branch ORDER BY Date, Time) AS PrevTime
    FROM 
        wallmart.dbo.sales
)
SELECT 
    Branch, 
    ROUND(AVG(DATEDIFF(MINUTE, PrevTime, Time)), 2) AS avg_time_between_transactions
FROM 
    LaggedSales
WHERE 
    PrevTime IS NOT NULL
GROUP BY 
    Branch
ORDER BY 
    avg_time_between_transactions;

---Identify the city where the gender distribution is closest to a 50/50 split. Display the City and the percentage 
---difference between male and female customers.

WITH GenderDistribution AS (
    SELECT 
        City, 
        Gender, 
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY City) AS gender_percentage 
    FROM 
        wallmart.dbo.sales 
    GROUP BY 
        City, 
        Gender
)
SELECT 
    City, 
    ABS(MAX(gender_percentage) - MIN(gender_percentage)) AS percentage_difference 
FROM 
    GenderDistribution 
GROUP BY 
    City 
ORDER BY 
    percentage_difference ASC;

----For each City, calculate the average Unit_price and identify the Product_line 
--									with the highest average unit price in each city. 
---Display the City, Product_line, and the average unit price.

WITH CityProductPrice AS (
    SELECT 
        City, 
        Product_line, 
        AVG(Unit_price) AS avg_unit_price 
    FROM 
        wallmart.dbo.sales 
    GROUP BY 
        City, 
        Product_line
)
SELECT 
    City, 
    Product_line, 
    MAX(avg_unit_price) AS max_avg_unit_price 
FROM 
    CityProductPrice 
GROUP BY 
    City, 
    Product_line 
ORDER BY 
    City, 
    max_avg_unit_price DESC;

----Find the product line that has the highest variance in rating. 
--Display the Product_line and the variance of the ratings.
SELECT 
    Product_line, 
    var(Rating) AS rating_variance 
FROM 
    wallmart.dbo.sales 
GROUP BY 
    Product_line 
ORDER BY 
    rating_variance DESC;

	---Identify the Customer_type that has the highest average gross margin percentage.
	--Display the Customer_type and the average gross margin percentage.
	SELECT 
    Customer_type, 
    ROUND(AVG(gross_margin_percentage), 2) AS avg_gross_margin_percentage 
FROM 
    wallmart.dbo.sales 
GROUP BY 
    Customer_type 
ORDER BY 
    avg_gross_margin_percentage DESC;

---Find the correlation between Rating and Total sales for each Product_line. 
--Display the Product_line and the correlation coefficient.
WITH CorrelationCTE AS (
    SELECT 
        Product_line,
        AVG(Rating) AS avg_rating,
        AVG(Total) AS avg_total,
        AVG(Rating * Total) AS avg_rating_total,
        AVG(Rating * Rating) AS avg_rating_squared,
        AVG(Total * Total) AS avg_total_squared,
        COUNT(*) AS count
    FROM 
        wallmart.dbo.sales
    GROUP BY 
        Product_line
)
SELECT 
    Product_line,
    (avg_rating_total - (avg_rating * avg_total)) / 
    SQRT((avg_rating_squared - avg_rating * avg_rating) * (avg_total_squared - avg_total * avg_total)) AS correlation_coefficient
FROM 
    CorrelationCTE
ORDER BY 
    correlation_coefficient DESC;
