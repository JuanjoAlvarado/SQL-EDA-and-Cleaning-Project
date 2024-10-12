/*
This query aims to show how each country contributed in diagnosing people over the total population
of the globe. It's necessary to show the accumulated new tests performed by each country over time 
and divide it by the global population. The first part is already done (copy and paste of the previous
query) but we can't operate with columns created temporarily. So for this particular case a CTE is going
to be used. It allows you to create a temporary result set within a query.

A CTE helps the 'readability' of a complex query by breaking it down into smaller and more reusable parts
(columns in this case). We are going to skip all the syntax explanation of a CTE; basically we need to put
the previous query of accumulated new tests inside the CTE so we can call the "accumulated_new_test" column
in a 'SELECT' statement and do calculations with it. 

The "diagnosed_population_rate" column was created by dividing the "accumulated_new_tests" column within the
CTE "population_vs_test" by the "population" column also in the CTE. The division was multiplied by 100 to show 
a percentage. 

Note: The "population" column was CAST as float in order to show values with decimal points.  
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