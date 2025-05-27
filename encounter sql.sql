


SELECT
    Id AS Encounter_ID,
    PATIENT AS PATIENT_ID,
    START,
    STOP,
	PAYER AS PAYER_ID,
    ENCOUNTERCLASS,
	CODE,
    DESCRIPTION AS Encounter_Description,
    BASE_ENCOUNTER_COST,
    TOTAL_CLAIM_COST,
    PAYER_COVERAGE,
-- Remaining amount the patient has to cover
    (TOTAL_CLAIM_COST - PAYER_COVERAGE) AS REMAINING_BILL,
	REASONCODE,
    REASONDESCRIPTION
INTO
	encounters_clean
FROM
    encounters
ORDER BY
    START


--replacing null in reasoncode and resondescription respectively
UPDATE 
	encounters_clean
SET 
	REASONCODE = 'No Code',
	REASONDESCRIPTION = 'No Description'
WHERE 
	REASONCODE IS NULL AND REASONDESCRIPTION IS NULL


--total of cost by encounterclass
SELECT
	ENCOUNTERCLASS,
	COUNT(*) AS Num_Encounters,
	SUM(TOTAL_CLAIM_COST) AS Total_claimed,
	SUM(BASE_ENCOUNTER_COST) AS EncountCost_Total,
	SUM(PAYER_COVERAGE) AS CoverayPay_Total
FROM
	encounters_clean
GROUP BY
	ENCOUNTERCLASS


--Average of remaining_bill by reason description
SELECT
    REASONDESCRIPTION,
    COUNT(*) AS Total_Encounters,
    AVG(REMAINING_BILL) AS Avg_Remaining_Bill,
    SUM(REMAINING_BILL) AS Total_Remaining_Bill
FROM
    encounters_clean
WHERE
	REASONDESCRIPTION  <> 'No Description'
GROUP BY
    REASONDESCRIPTION


SELECT *
FROM
	encounters_clean
	
