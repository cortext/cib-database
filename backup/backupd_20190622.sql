/* This is the selection of applicant with priority patents and patents from years above than 1999, in addition 
 was only selected legal and ambiguos applicants-inventors

 Updated Rows	2'011.402
*/
CREATE TABLE cibmatch_patstat_applicants AS
SELECT A.* FROM patstatAvr2017_lab.applt_addr_ifris AS A 
INNER JOIN patstatAvr2017.tls201_appln_ifris AS B ON A.appln_id = B.appln_id
WHERE (A.`type`='legal' OR A.`type` IS NULL)
AND B.appln_filing_year > 1999 AND B.appln_first_priority_year = 0
GROUP BY A.doc_std_name_id, A.iso_ctry;

SELECT COUNT(*) FROM patstatAvr2017.applt_addr_ifris;

INSERT INTO cibmatch_patstat_applicants
SELECT B.* FROM cibmatch_patstat_applicants AS A 
INNER JOIN patstatAvr2017_lab.applt_addr_ifris AS B ON A.doc_std_name_id = B.doc_std_name_id 
WHERE (A.iso_ctry IS NULL or A.iso_ctry = "")
AND (B.iso_ctry IS NOT NULL OR B.iso_ctry <> "")
GROUP BY B.doc_std_name_id, B.iso_ctry;

CREATE INDEX cibmatching_patstat_applicants_doc_std_name_id_IDX USING BTREE ON cib_matching_v2.cibmatching_patstat_applicants (doc_std_name_id);

CREATE TABLE cibmatching_patstat_applicants2
SELECT * FROM cibmatch_patstat_applicants;

CREATE INDEX cibmatching_patstat_applicants_doc_std_name_id_IDX USING BTREE ON cib_matching_v2.cibmatching_patstat_applicants2 (doc_std_name_id);

-- Updated Rows	209.500
DELETE FROM cibmatching_patstat_applicants
WHERE iso_ctry = "" AND doc_std_name_id IN (
	SELECT doc_std_name_id FROM cibmatch_patstat_applicants2
	WHERE iso_ctry <> "");

DROP TABLE cibmatch_patstat_applicants2;

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

UPDATE global_ultimate_owners
SET magerman = ""
WHERE magerman = "CHINA";

UPDATE global_ultimate_owners
SET magerman = "China International Marine"
WHERE new_bvd_id = "CN30120PC";

UPDATE global_ultimate_owners
SET magerman = ""
WHERE magerman = "ISRAEL";

CREATE TABLE IF NOT EXISTS cibmatch_log ( 
	new_bvd_id VARCHAR(255),
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id INT (10),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	`filter` VARCHAR(255),
	time_exec TIMESTAMP
);

-- Variable declaration for the stored procedure used for matching orbis companies names 
-- with patstat applicant names
SET @original = 'original';
SET @magerman = 'magerman';
SET @patstat_std = 'patstat_std';
SET @manual = 'manual';
SET @manual2 = 'manual2';
SET @manual3 = 'manual3';
SET @filter = 'country';
SET @method = 'exact';

SELECT COUNT(*) FROM cibmatch_log;
-- Updated Rows	1122 --> 1512
CALL cib_matching(@original, @method, @filter);
-- Updated Rows	390 --> 1989
CALL cib_matching(@magerman, @method, @filter);
-- Updated Rows	38 --> 2045
CALL cib_matching(@patstat_std, @method, @filter);
-- Updated Rows	76 --> 2 150
CALL cib_matching(@manual, @method, @filter);
-- Updated Rows	6 --> 2.163
CALL cib_matching(@manual2, @method, @filter);
-- Updated Rows	0 --> 0
CALL cib_matching(@manual3, @method, @filter);

SET @method = 'like_suffix';

-- Updated Rows 2.649
CALL cib_matching(@original, @method, @filter);
-- Updated Rows 26.014
CALL cib_matching(@magerman, @method, @filter);
-- Updated Rows 26.560
CALL cib_matching(@patstat_std, @method, @filter);
-- Updated Rows 33.243
CALL cib_matching(@manual, @method, @filter);
-- Updated Rows 34.017
CALL cib_matching(@manual2, @method, @filter);
-- Updated Rows 34.070
CALL cib_matching(@manual3, @method, @filter);

SELECT * FROM t_juan.CIBmatch_summarize_matching
WHERE doc_std_name_id NOT IN (SELECT doc_std_name_id FROM cibmatch_log);

SET @method = 'like_prefix'

-- 
CALL cib_matching(@original, @method, @filter);
-- 
CALL cib_matching(@magerman, @method, @filter);
-- 
CALL cib_matching(@patstat_std, @method, @filter);
-- 
CALL cib_matching(@manual, @method, @filter);
-- 
CALL cib_matching(@manual2, @method, @filter);
-- 
CALL cib_matching(@manual3, @method, @filter);

SET @method = 'full_like'

-- 
CALL cib_matching(@original, @method, @filter);
-- 
CALL cib_matching(@magerman, @method, @filter);
-- 
CALL cib_matching(@patstat_std, @method, @filter);
-- 
CALL cib_matching(@manual, @method, @filter);
-- 
CALL cib_matching(@manual2, @method, @filter);
-- 
CALL cib_matching(@manual3, @method, @filter);



UPDATE CIBmatch_summarize_matching AS A
SET N_Patents = (SELECT COUNT(*) 
				 	FROM patstatAvr2017.applt_addr_ifris AS B
				 WHERE A.doc_std_name_id = B.doc_std_name_id
				 GROUP BY A.doc_std_name_id, A.match_type);
				
CREATE TABLE report_guo_matching AS
SELECT A.*, COUNT(*) as N_patents FROM (SELECT * FROM cibmatch_log
GROUP BY new_bvd_id, doc_std_name_id) AS A
INNER JOIN patstatAvr2017.applt_addr_ifris AS B
ON A.doc_std_name_id = B.doc_std_name_id
GROUP BY A.doc_std_name_id, A.new_bvd_id;
		
-- 24374
SELECT COUNT(*) FROM report_guo_matching;

SELECT COUNT(*) FROM global_ultimate_owners
WHERE new_bvd_id NOT IN (SELECT new_bvd_id FROM report_guo_matching);

/*
 * ====================================
 * GENERATING NEW NAMES AND CHECKING MATCHES
 * ====================================
 * 
 */

CREATE VIEW guo_to_keep AS
SELECT * FROM report_guo_matching
WHERE new_bvd_id IN (SELECT new_bvd_id FROM to_keep_csv);

-- 8787
SELECT COUNT(*) FROM guo_to_keep;

CREATE TABLE matches_asia_ok AS
SELECT * FROM to_keep_asia_csv
UNION
SELECT * FROM to_keep_ch_csv
UNION
SELECT * FROM to_keep_jp_csv;

CREATE TABLE report_guo_matching_to_verify
SELECT * FROM report_guo_matching WHERE 
(new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM matches_asia_ok)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_keep_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_keep_ch_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_keep_zeros)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_asia_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_eu_us_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_zeros)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_like_prefix);

CREATE TABLE report_guo_matching_ok
SELECT * FROM report_guo_matching
WHERE (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM report_guo_matching_to_verify)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_asia_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_eu_us_csv)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_like_prefix)
AND (new_bvd_id,doc_std_name_id) NOT IN 
(SELECT new_bvd_id,doc_std_name_id FROM to_delete_zeros);

SELECT A.* FROM manual_name_csv A

CREATE TABLE global_ultimate_owners2
SELECT * FROM global_ultimate_owners;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 22
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual = A.exactmatchingtouse
WHERE (A.exactmatchingtouse <> B.original
AND A.exactmatchingtouse <> B.magerman
AND A.exactmatchingtouse <> B.manual
AND A.exactmatchingtouse <> B.manual2
AND A.exactmatchingtouse <> B.manual3) AND B.manual = "";

-- 19
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual2 = A.exactmatchingtouse
WHERE (A.exactmatchingtouse <> B.original
AND A.exactmatchingtouse <> B.magerman
AND A.exactmatchingtouse <> B.manual
AND A.exactmatchingtouse <> B.manual2
AND A.exactmatchingtouse <> B.manual3) AND B.manual2 = "";

-- 10
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual3 = A.exactmatchingtouse
WHERE (A.exactmatchingtouse <> B.original
AND A.exactmatchingtouse <> B.magerman
AND A.exactmatchingtouse <> B.manual
AND A.exactmatchingtouse <> B.manual2
AND A.exactmatchingtouse <> B.manual3) AND B.manual3 = "";

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 67
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual = A.matchingtouse2
WHERE (A.matchingtouse2 <> B.original
AND A.matchingtouse2 <> B.magerman
AND A.matchingtouse2 <> B.manual
AND A.matchingtouse2 <> B.manual2
AND A.matchingtouse2 <> B.manual3) AND B.manual = "";

-- 53
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual2 = A.matchingtouse2
WHERE (A.matchingtouse2 <> B.original
AND A.matchingtouse2 <> B.magerman
AND A.matchingtouse2 <> B.manual
AND A.matchingtouse2 <> B.manual2
AND A.matchingtouse2 <> B.manual3) AND B.manual2 = "";

-- 11
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual3 = A.matchingtouse2
WHERE (A.matchingtouse2 <> B.original
AND A.matchingtouse2 <> B.magerman
AND A.matchingtouse2 <> B.manual
AND A.matchingtouse2 <> B.manual2
AND A.matchingtouse2 <> B.manual3) AND B.manual3 = "";

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 38
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual = A.matchingtouse3
WHERE (A.matchingtouse3 <> B.original
AND A.matchingtouse3 <> B.magerman
AND A.matchingtouse3 <> B.manual
AND A.matchingtouse3 <> B.manual2
AND A.matchingtouse3 <> B.manual3) AND B.manual = "";

-- 55
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual2 = A.matchingtouse3
WHERE (A.matchingtouse3 <> B.original
AND A.matchingtouse3 <> B.magerman
AND A.matchingtouse3 <> B.manual
AND A.matchingtouse3 <> B.manual2
AND A.matchingtouse3 <> B.manual3) AND B.manual2 = "";

-- 11
UPDATE global_ultimate_owners AS B
INNER JOIN manual_name_csv AS A ON A.bvdidfinal = B.new_bvd_id
SET B.manual3 = A.exactmatchingtouse
WHERE (A.matchingtouse3 <> B.original
AND A.matchingtouse3 <> B.magerman
AND A.matchingtouse3 <> B.manual
AND A.matchingtouse3 <> B.manual2
AND A.matchingtouse3 <> B.manual3) AND B.manual3 = "";

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT COUNT(*) FROM (
SELECT A.* FROM manual_name_csv AS A
INNER JOIN global_ultimate_owners AS B ON A.bvdidfinal = B.new_bvd_id
WHERE A.matchingtouse3 <> B.original
AND A.matchingtouse3 <> B.magerman
AND A.matchingtouse3 <> B.manual
AND A.matchingtouse3 <> B.manual2
AND A.matchingtouse3 <> B.manual3) AS Z;


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 106
SELECT COUNT(*) FROM (
SELECT A.* FROM manual_name_csv AS A
INNER JOIN global_ultimate_owners AS B ON A.bvdidfinal = B.new_bvd_id
WHERE A.matchingtouse3 <> B.original
AND A.matchingtouse3 <> B.magerman
AND A.matchingtouse3 <> B.manual
AND A.matchingtouse3 <> B.manual2
AND A.matchingtouse3 <> B.manual3) AS Z;

UPDATE global_ultimate_owners AS A
INNER JOIN t_juan.CIBmatch_global_ultimate_owners AS B ON A.new_bvd_id = B.new_bvd_id
SET A.manual2 = B.manual
WHERE A.manual <> B.manual
AND B.manual <> "";

/**
 * NO986228608: manual3: YARA INTERNATIONAL
 * JP7130001011258: ùanual3: TOWA
 */

/*
 * ====================================
 * END GENERATING NEW NAMES
 * ====================================
 * 
 */

/*
 * ====================================
 * SECTION FOR TESTS
 * ====================================
 * 
 */
EXPLAIN INSERT
	INTO
		cibmatch_log SELECT
			A.new_bvd_id,
			A.original,
			A.original,
			B.doc_std_name_id,
			B.doc_std_name,
			'exact|magerman' as match_type,
			'country',
			NOW()
		FROM
			global_ultimate_owners AS A
		INNER JOIN cibmatch_patstat_applicants AS B ON
			A.cnty_iso = B.iso_ctry
		AND
			A.original = B.doc_std_name;

SELECT COUNT(*) FROM (
SELECT B.* FROM t_juan.low_ratio_match AS A
INNER JOIN patstatAvr2017_lab.applt_addr_ifris AS B ON A.person_id = B.person_id
WHERE A.ratio_docn_psn < 40
AND (B.`type`='legal' OR B.`type` IS NULL) AND B.person_name <> "") AS Z;		

CREATE 	TABLE cibmatch_log_backup20191406
SELECT * FROM cibmatch_log;

SELECT * FROM t_juan.CIBmatch_summarize_matching WHERE doc_std_name_id NOT IN (
SELECT doc_std_name_id FROM cibmatch_log);

-- 70 Updated rows	
INSERT INTO cib_matching_v2.cibmatch_log
SELECT
new_bvd_id, original, name_for_match, doc_https://www.google.com.co/std_name_id, 
doc_std_name, match_type, 'country' as `filter`, NULL
FROM t_juan.CIBmatch_summarize_matching WHERE doc_std_name_id NOT IN (
SELECT doc_std_name_id FROM cibmatch_log) AND match_type NOT LIKE "%like_prefix_ctry" ;

CREATE TABLE cibmatch_log_backup20192506
SELECT * FROM cibmatch_log;

/*
 * ====================================
 * END SECTION FOR TESTS
 * ====================================
 * 
 */
		
-- UPDATE TABLE global_ultimate_owners AS A
				 
