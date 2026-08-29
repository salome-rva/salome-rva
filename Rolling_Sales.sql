--EXTRACT / TRANSFORM / LOAD PROJECT--

CREATE DATABASE NY_ROLLING_SALES

USE NY_ROLLING_SALES

GO
-------------------------------------------

--Brooklyn Rolling Sales--
--Database : https://www.nyc.gov/site/finance/property/property-rolling-sales-data.page#

--BUSINESS QUESTIONS--

--"WHAT IS THE MEAN PRICE PER NEIGHBORHOOD?"--
--"WHAT IS THE MEDIAN PRICE PER NEIGHBORHOOD?"--
--"WHICH ARE THE 3 MOST EXPENSIVE NEIGHBORHOODS?"--
--"WHAT IS THE MEAN PRICE PER SQUARE FEET PER NEIGHBORHOOD?"--
--"HOW HAS THE MEDIAN PRICE EVOLVED OVER TIME?"--

------------------------------------------------

--IMPORTATION OF FLAT FILE--

--OK--

--CHECK TABLE--

SELECT * from 
dbo.rollingsales_brooklyn

--CHECK NUMBER OF SALES--

SELECT COUNT (*) as number_sales
from dbo.rollingsales_brooklyn

--22620--

------------------------------------------------

--INFORMATION ABOUT THE TABLE--

SELECT Column_name, data_type, character_maximum_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'rollingsales_brooklyn'

--OK--

--NUMBER OF SALES DISPLAYING 0 AS SALE PRICE--

SELECT COUNT(*) as Sales_0
from dbo.rollingsales_brooklyn
WHERE SALE_PRICE = '0'

--8756--
--HIGH NUMBER DUE TO DONATIONS, ETC.--

--NUMBER OF DISTINCT NEIGHBORHOODS--

SELECT COUNT (DISTINCT neighborhood) as Number_Neighborhoods
from dbo.rollingsales_brooklyn

--60--

--NUMBER OF EMPTY NEIGHBORHOODS--

SELECT COUNT (*) as Empty_Neighborhoods
from dbo.rollingsales_brooklyn
WHERE NEIGHBORHOOD IS NULL

--=0--ALL SALES HAVE A REGISTERED NEIGHBORHOOD--

---------------------------------------------------------
----------------------TABLE CREATION---------------------
---------------------------------------------------------

--CREATION DIMENSION TABLES--
--1. DIM_Date--
CREATE TABLE DIM_Date(
Date_id INT IDENTITY(1,1) PRIMARY KEY,
Sale_Date DATE
)

--2. DIM_Geo--
CREATE TABLE DIM_Geo(
Neighborhood_id INT IDENTITY(1,1) PRIMARY KEY,
Neighborhood_name VARCHAR(50)
)

--3. DIM_Attributes--
CREATE TABLE DIM_Attributes(
Attributes_id INT IDENTITY(1,1) PRIMARY KEY,
Building_category VARCHAR(100),
Building_class VARCHAR(10)

)

--CREATION FACT TABLE--
CREATE TABLE FACT_Sales (
Sale_id INT IDENTITY(1,1) PRIMARY KEY,
Sale_price INT,
Land_Square_Feet FLOAT,
Number_units INT,
Year_built INT,
Date_id INT,
Attributes_id INT,
Neighborhood_id INT,
FOREIGN KEY (Date_id) REFERENCES DIM_Date(Date_id),
FOREIGN KEY (Attributes_id) REFERENCES DIM_Attributes(Attributes_id),
FOREIGN KEY (Neighborhood_id) REFERENCES DIM_Geo(Neighborhood_id)
)

--VERIFICATION OF TABLES--
--------------------------
SELECT*
from FACT_Sales
SELECT*
from DIM_Attributes
SELECT*
from DIM_Date
SELECT*
from DIM_Geo

--OK--
---------------------------
SELECT*
from rollingsales_brooklyn
---------------------------

--OK--

---------------------------------------------------------------------

---INSERT---

--1.DIM_Date--

INSERT INTO DIM_Date (Sale_Date)
SELECT DISTINCT SALE_DATE
from rollingsales_brooklyn

--2.DIM_Geo--

INSERT INTO DIM_Geo (Neighborhood_name)
SELECT DISTINCT
NEIGHBORHOOD
FROM rollingsales_brooklyn

--3.DIM_Attributes--

INSERT INTO DIM_Attributes (Building_category, Building_class)
SELECT DISTINCT BUILDING_CLASS_CATEGORY, BUILDING_CLASS_AT_TIME_OF_SALE
FROM rollingsales_brooklyn;

--4.FACT_Sale--

INSERT INTO FACT_Sales (Sale_price, Land_Square_Feet, Number_units,Year_built, Date_id, Attributes_id, Neighborhood_id)
SELECT
    a.SALE_PRICE,
    a.LAND_SQUARE_FEET,
    a.RESIDENTIAL_UNITS,
    a.YEAR_BUILT,
    b.Date_id,
    d.Attributes_id,
    c.Neighborhood_id
FROM rollingsales_brooklyn AS a
JOIN DIM_Date AS b
    ON a.SALE_DATE = b.Sale_Date
JOIN DIM_Geo AS c
    ON a.NEIGHBORHOOD = c.Neighborhood_name
JOIN DIM_Attributes AS d
    ON a.BUILDING_CLASS_CATEGORY = d.Building_category
   AND a.BUILDING_CLASS_AT_TIME_OF_SALE = d.Building_class
WHERE a.SALE_PRICE >= 1000
AND a.RESIDENTIAL_UNITS >= 1;

--Sales selected with sale price higher than 1000 and at least one number of units--

------CHECK NUMBER OF ACTUAL SALES TABLE------

SELECT COUNT (*) as number_sales
FROM FACT_Sales

--9785--

------------------------------------------------
--------------------ANALYSES--------------------
------------------------------------------------

--"WHAT IS THE MEAN PRICE PER NEIGHBORHOOD?"--

SELECT
AVG(a.Sale_price) as Mean_price,
b.Neighborhood_name
FROM FACT_Sales as a
JOIN DIM_GEO as b
    ON a.Neighborhood_id = b.Neighborhood_id
GROUP BY Neighborhood_name
ORDER BY Mean_Price DESC

--RESULTS--
--Based on the mean price, Gowanus (5M$) is almost 9 times more expensive than Coney Island (600k$)--
--However the gaps in the mean also indicate that the mean is highly sensitive to outliers in price of sales--
--Thus, for further analyses, the median price will be used to better overcome the outliers sensitivity issue--

---------------------------------------------------------------------------------

--"WHAT IS THE MEDIAN PRICE PER NEIGHBORHOOD?"--

SELECT DISTINCT
    b.Neighborhood_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY a.Sale_price) OVER (PARTITION BY b.Neighborhood_name) as Median_price
FROM FACT_Sales as a
JOIN DIM_GEO as b
    ON a.Neighborhood_id = b.Neighborhood_id
ORDER BY Median_price DESC

--RESULTS--
--Based on the median price, number show a 6* gap between the most affordable neighborhood (Gerritsen Beach)
--and the most expensive one (Brooklyn Heights)
--Thus hinting significant spatial inequalities between neighborhoods even when the outliers sensitivity is lowered--

-----------------------------------------------------

--"WHICH ARE THE 3 MOST EXPENSIVE NEIGHBORHOODS?"--

SELECT DISTINCT
TOP 3
    b.Neighborhood_name,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY a.Sale_price) OVER (PARTITION BY b.Neighborhood_name) as Median_price
FROM FACT_Sales as a
JOIN DIM_GEO as b
    ON a.Neighborhood_id = b.Neighborhood_id
ORDER BY Median_price DESC

--RESULTS--
--The most expensive neighborhoods based on the median price are Brooklyn Heights, Cobble Hill and Carroll Gardens
--This appears consistent with reality as those three neighborhoods are located in the north-western part of Brooklyn
--close to the waterfront and Manhattan--

-----------------------------------------------------

--"WHAT IS THE MEDIAN PRICE PER SQUARE FEET PER NEIGHBORHOOD?"--

SELECT DISTINCT
b.Neighborhood_name,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (a.Sale_price/a.Land_Square_Feet)) OVER (PARTITION BY b.Neighborhood_name) as Median_price_per_sqf
FROM FACT_Sales as a
JOIN DIM_GEO as b
    ON a.Neighborhood_id = b.Neighborhood_id
WHERE Land_Square_Feet <> 0
ORDER BY Median_price_per_sqf DESC

--RESULTS--
--The median price per sqft varies greatly between neighborhoods
--the most expensive neighborhoods such as Brooklyn Heights or Cobble Hill display a price over 10 times higher
--than the least expensive ones, such as Coney Island or Seagate
--This analyse confirms significant spatial and economic inequalities between neighborhoods inside Brooklyn--

-----------------------------------------------------

--"HOW HAS THE MEDIAN PRICE EVOLVED OVER TIME?"--

SELECT DISTINCT
YEAR(b.Sale_Date) as Year,
MONTH(b.Sale_Date) as Month,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY a.Sale_price) OVER (PARTITION BY MONTH(b.Sale_Date), YEAR(b.Sale_Date)) as Median_price
FROM FACT_Sales as a
JOIN DIM_Date as b
    ON a.Date_id = b.Date_id
ORDER BY Year, Month

--RESULTS--
--The median price has evoled by 7.8% between August 2025 and July 2026 in Brooklyn, a significant increase in sale prices--