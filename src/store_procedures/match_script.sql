USE `CIB_2`;
DROP PROCEDURE IF EXISTS matching_orbis_patstat;

DELIMITER $$
$$
CREATE DEFINER=`gnupablo`@`%` PROCEDURE `match_orbis_patstat`(orbis_name VARCHAR(50),  
              match_type VARCHAR(10), ctry_filter INT UNSIGNED)
BEGIN
    DECLARE var_char INT DEFAULT 0;
    
    INSERT INTO CIBmatch_summarize_matching
    SELECT A.new_bvd_id, A.original, A.manual, 
        B.doc_std_name_id, B.doc_std_name, 'manual|exact' as match_type, 
        A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
    INNER JOIN CIBmatch_applt_risis_patents AS B
    ON A.cnty_iso = B.iso_ctry
    WHERE A.manual <> "" AND A.manual = B.doc_std_name;
END$$
DELIMITER ;
