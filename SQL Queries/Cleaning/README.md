# The Analysis
As in any other project, the best way to start is open the data set you are going to work on and observe. Describe what you see mentally or write it out somewhere, this step is crucial in order to establish how you want the data set to look like when you present it. It has to be "useful" and clear for understanding. 

In this project it is going to be presented the process (quering) of fixing or removing incorrectly formatted, duplicate, or incomplete data within a dataset. 

## Sold As Vacant Column

First of all it's necessary to look up what is the predominant data format in the "SoldAsVacant" column. In a 'SELECT' statement we use a 'COUNT(*)'function to return the number of record for each different value in the "SoldAsVacant" column. 

```SQL
SELECT 
	SoldAsVacant,
	COUNT(*)
FROM 
	housing_data
GROUP BY
	SoldAsVacant
;
```

|soldasvacant	|count	|
|---------------|-------|
|Yes			|4623	|
|Y				|52		|
|N				|399	|
|No				|51403	|


The predominant format was 'Yes' vs 'Y' and 'No' vs 'N'. Now we have to update the column "SoldAsVacant" in table "housing_data" replacing every 'Y' and 'N' value with 'Yes' and 'No' respectively. Using the 'UPDATE' statement we 'SET' the "SoldAsVacant" column to be equal to a 'CASE' statement.

```SQL
UPDATE housing_data
SET 
	SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
;
```


The 'CASE' statement specifies that when the value of the column is equal to 'Y' then replace it with 'Yes', when the value is equal to 'N' then replace it with 'No'. If it is not any of those options then the value stays the same. 

Column Update
|soldasvacant	|count	|
|---------------|-------|
|No				|51802	|
|Yes			|4675	|


Also if you want to take care of any 'NULL' value to be displayed with any other format or value, you can 'UPDATE' the "SoldAsVacant" column to replace every NULL value with a 'No Available' string using the 'COALESCE' function. 

```SQL
UPDATE housing_data
SET SoldAsVacant = COALESCE(SoldAsVacant, 'No Available')
```


## Sale Date Column

The "SaleDate" column has date values in the following string format: 'Month Day, Year'. We need to break this string apart in three data values (month, day and year) stored in three new columns. The objective is to be able to use the data stored in "SaleDate" column in a more practical and useful way.

```SQL
SELECT
	SaleDate
FROM
	housing_data
LIMIT 100;
```

|saledate	|
|-----------|
|April 25, 2014	|
|December 18, 2015	|
|November 23, 2015	|
|July 7, 2016	|
|January 16, 2015	|


First change the initial format of 'month day, year' to 'month.day.year' (an easy way to split the string after but is not the only way). Use the 'UPDATE' statement to 'SET' the "SaleDate" column to be equal to a 'REPLACE' function. Replace the spaces (" ") with (".") and the coma (",")
with nothing (""). If there is any character at the start or end of the strign you can replace it with nothing also. 

```SQL
UPDATE housing_data
SET SaleDate = REPLACE(SaleDate, '"', '') 

UPDATE housing_data
SET SaleDate = REPLACE(SaleDate, ' ','.')

UPDATE housing_data									
SET SaleDate = REPLACE(SaleDate, ',', '')

```

|saledate	|
|-----------|
|February.17.2016	|
|June.10.2015	|
|May.20.2016	|
|October.9.2015	|
|July.30.2015	|


Create three new columns with the 'ALTER TABLE' statement to store the different parts of the string we are going to split (month, day, year). 

```SQL
ALTER TABLE housing_data
	ADD 
		sale_month varchar(50),
	ADD
		sale_day varchar(50),
	ADD
		sale_year varchar(50)
;
```


Once again use the 'UPDATE' function to 'SET' each of the new columns ("sale_month", "sale_day" and "sale_year") to be equal to the part of the string of "SaleDate" we want. We can use a 'SUBSTRING' function to split apart the string value or the 'SPLIT_PART' function (in Postgresql) were you look for a specific character (in this case '.') to be the delimiter of the string split and specifying wich part of the string you want (before/after the first or second '.').

```SQL
UPDATE housing_data
SET sale_month = SUBSTRING(SaleDate, 1, STRPOS(SaleDate, '.')-1)

UPDATE housing_data
SET sale_day = SPLIT_PART(SaleDate, '.', 2)

UPDATE housing_data
SET sale_year = SPLIT_PART(SaleDate, '.', 3)

```


```SQL
SELECT
	SaleDate,
	sale_month,
	sale_day,
	sale_year
FROM
	housing_data
LIMIT 100;
```

This is the result:
|saledate	|sale_month	|sale_day	|sale_year	|
|-----------|-----------|-----------|-----------|
|October.6.2014	|October	|6	|2014	|
|October.4.2013	|October	|4	|2013	|
|February.17.2015	|February	|17	|2015	|
|June.12.2013	|June	|12	|2013	|
|December.7.2015	|December	|7	|2015	|


## Property Address Column

### Populate missing information

After cheking out the data of the "housing_table" it came around something particular regarding how the information populated all the columns, specifically the "PropertyAddress" column. For some unknown reason there are rows that contain the same information on every other column (legal reference, ParcelID, Baths, Rooms, etc.) but the Property Address is missing in one row and has it in the other row that has the same information. 

At first it may seem as a duplicate row in wich one of the rows doesn't have the Property Addres information, this was discarded after comparing the values of the column "UniqueID" returning different values for each row. Distinct data entrys with the same property but with one of those missing the "PropertyAdress" reference.

To illustrate better we are going to use a common technique called *Self Join*. The self join, as its name implies, joins a table to itself. It is useful when you want to correlate pairs of rows from the same table. So inside the 'JOIN' we have to establish a correlation between the rows that contain the same information but with a distinct value in the ID entry. Also its important to filter the data set result where the "PropertyAddress" has a NULL value. 

```SQL
SELECT 
	h_a.ParcelID, 
	h_a.PropertyAddress, 
	h_b.ParcelID, 
	h_b.PropertyAddress
FROM 
	housing_data AS h_a  
	JOIN housing_data AS h_b	
		ON 
			h_a.ParcelID = h_b.ParcelID	AND	
			h_a.UniqueID <> h_b.UniqueID	
WHERE 
	h_a.PropertyAddress is NULL		
;
```

Here an example of a total of 35 rows
|parcelid	|propertyaddress	|parcelid(1)	|propertyaddress(1)	|
|-----------|-------------------|---------------|-------------------|
|092 06 0 273.00	|NULL	|092 06 0 273.00	|2721 HERMAN ST, NASHVILLE	|
|092 06 0 282.00	|NULL	|092 06 0 282.00	|815 31ST AVE N, NASHVILLE	|
|092 13 0 322.00	|NULL	|092 13 0 322.00	|237 37TH AVE N, NASHVILLE	|


The next step is to populate the rows that have a "PropertyAddress" NULL value with the information of the row that has that information but with distinct UniqueID. To do that we use the 'COALESCE' function; it returns the first NOT NULL value of a data set. As we specified to show only where "PropertyAddress"is NULL then we need to determine what value has to be replace with, in this case with the value of the row we correlated previously with the conditions of "ParcelID" and "UniqueID" columns.

```SQL
SELECT
	COALESCE(h_a.PropertyAddress, h_b.PropertyAddress)
FROM 
	housing_data AS h_a  
	JOIN housing_data AS h_b	
		ON 
			h_a.ParcelID = h_b.ParcelID	AND	
			h_a.UniqueID <> h_b.UniqueID
WHERE 
	h_a.PropertyAddress is NULL	
;
```

The following column has the values already replaced where the "PropertyAddress" is NULL
|coalesce	|
|-----------|
|2721 HERMAN ST, NASHVILLE	|
|815 31ST AVE N, NASHVILLE	|
|237 37TH AVE N, NASHVILLE	|


Now that we have a way to correlate and populate rows where "PropertyAddress" is NULL, is time to use the 'UPDATE' statement in order to change definetly those NULL values with the information available within the table. When using PostgreSQL is important to note that the syntax needs a little change (because the hierarchy and aliasing this software use). The conditions established inside the JOIN of the table to itself has to be inside a 'WHERE' statement. The aliasing also has to change to avoid an ambiguity problem in PostgreSQL.

```SQL
UPDATE housing_data
SET 
	PropertyAddress = COALESCE(housing_data.PropertyAddress, h_b.PropertyAddress)

FROM 
	housing_data AS h_b  
WHERE 
	housing_data.ParcelID = h_b.ParcelID	AND	
	housing_data.UniqueID <> h_b.UniqueID AND
	housing_data.PropertyAddress IS NULL	 
;
```


If it worked it should not apppear any row in the result set with the following query:

```SQL
SELECT
	PropertyAddress
FROM
	housing_data
WHERE
	PropertyAddress IS NULL
;
```

**Result Set**
|propertyaddress	|
|-------------------|
|	No data			|


### Breaking apart the information

The "PropertyAddress" column has address values in the following string format: 'Address, City'. We need to break this string apart in two data values (address and city) stored in two new columns. The objective is to be able to use the data stored in "PropertyAddress" column in a more practical and useful way. 

```SQL
UPDATE housing_data
SET PropertyAddress = REPLACE(PropertyAddress, ',','.')

ALTER TABLE housing_data
ADD 
	property_address varchar(255),
ADD  
	property_city varchar(255)
;
```

We use the same query as in the "SaleDate" column, obviously adapted to this context (adding two new columns "property_address", "property_city" and making an UPDATE in the table).

```SQL
UPDATE housing_data
SET property_address = SPLIT_PART(PropertyAddress, '.', 1)

UPDATE housing_data	
SET property_city = SPLIT_PART(PropertyAddress, '.', 2)
```


Check the result.

```SQL
SELECT
	property_address, 
	property_city
FROM
	housing_data
LIMIT 100
;
```

|property_address	|property_city	|
|-------------------|---------------|
|2905 SUSAN DR		|NASHVILLE		|
|2916 SUSAN DR		|NASHVILLE		|
|2918 SUSAN DR		|NASHVILLE		|
|2925 IRONWOOD DR	|NASHVILLE		|
|4151 ALVA LN		|NOLENSVILLE	|


## Owner Address Column

**Note**: You probably already know that unlike the "PropertyAddress" column where we can populate the NULL values using some conditions, can't do the same with the "OwnerAddress". Even though the data rows may have the same property address, legal reference, parcelID information, and a uniqueID value, it is possible that a different person did something with the same property at a distinct time. So for this example I replaced and updated this column where the value is NULL with a "No,Data,Available" string before spliting the values in the new columns.

```SQL
UPDATE housing_data
SET OwnerAddress = COALESCE(OwnerAddress, 'No Data Available')
WHERE
	housing_data.OwnerAddress IS NULL
;
```


The "OwnerAddress" column has address values in the following string format: 'Address, City, State'. We need to break this string apart in three data values (address, city and state) stored in three new columns. The objective is to be able to use the data stored in "OwnerAddress" column in a more practical and useful way. We use the same query as in the "SaleDate" column, obviously adapted to this context (adding three new columns "owner_address", "owner_city" and "owner_state" making an UPDATE in the table).

```SQL
ALTER TABLE housing_data
ADD 
	owner_address varchar(255),
ADD
	owner_city varchar(255),
ADD
	owner_state varchar(255)
;

UPDATE housing_data
SET owner_address = SPLIT_PART(OwnerAddress, ',', 1)

UPDATE housing_data
SET owner_city = SPLIT_PART(OwnerAddress, ',', 2)

UPDATE housing_data
SET owner_state = SPLIT_PART(OwnerAddress, ',', 3)
```


Check the result.

```SQL
SELECT
	OwnerAddress,
	owner_address,
	owner_city,
	owner_state
FROM
	housing_data
LIMIT 100
;
```

|owneraddress	|owner_address	|owner_city	|owner_state	|
|---------------|---------------|-----------|---------------|
|165 KENNER AVE, NASHVILLE, TN	|165 KENNER AVE	|NASHVILLE	|TN	|
|191 KENNER AVE, NASHVILLE, TN	|191 KENNER AVE	|NASHVILLE	|TN	|
|196 A KENNER AVE, NASHVILLE, TN	|196 A KENNER AVE	|NASHVILLE	|TN	|
|188 KENNER AVE, NASHVILLE, TN	|188 KENNER AVE	| NASHVILLE	|TN	|
|188 KENNER AVE, NASHVILLE, TN	|188 KENNER AVE	| NASHVILLE	|TN	|

## Other Queries

### Removing Duplicated Rows

The following query aims to delete all those rows that have the same "UniqueID" value as we can considered it as a suplicate row. In this case I used a subquery inside a 'DELETE' statement to specify wich "UniqueID" values needs to remove.

```SQL
DELETE FROM
	housing_data
WHERE 
	UniqueID IN (
        ...
)
;
```


Inside a 'SELECT' statement I wanted to show the UniqueID and a reference that could show me if the row is the same as the previous one (same ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).

The 'ROW_NUMBER' function assigns a sequential integer to each row in a result set, if a 'PARTITION BY' clause is specified the row number for each partition starts with one and increments by one. Basically, if the row number referenced to a UniqueID value is greater than one, then that row is a duplicated.

```SQL
			SELECT
				UniqueID,
				row_number() OVER(
					PARTITION BY 
						ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
				) AS row_num
```


We want to DELETE the UniqueID where the row number is greater than one.

```SQL
		SELECT 
			UniqueID
		FROM (
            SELECT
                  ...
		        ) AS row_num
		WHERE
			row_num > 1
```
[Check the full query here](/SQL%20Queries/Cleaning/c5_other_queries.sql)


### Drop Not Useful Columns

We can 'DROP' from the table the columns wich are not of great use for a query or any visual representation using the 'ALTER TABLE' statement. 

Extremly important: is not a standard practice to drop columns from the origina data base or remove duplicates. In this case we can create the  tables and populate them again as I have the csv files with the original data. Is just to exemplify what we can do with the data base. I do not recomend do any of these things without consulting with the data base owner or person in charge.

```SQL
ALTER TABLE housing_data
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate, 
DROP COLUMN OwnerAddress
```
