--SELECT * FROM covid_deaths
--ORDER BY 2,3
--SELECT * FROM covid_vaccinations


--Selecting data that will be used

SELECT location, date,total_cases,new_cases,total_deaths,population
FROM covid_deaths
ORDER BY 1,2




--Looking at total_cases vs total_deaths
--Showing the chance of dying if covid is contacted by a person in India

SELECT location, date,total_cases,new_cases,total_deaths, 
(total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
WHERE location LIKE '%india%'
ORDER BY 1,2 




--Looking at total_cases vs population
--Shows chance of being affected by covid if living in India

SELECT location, date,population,total_cases,
(total_cases/population)*100 AS affected_percentage
FROM covid_deaths
WHERE location LIKE '%india%'
ORDER BY 1,2 



--Looking at countries based on affected_percentage

SELECT location,population,MAX(total_cases) AS max_total_cases,
(MAX(total_cases)/population)*100 AS affected_percentage
FROM covid_deaths
GROUP BY location,population
ORDER BY 4 DESC



--Looking at countries based on death_count

SELECT location, MAX(cast(total_deaths AS int)) AS max_total_Deaths
FROM covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY max_total_Deaths DESC



--Looking at death_count based on continent

SELECT continent, MAX(cast(total_deaths AS int)) AS total_Deaths
FROM covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_Deaths DESC



--GLOBAL NUMBER

SELECT  date, SUM(new_cases) AS Total_cases, SUM(CAST (new_deaths AS int)) AS Total_deaths,
(SUM(CAST (new_deaths AS int))/SUM(new_cases)) * 100 AS Death_percentage
FROM covid_deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1




--Vaccinations_percentage of countries

SELECT dea.location,(MAX(vac.total_vaccinations)) AS total_vaccinations,
((MAX(vac.total_vaccinations))/MAX(population)) * 100 AS vaccination_percentage
FROM covid_deaths as dea
INNER JOIN covid_vaccinations as vac
ON dea.location = vac.location
GROUP BY dea.location
ORDER by vaccination_percentage 




--Total population vs vaccinations

SELECT dea.continent ,dea.location, dea.date , dea.population , vac.new_vaccinations ,
(SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location ,dea.date)) AS RollingCount_Vaccinations

FROM covid_deaths as dea

INNER JOIN covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date =  vac.date 

WHERE dea.continent IS NOT NULL
ORDER BY 2,3




-- Looking at pop vs vac using CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingCount_Vaccinations)
AS
(SELECT dea.continent ,dea.location, dea.date , dea.population , vac.new_vaccinations ,
(SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location ,dea.date)) AS RollingCount_Vaccinations
FROM covid_deaths as dea
INNER JOIN covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date =  vac.date 
WHERE dea.continent IS NOT NULL
)
SELECT *, ((RollingCount_Vaccinations / Population)*100) AS Vaccination_Percentage
FROM PopvsVac




-- Looking at Pop vs Vac using Temp Table

DROP TABLE IF EXISTS #PopvsVac

CREATE TABLE #PopvsVac
(Continent nvarchar(225), Location nvarchar(225), Date datetime, Population int, New_Vaccinations int, RollingCount_Vaccinations int)

INSERT INTO #PopvsVac
SELECT dea.continent ,dea.location, dea.date , dea.population , vac.new_vaccinations ,
(SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location ,dea.date)) AS RollingCount_Vaccinations
FROM covid_deaths as dea
INNER JOIN covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date =  vac.date 
WHERE dea.continent IS NOT NULL

SELECT Continent,Location,Date,Population,New_Vaccinations,RollingCount_Vaccinations,
((RollingCount_Vaccinations/Population)*100) AS Vaccination_Percentage
FROM #PopvsVac



-- Creating views for later visualization

CREATE VIEW PercentPopulationVaccination AS
SELECT dea.continent ,dea.location, dea.date , dea.population , vac.new_vaccinations ,
(SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location ,dea.date)) AS RollingCount_Vaccinations
FROM covid_deaths as dea
INNER JOIN covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date =  vac.date 
WHERE dea.continent IS NOT NULL