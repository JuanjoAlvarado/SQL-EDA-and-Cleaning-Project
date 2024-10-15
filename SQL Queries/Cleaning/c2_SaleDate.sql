/*
Breaking apart the information in "SaleDate" column into three new columns.
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