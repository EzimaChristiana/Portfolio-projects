# COVID-19 Data Analysis SQL Queries

## Overview
This repository contains SQL queries used to analyze COVID-19 data, focusing on cases, deaths, and vaccinations across different regions, especially Africa. The queries explore various metrics such as case rates, death percentages, vaccination rates, and infection comparisons between countries.

## Data Source
The SQL queries are run on the Coviddeaths table from the PORTFOLIOPROJECT01 database. The table includes information on:
- location: Country or region.
- date: Date of the data record.
- total_cases: Cumulative number of confirmed COVID-19 cases.
- new_cases: Number of new confirmed cases.
- total_deaths: Cumulative number of confirmed deaths due to COVID-19.
- population: Population of the location.

## Key Queries

### 1. Global Metrics
- Total Cases vs Total Deaths Globally: 
   sql
   SELECT total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0)) * 100 AS DeathPercentage
   FROM PORTFOLIOPROJECT01..Coviddeaths
   ORDER BY 1, 2;
   
   This query calculates the percentage of deaths relative to total cases globally.

### 2. Africa-Specific Analysis
- Total Cases vs Total Deaths in Africa: 
   sql
   SELECT SUM(total_cases) AS Total_cases, 
          (SUM(total_deaths) / SUM(total_cases)) * 100 AS DeathPercentage 
   FROM PORTFOLIOPROJECT01..Coviddeaths 
   WHERE location = 'Africa';
   
   This query calculates the death percentage for Africa based on the total number of cases.

- Total Cases vs Population in Africa: 
   sql
   SELECT SUM(total_cases) AS Total_cases, 
          SUM(population) AS Total_population, 
          (SUM(total_cases) / SUM(population)) * 100 AS CasePercentage 
   FROM PORTFOLIOPROJECT01..Coviddeaths 
   WHERE continent = 'Africa';
   
   It calculates the percentage of COVID-19 cases compared to the population in Africa.

### 3. Mortality Rates
- Mortality Rate in Africa: 
   sql
   SELECT location, MAX(total_deaths) AS TotalDeathCount 
   FROM PORTFOLIOPROJECT01..Coviddeaths 
   WHERE continent = 'Africa' 
   GROUP BY location 
   ORDER BY TotalDeathCount DESC;
   
   This query identifies the countries in Africa with the highest number of deaths due to COVID-19.

### 4. Vaccination Analysis
- Total Vaccination by Population:
   sql
   SELECT location, date, SUM(total_vaccinations) AS TotalVaccinationsPerDay 
   FROM PORTFOLIOPROJECT01..Covidvaccination 
   WHERE continent = 'Africa' 
   GROUP BY location, date 
   ORDER BY date;
   
   It shows daily vaccinations in Africa.

- New Vaccination per Day: 
   sql
   WITH DailyVaccinations AS (
       SELECT date, SUM(CAST(total_vaccinations AS INT)) AS TotalVaccinationsPerDay 
       FROM PORTFOLIOPROJECT01..Covidvaccination 
       GROUP BY date
   )
   SELECT date, TotalVaccinationsPerDay - COALESCE(LAG(TotalVaccinationsPerDay) OVER (ORDER BY date), 0) AS NewVaccinationPerDay 
   FROM DailyVaccinations;
   
   This query calculates the number of new vaccinations administered per day.

## Conclusion
These queries provide valuable insights into the impact of COVID-19 globally and specifically in Africa, including infection rates, mortality rates, and vaccination efforts. The data can help in tracking the pandemic's progression and the effectiveness of vaccination campaigns.

## Future Work
- Further analysis can be done by including additional regions and comparing vaccination progress worldwide.
- Visualizing the results using tools like Power BI or Tableau can provide a clearer understanding of trends over time.
