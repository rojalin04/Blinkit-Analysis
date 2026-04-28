
select count(*) from Blinkit_data; --8523
--data cleaning
update Blinkit_data
set Item_Fat_content = 
case
when Item_Fat_content IN ('LF', 'low fat') then 'Low Fat'
when Item_Fat_content = 'reg' then 'Regular'
else Item_Fat_content
end

-- to check if the values are really changed
select distinct(Item_Fat_content) from Blinkit_data;
-- so now i have cleaned the entire data

-- KPI Requirements (Key Performance Indicator)
-- Total Sales - The total revenew generated in the entire data
select sum(Sales) as Total_Sales from Blinkit_data; --1201681.49196053

-- Total Sales in millions
select cast(sum(Sales)/1000000 as decimal(10, 2)) as Total_Sales_In_millions from Blinkit_data; --1.20

--Total Sales for low fat
select cast(sum(Sales)/1000000 as decimal(10, 2)) as Total_Sales_In_millions from Blinkit_data
where Item_Fat_Content = 'Low Fat'; -- 0.78

-- Total Average sales
select cast(avg(Sales) as decimal(10, 1)) as Total_Avg_sales from Blinkit_data; --141.0

-- total no of items (Total no of rows in the dataset)

select count(*) as No_Of_Items from Blinkit_data --8523

-- Average rating- the avg rating for items sold
select cast( avg(Rating) as decimal(10, 2)) as Avg_Rating from Blinkit_data; --3.97

--Granular Requirement
--Total Sales By Fat Content,Avg Sales By Fat Content, No Of Items By fat content, average rating by fat content
-- whenever we are using aggregation with a dimension field then we have to group it
select Item_Fat_Content, 
		cast(sum(Sales) as decimal(10, 2)) as Total_Sales ,
		cast(avg(Sales) as decimal(10, 2)) as Avg_Sales,
		count(*) as No_Of_Items,
		cast(avg(Rating) as decimal(10, 2)) as Avg_Rating
from Blinkit_data
group by Item_Fat_Content
order by Total_Sales Desc;

-- Total Sales By Item Type
select Item_Type, 
		cast(sum(Sales) as decimal(10, 2)) as Total_Sales ,
		cast(avg(Sales) as decimal(10, 2)) as Avg_Sales,
		count(*) as No_Of_Items,
		cast(avg(Rating) as decimal(10, 2)) as Avg_Rating
from Blinkit_data
group by Item_Type
order by Total_Sales Desc;

-- top 5 best sell item type
select top 5 Item_Type,  
		cast(sum(Sales) as decimal(10, 2)) as Total_Sales ,
		cast(avg(Sales) as decimal(10, 2)) as Avg_Sales,
		count(*) as No_Of_Items,
		cast(avg(Rating) as decimal(10, 2)) as Avg_Rating
from Blinkit_data
group by Item_Type
order by Total_Sales Desc;

--Fat Content By Outlet For Total Sales
select Outlet_Location_Type,
	isnull([Low Fat], 0) as Low_Fat,
	isnull([Regular], 0) as Regular
from 
(
	select Outlet_Location_Type, Item_Fat_Content,
			cast(sum(Total_Sales) as decimal(10, 2)) as Total_Sales
	from Blinkit_data
	group by Outlet_Location_Type, Item_Fat_Content
) as SourceTable -- giving a name to use it again
pivot -- changes rows into column
(
	sum(Total_Sales)
	for Item_Fat_Content in ([Low Fat],[Regular])
) as PivotTable
order by Outlet_Location_Type

-- Total Sales By Item Establishment
select Outlet_Establishment_Year, 
		cast(sum(Total_Sales) as decimal(10, 2)) as Total_sales,
		cast(avg(Total_Sales) as decimal(10, 1)) as Avg_Sales,
		count(*) as No_Of_Items,
		cast(avg(Rating) as decimal(10, 2)) as Avg_Rating

from Blinkit_Data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year;

-- Charts Requirement
-- Percentage Of Sales by Outlet Size- the correlation between outlet size and total_sales
--sum(sum(Total_Sales)) over()) gives total sale of all outlets combined
select
    Outlet_Size, 
    cast(sum(Total_Sales) as decimal(10,2)) AS Total_Sales,
    cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2)) as Sales_Percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales desc;

-- Sales By Outlet Location
select
    Outlet_Location_Type, 
    cast(sum(Total_Sales) as decimal(10,2)) AS Total_Sales,
    cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2)) as Sales_Percentage,
	cast(avg(Total_Sales) as decimal(10, 2)) as Avg_Sales,
	count(*) as No_Of_items,
	cast(avg(Rating) as decimal(10, 2)) as Avg_Rating
from blinkit_data
group by Outlet_Location_Type
order by Total_Sales desc;

-- All metrics by Outlet_type
select
    Outlet_Type, 
    cast(sum(Total_Sales) as decimal(10,2)) AS Total_Sales,
    cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2)) as Sales_Percentage,
	cast(avg(Total_Sales) as decimal(10, 2)) as Avg_Sales,
	count(*) as No_Of_items,
	cast(avg(Rating) as decimal(10, 2)) as Avg_Rating
from blinkit_data
group by Outlet_Type
order by Total_Sales desc;










