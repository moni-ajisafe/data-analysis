-- US HOUSEHOLD INCOME EDA

#What is the total area of Land and Water in each state?
#What state has the most land? the most water?
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
;

# Joining the income statistics data to the income and geographical data
SELECT *
FROM us_household_income i
JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE Mean != 0
;


SELECT *
FROM us_household_income i
RIGHT JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE i.id IS NULL
;

#Looking at income stats by state...
SELECT i.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income i
JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE Mean != 0
;

SELECT i.State_Name, ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM us_household_income i
JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE Mean != 0
GROUP BY i.State_Name
ORDER BY 2 DESC
LIMIT 10
;

#Looking at summary statistics for each region Type
SELECT Type, COUNT(Type), ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM us_household_income i
JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE Mean != 0
GROUP BY Type
#HAVING COUNT(Type) > 100
ORDER BY 4 DESC;

#Type 'Community' has the lowest median income
SELECT *
FROM us_household_income
WHERE Type = 'Community'
;


#What cities have the highest average household income?
SELECT i.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income i
JOIN us_household_income_statistics ist
	ON i.id = ist.id
WHERE Mean != 0
GROUP BY i.State_Name, City
ORDER BY 3 DESC
;