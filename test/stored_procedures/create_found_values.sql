CREATE PROCEDURE create_found_values(
IN schema_name_cib VARCHAR(255),
IN table_name_cib VARCHAR(255))
BEGIN
	
	/* columns */
	INSERT INTO tchecksum 
	SELECT @columns_md5 := Md5(Group_concat(column_name)) AS columns_md5
	FROM   information_schema.columns
	WHERE  table_schema = schema_name_cib
       AND table_name = table_name_cib
	ORDER BY column_name ASC;

	/* data_type */
	INSERT INTO tchecksum 
	SELECT @data_type_md5 := Md5(Group_concat(data_type)) AS data_type_md5
	FROM   information_schema.columns
	WHERE  table_schema = schema_name_cib
       AND table_name = table_name_cib
	ORDER BY data_type ASC;

	/* indexes */
	INSERT INTO tchecksum 
	SELECT @indexes_md5 := Md5(Group_concat(column_name)) as indexes_md5
	FROM information_schema.statistics
	WHERE table_schema = schema_name_cib
	AND table_name = table_name_cib
	ORDER BY column_name ASC;

	SET @query = CONCAT('SELECT @total_records := COUNT(*) FROM ', table_name_cib); 

	PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;

	/* Insert collected variables into the found_values table */ 
	INSERT INTO found_values values (table_name_cib, @total_records, @columns_md5, @data_type_md5, @indexes_md5);

END 
