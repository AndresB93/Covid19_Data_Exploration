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

