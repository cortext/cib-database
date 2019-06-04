/* This is the selection of applicant with priority patents and patents from years above than 1999, in addition 
 was only selected legal and ambiguos applicants-inventors

 Updated Rows	2'011.402
*/
CREATE TABLE cibmatch_patstat_applicants AS
SELECT A.* FROM patstatAvr2017_lab.applt_addr_ifris AS A 
INNER JOIN patstatAvr2017.tls201_appln_ifris AS B ON A.appln_id = B.appln_id
WHERE (A.`type`='legal' OR A.`type` IS NULL)
AND B.appln_filing_year > 1999 AND B.appln_first_priority_year = 0
GROUP BY A.doc_std_name_id, iso_ctry;

-- Updated Rows	939.766
-- Total cibmatch_patstat_applicants: 1071636
DELETE FROM cibmatch_patstat_applicants WHERE iso_ctry = "";

ALTER TABLE cibmatch_patstat_applicants MODIFY COLUMN doc_std_name varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL;
CREATE INDEX cibmatch_patstat_applicants_iso_ctry_IDX USING BTREE ON cib_matching_v2.cibmatch_patstat_applicants (iso_ctry,doc_std_name);
CREATE INDEX cibmatch_patstat_applicants_doc_std_IDX USING BTREE ON cib_matching_v2.cibmatch_patstat_applicants (doc_std_name_id);


CREATE TABLE global_ultimate_owners AS
SELECT * FROM t_juan.CIBmatch_global_ultimate_owners;

CREATE INDEX global_ultimate_owners_original_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (original);
CREATE INDEX global_ultimate_owners_magerman_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (magerman);
CREATE INDEX global_ultimate_owners_patstat_std_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (patstat_std);
CREATE INDEX global_ultimate_owners_manual_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (manual);
CREATE INDEX global_ultimate_owners_manual2_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (manual2);
CREATE INDEX global_ultimate_owners_manual3_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (manual3);
CREATE INDEX global_ultimate_owners_cnty_IDX USING BTREE ON cib_matching_v2.global_ultimate_owners (cnty_iso);

CREATE TABLE IF NOT EXISTS cibmatch_log ( 
	new_bvd_id VARCHAR(255),
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id VARCHAR (255),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	country VARCHAR(255),
	N_Patents VARCHAR(255)
);


-- Variable declaration for the stored procedure used for matching orbis companies names 
-- with patstat applicant names
SET @original = 'original';
SET @magerman = 'magerman';
SET @patstat_std = 'patstat_std';
SET @manual = 'manual';
SET @manual2 = 'manual2';
SET @manual3 = 'manual3';
SET @method = 'exact';
SET @filter = 'country';

CALL cib_matching(@original, @method, @filter);
CALL cib_matching(@magerman, @method, @filter);
CALL cib_matching(@patstat_std, @method, @filter);
CALL cib_matching(@manual, @method, @filter);
CALL cib_matching(@manual2, @method, @filter);
CALL cib_matching(@manual3, @method, @filter);

SET @method = 'like';

CALL cib_matching(@original, @method, @filter);
CALL cib_matching(@magerman, @method, @filter);
CALL cib_matching(@patstat_std, @method, @filter);
CALL cib_matching(@manual, @method, @filter);
CALL cib_matching(@manual1, @method, @filter);
CALL cib_matching(@manual2, @method, @filter);

SET @method = 'like_prefix'

CALL cib_matching(@original, @method, @filter);
CALL cib_matching(@magerman, @method, @filter);
CALL cib_matching(@patstat_std, @method, @filter);
CALL cib_matching(@manual, @method, @filter);
CALL cib_matching(@manual1, @method, @filter);
CALL cib_matching(@manual2, @method, @filter);

UPDATE CIBmatch_summarize_matching AS A
SET N_Patents = (SELECT COUNT(*) 
				 	FROM patstatAvr2017.applt_addr_ifris AS B
				 WHERE A.doc_std_name_id = B.doc_std_name_id
				 GROUP BY A.doc_std_name_id, A.match_type);

 
