---cleaning of patients table for the healthcare dataset

---create a clean table(creating a clean table
---dropping the relevant clomn for my analysis


SELECT
    Id,

---convert BIRTHDATE to age, age based on life status
---create death rate to indicate if dead or not
	 BIRTHDATE,
	 DEATHDATE,
	CASE 
		WHEN DEATHDATE IS NULL THEN DATEDIFF(YEAR, BIRTHDATE, GETDATE())
		ELSE DATEDIFF(YEAR, BIRTHDATE, DEATHDATE)
    END AS AGE,
--- the dead flag
	CASE 
		WHEN DEATHDATE IS NULL THEN 'Not_Dead'
        ELSE 'Is_Dead'
    END AS Death_Rate,



----add the first, middle, last together as full_name column
---as well as the city,state,zip as location column

	CITY,
	ZIP,
    CONCAT(FIRST, ' ', MIDDLE, ' ', LAST) AS Full_Name,
    CONCAT(CITY, ', ', STATE, ' ', ZIP) AS Location,

---  Update the info to the right one
CASE
	when Marital ='M' then 'Married'
	when Marital = 'S'then 'Single'
	Else 'Other'
	End as Marital_Status,
CASE
	when Gender ='M' then 'Male'
	when Gender = 'F' then 'Female'
	Else 'Other'
	End as Gender,
	RACE,
    ETHNICITY,
    LAT AS Latitude,
    LON AS Longitude,
    HEALTHCARE_EXPENSES,
    HEALTHCARE_COVERAGE,
    INCOME
INTO
	Clean_patients
FROM
	patients



--- altering table to input death_num column for adding the number of deceased
ALTER TABLE
	Clean_patients
ADD Death_num INT

UPDATE Clean_patients
SET
	Death_num = CASE
					When DEATHDATE IS NULL THEN 0
					ELSE 1
					END 



---- distributing the gender( knowing the total of the gender each)
SELECT 
	Gender,
	COUNT(*) AS Gender_Total
FROM
	Clean_patients
GROUP BY
	Gender



---age bracket distribution
SELECT
	CASE
		WHEN AGE < 20 THEN '0-19'
		WHEN AGE < 40 THEN '20-39'
		WHEN AGE < 60 THEN '40-59'
		ELSE '60+'
	END AS Age_Group,
	COUNT (*) AS Age_Sum
FROM 
	Clean_patients
GROUP BY
	CASE
		WHEN AGE < 20 THEN '0-19'
		WHEN AGE < 40 THEN '20-39'
		WHEN AGE < 60 THEN '40-59'
		ELSE '60+'
	END



---Total Number of Deaceased by Gender

SELECT 
	Gender,
	Count (*) AS total,
	SUM (Death_num) AS DECEASED
FROM 
	Clean_patients
GROUP BY
	Gender


---mortality rate  by Race 
SELECT
	RACE,
	COUNT(*) AS TOTAL,
	SUM(Death_num) AS Deceased,
	CAST(SUM(Death_num)*100.0/COUNT(*) AS Decimal(5,2)) AS Mortality_Rate
FROM
	Clean_patients
GROUP BY
	RACE


---Average Expense
SELECT 
    AVG(INCOME) AS Avg_Income,
    AVG(HEALTHCARE_EXPENSES) AS Avg_Expenses,
    AVG(HEALTHCARE_COVERAGE) AS Avg_Coverage
FROM 
	Clean_patients

---out of pocket payment /bills

	


	
SELECT *
FROM 
	Clean_patients