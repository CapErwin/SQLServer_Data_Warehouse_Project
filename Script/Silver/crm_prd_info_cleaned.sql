/*
===============================================================================
Transformation Script: Clean and Load CRM Product Info to Silver Layer
===============================================================================
Script Purpose:
    This script transforms and loads cleaned product data from the bronze 
    layer into the silver.crm_prd_info table. If the table already exists, 
    it will be dropped and recreated with updated schema and logic.

Key Transformations:
    - Drops and recreates the silver.crm_prd_info table.
    - Converts datetime fields (prd_start_dt, prd_end_dt) to DATE format.
    - Extracts a new cat_id column from the first 5 characters of prd_key,
      replacing hyphens with underscores.
    - Cleans prd_key by removing the category prefix.
    - Replaces NULLs in prd_cost with 0.
    - Normalizes prd_line values using defined mappings:
        'S' → 'Other Sales', 'R' → 'Road', 'M' → 'Mountain', 'T' → 'Touring',
        others → 'n/a'.
    - Calculates prd_end_dt using LEAD() to find the day before the next
      product's start date (partitioned by prd_key).
    - Adds dwh_create_date column with default value GETDATE() for metadata.
===============================================================================
*/

SELECT * FROM silver.crm_cust_info;

-- UPDATE THE METADATE OF THE datetime to date, and add a new column(cat_id) from seperating prd_key code.

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,	
	prd_end_dt DATE,
	dwh_create_date DATETIME DEFAULT GETDATE()
);

INSERT INTO silver.crm_prd_info (
	prd_id, 
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,	
	prd_end_dt)

SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
		WHEN 'S' THEN 'Other Sales'
		WHEN 'R' THEN 'Road'
		WHEN 'M' THEN 'Mountain'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
END prd_line,
prd_start_dt,
DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM bronze.crm_prd_info;
