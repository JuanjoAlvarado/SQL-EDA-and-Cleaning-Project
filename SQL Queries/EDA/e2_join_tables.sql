/*
This query aims to show in a column how the new tests increase in a country's population
over time until the recollection of data stops.
*/

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
	death.continent IS NOT NULL AND 
	vac.new_tests IS NOT NULL 
ORDER BY 
	death.location,
	death.date
LIMIT 100;