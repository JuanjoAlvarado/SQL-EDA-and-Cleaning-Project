/*
Populating the missing information in the "PropertyAddress" column.
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
Breaking apart the information in "SaleDate" column into three new columns.
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
