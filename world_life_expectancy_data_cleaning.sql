SELECT *
FROM world_life_expectancy
;

#check for duplicates
SELECT Country, 
Year, 
CONCAT(Country, Year) , 
COUNT(CONCAT(Country, Year)) AS copies
FROM world_life_expectancy
GROUP BY Country, Year
HAVING copies > 1;

#removing duplicates
SELECT Row_ID, 
CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS copies
FROM world_life_expectancy
;

SELECT *
FROM 
(
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS copies
	FROM world_life_expectancy
) AS copies_table
WHERE copies > 1
;

DELETE FROM world_life_expectancy
WHERE Row_ID IN
(
	SELECT Row_ID
	FROM 
	(
		SELECT Row_ID, 
		CONCAT(Country, Year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS copies
		FROM world_life_expectancy
	) AS copies_table
	WHERE copies > 1
);

-- Removing blanks in the Status Column

#Checking for blanks
SELECT *
FROM world_life_expectancy
WHERE Status = '' 
;

SELECT Country, Year, Status
FROM world_life_expectancy
WHERE Row_ID IN 
(
	SELECT Row_ID 
	FROM world_life_expectancy
	WHERE Status = '' 
)
OR Row_ID IN 
(
	SELECT Row_ID + 1 
	FROM world_life_expectancy
	WHERE Status = '' 
)
OR Row_ID IN 
(
	SELECT Row_ID - 1
	FROM world_life_expectancy
	WHERE Status = '' 
);

SELECT DISTINCT(Country)
FROM world_life_expectancy 
WHERE Status = 'Developing';
-- Won't work (Can't use subquery in update)
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN
(
	SELECT DISTINCT(Country)
	FROM world_life_expectancy 
	WHERE Status = 'Developing'
);

SELECT t1.Country, t1.Status, t1.Year, t2.Country, t2.Status, t2.Year,
ROW_NUMBER() OVER()
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = t2.Status
WHERE t1.Status = ''
AND t2.Status != ''
;


#Addressing blanks in Life Expectancy data
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
	t2.Country, t2.Year, t2.`Life expectancy`,
    t3.Country, t3.Year, t3.`Life expectancy`,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# Updating the data using the above logic
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = ''
;


