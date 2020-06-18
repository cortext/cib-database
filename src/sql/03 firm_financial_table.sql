/*
   This script aims to organize the financial data extracted by orbis not storing the 
   financial data by columns for each year, but instead pivoting the year columns into
   new records 
*/

CALL pivot_financial_table('tmp_cib_firm_financial_data', 10);

/* Cleaning steps for NULL values */

SET @table_name = 'tmp_cib_firm_financial_data';
CALL normalize_null(@table_name, 'operating_revenue_eur');
CALL normalize_null(@table_name, 'operating_revenue_eur');
CALL normalize_null(@table_name, 'net_income_eur');
CALL normalize_null(@table_name, 'net_income_usd');
CALL normalize_null(@table_name, 'total_assests_eur');
CALL normalize_null(@table_name, 'total_assests_usd');
CALL normalize_null(@table_name, 'number_employees');
CALL normalize_null(@table_name, 'roe_percent_before_taxes');
CALL normalize_null(@table_name, 'roa_percent_before_taxes');

/* 
   Insert into the final table (cib_firm_financial_data) in order to check 
   that all data meets the requirements for the financial data types.  
*/   

INSERT INTO cib_firm_financial_data
SELECT * FROM tmp_cib_firm_financial_data;
