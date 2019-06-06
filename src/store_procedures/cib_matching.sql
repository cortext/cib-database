DROP PROCEDURE IF EXISTS cib_matching;

DELIMITER $$
$$
CREATE DEFINER=`user`@`%` PROCEDURE `cib_matching`(IN name_match CHAR(20), 
IN `method` CHAR(20), IN `filter` CHAR(20))
BEGIN
	
	DECLARE matching CHAR(50);
	DECLARE name_for_where VARCHAR(255);
    DECLARE name_clause VARCHAR(500);
	DECLARE join_clause VARCHAR(500);
	DECLARE condition_clause VARCHAR(20);
	DECLARE where_clause VARCHAR(500);
	SET @matching = CONCAT(name_match, '|', `method`);
	SET @dt =  NOW();

	SET @name_clause = CONCAT('(CASE ', name_match, 
	    		' WHEN original THEN A.original 
	    		WHEN magerman THEN A.magerman
	    		WHEN patstat_std THEN A.patstat_std
	    		WHEN manual THEN A.manual
	    		WHEN manual2 THEN A.manual2
	    		WHEN manual3 THEN A.manual3
			    END)');
	 	
    SET @SQLText = 	CONCAT(' INSERT INTO cibmatch_log
		SELECT new_bvd_id, original, ', @name_clause ,' AS name_for_match, 
		B.doc_std_name_id, B.doc_std_name, 
		@matching as match_type, @`filter`, @dt FROM global_ultimate_owners AS A
		INNER JOIN cibmatch_patstat_applicants AS B
		ON A.cnty_iso = B.iso_ctry
		AND ', @name_clause ,' = B.doc_std_name;');    

    PREPARE stmt FROM @SQLText;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
   
END
END$$
DELIMITER ;

