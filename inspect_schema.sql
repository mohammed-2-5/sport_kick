-- SQL Query to Inspect 'fields' Table Schema
-- Run this to see all columns and their data types

SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM 
    information_schema.columns
WHERE 
    table_name = 'fields'
ORDER BY 
    ordinal_position;
