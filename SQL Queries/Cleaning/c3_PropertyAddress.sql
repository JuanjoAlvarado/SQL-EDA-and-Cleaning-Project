/*
After cheking out the data of the "housing_table" it came around something particular regarding
how the information populated all the columns, specifically the "PropertyAddress" column. For some
unknown reason there are rows that contain the same information on every other column (legal reference,
ParcelID, Baths, Rooms, etc.) but the Property Address is missing in one row and has it in the other row 
that has the same information. At first it may seem as a duplicate row in wich one of the rows doesn't 
have the Property Addres information, this was discarded after comparing the values of the column "UniqueID"
returning different values for each row. Distinct data entrys with the same property but with one of those 
missing the "PropertyAdress" reference.

To illustrate better we are going to use a common technique called <<Self Join>>. The self join, as its name 
implies, joins a table to itself. It is useful when you want to correlate pairs of rows from the same table.
So inside the 'JOIN' we have to establish a correlation between the rows that contain the same information but 
with a distinct value in the ID entry. Also its important to filter the data set result where the "PropertyAddress"
has a NULL value. 
*/
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

/*
The next step is to populate the rows that have a "PropertyAddress" NULL value with the information 
of the row that has that information but with distinct UniqueID. To do that we use the 'COALESCE' 
function; it returns the first NOT NULL value of a data set. As we specified to show only where 
"PropertyAddress"is NULL then we need to determine what value has to be replace with, in this case
with the value of the row we correlated previously with the conditions of "ParcelID" and "UniqueID"
columns.
*/
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

/*
Now that we have a way to correlate and populate rows where "PropertyAddress" is NULL is time to use
the 'UPDATE' statement in order to change definetly those NULL values with the information available
within the table. When using PostgreSQL is important to note that the syntax needs a little change 
(because the hierarchy and aliasing this software use). The conditions established inside the JOIN of 
the table to itself has to be inside a 'WHERE' statement. The aliasing also has to change to avoid an
ambiguity problem in PostgreSQL.
*/
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

SELECT
	PropertyAddress
FROM
	housing_data
WHERE
	PropertyAddress IS NULL
;

/*
The "PropertyAddress" column has address values in the following string format: 'Address, City'.
We need to break this string apart in two data values (address and city) stored in 
two new columns. The objective is to be able to use the data stored in "PropertyAddress" column
in a more practical and useful way. We use the same query as in the "SaleDate" column, obviously 
adapted to this context (adding two new columns "property_address", "property_city" and making an 
UPDATE in the table).
*/

UPDATE housing_data
SET PropertyAddress = REPLACE(PropertyAddress, ',','.')

ALTER TABLE housing_data
ADD 
	property_address varchar(255),
ADD  
	property_city varchar(255)
;

UPDATE housing_data
SET property_address = SPLIT_PART(PropertyAddress, '.', 1)

UPDATE housing_data	
SET property_city = SPLIT_PART(PropertyAddress, '.', 2)

SELECT
	property_address, 
	property_city
FROM
	housing_data
LIMIT 100
;
