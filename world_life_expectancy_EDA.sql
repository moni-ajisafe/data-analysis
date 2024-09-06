-- WORLD LIFE EXPECTANCY EDA

#	Exploring life expectancy data
# How has Life expectancy changed for each country from 2007 to 2022?
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
ORDER BY Life_Increase_15_Years DESC
;

#What is the average life expectancy per year?
SELECT Year, 
ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` != 0
GROUP BY Year
ORDER BY Year
;

#What is the corellation between GDP and average life expectancy?
SELECT Country, 
ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Exp,
ROUND(AVG(GDP), 1) AS Avg_GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_GDP > 0
ORDER BY Avg_GDP DESC
;

SELECT *
FROM world_life_expectancy
WHERE GDP > 0
ORDER BY GDP;

SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END), 2) AS High_GDP_Life_Exp,
SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` ELSE NULL END), 2) AS Low_GDP_Life_Exp
FROM world_life_expectancy
;


#Life Expectancy vs Developing/Developed Countries
SELECT Status, 
ROUND(AVG(`Life expectancy`), 1), 
COUNT(Status)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, 
COUNT(DISTINCT Country) AS Countries,
ROUND(AVG(`Life expectancy`), 1) AS Avg_life_expectancy
FROM world_life_expectancy
GROUP BY Status
;

#What is the corellation between BMI and average life expectancy?
SELECT Country, 
ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Exp,
ROUND(AVG(BMI), 1) AS Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_BMI > 0
ORDER BY Avg_BMI DESC
;

SELECT *
FROM world_life_expectancy
;

SELECT Country,
Year, 
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Running_total
FROM world_life_expectancy
WHERE Country = 'Nigeria'
;