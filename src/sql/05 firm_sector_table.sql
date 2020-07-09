SET @table_name = 'tmp_cib_firm_sector';
CALL normalize_null(@table_name, 'nace2_primary_code');
CALL normalize_null(@table_name, 'nace2_primary_label');
CALL normalize_null(@table_name, 'nace2_secondary_code');
CALL normalize_null(@table_name, 'nace2_secondary_label');

INSERT INTO cib_firm_sector 
SELECT * FROM tmp_cib_firm_sector;
