/*
This query aims to show in a column how the new tests increase in a country's population
over time until the recollection of data stops. In order to do this we need to add the value 
('SUM' function) of each row one at a time, and every time the "location" value changes the
addition of values also restarts. 

As you may already know an aggregate function such as 'SUM', aggregates data from a set of rows 
into a single row, so we can´t use it to show the accumulated addition of new tests over time or 
location. Instead we need the 'SUM' function to work as a window function, this type allows to 
operate on a set of rows without reducing the number of rows returned by the query. This can be
done using the 'PARTITION BY' function.

In this query the 'SUM' function (on the "new_tests" column) operates on a set of rows specified
by the 'OVER' clause. The 'PARTITION BY' distributes the rows of the result set into groups ("location"
column) and the 'SUM' function is applied to each group to return the sum for each restarting the 
calculation every time the "location" column value changes. 

Once we have that we can join the tables "coviddeaths" and "covidvaccinations". There is no primary 
key or foreign key specified in this tables so we join on columns we know those tables share ("location" 
and "date"). The data set is finally filtered out inside the 'WHERE' statement to not include possible 
NULL values inside the "new_tests" column.
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