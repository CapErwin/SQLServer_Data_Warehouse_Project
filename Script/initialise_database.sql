/*
=============================================================
Create Database and Schemas
=============================================================

Quick Note on What This Script Does
	This script sets up a fresh DataWarehouse database.	
	First, it checks if the database already exists. 
	If it does, it drops it and recreates it from scratch—so be careful. 
	Once that’s done, it creates three schemas: 
	bronze, silver, and gold, which we’ll use for staging, cleaned, and final data respectively.

Important
Just a heads-up: this will wipe out the existing DataWarehouse database completely. 
All the data will be gone. 
Make sure you’ve backed up anything important before you run it.

*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
