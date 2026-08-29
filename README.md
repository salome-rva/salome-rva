![Banner](Banner(4).png.png)

# 🔹 1. Gender Equality KPI Project
- Analytics & Visualization - 
Interactive dashboard built in PowerBI to monitor gender equality indicators aligned with the Sustainable Development Goals set by the UN.

[View the Dashboard](https://lookerstudio.google.com/s/sIpz7YQtjcI)

# 🔹 2. Brooklyn Real Estate Project

Analysis of ~9,800 residential property sales in Brooklyn, based on open data from the NYC Department of Finance (https://www.nyc.gov/site/finance/property/property-rolling-sales-data.page).The project covers the full data pipeline: extracting the raw file & cleaning it in SQL Server, modeling it as a star schema (one fact table, three dimensions), then analyzing the data and building an interactive Tableau dashboard.

Core business question: what is the median price per neighborhood, and how do prices vary across space and time?

## - ETL - Dimensional Modeling - Data Vizualization -

### Dimensional Modeling on Draw DB

- Star Schema composed of FACT_Sales, DIM_Date, DIM_Geo & DIM_Attributes

![Star schema](Diagram_rolling_sales.png)

### ETL Process & primary analyses on SQL Server Management Studio

[Full script available here](Rolling_Sales.sql)

### Visualization & Analysis of Data on Tableau Public

![Dashboard](Dashboard_Rolling_Sales.png)

![Insights](Insights_Rolling_Sales.png)


