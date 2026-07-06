
--Exercise 1: Ranking and Window Functions

with custom_results as(
	select 
	ProductName,
	category 
	,sum(Price) as price, 
	row_number() over(partition by (category) order by price desc) as ranking
	, rank() over(partition by (category) order by price desc) as org_ranking
	, dense_rank() over(partition by (category) order by price desc) as dense_ranking
	from Products
	group by ProductName, Category, Price
)
select * from custom_results where ranking <= 3



--Exercise 2: Aggregation with GROUPING SETS, CUBE, and ROLLUP

--Join Orders, OrderDetails, Customers, and Products.

select 
	c.region,
	p.category,
	sum(od.quantity) as total_quant
	from Products as p
	
inner join OrderDetails 
	as od on p.ProductID = od.ProductID
inner join Orders
	as o on od.OrderID = o.OrderID
inner join Customers 
	as c on o.CustomerID = c.CustomerID

--Use GROUPING SETS to get totals by Region, Category, and both.
group by grouping sets(
	(c.region,
	p.category),
	(c.region),
	(p.category),());

--Use ROLLUP to get subtotals and grand totals.

select 
	c.region,
	p.category,
	sum(od.quantity) as total_quant
	from Products as p
	
inner join OrderDetails 
	as od on p.ProductID = od.ProductID
inner join Orders
	as o on od.OrderID = o.OrderID
inner join Customers 
	as c on o.CustomerID = c.CustomerID
group by rollup(c.region,
	p.category);



select 
	c.region,
	p.category,
	sum(od.quantity) as total_quant
	from Products as p
	
inner join OrderDetails 
	as od on p.ProductID = od.ProductID
inner join Orders
	as o on od.OrderID = o.OrderID
inner join Customers 
	as c on o.CustomerID = c.CustomerID
group by cube(c.region,
	p.category);



--Exercise 3: CTEs and MERGE


-- Create a recursive CTE to generate a calendar table.

with calender as (
 
 select cast('2025-01-01' as date ) as mydate 

 union all

 select dateadd(day,1,mydate) from calender
 where mydate < '2025-01-31'
 )
 select * from calender

 --  Use a MERGE statement to update or insert product prices from a staging tables:

 merge into Products as target
 using StagingProducts as source
 on target.productID =  source.productID

 when matched then 
	update set
	target.price = source.price

 when not matched then
 insert(ProductID, ProductName, category, price)
 values(source.ProductID, source.ProductName, source.category, source.price);

 select * from products

--Exercise 4: PIVOT and UNPIVOT

SELECT Name, 
    [2025-01-02], [2025-01-03], [2025-01-05], [2025-01-10], [2025-01-12],
    [2025-01-15], [2025-01-18], [2025-01-20], [2025-01-22], [2025-02-14],
    [2025-02-28], [2025-03-10], [2025-03-22], [2025-03-30]
FROM (
    SELECT c.Name, CONVERT(VARCHAR, o.OrderDate, 23) AS OrderDate, od.Quantity
    FROM Customers AS c
    INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails AS od ON o.OrderID = od.OrderID
) AS src
PIVOT (
    COUNT(Quantity)
    FOR OrderDate IN (
        [2025-01-02], [2025-01-03], [2025-01-05], [2025-01-10], [2025-01-12],
        [2025-01-15], [2025-01-18], [2025-01-20], [2025-01-22], [2025-02-14],
        [2025-02-28], [2025-03-10], [2025-03-22], [2025-03-30]
    )
) AS pvt;
