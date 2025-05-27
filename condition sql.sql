SELECT *
FROM condition_clean


SELECT
	START,
	STOP,
	PATIENT AS PATIENT_ID,
	ENCOUNTER AS ENCOUNTER_ID,
	CODE,
	DESCRIPTION AS CONDITION_DESCRIPTION
INTO
	condition_clean
FROM 
	conditions

-- the top 5 desciption
SELECT TOP 5
	condition_description,
	COUNT(*) AS FREQUENCY
FROM
	condition_clean
GROUP BY
	CONDITION_DESCRIPTION
ORDER BY
	FREQUENCY DESC

--Changing the null in the STOP colun to the current date
UPDATE condition_clean
SET
	STOP = GETDATE()
WHERE
	STOP IS NULL


--Duration of every condition
SELECT *,
	DATEDIFF(DAY,START,STOP) AS DURATION_DAYS
FROM
	condition_clean
