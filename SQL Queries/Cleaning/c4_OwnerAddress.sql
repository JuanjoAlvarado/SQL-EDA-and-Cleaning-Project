/*
The "OwnerAddress" column has address values in the following string format: 'Address, City, State'.
We need to break this string apart in three data values (address, city and state) stored in 
three new columns. The objective is to be able to use the data stored in "OwnerAddress" column
in a more practical and useful way. We use the same query as in the "SaleDate" column, obviously 
adapted to this context (adding three new columns "owner_address", "owner_city" and "owner_state" 
making an UPDATE in the table).

Note: You probably already know that unlike the "PropertyAddress" column where we can populate the NULL
values using some conditions, can't do the same with the "OwnerAddress". Even though the data rows may have
the same property address, legal reference, parcelID information, and a uniqueID value, it is possible
that a different person did something with the same property at a distinct time. So for this example I replaced
and updated this column where the value is NULL with a "No,Data,Available" string before splting the values 
in the new columns.
*/

UPDATE housing_data
SET OwnerAddress = COALESCE(OwnerAddress, 'No,Data,Available')
WHERE
	housing_data.OwnerAddress IS NULL
;

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


SELECT
	OwnerAddress,
	owner_address,
	owner_city,
	owner_state
FROM
	housing_data
LIMIT 100
;