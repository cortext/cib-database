/* ================ Cleaning firm sector table ================ */

SET @table_name = 'cib_firm_sector';
CALL normalize_null(@table_name, 'nace2_primary_code');
CALL normalize_null(@table_name, 'nace2_primary_label');
CALL normalize_null(@table_name, 'nace2_secondary_label');
CALL normalize_null(@table_name, 'nace2_secondary_label');
CALL normalize_null(@table_name, 'nace2_secondary_label');

/* ================ Cleaning financial table ================ */

SET @table_name = 'cib_firm_sector';
CALL normalize_null(@table_name, 'operating_revenue');
CALL normalize_null(@table_name, 'total_assests');
CALL normalize_null(@table_name, 'number_employees');
CALL normalize_null(@table_name, 'pl_before_taxes');
CALL normalize_null(@table_name, 'roe_using_pl_before_taxes')
CALL normalize_null(@table_name, 'roa_using_pl_before_taxes');
