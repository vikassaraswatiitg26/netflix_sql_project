#  Netflix Movies and TV shows Data analysis using SQL
![Netflix Logo](https://github.com/vikassaraswatiitg26/netflix_sql_project/blob/main/BrandAssets_Logos_01-Wordmark.jpg)


# 🎬 Netflix Content Analysis using SQL

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

