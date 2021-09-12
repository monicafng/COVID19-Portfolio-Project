/*

Covid-19 Data Exploration

*/

SELECT * FROM covid;

-- Select data to start working with
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid
ORDER BY 1, 2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country
SELECT location, date, total_cases, total_deaths, 
	   (total_deaths/total_cases)*100 AS death_percentage
FROM covid;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT location, date, population, total_cases, 
	   (total_cases/population)*100 AS percent_population_infected
FROM covid 
ORDER BY 1, 2;

-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS highest_infection_count, 
	   MAX((total_cases/population))*100 AS percent_population_infected
FROM covid
GROUP BY 1, 2
ORDER BY percent_population_infected DESC;

-- Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- BREAKING DOWN BY CONTINENT

-- Showing continents with the highest death count per population
SELECT continent, MAX(total_deaths) AS total_death_count
FROM covid 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
	   SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid
ORDER BY 1, 2;

-- Total population vs Vaccinations
-- Shows percentage of population that has received at least one Covid Vaccine
SELECT continent, location, date, population, new_vaccinations,
	   SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS rolling_people_vaccinated
FROM covid
ORDER BY 2, 3;

-- Using CTE to perform calculation on partition by in previous query
WITH PopvsVac 
-- (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT continent, location, date, population, new_vaccinations,
	   SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS rolling_people_vaccinated
FROM covid
)
SELECT *, (rolling_people_vaccinated/population)*100
FROM PopvsVac;

-- Using temp table to perform calculation on partition by in previous query
DROP TABLE IF EXISTS percent_population_vaccinated;

CREATE TABLE percent_population_vaccinated
(
Continent VARCHAR(200),
Location VARCHAR(200),
Date DATETIME,
Population NUMERIC,
New_Vaccinations CHAR(20),
Rolling_People_Vaccinated NUMERIC
);

INSERT INTO percent_population_vaccinated
SELECT continent, location, date, population, new_vaccinations,
	   SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS rolling_people_vaccinated
FROM covid;
    
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM percent_population_vaccinated;

-- Creating view to store data for late visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT continent, location, date, population, new_vaccinations,
	   SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS rolling_people_vaccinated
FROM covid;
