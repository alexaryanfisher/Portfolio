-- Data Exploration of the Coronavirus (COVID-19) Deaths and Vaccines for the World.

---- This data was captured from the Our World in Data website as of September 2023.

--- Viewing the first table that was imported.

SELECT * 
FROM public.deaths
WHERE continent IS NOT NULL;

--- The Deaths table had a total of 339549 rows across 26 columns.

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM public.deaths
WHERE continent IS NOT NULL;

--- Viewing the total cases versus the total deaths. Calculating the total percentage of deaths.

SELECT location, date, total_cases, total_deaths, (total_deaths)/(total_cases)*100 as death_percentage
FROM public.deaths
WHERE continent IS NOT NULL;

--- See the total death percentage for the United States only.

SELECT location, date, total_cases, total_deaths, (total_deaths)/(total_cases)*100 as death_percentage
FROM public.deaths
WHERE location LIKE '%States%';

/* We can see at the time of this data that there is a 1.09 percent rate of death after contracting COVID.
At the high of the pandemic in May of 2020, there was a 6.12 percent death rate.*/

--- Viewing the total cases versus the population. Calculating the total percentage of cases in the United States

SELECT location, date, total_cases, population, (total_cases)/(population)*100 AS case_percentage
FROM public.deaths
WHERE location LIKE '%States%';

/* We can see that by September 2023 at least 30.57% of the population has gotten COVID.*/

---Showing the countries with the highest infection rate in comparison to the population.

SELECT location, MAX(total_cases) AS highestcaseCount, population, MAX((total_cases)/(population))*100 AS infection_percentage
FROM public.deaths
WHERE continent IS NOT NULL
GROUP BY population, location
ORDER BY infection_percentage DESC;

--- Showing the countries with the highest death rate in comparison to the population.

SELECT location, MAX(total_deaths) AS highestdeathCount
FROM public.deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY highestdeathCount DESC;

--- Showing the total number of deaths based on continent.

SELECT continent, MAX(total_deaths) AS highestdeathCount
FROM public.deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highestdeathCount DESC;

--- Showing Global death percentages.

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM public.deaths
WHERE continent IS NOT NULL;

--- Showing the global sum of new cases per date

SELECT date, SUM(new_cases) AS cases_sum
FROM public.deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY cases_sum DESC;

--- Viewing new Deaths versus new cases.

SELECT date, SUM(new_cases) AS cases_sum, SUM(new_deaths) AS deaths_sum, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM public.deaths
WHERE new_cases <> 0 AND continent IS NOT NULL
GROUP BY date
ORDER BY death_percentage DESC;


--- Viewing the second table of COVID vaccinations

SELECT *
FROM public.vaccines;

--- Joining tables Death and Vaccines

SELECT *
FROM public.deaths AS d
JOIN public.vaccines AS v
ON d.location = v.location
AND d.date = v.date

--- Viewing total population versus vaccinations
---- Vaccines were not introduced until the end of 2020. I filtered out the null values to give us an idea of where the vaccination counts were located.

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM public.deaths AS d
JOIN public.vaccines AS v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL AND v.new_vaccinations IS NOT NULL
ORDER BY d.date

--- Viewing total vaccinations within each location, providing a rolling count of vaccinated, and percentage of vaccinated compared to the total population with the use of a CTE

WITH popvsvac(continent, location, date, population, new_vaccinations, rollingvaccinations)
AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS rollingvaccinations
FROM public.deaths AS d
JOIN public.vaccines AS v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL AND v.new_vaccinations IS NOT NULL
)

SELECT *, rollingvaccinations/population*100 AS vaccinated_percentage
FROM popvsvac;

---- Creating a View of the same data just to show different ways to capture this data.

CREATE VIEW percentagepopvaccinated AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS rollingvaccinations
FROM public.deaths AS d
JOIN public.vaccines AS v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL AND v.new_vaccinations IS NOT NULL
)

SELECT * 
FROM percentagepopvaccinated