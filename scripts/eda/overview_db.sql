/*
================================================
Script to get an overview of the database
================================================
Purpose:
  - to check the metadata of the warehouse database with all the tables in them
  - second script prints the tables with all the columns present 
*/

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA IN ('dw_gold','dw_silver','dw_bronze');

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA IN ('dw_gold','dw_silver','dw_bronze');
