/*
This query aims to provide information about the progress of people diagnosed and vaccinated over
the globe population, also providing with the rate of people being treated after being diagnosed. 

As we know we can't operate with columns created temporarily so in this case we are going to create 
a temporary table to call those columns we create and operate with them in a SELECT statement.

The table "rate_table" contains the following columns: continent, location, date, population, new_tests,
new_vaccinations, accumulated_new_test and accumulated_new_vaccination. We are going to populate these columns
with the data from the columns continent, location, date, population, from the table "coviddeaths"; new_tests,
new vaccinations, from the table "covidvaccinations"; finally the columns accumulated_new_test will and 
accumulated_new_vaccinations will be created using the 'PARTITION BY' function on a 'SUM' aggregated function.

The final data set result will display the following: "accumulated_diagnosed_rate", "accumulated_vaccination_rate",
both obtained dividng the "accumulated_new_test" and "accumulated_new_vaccination" (from "rate_table") by the
"population" column. "accumulated_treatment_rate" column was calculated dividing "accumulated_diagnosed_rate" and
"accumulated_vaccination_rate". All columns were 'CAST' as FLOAT and multiplied by 100 to show a value in percentage
with decimal points.

*/

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

INSERT INTO rate_table 
	SELECT 
		death.continent, 
		death.location, 
		death.date, 
		death.population, 
		vac.new_tests,
		vac.new_vaccinations,
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
;

SELECT *, 
	(CAST(accumulated_new_vaccination AS FLOAT))/(CAST(accumulated_new_test AS FLOAT)) * 100 AS accumulated_treatment_rate,
	(CAST(accumulated_new_test AS FLOAT))/(CAST(population AS FLOAT)) * 100 AS accumulated_diagnosed_rate,
	(CAST(accumulated_new_vaccination AS FLOAT))/(CAST(population AS FLOAT)) * 100 AS accumulated_vaccination_rate
FROM 
	rate_table
WHERE 
	rate_table.continent like '%Africa%'
LIMIT 100;