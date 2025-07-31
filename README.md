# 🚦 Urban Collision Data Analytics

A data-driven project analyzing 2.4M+ traffic accidents across NYC, Chicago, and Austin to uncover patterns, causes, and high-risk zones using ETL, SQL, and BI tools.

## 🧠 Project Objective

To uncover critical patterns in urban traffic accidents, identify high-risk areas and contributing factors, and drive actionable insights for public safety through advanced data processing and visual storytelling.

## 🛠 Tech Stack

- **Data Integration & ETL**: Alteryx, Talend, Python  
- **Database & Modeling**: MySQL, SQL Server Management Studio (SSMS), ER Studio  
- **Visualization Tools**: Tableau, Power BI  
- **Query Languages**: SQL (T-SQL, MySQL)

## 🗂️ Data Sources

- Accident datasets from open-source urban repositories for NYC, Chicago, and Austin
- Weather, vehicle, location, and temporal dimension tables joined into a star schema
- Total records processed: **2.4 million+**

## 📊 Key Business Questions Answered

| # | Business Question |
|--|--------------------|
| 1 | How many accidents occurred in NYC, Austin, and Chicago? |
| 2 | Which areas had the highest accident counts and fatalities? |
| 3 | How often are pedestrians and motorists involved? |
| 4 | What are the most common contributing factors to accidents? |
| 5 | When do accidents occur most — by season, day, and time? |
| 6 | Which vehicle types are most frequently involved? |
| 7 | Which cities experience more multi-vehicle accidents? |

> 📄 See: [`BUSSINESS_REQUIREMENTS.sql`](./BUSSINESS%20REQUIREMENTS.sql), [`MySQLBusinessRequirements.sql`](./MySQLBusinessRequirements.sql)

## 📈 Power BI Dashboards

- **Total accidents by city**  
- **Heatmap of top dangerous locations**  
- **Pedestrian vs. motorist involvement**  
- **Seasonal, hourly, and weekday trends**  
- **Fatality comparison by area**  
- **Top 10 contributing factors and vehicle types**

> 📄 See: [`MVC_FINAL_PROJECT.pbix`](./MVC_FINAL_PROJECT.pbix), [`MVC_FINAL_PROJECT Power_BI_Vizualization.pdf`](./MVC_FINAL_PROJECT%20Power_BI_Vizualization.pdf)

## 📍 Tableau Visualizations

- **Interactive maps of accident hotspots**
- **Filterable views by city, time, and season**
- **Dashboards for multi-vehicle accident analysis**

> 📄 See: [`Tableau_Visualization_Final.twbx`](./Tableau_Visualization_Final.twbx), [`Tableau_Visualization_Final_PPT.pptx`](./Tableau_Visualization_Final_PPT.pptx)

## 🧮 Data Model Design

- **Star schema** with dimensions: `Location`, `Time`, `Date`, `Vehicle_Type`, `Contributing_Factor`
- Fact tables: `FACT_ACCIDENTS`, `FACT_VEHICLE`, `FACT_CONTRIBUTION`
- Modeled in ER Studio to ensure consistency and granularity

![Dimension Model](./images/dimensional_model.png)

## 🚀 Outcomes

- 📉 Reduced query processing time by 40% with optimized joins and indexed dimensions
- 🗺️ Identified top 5 high-risk zones per city
- 🚗 Revealed that **driver inattention** and **unsafe speeds** are leading accident causes
- 📅 Discovered that **weekdays** and **evening hours** are most accident-prone

## 📚 Documentation

- 📘 [Visualization Documentation (PDF)](./Visualization-%20Documentation.pdf)
- 📘 [Business Requirements in SQL (PDF & Scripts)](./BUSSINESS%20REQUIREMENTS.sql)

## 🧑‍💻 Author

**Anusree Mohanan**  
Graduate Student, MS in Information Systems  
Data Analytics | BI | Visualization | ETL | Python | SQL
