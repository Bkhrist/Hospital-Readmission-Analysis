# Readmission Analysis Dashboards for Synthea EHR Dataset

**Objective:**
To analyze hospital readmissions using Synthea-generated EHR data to identify preventable patterns, improve care quality, and reduce healthcare costs. Develop a suite of Power BI dashboards to analyze patient readmissions, encounter patterns, and financial impacts using the Synthea EHR dataset. 

**Tools Used:**
•	Power BI
•	Microsoft Excel (lightweight review)
•	SQL (data querying/Cleaning)

----

**Data Source & Preparation**
**Data Source:**
Synthea - Synthetic Patient Generator
Dataset Access:
1.	Java.
2.	Cloned the Synthea repository:
            git clone https://github.com/synthetichealth/synthea.git
            cd synthea
3.	Enabled CSV output by editing the config file:
        	File: synthea/src/main/resources/synthea.properties
        	Change to: 	exporter.fhir.export = false,
  	                    exporter.csv.export = true
5.	Ran the generator:
	       ./run_synthea -p 10000
6.	CSV files generated in:
	synthea/output/csv/

**Tables Used (7):**
•	Patient
•	Encounter
•	Condition
•	Medication
•	Claim
•	Claim_Transaction
•	Payers

**Preparation:**
SQL Data Cleaning:
1.	Standardize Date Formats - Ensure consistency across STARTDATE, STOPDATE, FROMDATE, TODATE.
2.	Filter Valid Encounters - Remove test/pseudo records, filter to inpatient, emergency, Urgentcare.
3.	Create Discharge Dates Table - Calculate previous STOPDATEs per patient to track readmissions.
4.	Create Views:
o	v_TrueReadmissions (based on Inpatient Encounters)
o	v_ProxyReadmissions (based on Emergency/UrgentCare encounters)


![patient 1](https://github.com/user-attachments/assets/df1e96f1-5373-4951-9e0b-d9a768dec884)
![encounter 1](https://github.com/user-attachments/assets/db156eb1-e3d9-4893-ad4d-cc7618638004)
![Claim1](https://github.com/user-attachments/assets/7efc8f59-5924-4b19-83c0-d1b18fc97d3a)

----

**Power BI Setup**
**Overview:**
Using the Synthea synthetic EHR dataset to build three interactive and interlinked Power BI dashboards:
1.	Patient Overview
2.	Encounter Analysis
3.	Insurance & Financial Impact
The dashboards use a DAX-driven approach to identify and quantify readmissions, categorize encounter types (e.g., inpatient, emergency, urgent care), and evaluate financial metrics such as claim charges and outstanding balances. Key calculations rely on the ReadmissionFlags table for defining true and proxy readmissions and transaction data from claim_transactions.

**Key Objectives**
•	Patient Overview: Visualize demographics, readmission counts, and risk profiles to highlight high-risk groups.
•	Encounter Analysis: Track patterns in encounter types, time gaps, and readmission timelines.
•	Insurance & Financial Impact: Quantify the financial implications of readmissions by insurance type and patient risk.

----

**Data Model:**
Primary Tables:
•	encounters: Includes patient_id, encounter_id, encounterclass, STARTDATE, STOPDATE, payer, and derived DAX metrics (e.g., DaysToPrev, TimeGapBin, LengthOfStay).
•	patients: Contains patient_id, gender, birth_date, and DAX-derived Age and AgeGroup.
•	claims: Stores CLAIM_ID, PATIENT_ID, PRIMARYPATIENTINSURANCEID, SERVICEDATE, and APPOINTMENTID.
•	claim_transactions: Includes claim_id, transaction type, amount, and outstanding.
•	payers: Maps payer_id to payer_name (e.g., private, Medicare, Medicaid).
•	ReadmissionFlags (DAX table): Maps encounter_id to TrueReadmission and ProxyReadmission.

**Data Relationships:**
•	Proper relationships between tables (1: Many between patient and other entities).
•	Star schema approach where possible.
•	Use calculated tables/measures to support dashboards.
o	A slicer table ReadmissionParameter provides True/Proxy filter options.
o	A DateTable created to link dates on from different table etc..

----

**Dashboard Summaries**

**1. Patient Overview Dashboard**

**Purpose:** Summarize patient demographics, readmission statistics, and risk levels.

**Key DAX Metrics:**
•	TotalPatients: Count of distinct patients.
•	TrueReadmitted: Patients with Inpatient readmission.
•	ProxyReadmitted: Patient with Urgentcare & Emergency
•	ReadmittedPatients_30days
•	Readmission Encounters by Condition

**Visual Highlights:**
•	KPI Cards: Total patients, readmissions, average age.
•	Pie Chart: Readmissions by age group.
•	Bar Chart: Encounters by Condition.

**KeyInsight:**
Patients aged 60+ and those with long inpatient stays have significantly higher readmission rates.

![Patient page](https://github.com/user-attachments/assets/a3eb5fd4-a662-408b-8579-3a71b38753c9)

----

**2. Encounter Analysis Dashboard**

**Purpose:** Analyze encounter dynamics and how they relate to readmissions.

**Key DAX Metrics:**
•	TrueReadmissionCount, ProxyReadmissionCount
•	SelectedReadmissionRate: Based on slicer selection (True/Proxy)
•	ReadmissionByEncounterClass: Disaggregated view by encounter type

**Visual Highlights:**
•	Area Chart: Trend of readmissions over time by encounter type.
•	Funnel: Flow from initial to readmit encounter types.
•	Column: Time gap distributions.
•	Scatter Plot: Stay duration vs. readmission rate.

**KeyInsight:**
Emergency visits often precede inpatient readmissions. March and December are peak readmission windows, possibly cause of the festive seasons

![Encounter Analysis](https://github.com/user-attachments/assets/6cc3455c-2a55-46a6-b4f2-a892576d8157)

----

**3. Insurance & Financial Impact Dashboard**

**Purpose:**
Evaluate how readmissions impact claim amounts, insurance coverage, and unpaid balances.

**Key DAX Metrics:**
•	TotalClaimAmount, ReadmissionClaimAmount, AvgClaimPerReadmission
•	Financial breakdown: ReadmissionCharges, Payments, Transfers, Outstanding

**Visual Highlights:**
•	Stacked Column Chart: Readmissions by insurance type and encounter class.
•	KPI Card: Average claim per readmission.
•	Clustered Column Chart: Cost comparison (readmitted vs. non-readmitted).
•	Area Chart: Cost Timeline 

**KeyInsight:**
Medicare pays the highest. No-Insurance patients accumulate the largest unpaid balances.

![Financial Impact report](https://github.com/user-attachments/assets/3ff6ea95-f69e-422e-9019-1d3f137b8c27)

----

**4. Interactivity **
•	Cross-filter by Readmission Type (True vs Proxy).
•	Date and ReadmissionType Selector slicers control most visuals.

----

**5. Insights and Impact**
•	Ambutory visits often lead to inpatients (True Admission)
•	Certain encounterclass had shorter discharge → readmit gaps.
•	Medication review due(situation) Conditions description had highest true readmission.
•	The highest stay of patients is 0-7days

**Analyzed/Prepared By:**
Oladokun Abisola
Data Analyst
May 2025


