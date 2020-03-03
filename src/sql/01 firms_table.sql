SET @table_name = 'tmp_cib_firms';
CALL normalize_null(@table_name, 'iso_ctry');
CALL normalize_null(@table_name, 'nace2_main_section');
CALL normalize_null(@table_name, 'category');
CALL normalize_null(@table_name, 'status');
CALL normalize_null(@table_name, 'quoted');
CALL normalize_null(@table_name, 'I_GUO');
CALL normalize_null(@table_name, 'incorporation_date');
CALL normalize_null(@table_name, 'last_year_account_available');

INSERT INTO cib_firms
SELECT * FROM tmp_cib_firms;
