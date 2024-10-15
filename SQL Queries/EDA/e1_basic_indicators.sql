/*
The following queries aim to extract some basic indicators such as: mortality rate, 
total mortality rate, new cases being hospitalized, etc. 
*/

/*
Mortality rate
*/
SELECT
	location, 
	date, 
	new_cases, 
	new_deaths,
	CASE
		WHEN 
			new_cases = 0 THEN NULL
		ELSE 
			(CAST(new_deaths AS FLOAT)*100)/(CAST(new_cases AS FLOAT))
	END AS "mortality_rate"
FROM
	coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	location, 
	date
LIMIT 100;

/*
Total mortality rate
*/
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(CAST(total_deaths AS FLOAT)*100)/nullif(total_cases,0) AS "total_mortality"
FROM 
	coviddeaths
WHERE 
	continent IS NOT NULL AND
	location LIKE '%Germany%' 
ORDER BY 
	location, 
	date
LIMIT 100;

/*
Hospitalized ratio and Intensive care unit ratio 
*/
SELECT 
	location, 
	new_cases, 
	hosp_patients, 
	icu_patients, 
	(hosp_patients/nullif(new_cases,0)) AS hospitalized_ratio, 
	(icu_patients/nullif(hosp_patients,0)) AS icu_ratio 
FROM 
	coviddeaths
WHERE 
	continent IS NOT NULL AND
	location LIKE '%Germany%'
ORDER BY 
	location
LIMIT 100;

/*
Maximum infection and new infection count
*/
SELECT 
	location, 
	max(total_cases) AS maxinfection_count,
	max(new_cases) AS max_newinfection_count
FROM
	coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	location 
ORDER BY 
	maxinfection_count DESC
LIMIT 100;

/*
Maximum death count
*/
SELECT 
	location, 
	max(total_deaths) AS maxdeath_count
FROM 
	coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	location
ORDER BY 
	maxdeath_count DESC
LIMIT 100;

/*
Maximum death count by Continent
*/
SELECT 
	location, 
	max(total_deaths) AS maxdeath_count
FROM 
	coviddeaths
WHERE 
	continent IS NULL
GROUP BY 
	location
ORDER BY 
	maxdeath_count DESC 
LIMIT 100;
