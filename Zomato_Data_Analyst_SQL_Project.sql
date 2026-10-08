-- ============================================================
-- ZOMATO RESTAURANT MARKETPLACE ANALYTICS
-- Data Analyst SQL Portfolio Project
-- Database: MySQL
-- Tool: MySQL Workbench
-- ============================================================

-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS zomato_db;
USE zomato_db;

-- ============================================================
-- 2. TABLE SETUP
-- IMPORTANT:
-- Import the CSV using MySQL Workbench's
-- "Table Data Import Wizard" into this table.
-- ============================================================

DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
    restaurant_id INT,
    restaurant_name VARCHAR(255),
    country_code INT,
    city VARCHAR(100),
    address VARCHAR(500),
    locality VARCHAR(200),
    locality_verbose VARCHAR(300),
    longitude DECIMAL(10,6),
    latitude DECIMAL(10,6),
    cuisines VARCHAR(500),
    average_cost_for_two DECIMAL(12,2),
    currency VARCHAR(100),
    has_table_booking VARCHAR(20),
    has_online_delivery VARCHAR(20),
    is_delivering_now VARCHAR(20),
    switch_to_order_menu VARCHAR(20),
    price_range INT,
    aggregate_rating DECIMAL(3,2),
    rating_color VARCHAR(50),
    rating_text VARCHAR(50),
    votes INT
);

-- ============================================================
-- 3. BASIC DATA EXPLORATION
-- ============================================================

-- View sample records
SELECT *
FROM restaurants
LIMIT 10;

-- Total restaurants
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- Total cities
SELECT COUNT(DISTINCT city) AS total_cities
FROM restaurants;

-- Total countries
SELECT COUNT(DISTINCT country_code) AS total_countries
FROM restaurants;

-- Total cuisines entries
SELECT COUNT(DISTINCT cuisines) AS distinct_cuisine_entries
FROM restaurants;

-- Minimum, maximum and average rating
SELECT
    MIN(aggregate_rating) AS minimum_rating,
    MAX(aggregate_rating) AS maximum_rating,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants;

-- Minimum, maximum and average cost
SELECT
    MIN(average_cost_for_two) AS minimum_cost,
    MAX(average_cost_for_two) AS maximum_cost,
    ROUND(AVG(average_cost_for_two), 2) AS average_cost
FROM restaurants;

-- ============================================================
-- 4. DATA QUALITY CHECKS
-- ============================================================

-- Missing restaurant names
SELECT COUNT(*) AS missing_restaurant_names
FROM restaurants
WHERE restaurant_name IS NULL
   OR TRIM(restaurant_name) = '';

-- Missing cities
SELECT COUNT(*) AS missing_cities
FROM restaurants
WHERE city IS NULL
   OR TRIM(city) = '';

-- Missing ratings
SELECT COUNT(*) AS missing_ratings
FROM restaurants
WHERE aggregate_rating IS NULL;

-- Missing cuisines
SELECT COUNT(*) AS missing_cuisines
FROM restaurants
WHERE cuisines IS NULL
   OR TRIM(cuisines) = '';

-- Duplicate restaurant IDs
SELECT
    restaurant_id,
    COUNT(*) AS duplicate_count
FROM restaurants
GROUP BY restaurant_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Check invalid ratings
SELECT *
FROM restaurants
WHERE aggregate_rating < 0
   OR aggregate_rating > 5;

-- Check invalid price ranges
SELECT *
FROM restaurants
WHERE price_range NOT BETWEEN 1 AND 4;

-- ============================================================
-- 5. CITY ANALYSIS
-- ============================================================

-- Number of restaurants by city
SELECT
    city,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY city
ORDER BY restaurant_count DESC;

-- Top 10 cities by restaurant count
SELECT
    city,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 10;

-- Average rating by city
SELECT
    city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC;

-- Top 10 cities by average rating
SELECT
    city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC
LIMIT 10;

-- Average cost by city
SELECT
    city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(average_cost_for_two), 2) AS average_cost_for_two
FROM restaurants
GROUP BY city
ORDER BY average_cost_for_two DESC;

-- ============================================================
-- 6. RATING ANALYSIS
-- ============================================================

-- Rating distribution
SELECT
    aggregate_rating,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY aggregate_rating
ORDER BY aggregate_rating DESC;

-- Rating text distribution
SELECT
    rating_text,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY rating_text
ORDER BY restaurant_count DESC;

-- Rating category using CASE
SELECT
    CASE
        WHEN aggregate_rating >= 4.5 THEN 'Excellent'
        WHEN aggregate_rating >= 4.0 THEN 'Very Good'
        WHEN aggregate_rating >= 3.0 THEN 'Good'
        WHEN aggregate_rating >= 2.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY rating_category
ORDER BY restaurant_count DESC;

-- Highly rated restaurants
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes
FROM restaurants
WHERE aggregate_rating >= 4.5
ORDER BY aggregate_rating DESC, votes DESC;

-- Highly rated restaurants with strong vote counts
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes
FROM restaurants
WHERE aggregate_rating >= 4.5
  AND votes >= 100
ORDER BY aggregate_rating DESC, votes DESC;

-- ============================================================
-- 7. PRICE ANALYSIS
-- ============================================================

-- Restaurant count by price range
SELECT
    price_range,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY price_range
ORDER BY price_range;

-- Average rating by price range
SELECT
    price_range,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY price_range
ORDER BY price_range;

-- Average cost by price range
SELECT
    price_range,
    ROUND(AVG(average_cost_for_two), 2) AS average_cost_for_two
FROM restaurants
GROUP BY price_range
ORDER BY price_range;

-- Most expensive restaurants
SELECT
    restaurant_name,
    city,
    average_cost_for_two,
    currency,
    aggregate_rating
FROM restaurants
ORDER BY average_cost_for_two DESC
LIMIT 20;

-- ============================================================
-- 8. DELIVERY & BOOKING ANALYSIS
-- ============================================================

-- Online delivery availability
SELECT
    has_online_delivery,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY has_online_delivery;

-- Average rating: online delivery vs no online delivery
SELECT
    has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY has_online_delivery;

-- Table booking availability
SELECT
    has_table_booking,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY has_table_booking;

-- Average rating: table booking vs no table booking
SELECT
    has_table_booking,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY has_table_booking;

-- Delivery + booking combination
SELECT
    has_table_booking,
    has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
GROUP BY has_table_booking, has_online_delivery
ORDER BY restaurant_count DESC;

-- ============================================================
-- 9. CUSTOMER ENGAGEMENT / VOTES ANALYSIS
-- ============================================================

-- Top restaurants by votes
SELECT
    restaurant_name,
    city,
    votes,
    aggregate_rating
FROM restaurants
ORDER BY votes DESC
LIMIT 20;

-- Average votes by rating
SELECT
    aggregate_rating,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(votes), 0) AS average_votes
FROM restaurants
GROUP BY aggregate_rating
ORDER BY aggregate_rating DESC;

-- High rating + high engagement
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes
FROM restaurants
WHERE aggregate_rating >= 4
  AND votes >= 500
ORDER BY votes DESC;

-- ============================================================
-- 10. CUISINE ANALYSIS
-- ============================================================

-- Most common cuisine entries
SELECT
    cuisines,
    COUNT(*) AS restaurant_count
FROM restaurants
WHERE cuisines IS NOT NULL
  AND TRIM(cuisines) <> ''
GROUP BY cuisines
ORDER BY restaurant_count DESC
LIMIT 20;

-- Cuisine entries with best average rating
SELECT
    cuisines,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants
WHERE cuisines IS NOT NULL
  AND TRIM(cuisines) <> ''
GROUP BY cuisines
HAVING COUNT(*) >= 5
ORDER BY average_rating DESC
LIMIT 20;

-- ============================================================
-- 11. BUSINESS SEGMENTATION
-- ============================================================

-- Segment restaurants by rating
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    CASE
        WHEN aggregate_rating >= 4.5 THEN 'Premium Performer'
        WHEN aggregate_rating >= 4.0 THEN 'Strong Performer'
        WHEN aggregate_rating >= 3.0 THEN 'Average Performer'
        WHEN aggregate_rating >= 2.0 THEN 'Needs Improvement'
        ELSE 'Poor Performer'
    END AS performance_segment
FROM restaurants
ORDER BY aggregate_rating DESC;

-- Segment by price
SELECT
    restaurant_name,
    city,
    price_range,
    average_cost_for_two,
    CASE
        WHEN price_range = 1 THEN 'Budget'
        WHEN price_range = 2 THEN 'Mid-Range'
        WHEN price_range = 3 THEN 'Expensive'
        WHEN price_range = 4 THEN 'Premium'
        ELSE 'Unknown'
    END AS price_segment
FROM restaurants;

-- ============================================================
-- 12. SUBQUERY ANALYSIS
-- ============================================================

-- Restaurants rated above the overall average
SELECT
    restaurant_name,
    city,
    aggregate_rating
FROM restaurants
WHERE aggregate_rating >
      (SELECT AVG(aggregate_rating)
       FROM restaurants)
ORDER BY aggregate_rating DESC;

-- Restaurants with above-average votes
SELECT
    restaurant_name,
    city,
    votes
FROM restaurants
WHERE votes >
      (SELECT AVG(votes)
       FROM restaurants)
ORDER BY votes DESC;

-- Restaurants costing more than the average cost
SELECT
    restaurant_name,
    city,
    average_cost_for_two
FROM restaurants
WHERE average_cost_for_two >
      (SELECT AVG(average_cost_for_two)
       FROM restaurants)
ORDER BY average_cost_for_two DESC;

-- ============================================================
-- 13. CTE ANALYSIS
-- ============================================================

-- City performance using a CTE
WITH city_stats AS (
    SELECT
        city,
        COUNT(*) AS restaurant_count,
        ROUND(AVG(aggregate_rating), 2) AS average_rating,
        ROUND(AVG(average_cost_for_two), 2) AS average_cost
    FROM restaurants
    GROUP BY city
)
SELECT *
FROM city_stats
WHERE restaurant_count >= 10
ORDER BY average_rating DESC;

-- Find cities performing above the overall average rating
WITH city_stats AS (
    SELECT
        city,
        COUNT(*) AS restaurant_count,
        AVG(aggregate_rating) AS average_rating
    FROM restaurants
    GROUP BY city
),
overall_stats AS (
    SELECT AVG(aggregate_rating) AS overall_average_rating
    FROM restaurants
)
SELECT
    c.city,
    c.restaurant_count,
    ROUND(c.average_rating, 2) AS average_rating
FROM city_stats c
CROSS JOIN overall_stats o
WHERE c.average_rating > o.overall_average_rating
  AND c.restaurant_count >= 10
ORDER BY c.average_rating DESC;

-- ============================================================
-- 14. WINDOW FUNCTIONS
-- ============================================================

-- Rank restaurants by rating
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes,
    RANK() OVER (
        ORDER BY aggregate_rating DESC, votes DESC
    ) AS overall_rank
FROM restaurants;

-- Rank restaurants within each city
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes,
    RANK() OVER (
        PARTITION BY city
        ORDER BY aggregate_rating DESC, votes DESC
    ) AS city_rank
FROM restaurants;

-- Top 3 restaurants in each city
WITH ranked_restaurants AS (
    SELECT
        restaurant_name,
        city,
        aggregate_rating,
        votes,
        RANK() OVER (
            PARTITION BY city
            ORDER BY aggregate_rating DESC, votes DESC
        ) AS city_rank
    FROM restaurants
)
SELECT *
FROM ranked_restaurants
WHERE city_rank <= 3
ORDER BY city, city_rank;

-- City restaurant share of total restaurants
WITH city_counts AS (
    SELECT
        city,
        COUNT(*) AS restaurant_count
    FROM restaurants
    GROUP BY city
)
SELECT
    city,
    restaurant_count,
    ROUND(
        restaurant_count * 100.0 /
        SUM(restaurant_count) OVER (),
        2
    ) AS percentage_of_total
FROM city_counts
ORDER BY percentage_of_total DESC;

-- ============================================================
-- 15. FINAL BUSINESS DASHBOARD QUERIES
-- ============================================================

-- KPI 1: Total restaurants
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- KPI 2: Total cities
SELECT COUNT(DISTINCT city) AS total_cities
FROM restaurants;

-- KPI 3: Average rating
SELECT ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM restaurants;

-- KPI 4: Average cost
SELECT ROUND(AVG(average_cost_for_two), 2) AS average_cost_for_two
FROM restaurants;

-- KPI 5: Total votes
SELECT SUM(votes) AS total_votes
FROM restaurants;

-- KPI 6: Top 10 cities
SELECT
    city,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 10;

-- KPI 7: Rating categories
SELECT
    CASE
        WHEN aggregate_rating >= 4.5 THEN 'Excellent'
        WHEN aggregate_rating >= 4.0 THEN 'Very Good'
        WHEN aggregate_rating >= 3.0 THEN 'Good'
        WHEN aggregate_rating >= 2.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY rating_category
ORDER BY restaurant_count DESC;

-- KPI 8: Delivery availability
SELECT
    has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM restaurants),
        2
    ) AS percentage_of_restaurants
FROM restaurants
GROUP BY has_online_delivery;

-- ============================================================
-- 16. PORTFOLIO INSIGHTS TO REPORT
-- ============================================================

-- Use the query results to write findings such as:
--
-- 1. Which city has the largest restaurant market?
-- 2. Which cities have the strongest average ratings?
-- 3. Does price range influence average rating?
-- 4. Is online delivery associated with higher ratings?
-- 5. Which restaurants have both high ratings and high votes?
-- 6. Which cuisines are most common?
-- 7. Which cities have the highest average restaurant cost?
-- 8. What percentage of restaurants offer online delivery?
-- 9. Which restaurants rank in the top 3 within their city?
-- 10. What recommendations can be made to restaurant/platform managers?

-- ============================================================
-- END OF PROJECT
-- ============================================================
