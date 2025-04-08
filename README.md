#  Netflix Movies and TV shows Data analysis using SQL
![Netflix Logo](https://github.com/vikassaraswatiitg26/netflix_sql_project/blob/main/BrandAssets_Logos_01-Wordmark.jpg)
## objective
-- netflix Project 
drop table netflix;
create table netflix
(
  show_id	varchar(10),
  type	varchar(10),
  title	varchar(150),
  director varchar(250),
  casts	varchar(1000),
  country	varchar(150),
  date_added	varchar(100),
  release_year	int,
  rating	varchar(10),
  duration   	varchar(15),
  listed_in	    varchar(250),
  description   varchar(250)

)

select * from netflix;

select 
      count(*) as total_content
from netflix;


select 
      Distinct type 
from netflix;


-- 1. Count the number of movies vs tv shows 


select
    type,
	count(*) as total_count
from netflix
group by type ;

-- Find the most common rating for movies and TV shows 

select 
   type,
   rating
 from

(
  select 
    type,
    rating,
    count(*) as total_count,
    rank() over(partition by type order by count(*) desc) as ranking 
  from netflix
  group by type,rating 
) as t1 
where 
  ranking =1;

-- 3. List all the movies released in a specific year (eg : 2020)


select * from netflix
where 
      type ='Movie'
	  and 
	  release_year=2020;


--4. Find the top 5 countries with the most content on Netflix 

select 
   unnest( string_to_array(country,',' ))as new_country,
  count(show_id) as total_content
from netflix
group by new_country
order by total_content desc
limit 5;


--5.  Identify the longest movie ?


select * from netflix
where 
      type='Movie'
	  and
	  duration =(select max(duration) from netflix)

-- 6. Find content added in the last 5 years?

select 
         *
from netflix
where 
       TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE-INTERVAL '5 years';


--7. Find all the movies/TV shoes by director 'rajiv chilaka'?


select 
    type,
	title
from netflix 
where
      director like '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons ?

select 
     type,
	 title,
	 duration
from netflix 
where 
       type='TV Show'
	   and
       split_part(duration,' ',1):: numeric > 5;
	 
-- 9. Count the number of content items in each genre

select 
	UNNEST(STRING_TO_ARRAY(listed_in , ',')) as genre,
	count(show_id) as total_content
from netflix
group by genre;

--10. Find each year and the average number of content release by India on netflix, 
return top 5 year with highest avg content release?

select 
     Extract(year from to_date(date_added,'month DD,YYYY')) as year,
	 count(*),
	 round(count(*)::numeric/(select count(*) from netflix where country ='India') *100 ,2)as avg_content_per_year
from netflix
 where country ='India'
group by year
order by 2 desc
limit 5;
 
11. list all movies that are documentaries

select
* 
from netflix
 where 
 listed_in like '%Documentaries%';

12. Find all content without a director

select 
    *
from netflix
where director is null 


13. Find how many movies actor 'Salman Khan' appered in last 10 year?


select 
     *
from netflix
 where 
       
	   casts like '%Salman Khan%'
	   and
	release_year>extract(year from current_date)-10;


--14 . Find the top 10 actors who have appered in the highest number of movies produced in India?

select

  unnest(string_to_array(casts, ',')) as actor_name,
  count(*)
from netflix 
where 
      type= 'Movie'
	  and
      country = 'India'
	  group by actor_name 
	  order by count desc
	  limit 10;

--15. Categorize the content based on the presence of the keywords 'kill' and 'voilence' in 
     the description field. label content containing these keyword as 'Bad' and all other 
	 content as 'Good'. Count how many items fall into each category. 
with new_table
 as 
(
select
   *,
	case
	     when 
		       description like '%kill%'   or 
		       description like '%violence%' then 'BAD'
	     
    else 'GOOD'
	end as label 	
from netflix
)
 select 
     label,
	 count(*) as total_content
from new_table 
group by 1
