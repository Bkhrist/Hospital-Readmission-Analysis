select*from payers_cleaned

SELECT
	ID as PAYER_ID,
	NAME AS PAYER_NAME,
	OWNERSHIP,
	AMOUNT_COVERED,
	AMOUNT_UNCOVERED,
	REVENUE,
	COVERED_ENCOUNTERS,
	UNCOVERED_ENCOUNTERS,
	COVERED_MEDICATIONS,
	UNCOVERED_MEDICATIONS,
	COVERED_PROCEDURES,
	UNCOVERED_PROCEDURES,
	UNIQUE_CUSTOMERS,
	QOLS_AVG,
	MEMBER_MONTHS
INTO
	payers_cleaned
FROM
	payers

--list of payer with their Quality of Life Score
SELECT
	PAYER_NAME,
	OWNERSHIP,
	QOLS_AVG
FROM
	payers_cleaned


--highest unique customers by payer's name 
SELECT TOP 1
	PAYER_NAME,
	MAX(UNIQUE_CUSTOMERS) AS HIGHEST_PAYER
FROM 
	payers_cleaned
GROUP BY
	PAYER_NAME 
ORDER BY
	HIGHEST_PAYER DESC


--Average revenue per membermonth for each player
SELECT
	PAYER_NAME,
	REVENUE,
	MEMBER_MONTHS,
	REVENUE * 1.0 / NULLIF(MEMBER_MONTHS, 0) AS RevenuePerMemberMonth
FROM
	payers_cleaned


--covered vs uncovered procedure
SELECT 
  PAYER_NAME,
  COVERED_PROCEDURES,
  UNCOVERED_PROCEDURES,
  (COVERED_PROCEDURES + UNCOVERED_PROCEDURES) AS TotalProcedures,
  COVERED_PROCEDURES * 1.0 / NULLIF((COVERED_PROCEDURES + UNCOVERED_PROCEDURES), 0) AS CoverageRatio
FROM 
	payers_cleaned


--Payer with the lower quality of life score
SELECT
	PAYER_ID,
	QOLS_AVG
FROM	
	payers_cleaned
WHERE
	QOLS_AVG < 0.75
ORDER BY
	QOLS_AVG ASC
