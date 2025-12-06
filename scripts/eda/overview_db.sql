/*
================================================
Script to get an overview of the database
================================================
Purpose:
  - to check the metadata of the warehouse database with all the tables in them

*/
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA IN ('dw_gold','dw_silver','dw_bronze');
