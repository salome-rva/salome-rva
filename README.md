![Banner](Banner_Gr.png)

# Salomé Rolland - Data Analyst

> Bringing data and behavioral science together to drive better decisions

![Le Wagon](https://img.shields.io/badge/Certified-Le_Wagon-A21B1B?style=flat-square)
![Digitalcity Brussels](https://img.shields.io/badge/Certified-Digitalcity_Brussels-A21B1B?style=flat-square)
![Location](https://img.shields.io/badge/Brussels-_Mobility_Paris-1A2744?style=flat-square)

**Toolbox**

![Power BI](https://img.shields.io/badge/Power_BI-A21B1B?style=flat-square&logo=powerbi&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-A21B1B?style=flat-square)
![Power Query](https://img.shields.io/badge/Power_Query-A21B1B?style=flat-square)
![SQL Server](https://img.shields.io/badge/SQL_Server-A21B1B?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-A21B1B?style=flat-square&logo=tableau&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-A21B1B?style=flat-square&logo=microsoftexcel&logoColor=white)

**Contact** · [LinkedIn](https://www.linkedin.com/in/salomé-rolland-4b8888425/) · [rollandsalome@gmail.com](mailto:rollandsalome@gmail.com)

# ‣ 1. Gender Equality KPIs Project

Analysis of gender equality in the workplace across the 27 EU member states, based on open data from Eurostat's Sustainable Development Goals dataset (https://ec.europa.eu/eurostat/web/sdi/database). The project covers the full data pipeline: extracting and cleaning the data in Power Query, star schema modeling (one fact table, three dimensions) and building an interactive Power BI dashboard based on several custom KPIs of gender equality.

Core research question: how significant is the workplace gender equality gap across the EU countries and which countries lead or lag?

## - ETL - Dimensional Modeling - Data Vizualization -

### Dimensional Modeling in Power BI

- Star Schema composed of FACT_Indicators_Gender_Equality, DIM_Date, DIM_Country & DIM_Indicator

![Star schema](Schema_Gender_Equality.png)

### Visualization & Analysis of Data in Power BI

You can download the Power BI Project here : 
![Power_BI](Dashboard_Gender_Equality.pbix)

#### Insights

![Context](Context.png)

![Employment](Employment.png)

![Salary](Salary.png)

![Governance](Governance.png)

![Insights](Targets.png)

# ‣ 2. Paris Real Estate & Urban Sustainability

You can download the Power BI Project here : 
![Power_BI](Project_Paris_Sustainability.pbix)

# ‣ 3. Brooklyn Real Estate

Analysis of the residential property sales in Brooklyn, based on open data from the NYC Department of Finance (https://www.nyc.gov/site/finance/property/property-rolling-sales-data.page). The project covers the full data pipeline: extracting & cleaning the files in SQL Server, star schema modeling (one fact table, three dimensions), then analyzing the data and building an interactive Tableau dashboard.

Core research question: what is the median price per neighborhood, and how do prices vary across space and time?

## - ETL - Dimensional Modeling - Data Vizualization -

### Dimensional Modeling on Draw DB

- Star Schema composed of FACT_Sales, DIM_Date, DIM_Geo & DIM_Attributes

![Star schema](Diagram_rolling_sales.png)

### ETL Process & primary analyses on SQL Server Management Studio

[Full script available here](Rolling_Sales.sql)

### Visualization & Analysis of Data on Tableau Public

![Dashboard](Dashboard_Rolling_Sales.png)

![Insights](Insights_Rolling_Sales.png)


