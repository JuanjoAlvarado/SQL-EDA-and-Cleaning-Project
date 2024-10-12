/*
The "SaleDate" column has date values in the following string format: 'Month Day, Year'.
We need to break this string apart in three data values (month, day and year) stored in 
three new columns. The objective is to be able to use the data stored in "SaleDate" column
in a more practical and useful way.

First change the initial format of 'month day, year' to 'month.day.year' (an easy way to split
the string after but is not the only way). Use the 'UPDATE' statement to 'SET' the "SaleDate"
column to be equal to a 'REPLACE' function. Replace the spaces (" ") with "." and the coma (",")
with nothing (""). If there is any character at the start or end of the strign you can replace it
with nothing also. 

Create three new columns with the 'ALTER TABLE' statement to store the different parts of the string
we are going to split (month, day, year). Once again use the 'UPDATE' function to 'SET' each of the 
new columns ("sale_month", "sale_day" and "sale_year") to be equal to the part of the string of 
"SaleDate" we want. We can use a 'SUBSTRING' function to split apart the string value or the 'SPLIT_PART'
function (in Postgresql) were you look for a specific character (in this case '.') to be the delimiter of 
the string split and specifying wich part of the string you want (before/after the first or second '.').
*/

SELECT
	SaleDate
FROM
	housing_data
LIMIT 100;

UPDATE housing_data
SET SaleDate = REPLACE(SaleDate, '"', '') 

UPDATE housing_data
SET SaleDate = REPLACE(SaleDate, ' ','.')

UPDATE housing_data									
SET SaleDate = REPLACE(SaleDate, ',', '')



ALTER TABLE housing_data
	ADD 
		sale_month varchar(50),
	ADD
		sale_day varchar(50),
	ADD
		sale_year varchar(50)
;

UPDATE housing_data
SET sale_month = SUBSTRING(SaleDate, 1, STRPOS(SaleDate, '.')-1)

UPDATE housing_data
SET sale_day = SPLIT_PART(SaleDate, '.', 2)

UPDATE housing_data
SET sale_year = SPLIT_PART(SaleDate, '.', 3)

SELECT
	SaleDate,
	sale_month,
	sale_day,
	sale_year
FROM
	housing_data
LIMIT 100;