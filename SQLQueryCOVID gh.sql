
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

--TOTALCASES VS TOTALDEATHS
SELECT location,date,total_cases,total_deaths,(total_deaths/NULLIF(total_cases,0))*100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
ORDER BY 1,2

--TOTALCASES VS TOTALDEATHS IN AFRICA
SELECT location,date,total_cases,total_deaths,(total_deaths/NULLIF(total_cases,0))*100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%'
ORDER BY 1,2

--TOTALCASES VS POPULATION
SELECT location,date,total_cases,population,(NULLIF(total_cases,0)/population)*100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%'
ORDER BY 1,2

--COUNTRIES WITH HIGHEST INFECTION COMPARED TO POPULATION
SELECT location,population,MAX(total_cases) AS Highestinfectioncount, MAX((NULLIF(total_cases,0)/population))*100 AS
Percentageofinfectedpopulation
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%'
GROUP BY location,population
ORDER BY Percentageofinfectedpopulation DESC

--COUNTRIES WITH HIGHEST MORTALITY RATE PER POPULATION

SELECT location,MAX(total_deaths) AS Totaldeathcount
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%' 
AND continent IS NOT NULL
GROUP BY location
ORDER BY Totaldeathcount DESC

--BY CONTINENT

SELECT location,MAX(total_deaths) AS Totaldeathcount
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%' 
AND continent IS NULL
GROUP BY location
ORDER BY Totaldeathcount DESC

--Global deathcount
SELECT date,SUM(New_cases)--,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%' 
AND continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--DEATHCASES RECORDED DAILY ACROSS AFRICA
SELECT date,SUM(new_cases) AS total_cases,
SUM(CAST(new_deaths as int)) AS total_deaths,
(SUM(CAST(new_deaths as int)) / NULLIF(SUM(new_cases) ,0))* 100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%' 
AND continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--TOTAL CASES RECORDED IN AFRICA
SELECT SUM(new_cases) AS total_cases,
SUM(CAST(new_deaths as int)) AS total_deaths,
(SUM(CAST(new_deaths as int)) / NULLIF(SUM(new_cases) ,0))* 100 AS Deathpercentage
FROM PORTFOLIOPROJECTO1..Coviddeaths
WHERE location LIKE '%Africa%' 
AND continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--VACCINATION PER TOTAL POPULATION

SELECT Cd.continent,Cd.location,Cd.date,Cd.population,Cv.new_vaccinations
FROM PORTFOLIOPROJECTO1..Coviddeaths Cd
JOIN PORTFOLIOPROJECTO1..Covidvaccination Cv
ON Cd.location=Cv.location
AND Cd.date=Cd.date
WHERE Cd.continent IS NOT NULL

--NEW VACCINATION PER DAY
SELECT Cd.continent,Cd.location,Cd.date,Cd.population,Cv.new_vaccinations,
SUM(Cast(Cv.new_vaccinations as int)) OVER (Partition by Cd.location)
FROM PORTFOLIOPROJECTO1..Coviddeaths Cd
JOIN PORTFOLIOPROJECTO1..Covidvaccination Cv
ON Cd.location=Cv.location
AND Cd.date=Cd.date
WHERE Cd.continent IS NOT NULL










