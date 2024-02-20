-- Temp table for tracking returned orders 
select *
into #track_return 
from Orders$ o left join return$ r on o.[Order ID] = r.[Order ID returned]

--
select *
from #track_return t

-- tỉ lệ đơn bị return 
select sum(case when r.Returned = 'Yes' then 1 else 0 end) as Returned_Order, count(distinct o.[Order ID]) as TotalOrder
from Orders$ o left join return$ r on o.[Order ID] = r.[Order ID returned]
where o.[Order Date] BETWEEN '2013-01-01' AND '2014-12-31'

-- don hang bi doi tra chua mat hang nao
select o.Category, o.[Sub-Category], o.[Product Name]
from Orders$ o left join return$ r on o.[Order ID] = r.[Order ID returned]
where o.[Order Date] BETWEEN '2013-01-01' AND '2014-12-31'

-- nganh hang nao co ti le bi return cao
select Category, count([Product ID])
from #track_return
where Returned = 'Yes'
group by Category
order by 2 desc

-- Customer Retention Rate in 2014 
-- Active customer 
select count(distinct o.[Customer ID]) as active_user
from Orders$ o
where o.[Order Date] between '1-1-2014' and '12-31-2014' 

-- Returning customer
select distinct o.[Customer ID] as returning_user
from Orders$ o
join ( select distinct c.[Customer ID]
	   from Orders$ c
			where c.[Order Date] between '1-1-2013' and '12-31-2013'
	  ) returning on returning.[Customer ID] = o.[Customer ID]
where o.[Order Date] between '1-1-2014' and '12-31-2014'

--retention rate 
select count(distinct yy) as returning_customer, count(distinct zz) as active_customer
from 
	-- active user 
	(select distinct o.[Customer ID] zz 
	from Orders$ o
	where o.[Order Date] between '1-1-2014' and '12-31-2014') as active_user
left join 
	-- returning user
	(select distinct o.[Customer ID] yy 
from Orders$ o
join ( select distinct c.[Customer ID]
	   from Orders$ c
			where c.[Order Date] between '1-1-2013' and '12-31-2013'
	  ) returning on returning.[Customer ID] = o.[Customer ID]
where o.[Order Date] between '1-1-2014' and '12-31-2014') as ret 
	on active_user.zz = ret.yy

-- new customer in 2014 
select distinct [Customer ID] new_customer 
from Orders$
where [Customer ID] not in (
select distinct o.[Customer ID] as returning_user
from Orders$ o
join ( select distinct c.[Customer ID]
	   from Orders$ c
			where c.[Order Date] between '1-1-2013' and '12-31-2013'
	  ) returning on returning.[Customer ID] = o.[Customer ID]
where o.[Order Date] between '1-1-2014' and '12-31-2014')
and [Order Date] between '1-1-2014' and '12-31-2014'

