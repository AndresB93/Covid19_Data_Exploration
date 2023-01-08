/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From `covid19-374023.Covid19.covid_deaths`
Where continent is not null 
order by 3,4