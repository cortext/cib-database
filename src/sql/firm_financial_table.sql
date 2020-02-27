/*
   This script aims to organize the financial data extracted by orbis not storing the 
   financial data by columns for each year, but instead pivoting the year columns into
   new records 
*/

INSERT INTO cib_firm_financial_data
SELECT guo_orbis_id,
       last_year - 2,
       operating_revenue_two_years_previous_last_year,
       total_assests_two_years_previous_last_year,
       number_employees_two_years_previous_last_year,
       pl_before_taxes_two_years_previous_last_year,
       roe_using_pl_before_taxes_two_years_previous_last_year,
       roa_using_pl_before_taxes_two_years_previous_last_year
FROM   cib_firm_financial_data_cluttered; 

INSERT INTO cib_firm_financial_data
SELECT guo_orbis_id,
       last_year - 1,
       operating_revenue_previous_last_year,
       total_assests_previous_last_year,
       number_employees_previous_last_year,
       pl_before_taxes_previous_last_year,
       roe_using_pl_before_taxes_previous_last_year,
       roa_using_pl_before_taxes_previous_last_year
FROM   cib_firm_financial_data_cluttered; 

INSERT INTO cib_firm_financial_data
SELECT guo_orbis_id,
       last_year,
       operating_revenue_last_year,
       total_assests_last_year,
       number_employees_last_year,
       pl_before_taxes_last_year,
       roe_using_pl_before_taxes_last_year,
       roa_using_pl_before_taxes_last_year
FROM   cib_firm_financial_data_cluttered; 
