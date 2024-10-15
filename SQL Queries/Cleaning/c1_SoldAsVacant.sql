/*
Formatting of the "SoldAsVacant" column.
*/

SELECT 
	SoldAsVacant,
	COUNT(*)
FROM 
	housing_data
GROUP BY
	SoldAsVacant
;
	
UPDATE housing_data
SET 
	SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
;

UPDATE housing_data
SET SoldAsVacant = COALESCE(SoldAsVacant, 'No available')