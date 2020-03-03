DROP TABLE IF EXISTS found_values, tchecksum, unit_test_results;

CREATE TABLE unit_test_results (
    table_name varchar(50) not null primary key,
    records_exact_match varchar(6) not null,
    columns_match varchar(6) not null,
    data_type_match varchar(6) not null,
    indexes_match varchar(6) not null,
    consistency varchar(6) not null
) ENGINE=MyISAM;


CREATE TABLE found_values LIKE expected_values;

CREATE TABLE tchecksum (chk char(100)) ENGINE=blackhole;

SELECT table_name,
       recs              AS 'expected_records',
       columns_md5       AS 'expected_columns',
       data_types_md5    AS 'expected_data_types',
       indexes_md5       AS 'expected_indexes',
       proportional_size AS 'proportional_size'
FROM   expected_values ev; 

SET @schema_name = 'cib_database_v2.0.1';
ALTER TABLE found_values DROP COLUMN proportional_size;


CALL create_found_values(@schema_name , 'cib_firm_address'); 
CALL create_found_values(@schema_name , 'cib_firm_financial_data'); 
CALL create_found_values(@schema_name , 'cib_firm_names'); 
CALL create_found_values(@schema_name , 'cib_firm_sector'); 
CALL create_found_values(@schema_name , 'cib_firms'); 
CALL create_found_values(@schema_name , 'cib_patents_actors'); 
CALL create_found_values(@schema_name , 'cib_patents_inventors'); 
CALL create_found_values(@schema_name , 'cib_patents_priority_attributes'); 
CALL create_found_values(@schema_name , 'cib_patents_technological_classification');
CALL create_found_values(@schema_name , 'cib_patents_textual_information');
CALL create_found_values(@schema_name , 'cib_patents_value');

SELECT table_name,
       recs              AS 'found_records',
       columns_md5       AS 'found_columns',
       data_types_md5    AS 'found_data_types',
       indexes_md5       AS 'found_indexes'
FROM   found_values fv; 

CALL unit_test('cib_firm', 0.2); 
CALL unit_test('cib_patent', 0.2);

SELECT * FROM unit_test_results;

SET @records_count=(SELECT count(*) FROM unit_test_results WHERE
records_exact_match = 'not ok');

SET @columns_match=(SELECT count(*) FROM unit_test_results WHERE columns_match =
'not ok');

SET @data_types=(SELECT count(*) FROM unit_test_results WHERE data_type_match =
'not ok');

SET @indexes=(SELECT count(*) FROM unit_test_results WHERE indexes_match =
'not ok');

SET @consistency=(SELECT count(*) FROM unit_test_results WHERE consistency =
'not ok');

SELECT Timediff(Now(), (SELECT create_time
                        FROM   information_schema.tables
                        WHERE  table_schema = @schema_name
                               AND table_name = 'expected_values')) AS
       computation_time;

DROP TABLE expected_values, found_values, unit_test_results, tchecksum;

SELECT 'records_count'                      AS summary,
       IF(@records_count = 0, "ok", "fail") AS 'result'
UNION ALL
SELECT 'columns',
       IF(@columns_match = 0, "ok", "fail")
UNION ALL
SELECT 'data_types' AS summary,
       IF(@data_types = 0, "ok", "fail")
UNION ALL
SELECT 'indexes',
       IF(@indexes = 0, "ok", "fail")
UNION ALL
SELECT 'consistency',
       IF(@consistency = 0, "ok", "fail"); 
