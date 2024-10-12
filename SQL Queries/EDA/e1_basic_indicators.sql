/*
The following queries aim to extract some basic indicators such as: mortality rate, 
total mortality rate, new cases being hospitalized, etc. 

Note: In each query there is a 'WHERE' statement to filter out the data set by the 
"continent" column. When the "continent" column is 'NULL' for some reason in this
data set the "location" column contains the continent's name instead of the country's 
name. To "fix" this issue and display the precise information in each query we include 
in the 'WHERE' statement the following: 'continent IS NOT NULL'.
*/

/*
1. Mortality rate: A column created by dividing the "new_deaths" column by the "new_cases" 
column. It was used a 'CASE' statement to create this indicator to assure no mathematical 
problems would pop out (establishing 'NULL'  when a value of the divider -"new_cases"-
could be 0).
*/
SELECT
	location, 
	date, 
	new_cases, 
	new_deaths,
	CASE
		WHEN new_cases = 0 THEN Null
		ELSE 
		(CAST(new_deaths AS FLOAT)*100)/(CAST(new_cases AS FLOAT)) -- Porcentaje de mortalidad de nuevos casos --
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
2. Total mortality rate: A column created by dividing the "total_deaths" column by the "total_cases" 
column. Instead of using a 'CASE' statement, in this query was used the 'NULLIF' function to assure
that a value 0 of the divider ("total_cases") would not cause any problem. Also, inside the 'WHERE'
statement it was used the 'LIKE' function to filter out the data set by the "location" column. Making
it possible to display a data set filtered by the name of a country. 
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
3. Hospitalized ratio: Column created dividing the hospitalized patiens ("hosp_patients") by the 
new diagnosticated cases ("new_cases"). It aims to show the ratio of new cases being hospitalized.

Intensive care unit ratio: Column created dividing the intensive care unit patiens ("icu_patients")
by the hospitalized patients ("hosp_patients"). It aims to show the ratio of hospitalized patients 
needing to be in the ICU.
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
4. Maximum infection and new infection count: Using the 'MAX' function on the columns "total_cases"
and "new_cases" to show the maximum value of each. Every time an aggregated function is used it is
necessary to use the 'GROUP BY' statement. In this case the query groups each maximum value by the
"location" column. If you want to display the data set in a particular order it can be used the
'ORDER BY' statement ( in this case it was order by the highest to lowest maximum value). 
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
Maximum death count: Using the 'MAX' function on the column "total_deaths" to show the maximum value.
This query aims to show the maximum death count value for each country. Ordered highest to lowest.
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
Maximum death count: Using the 'MAX' function on the column "total_deaths" to show the maximum value.
This query aims to show the maximum death count value for each continent and group of interest.
This was achieved changing the condition inside the 'WHERE' statement: from 'IS NOT NULL' to 'IS NULL'.
Ordered highest to lowest.
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
