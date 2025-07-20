
/*

Cleaning Data in SQL Queries

*/


Select *
FROM [sql].[dbo].[us cities]

-- Standardize Date Format


Select PERIOD_BEGIN,PERIOD_END,LAST_UPDATED, CONVERT(Date,PERIOD_BEGIN),CONVERT(date,PERIOD_END),CONVERT(Date,LAST_UPDATED)
From  [sql].[dbo].[us cities]


Update [sql].[dbo].[us cities]
SET PERIOD_BEGIN = CONVERT(Date,PERIOD_BEGIN)


Update [sql].[dbo].[us cities]
SET PERIOD_END = CONVERT(Date,PERIOD_END)

Update [sql].[dbo].[us cities]
SET LAST_UPDATED = CONVERT(Date,LAST_UPDATED)

SELECT PERIOD_BEGIN,PERIOD_END,LAST_UPDATED
From  [sql].[dbo].[us cities]

----Breaking out Region Address into Individual Columns (, City, StateCode)


Select REGION
From [sql].[dbo].[us cities]
--Where PropertyAddress is null


SELECT
SUBSTRING(REGION, 1, CHARINDEX(',', REGION) -1 ) as CityAddress
, SUBSTRING(REGION, CHARINDEX(',', REGION) + 1 , LEN(REGION)) as Statecode

From [sql].[dbo].[us cities]


ALTER TABLE [sql].[dbo].[us cities]
Add RegionSplitCity Nvarchar(255);

Update [sql].[dbo].[us cities]
SET RegionSplitCity = SUBSTRING(REGION, 1, CHARINDEX(',', REGION) -1 ) 


ALTER TABLE  [sql].[dbo].[us cities]
Add RegionSplitStatecode Nvarchar(25);

Update  [sql].[dbo].[us cities]
SET RegionSplitStatecode = SUBSTRING(REGION, CHARINDEX(',', REGION) + 1 , LEN(REGION))


Select RegionSplitCity,RegionsplitStateCode,Parent_SplitCity,ParentMetro_SplitStateCode
From  [sql].[dbo].[us cities]

-----------------------------------
--Another way to split the city and state code from parent metro region



Select PARENT_METRO_REGION
From [sql].[dbo].[us cities]


Select
PARSENAME(REPLACE(PARENT_METRO_REGION, ',', '.') , 2)
,PARSENAME(REPLACE(PARENT_METRO_REGION, ',', '.') , 1)
From [sql].[dbo].[us cities]




ALTER TABLE [sql].[dbo].[us cities]
Add Parent_SplitCity Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  Parent_SplitCity = PARSENAME(REPLACE(PARENT_METRO_REGION, ',', '.') , 2)


ALTER TABLE [sql].[dbo].[us cities]
Add ParentMetro_SplitStateCode Nvarchar(255);

Update [sql].[dbo].[us cities]
SET ParentMetro_SplitStateCode = PARSENAME(REPLACE(PARENT_METRO_REGION, ',', '.') , 1)



Select *
From [sql].[dbo].[us cities]


---Change Na to N/A t in "PRICE DROPS" field


Select Distinct(PRICE_DROPS), Count(PRICE_DROPS)
From [sql].[dbo].[us cities]
Group by PRICE_DROPS
order by 2


Select PRICE_DROPS
, CASE When PRICE_DROPS = 'NA' THEN 'N/A'
	   ELSE PRICE_DROPS
	   END
From [sql].[dbo].[us cities]


Update [sql].[dbo].[us cities]
SET PRICE_DROPS = CASE When PRICE_DROPS = 'NA' THEN 'N/A'
	   ELSE PRICE_DROPS
	   END

Select PRICE_DROPS
From [sql].[dbo].[us cities]
--ROUND OF DECIMAL PLACES

SELECT ROUND(MEDIAN_SALE_PRICE_MOM, 6) AS formatted_MEDIAN_SALE_PRICE_MOM 
FROM [sql].[dbo].[us cities]

SELECT ROUND(MONTHS_OF_SUPPLY, 6) AS formatted_MONTHS_OF_SUPPLY 
FROM [sql].[dbo].[us cities]

SELECT ROUND(AVG_SALE_TO_LIST, 6) AS formatted_AVG_SALE_TO_LIST
FROM [sql].[dbo].[us cities]

SELECT ROUND(SOLD_ABOVE_LIST, 6) AS formatted_SOLD_ABOVE_LIST
FROM [sql].[dbo].[us cities]

SELECT ROUND(PRICE_DROPS,6)AS formatted_PRICE_DROPS
FROM [sql].[dbo].[us cities]
WHERE PRICE_DROPS <> 'N/A'

SELECT ROUND(OFF_MARKET_IN_TWO_WEEKS, 6) AS formattedOFF_MARKET_IN_TWO_WEEKS
FROM [sql].[dbo].[us cities]

----------
ALTER TABLE [sql].[dbo].[us cities]
Add  MEDIAN_SALE_PRICE_MOM_formatted Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  MEDIAN_SALE_PRICE_MOM_formatted = ROUND(MEDIAN_SALE_PRICE_MOM, 6)


ALTER TABLE [sql].[dbo].[us cities]
Add  MONTHS_OF_SUPPLY_formatted  Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  MONTHS_OF_SUPPLY_formatted  = ROUND(MONTHS_OF_SUPPLY, 6)

ALTER TABLE [sql].[dbo].[us cities]
Add  AVG_SALE_TO_LIST_formatted  Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  AVG_SALE_TO_LIST_formatted  = ROUND(AVG_SALE_TO_LIST, 6)

ALTER TABLE [sql].[dbo].[us cities]
Add  SOLD_ABOVE_LIST_formatted  Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  SOLD_ABOVE_LIST_formatted  = ROUND(SOLD_ABOVE_LIST, 6)

ALTER TABLE [sql].[dbo].[us cities]
Add  formatted_PRICE_DROPS  Nvarchar(255);

Update [sql].[dbo].[us cities]
SET formatted_PRICE_DROPS = ROUND(PRICE_DROPS,6)
FROM [sql].[dbo].[us cities]
WHERE PRICE_DROPS <> 'N/A'

ALTER TABLE [sql].[dbo].[us cities]
Add  OFF_MARKET_IN_TWO_WEEKS_formatted  Nvarchar(255);

Update [sql].[dbo].[us cities]
SET  OFF_MARKET_IN_TWO_WEEKS_formatted  =  ROUND(OFF_MARKET_IN_TWO_WEEKS, 6)

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY TABLE_ID,REGION,MEDIAN_SALE_PRICE,PARENT_METRO_REGION
				 ORDER BY
					TABLE_ID
					) row_num

FROM [sql].[dbo].[us cities]

)

--order by ParcelID
SELECT * 
From RowNumCTE
Where row_num > 1
--Order by REGION


Select *
FROM [sql].[dbo].[us cities]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [sql].[dbo].[us cities]


ALTER TABLE [sql].[dbo].[us cities]
DROP COLUMN MEDIAN_SALE_PRICE, MEDIAN_SALE_PRICE_MOM, MEDIAN_LIST_PRICE, MONTHS_OF_SUPPLY,AVG_SALE_TO_LIST,SOLD_ABOVE_LIST,OFF_MARKET_IN_TWO_WEEKS




