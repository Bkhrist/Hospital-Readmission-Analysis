select* from medications_clean

SELECT 
	START AS STARTDATE,
	STOP AS STOPDATE,
	PATIENT AS PATIENT_ID,
	PAYER AS PAYER_ID,
	ENCOUNTER AS ENCOUNTER_ID,
	CODE AS MEDICATION_CODE,
	DESCRIPTION AS MEDICATION_DESCRIPTION,
	BASE_COST,
	PAYER_COVERAGE,
	DISPENSES,
	TOTALCOST,
	REASONCODE,
	REASONDESCRIPTION
INTO 
	medications_clean
FROM medications


-- update the nulls in the table
UPDATE 
	medications_clean
	SET STOPDATE = CONVERT(DATETIME, CONVERT(DATE, GETDATE())),
	REASONCODE = 'No Code',
	REASONDESCRIPTION = 'No Description'
WHERE 
	 STOPDATE IS NULL AND REASONCODE IS NULL AND REASONDESCRIPTION IS NULL



--the total cost of all patient
SELECT
	SUM(TOTALCOST) AS TOTALMEDICTIONCOST
FROM	
	medications_clean


--differece of the total base cost from total cost
SELECT 
  SUM(BASE_COST) AS TotalBaseCost,
  SUM(TOTALCOST) AS TotalCost,
  SUM(TOTALCOST) - SUM(BASE_COST) AS CostDifference
FROM medications_clean


--total cost by medicationdescription
SELECT 
	MEDICATION_DESCRIPTION,
	COUNT(*) AS Num_Medication,
	SUM(TOTALCOST) AS TOTALMEDICATIONCOST,
	SUM(BASE_COST) AS TOTALBASEDCOST
FROM medications_clean
GROUP BY 
	MEDICATION_DESCRIPTION


