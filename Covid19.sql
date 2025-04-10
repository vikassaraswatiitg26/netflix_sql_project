
create table Covid_death
(
iso_code varchar(50),
continent varchar(100),	
location1 varchar(100),
date varchar(100),
population decimal,	
total_cases decimal,
new_cases decimal,
new_cases_smoothed DECIMAL,	
total_deaths decimal,
new_deaths decimal,
new_deaths_smoothed DECIMAL,
total_cases_per_million DECIMAL,	
new_cases_per_million DECIMAL,	
new_cases_smoothed_per_million DECIMAL,
total_deaths_per_million DECIMAL,	
new_deaths_per_million DECIMAL,	
new_deaths_smoothed_per_million DECIMAL,	
reproduction_rate DECIMAL,	
icu_patients decimal,	
icu_patients_per_million DECIMAL,	
hosp_patients decimal,	
hosp_patients_per_million DECIMAL,	
weekly_icu_admissions decimal,	
weekly_icu_admissions_per_million DECIMAL,	
weekly_hosp_admissions decimal,	
weekly_hosp_admissions_per_million DECIMAL
)

select * from Covid_death;

create table Covid_Vaccination
(
iso_code varchar(50),
continent varchar(100) ,
location1 varchar(100),	
date varchar(100),
new_tests int,	
total_tests int,	
total_tests_per_thousand decimal,	
new_tests_per_thousand decimal,
new_tests_smoothed int,	
new_tests_smoothed_per_thousand decimal,	
positive_rate decimal,	
tests_per_case decimal,	
tests_units  varchar(100),
total_vaccinations int,	
people_vaccinated int,
people_fully_vaccinated int,
new_vaccinations int,
new_vaccinations_smoothed  int,	
total_vaccinations_per_hundred decimal,
people_vaccinated_per_hundred decimal,	
people_fully_vaccinated_per_hundred decimal,	
new_vaccinations_smoothed_per_million decimal,	
stringency_index decimal,	
population_density decimal,	
median_age decimal,	
aged_65_older decimal,	
aged_70_older decimal,	
gdp_per_capita decimal,	
extreme_poverty decimal,
cardiovasc_death_rate decimal,	
diabetes_prevalence decimal,	
female_smokers decimal,	
male_smokers decimal,	
handwashing_facilities decimal,	
hospital_beds_per_thousand decimal,
life_expectancy decimal,	
human_development_index decimal
);

select * from Covid_Vaccination;

select
    *
from Covid_Death
where continent is not null
order by 3,4;

select
    *
from Covid_Vaccination
where continent is not null
order by 3,4;

select
    location1,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
from Covid_Death
where 
     continent is not null
	 and
	 total_cases is not null
     order by 1,2;

--looking at Total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select
    location1,
	date,
	total_cases,
	total_deaths,
	round((total_deaths/total_cases)*100,2)as Death_Percentage
from Covid_Death
where location1 like '%India%'
      and
	  continent is not null
	  and
	  total_cases is not null
      order by 1,2;


-- Looking at Total Cases vs Population 
-- Shows what percentage of population got Covid

select
    location1,
	date,
	total_cases,
	population,
	round((total_cases/population)*100,2)as Percent_Population_Infected
from Covid_Death
where 
       continent is not null
	   and
	   total_cases is not null
       order by 1,2;

-- Looking at countries with Highest Infection rate compared to population  

select
    location1,
	population,
	MAX(total_cases) as Highest_Infection_Count,
	MAX(round((total_cases/population)*100,2))as  Percent_Population_Infected
from Covid_Death
where 
      continent is not null
	  and
	  total_cases is not null
      group by location1,population
      order by 4 desc;


--Showing countries with Highest Death Count per Population

select
    location1,
	max(cast(Total_deaths as int)) as Total_death_Count
from Covid_Death
where 
      continent is not null
      and
	  Total_deaths is not null
      group by location1
      order by Total_death_Count desc ;

-- Lets's Break things down by continents

-- Showing contintents with the highest death count per population

select
    location1,
	max(cast(Total_deaths as int)) as Total_death_Count
from Covid_Death
where 
      continent is null
      and
	  Total_deaths is not null
      group by location1
      order by Total_death_Count desc ;

--GLOBAL NUMBERS 

select 
	  sum(new_cases) as total_cases,
	  sum(cast(new_deaths as int)) as total_deaths,
	 round((sum(cast(new_deaths as int))/sum(new_cases))*100,2)as death_percentage
	 
from  Covid_Death
where 
      continent is not null
	  --group by date
	  order by 1,2

--Loking at Total Population vs Vaccination

select 
    cd.continent,
	cd.location1,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over(partition by  cd.location1 order by cd.location1,cd.date) as rolling_people_vaccinated,
--  (rolling_people_vaccinated/cd.population)*100
from Covid_death cd
join Covid_vaccination cv
     on 
	 cd.location1=cv.location1 and
	 cd.date=cv.date
where 
     cd.continent is not null
	 order by 2,3;

--USE CTE

with pop_vs_vacc
 as 
( 
select 
    cd.continent,
	cd.location1,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over(partition by  cd.location1 order by cd.location1,cd.date) as rolling_people_vaccinated

from Covid_death cd
join Covid_vaccination cv
     on 
	 cd.location1=cv.location1 and
	 cd.date=cv.date
where 
     cd.continent is not null
--order by 2,3
)
select
*,
     round((rolling_people_vaccinated/population)*100,3)
from pop_vs_vacc;


--   Temp TABLE   

Create Table percentage_population_vaccinated
(
Continent varchar(255),
Location1 varchar(225),
Date date,
Population numeric,
New_vaccinations numeric,
rolling_people_vaccinated numeric
)

insert into percentage_population_vaccinated
(
select 
    cd.continent,
	cd.location1,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over(partition by  cd.location1 order by cd.location1,cd.date) as rolling_people_vaccinated

from Covid_death cd
join Covid_vaccination cv
     on 
	 cd.location1=cv.location1 and
	 cd.date=cv.date
where 
     cd.continent is not null
--order by 2,3
)
select
*,
     round((rolling_people_vaccinated/population)*100,3)
from percentage_population_vaccinated;


-- Creating View to Store data for later visualizations

create view pop_vs_vacc as 

select 
    cd.continent,
	cd.location1,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	sum(cv.new_vaccinations) over(partition by  cd.location1 order by cd.location1,cd.date) as rolling_people_vaccinated

from Covid_death cd
join Covid_vaccination cv
     on 
	 cd.location1=cv.location1 and
	 cd.date=cv.date
where 
     cd.continent is not null;
--order by 2,3


-- 
select * from pop_vs_vacc

