#  Netflix Movies and TV shows Data analysis using SQL
![Netflix Logo](https://github.com/vikassaraswatiitg26/netflix_sql_project/blob/main/BrandAssets_Logos_01-Wordmark.jpg)


This project explores and analyzes a dataset of Netflix content using SQL. It covers the breakdown of movies and TV shows, most common content ratings, longest films, popular genres, and more. The goal is to gain insights into Netflix’s global content library.

---

## 📌 Objectives

· Perform exploratory data analysis on Netflix content  
· Use SQL queries to extract insights from the dataset  
· Identify content trends like rating frequency, popular countries, genre-wise content, etc.  
· Filter and format data using built-in PostgreSQL functions  

---

## 🧰 Tools & Technologies

· PostgreSQL  
· Window Functions  
· Common Table Expressions (CTEs)  
· String Manipulation  
· Date Formatting & Filtering  

---

## 🗂️ Table Structure

```sql
CREATE TABLE netflix (
  show_id        VARCHAR(10),
  type           VARCHAR(10),
  title          VARCHAR(150),
  director       VARCHAR(250),
  casts          VARCHAR(1000),
  country        VARCHAR(150),
  date_added     VARCHAR(100),
  release_year   INT,
  rating         VARCHAR(10),
  duration       VARCHAR(15),
  listed_in      VARCHAR(250),
  description    VARCHAR(250)
);
```

# 🔍 Key Insights & SQL Queries
1.  Count of Movies vs TV Shows
```
  SELECT
    type,
    COUNT(*) AS total_count
FROM netflix
GROUP BY type;
```
  
2.  Most Common Rating by Type

```
SELECT 
   type,
   rating
FROM (
  SELECT 
    type,
    rating,
    COUNT(*) AS total_count,
    RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking 
  FROM netflix
  GROUP BY type, rating
) AS t1 
WHERE ranking = 1;

```

3.  Movies Released in a Specific Year (2020)

```
SELECT * 
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

```

4.  Top 5 Countries with Most Content

```
SELECT 
   UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
   COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;

```

5.  Longest Movie on Netflix

```
SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND duration = (
    SELECT MAX(duration) 
    FROM netflix
  );

```

6.  Content Added in the Last 5 Years

```
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

```

7.  Shows by Director 'Rajiv Chilaka'

```
SELECT 
    type,
    title
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';

```

8.  TV Shows with More than 5 Seasons

```
SELECT 
    type,
    title,
    duration
FROM netflix 
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;

```

9.  Genre-wise Content Count

```
SELECT 
    listed_in,
    COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;

```

 ## 🧼 Data Enhancements
 
· Split multi-country fields into separate rows

· Parsed dates from text to proper SQL date format

· Converted duration fields for comparison

· Used ranking and filtering for most common ratings


 ## 📈 Future Scope
 
· Build dashboards in Power BI or Tableau

· Add year-on-year trend analysis

· Sentiment analysis on descriptions using NLP

