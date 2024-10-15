/*
Removing duplicated rows.
*/

DELETE FROM
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
Drop columns.
*/

ALTER TABLE housing_data
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate, 
DROP COLUMN OwnerAddress