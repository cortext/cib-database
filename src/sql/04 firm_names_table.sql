SET @table_name = 'tmp_cib_firm_names';
CALL normalize_null(@table_name, 'previous_name');
CALL normalize_null(@table_name, 'previous_name_date');
CALL normalize_null(@table_name, 'aka_name');

INSERT INTO cib_firm_names
SELECT *, "", "" FROM tmp_cib_firm_names;
