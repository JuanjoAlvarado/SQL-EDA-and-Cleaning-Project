# The Analysis
Usually exploratory data analysis aims to find the best way to manipulate data sources. Extracting information necessary to solve problems, discover patterns, detect anomalies, test a hypothesis or verify assumptions.

The main objective in this particular case is to extract information necessary to acquire some knowledge about the recent global pandemic of 2019-2020, with basic indicators. 

## 1. Basic information

The following queries aim to extract some basic indicators such as: mortality rate, total mortality rate, new cases being hospitalized, etc. 

Note: In each query there is a 'WHERE' statement to filter out the data set by the "continent" column. When the "continent" column is 'NULL' for some reason, in the data set used, the "location" column contains the continent's name instead of the country's name. To "fix" this issue and display the precise information in each query we include in the 'WHERE' statement the following: 'continent IS NOT NULL'.

### Basic Indicators

**Mortality rate**: A column created by dividing the "new_deaths" column by the "new_cases" column. It was used a 'CASE' statement to create this indicator to assure no mathematical  problems would pop out (establishing 'NULL'  when a value of the divider -"new_cases"- could be 0).

```SQL
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
```

Here something of the Result Set
|location	|date			|new_cases	|new_deaths		|mortality_rate|
|-----------|---------------|-----------|---------------|--------------|
|Afghanistan|2020-03-29		|67			|	2			|2.98507....   |
|Afghanistan|2020-04-05		|183		|	3			|1.63934....   |
|Afghanistan|2020-04-12		|247		|	10			|4.04858....   |


**Total mortality rate**: A column created by dividing the "total_deaths" column by the "total_cases" column. Instead of using a 'CASE' statement in this query was used the 'NULLIF' function to assure that a value 0 of the divider ("total_cases") would not cause any problem. Also, inside the 'WHERE' statement it was used the 'LIKE' function to filter out the data set by the "location" column. Making it possible to display a data set filtered by the name of a country.

```SQL
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
```

Here something of the Result Set
|location		|date		|total_cases	|total_deaths	|total_mortality|
|---------------|-----------|---------------|---------------|------------|
|Germany	|2020-02-22		|25				|9				|36|
|Germany	|2020-02-23		|31				|10				|32.25806....|
|Germany	|2020-03-01		|170			|11				|6.47058....|


**Hospitalized ratio**: Column created dividing the hospitalized patients("hosp_patients") by the new diagnosticated cases ("new_cases"). It aims to show the ratio of new cases being hospitalized.

**Intensive care unit ratio**: Column created dividing the intensive care unit patiens ("icu_patients") by the hospitalized patients("hosp_patients"). It aims to show the ratio of hospitalized patients 
needing to be in the ICU.

```SQL
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
```

There were no data recorded for the *location* value "Germany" so I did not put a data result example for this query. You may try with another *location*.

**Maximum infection and new infection count**: Using the 'MAX' function on the columns "total_cases" and "new_cases" to show the maximum value of each. Every time an aggregated function is used it is necessary to use the 'GROUP BY' statement. 

In this case the query groups each maximum value by the "location" column. If you want to display the data set in a particular order it can be used the 'ORDER BY' statement ( in this case it was order by the highest to lowest maximum value).

```SQL
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
```

Here something of the Result Set
|location		|maxinfection_count		|max_newinfection_count|
|---------------|-----------------------|----------------------|
|United States	|103436829				|5650933
|China			|99361338				|40475477
|India			|45040074				|2738957


**Maximum death count**: Using the 'MAX' function on the column "total_deaths" to show the maximum value. This query aims to show the maximum death count value for each country. Ordered highest to lowest.

```SQL
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
```

Here something of the Result Set
|location		|maxdeath_count|
|---------------|--------------|
|United States	|1189083
|Brazil			|702116
|India			|533619


**Maximum death count**: Using the 'MAX' function on the column "total_deaths" to show the maximum value. This query aims to show the maximum death count value for each continent and group of interest.

This was achieved changing the condition inside the 'WHERE' statement: from 'IS NOT NULL' to 'IS NULL'. Ordered highest to lowest.

```SQL
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
```

Here something of the Result Set
|location		|maxdeath_count|
|---------------|--------------|
|Europe			|2101093
|North America	|1667314
|Asia			|1637131


## 2. Joining Tables
This query aims to show in a column how the new tests increase in a country's population over time until the recollection of data stops. In order to do this we need to add the value ('SUM' function) of each row one at a time, and every time the "location" value changes the addition of values also restarts. 

As you may already know an aggregate function such as 'SUM', aggregates data from a set of rows into a single row, so we can´t use it to show the accumulated addition of new tests over time or location. Instead we need the 'SUM' function to work as a window function, this type allows to operate on a set of rows without reducing the number of rows returned by the query. This can be done using the 'PARTITION BY' function.

In this query the 'SUM' function (on the "new_tests" column) operates on a set of rows specified by the 'OVER' clause. The 'PARTITION BY' distributes the rows of the result set into groups ("location" column) and the 'SUM' function is applied to each group to return the sum for each, restarting the calculation every time the "location" column value changes. 

```SQL
SELECT 
	...,
	SUM(vac.new_tests) OVER (
		PARTITION BY 
			death.location	
		ORDER BY 
			death.location, 
			death.date
	) AS accumulated_new_test  
```

Once we have that we can join the tables "coviddeaths" and "covidvaccinations". There is no primary key or foreign key specified so we join on columns we know those tables share ("location" and "date"). The data set is finally filtered out inside the 'WHERE' statement to not include possible NULL values inside the "new_tests" column.

```SQL
SELECT 
    ... 
FROM 
	covidvaccinations AS vac
	JOIN coviddeaths AS death				
		ON 
			death.location = vac.location AND death.date = vac.date
WHERE 
	death.continent IS NOT NULL AND 
	vac.new_tests IS NOT NULL 
ORDER BY 
	death.location,
	death.date
LIMIT 100;
```
See the full query

Here something of the Result Set
|continent	|location		|date			|population		|new_tests	|accumulated_new_test|
|-----------|---------------|---------------|---------------|-----------|--------------------|
|Europe		|Albania		|2020-02-25		|2842318		|8			|8
|Europe		|Albania		|2020-02-26		|2842318		|5			|13
|Europe		|Albania		|2020-02-27		|2842318		|4			|17
|Europe		|Albania		|2020-02-28		|2842318		|1			|18
|Europe		|Albania		|2020-02-29		|2842318		|8			|26


## Using a Common Table Expression

This query aims to show how each country contributed in diagnosing people over the total population of the globe. It's necessary to show the accumulated new tests performed by each country over time  and divide it by the global population. The first part is already done (copy and paste of the previous query) but we can't operate with columns created temporarily. So for this particular case a CTE is going to be used. It allows you to create a temporary result set within a query.

A CTE helps the 'readability' of a complex query by breaking it down into smaller and more reusable parts (columns in this case). We are going to skip all the syntax explanation of a CTE; basically we need to put the previous query of accumulated new tests inside the CTE so we can call the "accumulated_new_test" column in a 'SELECT' statement and do calculations with it. 


```SQL
WITH population_vs_test (
	continent, 
	location, 
	date, 
	population, 
	new_tests, 
	accumulated_new_test
) AS(
	SELECT 
		death.continent, 
		death.location, 
		death.date, 
		death.population, 
		vac.new_tests,
		SUM(vac.new_tests) OVER (
			PARTITION BY 
				death.location	
			ORDER BY 
				death.location, 
				death.date
		) AS accumulated_new_test  
	FROM 
		covidvaccinations AS vac
		JOIN coviddeaths AS death				
			ON 
				death.location = vac.location AND death.date = vac.date
	WHERE 
		death.continent is not NULL AND 
		vac.new_tests is not NULL
)
```

The "diagnosed_population_rate" column was created by dividing the "accumulated_new_tests" column within the CTE "population_vs_test" by the "population" column also in the CTE. The division was multiplied by 100 to show a percentage. 

```SQL
SELECT *, 
	(accumulated_new_test/CAST(population AS FLOAT))*100 AS diagnosed_population_rate
FROM 
	population_vs_test
LIMIT 100;
```

The Result Set is the same as the previous one just adding the following column
|diagnosed_population_rate|
|--------------------|
|0.0002814|
|0.0004573|
|0.0005981|
|0.0006332|
|0.0009147|

Note: The "population" column was CAST as float in order to show values with decimal points.


## Using a Temporary Table

This query aims to provide information about the progress of people diagnosed and vaccinated over the globe population, also providing with the rate of people being treated after being diagnosed. 

As we know we can't operate with columns created temporarily so in this case we are going to use a temporary table to call those columns we create and operate with them in a SELECT statement.

```SQL
DROP TABLE IF EXISTS rate_table;
CREATE TABLE rate_table (
	continent varchar(255),
	location varchar(255),			
	date date,
	population numeric,
	new_tests numeric,
	new_vaccinations numeric,
	accumulated_new_test numeric,
	accumulated_new_vaccination numeric
);
```


The table "rate_table" contains the following columns: continent, location, date, population, new_tests, new_vaccinations, accumulated_new_test and accumulated_new_vaccination. We are going to populate these columns with the data from the columns continent, location, date, population, from the table "coviddeaths". new_tests, new_vaccinations, from the table "covidvaccinations".

```SQL
INSERT INTO rate_table 
	SELECT 
		death.continent, 
		death.location, 
		death.date, 
		death.population, 
		vac.new_tests,
		vac.new_vaccinations,
		...
;
```


Finally the columns accumulated_new_test and accumulated_new_vaccinations will be created using the 'PARTITION BY' function on a 'SUM' aggregated function.

```SQL
INSERT INTO rate_table
	SELECT
		...,

		SUM(vac.new_tests) OVER (
			PARTITION BY 
					death.location	
			ORDER BY 
					death.location, 
					death.date
		) AS accumulated_new_test,

		SUM(vac.new_vaccinations) OVER (
				PARTITION BY 
					death.location	
				ORDER BY 
					death.location, 
					death.date
		) AS accumulated_new_vaccination
	FROM 
		covidvaccinations AS vac
		JOIN coviddeaths AS death				
			ON 
				death.location = vac.location AND death.date = vac.date
	WHERE 
		death.continent IS NOT NULL AND 
		vac.new_vaccinations IS NOT NULL AND 
		vac.new_tests IS NOT NULL
```


The final data set result will display the following: "accumulated_diagnosed_rate", "accumulated_vaccination_rate", both obtained dividng the "accumulated_new_test" and "accumulated_new_vaccination" (from "rate_table") by the "population" column. 

"accumulated_treatment_rate" column was calculated dividing "accumulated_diagnosed_rate" and "accumulated_vaccination_rate". All columns were 'CAST' as FLOAT and multiplied by 100 to show a value in percentage with decimal points.

```SQL
SELECT *, 
	(CAST(accumulated_new_vaccination AS FLOAT))/(CAST(accumulated_new_test AS FLOAT)) * 100 AS accumulated_treatment_rate,
	
	(CAST(accumulated_new_test AS FLOAT))/(CAST(population AS FLOAT)) * 100 AS accumulated_diagnosed_rate,
	
	(CAST(accumulated_new_vaccination AS FLOAT))/(CAST(population AS FLOAT)) * 100 AS accumulated_vaccination_rate

FROM 
	rate_table
WHERE 
	rate_table.continent like '%Africa%'
LIMIT 100;
```

Here something of the Result Set
|Continent	|location		|date			|population	|new_tests	|new_vaccinations	|accumulated_new_test		|accumulated_new_vaccinations	|accumulated_treatment_rate	|accumulated_diagnosed_rate	|accumulated_vaccination_rate|
|------|------|-------------------|-------|------|------|-------|------|-------|-------|------|
|Africa		|Cape Verde		|2021-06-15		|593162		|791		|3001				|791			|3001			|379.39			|0.13335			|0.50593|
|Africa		|Cape Verde		|2021-07-13		|593162		|1281		|4461				|2072			|7462			|360.13			|0.34931			|1.25800|
|Africa		|Cote d'Ivoire	|2021-03-09		|28160548	|1942		|1439				|1942			|1439			|74.09			|0.00689			|0.00510|
|Africa		|Cote d'Ivoire	|2021-03-10		|28160548	|3092		|4439				|5034			|5878			|116.76			|0.01787			|0.02087|

 