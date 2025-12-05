/*
=====================================================================================
Setting up the environment settings on MySQL server running locally on my machine 
=====================================================================================
Purpose: 
  - this file will contain server settings that maybe turned on or off depending on the need of the project
WARNING:
  - code maybe added as per needed and comments will indicate how to run those code snippets for optimum results 
*/

-- Run once per session in the server, allows for importing data from local to the locally run sql server directly
SET GLOBAL local_infile = 1;

-- Run once per session in the server, allows for simple substitution with manual logic checks for NULLS
SET sql_mode = 'NO_ENGINE_SUBSTITUTION';
