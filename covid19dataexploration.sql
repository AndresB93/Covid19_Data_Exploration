/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null 
ORDER BY 3,4

 -- Select first data that we are going to use 

SELECT location, date, total_cases, new_cases, total_deaths, population,
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows death rate of each location.(My case Colombia)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE location='Colombia' and continent is not null
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows infection rate of the total population in Colombia

SELECT location, date, Population, total_cases, (total_cases/Population)*100 as Infection_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE location='Colombia' and continent is not null
ORDER BY Infection_Rate desc

-- Looking at Countries with highest infection rate compared to population


SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as HighestInfection_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY Location, population
ORDER BY HighestInfection_Rate desc

-- Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null 
ORDER BY 3,4

 -- Select first data that we are going to use 

SELECT location, date, total_cases, new_cases, total_deaths, population,
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows death rate of each location.(My case Colombia)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE location='Colombia' and continent is not null
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows infection rate of the total population in Colombia

SELECT location, date, Population, total_cases, (total_cases/Population)*100 as Infection_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE location='Colombia' and continent is not null
ORDER BY Infection_Rate desc

-- Looking at Countries with highest infection rate compared to population


SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as HighestInfection_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY Location, population
ORDER BY HighestInfection_Rate desc

-- Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


-- CONTINENT RESULTS

-- Showing continents with highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- GLOBAL RESULTS without dates

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Death_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--GLOBAL RESULT with a date (Total)

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Death_Rate
FROM `covid19-374023.Covid19.covid_deaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- JOINING TABLES, Exploring the Vaccination data

SELECT * 
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
    ON dea.location = vac.location
    AND dea.date = vac.date



-- Total Population vs Vaccinations 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null 
    AND vac.new_vaccinations is not null
ORDER BY 2,3

--Total Vaccinations adding up each day 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as ACUM
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null 
    AND vac.new_vaccinations is not null
ORDER BY 2,3

-- MIX of Total Vaccination vs Population using CTE

With PopvsVac
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as INT)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ACUM
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
AND vac.new_vaccinations is not null
)
Select *,(ACUM/Population)*100 as MIX 
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM `covid19-374023.Covid19.covid_deaths` dea
  JOIN `covid19-374023.Covid19.covid_vaccinations`vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
