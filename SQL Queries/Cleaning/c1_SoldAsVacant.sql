/*
First of all it's necessary to look up what is the predominant data format in the "SoldAsVacant"
column. In a 'SELECT' statement we use a 'COUNT(*)'function to return the number of record for 
each different value in the "SoldAsVacant" column. The predominant format was 'Yes' vs 'Y' and 
'No' vs 'N'. Now we have to update the column "SoldAsVacant" in table "housing_data" replacing
every 'Y' and 'N' value with 'Yes' and 'No' respectively. Using the 'UPDATE' statement we 'SET'
the "SoldAsVacant" column to be equal to a 'CASE' statement.

The 'CASE' statement specifies that when the value of the column is equal to 'Y' then replace it
with 'Yes', when the value is equal to 'N' then replace it with 'No'. If it is not any of those 
options then the value stays the same. 

Also if you want to take care of any 'NULL' value to be displayed with any other format or value
you can 'UPDATE' the "SoldAsVacant" column to replace every NULL value with a 'No available' string
using the 'COALESCE' function. 
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