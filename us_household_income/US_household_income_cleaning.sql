-- US HOUSEHOLD INCOME DATA CLEANING

SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

ALTER TABLE us_household_income_statistics 
RENAME COLUMN `row_id` TO `id`;

#Checking for duplicates
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

#removing duplicates
SELECT *
FROM 
(
	SELECT row_id, 
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income
) AS duplicates
WHERE row_num > 1
;

DELETE FROM us_household_income
WHERE row_id IN 
(
	SELECT row_id
	FROM 
	(
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income
	) AS duplicates
	WHERE row_num > 1
)
;

#checking for duplicates in the statistics table
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

#checking for naming errors
SELECT DISTINCT State_Name
FROM us_household_income
WHERE State_Name NOT IN
('Alabama', 'Alaska', 'Arizona','Arkansas','California','Colorado', 'Connecticut',
'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland','Massachusetts','Michigan',
'Minnesota','Mississippi','Missouri','Montana','Nebraska',
'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico','New York','North Carolina', 'North Dakota',
'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
'Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin', 'Wyoming')
;

#updating wrongly named columns
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

SELECT DISTINCT State_ab
FROM us_household_income;

#checking for missing data in the 'Place' column
SELECT *
FROM us_household_income
WHERE Place = '';

#'Place is blank in 1 row where County is Autauga County'

SELECT *
FROM us_household_income
WHERE County = 'Autauga County';

#For all places where the County= 'Autauga County', Place = 'Autaugaville' (except one)

#updating blank Place row with 'Autaugaville'
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

#checking the Type column and the count of data in each category
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

#checking for blank, null or zero value data points in the ALand and AWater columns
SELECT ALand, AWater
FROM us_household_income
WHERE AWater IN (0, '', NULL);

SELECT DISTINCT AWater
FROM us_household_income
WHERE AWater IN (0, '', NULL);

SELECT ALand, AWater
FROM us_household_income
WHERE ALand IN (0, '', NULL)
AND AWater IN (0, '', NULL) ;

#while there are zero value points in both ALand and AWater, we do not have areas that have both az zero 
#which is right as an region should have at least land or water area.




