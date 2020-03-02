CREATE DEFINER=`gnupablo`@`%` PROCEDURE `CIB_2020_v2_lab`.`unit_test`(IN tables_type char(50),
IN minimum_absolute_tolerance float)
BEGIN
	
-- minimum_absolute_tolerance
SET @mabt = minimum_absolute_tolerance;


/* The origin of cib_firm tables comes from the table cib_firms, that's why
 * we use the number of record from this table as a reference in order to 
 * calculate the consistency of the other cib_firm tables.
 */
SELECT fv.recs FROM found_values fv 
WHERE table_name = 'cib_firms'
INTO @count_firms;


/* The origin of cib_patents tables comes from the table cib_patents_actors, 
 * that's why we use the number of record from this table as a reference 
 * in order to calculate the consistency of the other cib_patents tables.
 */
SELECT ev.recs FROM expected_values ev
WHERE table_name = 'cib_patents_actors'
INTO @count_patents;


/* As is stated above the origin of the tables differ, between cib_firm and cib_patents */
IF tables_type = 'cib_firm' THEN

    INSERT INTO unit_test_results
	SELECT     e.table_name,
             IF(e.recs=f.recs,'ok', 'not ok')                 AS records_exact_match,
             IF(e.columns_md5 = f.columns_md5 ,'ok','not ok') AS columns_match,
             IF(e.data_types_md5 = f.data_types_md5 ,'ok','not ok') AS data_type_match,
             IF(e.indexes_md5 = f.indexes_md5 ,'ok','not ok') AS indexes_match,
             IF(e.recs > @count_firms * (e.proportional_size - @mabt) 
                AND e.recs < @count_firms * (e.proportional_size + @mabt),'ok','not ok') 
                AS consistency
  FROM       expected_values e
  INNER JOIN found_values f
  USING      (table_name)
  WHERE      e.table_name IN ('cib_firm_address',
                              'cib_firm_financial_data',
                              'cib_firm_names',
                              'cib_firm_sector',
                              'cib_firms');
ELSEIF
  tables_type = 'cib_patent' THEN
  
  INSERT INTO unit_test_results
  SELECT     e.table_name,
             IF(e.recs=f.recs,'ok', 'not ok')                 AS records_match,
             IF(e.columns_md5 = f.columns_md5 ,'ok','not ok') AS columns_match,
             IF(e.data_types_md5 = f.data_types_md5 ,'ok','not ok') AS data_type_match,
             IF(e.indexes_md5 = f.indexes_md5 ,'ok','not ok') AS indexes_match,
             IF(e.recs > @count_patents * (e.proportional_size - @mabt) 
                AND e.recs < @count_patents * (e.proportional_size + @mabt),'ok','not ok')
                AS consistency
  FROM       expected_values e
  INNER JOIN found_values f
  USING      (table_name)
  WHERE      e.table_name IN ('cib_patents_inventors',
                              'cib_patents_priority_attributes',
                              'cib_patents_technological_classification',
                              'cib_patents_textual_information',
                              'cib_patents_value');
END IF;
	
END
