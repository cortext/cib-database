CREATE DEFINER=`gnupablo`@`%` PROCEDURE `CIB_2020_V2_1_LAB`.`add_missing_r&d`(IN tables_name VARCHAR(255),
IN year INT(4))
BEGIN
	
	    SET @query := CONCAT('INSERT INTO tmp_cib_firm_financial_data 
		SELECT A.firmreg_id,', year ,', NULL, NULL, NULL, NULL, 
		NULL, NULL, A.`r&d_', year, '` as rd FROM `tmp_r&d_investments_data` A
		INNER JOIN tmp_cib_firm_financial_data B
		ON A.firmreg_id = B.firmreg_id
		WHERE A.`r&d_', year, '` <> "" AND A.firmreg_id NOT IN (
		SELECT firmreg_id FROM tmp_cib_firm_financial_data
		WHERE year = ', year, ')
		GROUP BY A.firmreg_id;'); 
	
		PREPARE stmt FROM @query;
   		EXECUTE stmt;
   		DEALLOCATE PREPARE stmt;
	
END
