/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
    This script initializes three different databases in a MySQL server representing 
    the three layers of a Medallion style Data Warehouse.

MySQL Architecture Note:
    Since MySQL doesn't support hierarchical Schemas inside databases, we define 
    three separate databases, unlike the "One Database -> 3 Schemas" approach 
    popular in PostgreSQL and SQL Server.

WARNING:
    Use this script carefully! It DROPS all the existing layer databases and 
    initializes them once again from an empty state. All existing data will be lost.
===============================================================================
*/
DROP DATABASE IF EXISTS dw_bronze;
CREATE DATABASE dw_bronze;

DROP DATABASE IF EXISTS dw_silver;
CREATE DATABASE dw_silver;

DROP DATABASE IF EXISTS dw_gold;
CREATE DATABASE dw_gold;
