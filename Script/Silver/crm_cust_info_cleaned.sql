/*
===============================================================================
ETL Script: Clean and Load CRM Customer Info from Bronze to Silver
===============================================================================
Script Purpose:
    This script extracts the latest customer records from the Bronze layer,
    performs essential data cleaning and standardization, and inserts the
    results into the Silver layer (`silver.crm_cust_info`) for downstream use.
    
Cleaning & Transformation Steps:
    - Deduplicated customers by keeping only the latest record per `cst_id`
      using `ROW_NUMBER()` with `PARTITION BY` and `ORDER BY cst_create_date DESC`.
    - Trimmed leading/trailing spaces from `cst_firstname` and `cst_lastname`.
    - Standardized `cst_marital_status`:
        'S' → 'Single', 'M' → 'Married', else → 'n/a'
    - Standardized `cst_gndr`:
        'M' → 'Male', 'F' → 'Female', else → 'n/a'
    - Filtered out any records where `cst_id` is null.

Target:
    silver.crm_cust_info
===============================================================================
*/

SELECT * FROM silver.crm_cust_info;

INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE 
		WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
		WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_martial_status,
	CASE 
		WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_gndr,
	cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) AS sub 
WHERE flag_last = 1;
