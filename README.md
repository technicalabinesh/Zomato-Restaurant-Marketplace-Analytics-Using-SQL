# Zomato-Restaurant-Marketplace-Analytics-Using-SQL

Zomato Restaurant Marketplace Analytics (MySQL)
A Data Analyst portfolio project that explores restaurant performance,
ratings, pricing, cuisine categories, and service availability using SQL
in MySQL.
Project Overview
This project uses a Zomato restaurant dataset to answer practical
business questions, such as:
Which cities have the most restaurants?
Which cities have the highest average ratings?
How do ratings vary across price ranges?
Is online delivery availability associated with different average
ratings?
Which restaurants have both strong ratings and high vote counts?
Which cuisine entries are most common?
What share of restaurants offer online delivery?
The goal is to turn raw restaurant data into useful, evidence-based
business insights.
Tools & Skills
Database: MySQL
SQL environment: MySQL Workbench
Skills: Data exploration, data quality checks, filtering,
aggregation, `GROUP BY`, `HAVING`, `CASE`, subqueries, CTEs, window
functions, ranking, and KPI analysis
Dataset
The dataset contains restaurant-level fields, including:
Restaurant ID and restaurant name
Country code, city, address, locality
Longitude and latitude
Cuisines
Average cost for two and currency
Table booking and online delivery availability
Price range
Aggregate rating, rating text, and votes
> Note: The dataset's `cuisines` field may contain multiple cuisines in
> a single cell. The project initially analyzes each distinct cuisine
> string as stored; splitting it into individual cuisines would require
> an additional normalization step.
Repository Files
`Zomato_Data_Analyst_SQL_Project.sql` --- database/table setup and
analysis queries
`README.md` --- project documentation
Getting Started
1. Requirements
Install MySQL Server and MySQL Workbench. Make sure your MySQL server is
running and that you can connect to it.
2. Create the database
Open MySQL Workbench, connect to your server, and run:
``` sql
CREATE DATABASE IF NOT EXISTS zomato_db;
USE zomato_db;
```
3. Import the CSV
In MySQL Workbench:
In the Schemas panel, refresh the schemas if needed.
Right-click `zomato_db`.
Choose Table Data Import Wizard.
Select your Zomato CSV file.
Import it into a table named `restaurants`.
Check the column mapping and data types before completing the
import.
Important: If you use the SQL file's table-creation section, create
the table first and import the CSV into the existing `restaurants` table
if the wizard offers that option. Otherwise, let the wizard create the
table and skip the `DROP TABLE` / `CREATE TABLE` section in the SQL
script. Do not run `DROP TABLE` after importing, because it deletes the
imported table and its data.
4. Run the analysis
Open `Zomato_Data_Analyst_SQL_Project.sql` in MySQL Workbench. Run the
queries section by section, checking the results and recording the
useful findings.
Some queries use CTEs and window functions, so use MySQL 8.0 or
later.
Analysis Sections
Data exploration --- row counts, distinct cities/countries,
rating and cost summaries
Data quality --- missing values, duplicate IDs, invalid ratings
and price ranges
City analysis --- restaurant counts, average ratings, and
average cost by city
Rating analysis --- rating distribution and rating-based
segments
Price analysis --- restaurant counts and ratings by price range
Delivery & booking --- service availability and rating
comparisons
Customer engagement --- votes and highly rated restaurants
Cuisine analysis --- common cuisine entries and average ratings
Business segmentation --- performance and price segments using
`CASE`
Advanced SQL --- subqueries, CTEs, `RANK()`, and window
calculations
KPI queries --- summary metrics for a potential dashboard
Example Business Questions
---
Business question                   SQL approach
---
Which cities have the most          `GROUP BY`, `COUNT()`, `ORDER BY`
restaurants?
Which cities have high average      `AVG()`, `HAVING`
ratings?
How do ratings vary by price range? `GROUP BY`, `AVG()`
What percentage offer online        Aggregation and percentage
delivery?                           calculation
What are the top 3 restaurants in   `RANK()` with `PARTITION BY`
each city?
Which restaurants are rated above   Subquery
the overall average?
Which cities perform above the      CTE
overall average rating?
Deliverables
For a strong portfolio presentation, add:
The SQL script
Screenshots of selected query results from MySQL Workbench
A short summary of 5--10 findings supported by the query outputs
Optional: a Power BI or Tableau dashboard built from the analyzed
data
Suggested Business Insights Template
After running the queries, document findings in this format:
Finding: What did the query show?
Evidence: Include the relevant metric or result.
Business implication: Why does it matter?
Recommendation: What action could a restaurant or marketplace
team consider?
Avoid writing conclusions before checking the actual query results. The
results depend on the exact CSV version and the data imported.
Resume Description
Zomato Restaurant Marketplace Analytics | MySQL
Analyzed restaurant ratings, pricing, cuisine entries, city-level
distribution, and service availability using MySQL. Performed data
quality checks and applied aggregations, conditional logic, subqueries,
CTEs, and window functions to derive business insights and marketplace
KPIs.
Notes
Check the imported column names and data types before running the
script.
CSV values such as `Yes`/`No`, blank strings, and `NULL` may need
standardization.
Restaurant IDs may not be unique in every version of the dataset;
investigate duplicates before treating them as errors.
Average cost values may be in different currencies across countries.
Do not compare costs across currencies without converting them to a
common currency.
