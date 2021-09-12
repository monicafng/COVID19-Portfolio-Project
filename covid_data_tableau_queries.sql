/*

Queries used for Tableau Project

*/

-- 1. Global Numbers
SELECT SUM(new_cases) AS total_cases,
	   SUM(new_deaths) AS total_deaths,
       SUM(new_deaths)/SUM(new_cases) AS death_percentage
FROM covid;

-- 2. Total Deaths per Continent
SELECT continent, SUM(new_deaths) AS total_death_count
FROM covid
GROUP BY continent
ORDER BY total_death_count DESC;

-- 3. Percent Population Infected by Country
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM covid
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- 4. Percent Population Infected
SELECT location, population, date, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM covid 
GROUP BY location, population, date;






