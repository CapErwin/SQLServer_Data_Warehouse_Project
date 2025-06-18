/*
===============================================================================
Silver Layer - Data Exploration & Integration Modeling
===============================================================================
This script marks the start of the Silver layer in the Medallion architecture,
where raw Bronze data is explored and analyzed for building integration models.

    Objectives:
        - Explore and understand the structure and content of 6 Bronze tables:
            - CRM: crm_cust_info, crm_prd_info, crm_sales_details
            - ERP: erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2
        - Identify and define the relationships between tables to prepare for 
          data integration and transformation in the Silver layer.

    Key Table Relationships:
        - [crm_cust_info] ↔ [crm_sales_details] via (cst_id = sls_cust_id)
        - [crm_prd_info]  ↔ [crm_sales_details] via (prd_key = sls_prd_key)
        - [erp_cust_az12] ↔ [erp_loc_a101] via (cid = cid)
        - [erp_cust_az12] & [erp_loc_a101] ↔ [crm_cust_info] via (cst_key = cid)
        - [erp_px_cat_g1v2] ↔ [crm_prd_info] via (id = prd_key)

	Notes:
        - Some columns may require **data type casting**, **trimming**, or 
          **standardisation**, before joins can be reliably performed.
    
===============================================================================
*/


SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_cust_info]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_prd_info]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_sales_details]

SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_cust_az12]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_loc_a101]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]
