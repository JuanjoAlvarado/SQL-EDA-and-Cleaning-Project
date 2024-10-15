/*
This query aims to provide information about the progress of people diagnosed and vaccinated over
the globe population, also providing with the rate of people being treated after being diagnosed. 
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