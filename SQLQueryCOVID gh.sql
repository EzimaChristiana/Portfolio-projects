
SELECT*
FROM PORTFOLIOPROJECTO1..Coviddeaths
ORDER BY 3,4

SELECT*
FROM PORTFOLIOPROJECTO1..Covidvaccination
ORDER BY 3,4

--CREATE NEW TABLE
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PORTFOLIOPROJECTO1..Coviddeaths
ORDER BY 1,2

--TOTALCASES VS TOTALDEATHS GLOBALLY
SELECT location,date,total_cases,total_deaths,(total_deaths/NULLIF(total_cases,0))*100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
ORDER BY 1,2

--TOTALCASES VS TOTALDEATHS IN AFRICA 
SELECT SUM(total_cases) AS Total_cases,
SUM(total_deaths) AS Total_deaths,(SUM(total_deaths)/SUM(total_cases)) * 100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location ='Africa'
ORDER BY 1,2

--TOTALCASES VS POPULATION IN AFRICA
SELECT SUM(total_cases) AS Total_cases,
SUM(population) AS Total_population,(SUM(population)/SUM(total_cases)) * 100 AS Casepercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE continent='Africa'

--COUNTRIES WITH HIGHEST INFECTION COMPARED TO POPULATION
SELECT location,population,MAX(total_cases) AS Highestinfectioncount, MAX((NULLIF(total_cases,0)/population))*100 AS
Percentageofinfectedpopulation
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE continent= 'Africa'
GROUP BY location,population
ORDER BY Percentageofinfectedpopulation DESC

--1 MORTALITY RATE IN AFRICA
SELECT location,MAX(total_deaths) AS Totaldeathcount
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE continent='Africa'
GROUP BY location
ORDER BY Totaldeathcount DESC

--2 Global death count across africa daily
SELECT location,date,SUM(New_cases) AS TotalNewCases,SUM(total_deaths) AS TotalDeaths,
CASE WHEN SUM(total_cases)>0 THEN(SUM(total_deaths)/SUM(total_cases)) * 100 ELSE 0 END AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE continent='Africa' 
GROUP BY location,date
ORDER BY location,date;

--3 TOTAL VACCINATION BY POPULATION
SELECT cd.location,cd.date,SUM(cd.new_cases) AS Total_cases,SUM(cd.total_deaths) AS Total_deaths,
CASE WHEN SUM(cd.total_cases) > 0
THEN (SUM(cd.total_deaths) / SUM(cd.total_cases)) *100
ELSE 0
END AS DeathPercentsge,SUM(CAST(cv.total_vaccinations AS INT)) AS TotalVaccinations 
FROM PORTFOLIOPROJECTO1..Coviddeaths cd
JOIN
PORTFOLIOPROJECTO1..Covidvaccination cv
ON
cd.location=cv.location AND cd.date=cv.date
WHERE cd.continent='Africa'
GROUP BY cd.location,cd.date
ORDER BY  cd.location,cd.date;

--NEW VACCINATION PER DAY

WITH DailyVaccinations AS (SELECT date,SUM(CAST(total_vaccinations AS INT)) AS TotalVaccinationsPerDay 
FROM PORTFOLIOPROJECTO1..Covidvaccination
GROUP BY date )
SELECT date,TotalVaccinationsPerDay-COALESCE(LAG(TotalVaccinationsPerDay) 
OVER(ORDER BY date),0) AS NewVaccinationPerDay
FROM DailyVaccinations
ORDER BY date;










