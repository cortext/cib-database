/* ============ UNIT TESTING ================ */

USE corporate_invention_board;

SELECT 'TESTING INSTALLATION' as 'INFO';

SET @schema_name = 'corporate_invention_board';

/* ============ CRC FIRMS TABLES ================ */
SET @table_firm_address = 'cib_firm_address';

SET @table_firm_financial = 'cib_firm_financial';

SET @table_firm_names = 'cib_firm_names';

SET @table_firm_sector = 'cib_firm_sector';

SET @table_firms = 'cib_firms';

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_firm_address;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_firm_financial;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_firm_names;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_firm_sector;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_firms;

/* ============ CRC PATENT TABLES ================ */

SET @table_patents_actors = 'cib_patents_actors';

SET @table_patents_inventors = 'cib_patents_inventors';

SET @table_patents_prior_attr = 'cib_patents_priority_attributes';

SET @table_patents_tech_class = 'cib_patents_technological_classification';

SET @table_patents_txt_info = 'cib_patents_textual_information';

SET @table_patents_value = 'cib_patents_value';

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_actors;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_inventors;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_prior_attr;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_tech_class;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_txt_info;

SELECT Md5(Group_concat(column_name)) AS crc
FROM   information_schema.columns
WHERE  table_schema = @schema_name
       AND table_name = @table_patents_value; 
