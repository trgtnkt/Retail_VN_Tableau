-- Revenue, No.Customers, Avg Transaction Value, Profit Margin each Year
SELECT YEAR(O.[Order Date]) AS Year, 
	   SUM(O.Sales) AS Revenue,
	   COUNT (DISTINCT O.[Customer ID]) AS "No.Customers",
	   SUM(O.Sales)/COUNT (DISTINCT O.[Order ID]) AS "Avg Trans Value",
	   SUM(O.[Profit])/ SUM(O.Sales)*100 AS "Profit Margin"
FROM Orders$ O
GROUP BY YEAR(O.[Order Date])
ORDER BY YEAR(O.[Order Date])

-- Accumulated revenue and profit
SELECT DISTINCT MONTH(O.[Order Date]) as Month,
	   SUM(O.[Sales]) OVER (ORDER BY MONTH(O.[Order Date]))	as Revenue,
	   SUM(O.[Profit]) OVER (ORDER BY MONTH(O.[Order Date])) as Profit
FROM Orders$ O
WHERE YEAR(O.[Order Date]) = 2014
ORDER BY MONTH(O.[Order Date])

-- %Sale on Total Sale by Category 
SELECT O.Category, 
	   ROUND((SUM([Sales]) / (SELECT SUM([Sales]) 
							  FROM Orders$ O
							  WHERE YEAR([Order Date]) = 2014)*100),2) as Percentage 
FROM Orders$ O
WHERE YEAR([Order Date]) = 2014
GROUP BY O.Category

-- %Sale on Total Sale by Segment  
SELECT O.Segment, 
	   ROUND((SUM([Sales]) / (SELECT SUM([Sales]) 
							  FROM Orders$ O
							  WHERE YEAR([Order Date]) = 2014)*100),2) as Percentage 
FROM Orders$ O
WHERE YEAR([Order Date]) = 2014
GROUP BY O.Segment

-- Sale Performance by Months 
SELECT YEAR([Order Date]) Year, MONTH([Order Date]) Month, SUM([Sales]) Sales
FROM Orders$ 
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY YEAR([Order Date]), MONTH([Order Date])

-- Customer Retention Rate in 2014 
SELECT COUNT(DISTINCT re_user) AS returning_customer, 
	   COUNT(DISTINCT act_user) AS active_customer
FROM 
	-- active user 
	(SELECT DISTINCT o.[Customer ID] act_user 
	FROM Orders$ o
	WHERE o.[Order Date] BETWEEN '1-1-2014' AND '12-31-2014') AS active_user
LEFT JOIN 
	-- returning user
	(SELECT DISTINCT o.[Customer ID] re_user
FROM Orders$ o
JOIN (SELECT DISTINCT c.[Customer ID]
	   FROM Orders$ c
			WHERE c.[Order Date] BETWEEN '1-1-2013' AND'12-31-2013'
	  ) returning ON returning.[Customer ID] = o.[Customer ID]
WHERE o.[Order Date] BETWEEN '1-1-2014' AND'12-31-2014') AS ret 
	ON active_user.act_user = ret.re_user


