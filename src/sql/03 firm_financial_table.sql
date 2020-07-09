/*
This script aims to organize the financial data extracted by orbis not storing the
financial data by columns for each year, but instead pivoting the year columns into
new records
 */

CALL pivot_financial_table('tmp_cib_firm_financial_data', 10);

/* Cleaning steps for NULL values */

SET @table_name = 'tmp_cib_firm_financial_data';
CALL normalize_null(@table_name, 'operating_revenue_eur');
CALL normalize_null(@table_name, 'net_income_eur');
CALL normalize_null(@table_name, 'total_assests_eur');
CALL normalize_null(@table_name, 'number_employees');
CALL normalize_null(@table_name, 'roe_percent_before_taxes');
CALL normalize_null(@table_name, 'roa_percent_before_taxes');

/*
Insert into the final table (cib_firm_financial_data) in order to check
that all data meets the requirements for the financial data types.
 */

DELETE FROM tmp_cib_firm_financial_data
WHERE     ( net_income_eur IS NULL AND
    number_employees IS NULL AND
    total_assests_eur IS NULL AND
    number_employees IS NULL AND
    roe_percent_before_taxes IS NULL AND
    roa_percent_before_taxes IS NULL AND
    operating_revenue_eur IS NULL);

UPDATE tmp_cib_firm_financial_data A
INNER JOIN `tmp_r&d_investments_data` B
ON A.firmreg_id = B.firmreg_id
SET A.`r&d_investment_eur_millions` = 
  CASE 
    WHEN A.`year` = '2017' THEN B.`r&d_2017`
    WHEN A.`year` = '2016' THEN B.`r&d_2016`
    WHEN A.`year` = '2015' THEN B.`r&d_2015`
    WHEN A.`year` = '2014' THEN B.`r&d_2014`
    WHEN A.`year` = '2013' THEN B.`r&d_2013`
    WHEN A.`year` = '2012' THEN B.`r&d_2012`
    WHEN A.`year` = '2011' THEN B.`r&d_2011`
    WHEN A.`year` = '2010' THEN B.`r&d_2010`
    WHEN A.`year` = '2009' THEN B.`r&d_2009`
    WHEN A.`year` = '2008' THEN B.`r&d_2008`
    WHEN A.`year` = '2007' THEN B.`r&d_2007`
    WHEN A.`year` = '2006' THEN B.`r&d_2006`
    WHEN A.`year` = '2005' THEN B.`r&d_2005` 
    WHEN A.`year` = '2004' THEN B.`r&d_2004` 
    ELSE ""
  END;
  
SET @table_name = 'r&d_investment_eur_millions';
CALL `add_missing_r&d`(@table_name, 2017);
CALL `add_missing_r&d`(@table_name, 2016);
CALL `add_missing_r&d`(@table_name, 2015);
CALL `add_missing_r&d`(@table_name, 2014);
CALL `add_missing_r&d`(@table_name, 2013);
CALL `add_missing_r&d`(@table_name, 2012);
CALL `add_missing_r&d`(@table_name, 2011);
CALL `add_missing_r&d`(@table_name, 2010);
CALL `add_missing_r&d`(@table_name, 2009);
CALL `add_missing_r&d`(@table_name, 2008);
CALL `add_missing_r&d`(@table_name, 2007);
CALL `add_missing_r&d`(@table_name, 2006);
CALL `add_missing_r&d`(@table_name, 2005);
CALL `add_missing_r&d`(@table_name, 2004);

  
INSERT INTO cib_firm_financial_data
SELECT * FROM tmp_cib_firm_financial_data;
