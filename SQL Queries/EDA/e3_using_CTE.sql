/*
This query aims to show how each country contributed in diagnosing people over the total population
of the globe.   
*/

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

SELECT *, 
	(accumulated_new_test/CAST(population AS FLOAT))*100 AS diagnosed_population_rate
FROM 
	population_vs_test
LIMIT 100;