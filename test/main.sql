DROP TABLE IF EXISTS expected_values, found_values, tchecksum, unit_test_results;
CREATE TABLE expected_values (
    table_name varchar(50) not null primary key,
    recs int not null,
    columns_md5 varchar(100) not null,
    indexes_md5 varchar(100) not null,
    data_types_md5 varchar(100) not null,
    proportional_size float not null
) ENGINE=MyISAM;

CREATE TABLE unit_test_results (
    table_name varchar(50) not null primary key,
    records_exact_match varchar(6) not null,
    columns_match varchar(6) not null,
    data_type_match varchar(6) not null,
    indexes_match varchar(6) not null,
    consistency varchar(6) not null
) ENGINE=MyISAM;


CREATE TABLE found_values LIKE expected_values;

INSERT INTO expected_values 
            (table_name,
             recs,
             columns_md5,
             indexes_md5,
             data_types_md5,
             proportional_size)
VALUES      ('cib_firm_address',
             4001,
             '8ea78565413f1a67f2d15b25057f4121',
             'b780b3cdf7af019d6ded12f1e26be708',
             'e252275835dabd23d355b646e4f59545',
             1.00225),
            ('cib_firm_financial_data',
             11271,
             '1315f35d7c8dbb7629183b6843070fd3',
             'ad2b188f33daec91db650c77a74bb07d',
             'e252275835dabd23d355b646e4f59545',
             2.8234),
            ('cib_firm_names',
             7234,
             '68cbcfd62f2d20788435c77789e6939e',
             '47acfe4164232128fb9fcacc6661426a',
             'e252275835dabd23d355b646e4f59545',
             1.81212),
            ('cib_firm_sector',
             3992,
             '03f20591fdce1cbd48df67d53b092805',
             '62fea4099b6fdac6c565763adb8aece4',
             'e252275835dabd23d355b646e4f59545',
             1),
            ('cib_firms',
             3992,
             'ca0e84618b5f9a615b5b09b2fdf232f9',
             '5195709aa091ff80c92d64e14857158b',
             '0f8e66026c1a947967e1cc9fa9f58b8c',
             1),
            ('cib_patents_actors',
             6377887,
             '658c879ffb4f3c340dd9e3392f8c3aeb',
             'a65a79a1d1c81e98a1b9cb74afe51b7f',
             'ae961e2ecf7b6697b3b7017b2d0aac27',
             1),
            ('cib_patents_inventors',
             15792193,
             '143eb3f337a46ecf6360158b82ccd526',
             'e8171b46af83b62d6508d170c949f19a',
             'e6a95f5461b715256d09987643e0cbb8',
             2.47609),
            ('cib_patents_priority_attributes',
             6179588,
             '83686f6d931c5f4bf8d6f9bacb648cd9',
             'ff917ddc69fd216f2037b9f1b85f4f60',
             '46771313e0ca9e407fd08aacc1527d9a',
             0.968908),
            ('cib_patents_technological_classification',
             18237980,
             'f8204c5158b4af26fa9da20b5906c696',
             'b89743327bfc09b30444ad1fc5df9cb8',
             'a1d302a4c2f8c7d62f296ffbc01b31e2',
             2.85956),
            ('cib_patents_textual_information',
             6179588,
             'f650195dd258f5e55f30c25d81148bf4',
             '3e40b2438346c17a5387310d14157d75',
             '46771313e0ca9e407fd08aacc1527d9a',
             0.968908),
            ('cib_patents_value',
             6179588,
             '851da38865ff8a8716aae1220d8193eb',
             '7d50aaaa76a705e2b28de5e49d009d38',
             '3ae829ee705d7ba61f487ea1fdd874a3',
             0.968908); 


CREATE TABLE tchecksum (chk char(100)) ENGINE=blackhole;

SELECT table_name,
       recs              AS 'expected_records',
       columns_md5       AS 'expected_columns',
       data_types_md5    AS 'expected_data_types',
       indexes_md5       AS 'expected_indexes',
       proportional_size AS 'proportional_size'
FROM   expected_values ev; 

-- SET @schema_name = 'corporate_invention_board_v2.0.1';
SET @schema_name = 'CIB_2020_v2_lab';
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
