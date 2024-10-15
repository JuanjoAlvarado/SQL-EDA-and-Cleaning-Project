/*
Breaking apart the information in "OwnerAddress" column in three new column.
*/

UPDATE housing_data
SET OwnerAddress = COALESCE(OwnerAddress, 'No Data Available')
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