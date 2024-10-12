/*
The following query aims to delete all those rows that have the same "UniqueID" value as we can
considered it as a suplicate row. In this case I used a subquery inside a 'DELETE' statement to 
specify wich "UniqueID" values needs to remove.

Inside a 'SELECT' statement I wanted to show the UniqueID and a reference that could show me if the
row is the same as the previous one (same ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).
The 'ROW_NUMBER' function assigns a sequential integer to each row in a result set, if a 'PARTITION BY' 
clause is specified the row number for each partition starts with one and increments by one. Basically,
if the row number referenced to a UniqueID value is greater than one, then that row is a duplicated.

We want to DELETE the UniqueID where the row number is greater than one.
*/

DELETE
	housing_data
WHERE 
	UniqueID IN (
		SELECT 
			UniqueID
		FROM (
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
			FROM
				housing_data
		)
		WHERE
			row_num > 1
	)
;

/*
We can 'DROP' from the table the columns wich are not of great use for a query or any visual
representation using the 'ALTER TABLE' statement. Extremly important: is not a standard practice
to drop columns from the origina data base or remove duplicates. In this case we can create the 
tables and populate them again as I have the csv files with the original data. Is just to exemplify
what we can do with the data base. I do not recomend do any of these things without consulting with
the data base owner or person in charge.
*/

ALTER TABLE housing_data
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate, 
DROP COLUMN OwnerAddress