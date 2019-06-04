USE t_juan;

-- This is the selection of prior patent and from years above than 1999, in addition 
-- was only selected legal and ambiguos applicant-inventor type
-- Updated Rows	2'011.402
CREATE TABLE CIBmatch_applt_risis_patents AS
SELECT A.* FROM patstatAvr2017_lab.applt_addr_ifris AS A 
INNER JOIN patstatAvr2017.tls201_appln_ifris AS B ON A.appln_id = B.appln_id
WHERE (A.`type`='legal' OR A.`type` IS NULL)
AND B.appln_filing_year > 1999 AND B.appln_first_priority_year = 0
GROUP BY A.doc_std_name_id, iso_ctry;

-- 1071636
DELETE FROM CIBmatch_applt_risis_patents WHERE iso_ctry = "";

-- Updated Rows	1071636
CREATE TABLE CIBmatch_applt_risis_patents
SELECT * FROM CIBmatch_applt_risis_patents;

CREATE TABLE CIBmatch_global_ultimate_owners ( 
	new_bvd_id VARCHAR(255),
    original VARCHAR(255),
	magerman VARCHAR(255),
	patstat_std VARCHAR(255),
	manual VARCHAR(255),
	manual2 VARCHAR(255),
	manual3 VARCHAR(255),
	cnty_iso VARCHAR(255)
);

USE t_juan;

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/[CIB] Matching with patstat/CIBv2/guo_denominations2.csv' 
INTO TABLE `CIBmatch_global_ultimate_owners` 
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
IGNORE 1 LINES;

CREATE TABLE CIBmatch_summarize_matching ( 
	new_bvd_id VARCHAR(255),
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id VARCHAR (255),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	country VARCHAR(255),
	N_Patents VARCHAR(255)
);

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.original = B.doc_std_name COLLATE utf8_general_ci AND A.cnty_iso = B.iso_ctry COLLATE utf8_general_ci;

DROP INDEX original_description

CREATE FULLTEXT INDEX magerman_description
ON CIBmatch_global_ultimate_owners(magerman); 

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.magerman, 
	   B.doc_std_name_id, B.doc_std_name, 'magerman|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.magerman = B.doc_std_name COLLATE utf8_general_ci AND A.cnty_iso = B.iso_ctry COLLATE utf8_general_ci
WHERE A.magerman <> "";

DROP INDEX magerman_description ON CIBmatch_global_ultimate_owners

CREATE FULLTEXT INDEX patstat_std_description
ON CIBmatch_global_ultimate_owners(patstat_std); 

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.patstat_std = B.doc_std_name COLLATE utf8_general_ci AND A.cnty_iso = B.iso_ctry COLLATE utf8_general_ci
WHERE patstat_std <> "";

DROP INDEX patstat_std_description ON CIBmatch_global_ultimate_owners

-- Updated Rows 74
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'manual|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual <> "" AND A.manual = B.doc_std_name;

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual2, 
	   B.doc_std_name_id, B.doc_std_name, 'manual2|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.manual2 = B.doc_std_name COLLATE utf8_general_ci AND A.cnty_iso = B.iso_ctry COLLATE utf8_general_ci
WHERE manual2 <> "";

-- 0
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual3, 
	   B.doc_std_name_id, B.doc_std_name, 'manual3|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.manual3 = B.doc_std_name COLLATE utf8_general_ci AND A.cnty_iso = B.iso_ctry COLLATE utf8_general_ci
WHERE manual3 <> "";


CREATE TABLE CIBmatch_summarize_matching_1
SELECT * FROM CIBmatch_summarize_matching
GROUP BY doc_std_name_id, match_type;

CREATE TABLE CIBmatch_summarize_matching_count
SELECT A.*, COUNT(*) FROM CIBmatch_summarize_matching_1 AS A
INNER JOIN patstatAvr2017.applt_addr_ifris AS B
ON A.doc_std_name_id = B.doc_std_name_id
GROUP BY A.doc_std_name_id, A.match_type;

SELECT COUNT(*) FROM patstatAvr2017.applt_addr_ifris
WHERE doc_std_name_id = 41471;

SELECT COUNT(*) FROM CIBmatch_summarize_matching_1;

SELECT COUNT(*) FROM CIBmatch_summarize_matching;

SELECT COUNT(*) FROM CIBmatch_global_ultimate_owners;


SELECT COUNT(*) FROM patstatAvr2017_lab.applt_addr_ifris;

EXPLAIN
SELECT COUNT(*) FROM patstatAvr2017.applt_addr_ifris AS A
WHERE appln_id NOT IN (SELECT appln_id FROM patstatAvr2017.invt_addr_ifris);


SELECT * FROM patstatAvr2017.applt_addr_ifris AS A
RIGHT JOIN patstatAvr2017.invt_addr_ifris AS B
ON A.appln_id = B.appln_id
WHERE A.appln_id IS NULL;

EXPLAIN
SELECT * FROM  CIBmatch_global_ultimate_owners AS A
LEFT JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE B.iso_ctry IS NULL;


-- ***************************************************
-- 	New update for GUO names april 23				 *		
-- 	Not needed for the previous process			     *
-- *************************************************** 

CREATE TABLE CIBmatch_guo_update_april23 ( 
	rank VARCHAR(255),
    firmreg_id VARCHAR(255),
	new_bvd_id  VARCHAR(255),
	company_name VARCHAR(255),
	sb_name VARCHAR(255)
);

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/[CIB] Matching with patstat/CIBv2/3990_firms_from CIB_avril_2019.csv' 
INTO TABLE `CIBmatch_guo_update_april23` 
FIELDS TERMINATED BY '\t'
ENCLOSED BY '' 
IGNORE 1 LINES;

SELECT B.manual, A.sb_name 
FROM CIBmatch_guo_update_april23 AS A
INNER JOIN CIBmatch_global_ultimate_owners AS B
ON A.new_bvd_id = B.new_bvd_id
WHERE A.sb_name <> B.manual AND A.sb_name <> "#N/A"
AND B.manual <> "";

-- 187
UPDATE CIBmatch_global_ultimate_owners AS B
INNER JOIN CIBmatch_guo_update_april23 AS A
ON A.new_bvd_id = B.new_bvd_id
SET B.manual = A.sb_name
WHERE A.sb_name <> B.manual AND A.sb_name <> "#N/A"
AND B.manual <> "";

SELECT * FROM CIBmatch_guo_update_april23
WHERE s NOT IN (SELECT new_bvd_id FROM CIBmatch_global_ultimate_owners);

SELECT * FROM CIBmatch_global_ultimate_owners
WHERE new_bvd_id NOT IN (SELECT new_bvd_id FROM CIBmatch_guo_update_april23);

-- ***************************************************************************************************
-- *************************************************************************************************** 

SELECT LENGTH(doc_std_name) FROM CIBmatch_applt_risis_patents;

-- Updated Rows 421
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE B.doc_std_name LIKE CONCAT(A.original, ' %');

SELECT COUNT(*) FROM CIBmatch_summarize_matching WHERE match_type = 'original|like';

-- Updated Rows	19187 
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'magerman|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.magerman <> "" AND B.doc_std_name LIKE CONCAT(A.magerman, ' %');

-- Updated Rows 439
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.patstat_std <> "" AND B.doc_std_name LIKE CONCAT(A.patstat_std, ' %');

SELECT COUNT(*) FROM CIBmatch_summarize_matching WHERE match_type = 'patstat_std|like_ctry';

-- Updated Rows	5211
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'manual|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual <> "" AND B.doc_std_name LIKE CONCAT(A.manual, ' %');

SELECT * FROM CIBmatch_summarize_matching WHERE match_type = 'manual|like_ctry';

-- Updated Rows	509
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual2, 
	   B.doc_std_name_id, B.doc_std_name, 'manual2|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual2 <> "" AND B.doc_std_name LIKE CONCAT(A.manual2, ' %');

-- Updated Rows	23
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual3, 
	   B.doc_std_name_id, B.doc_std_name, 'manual3|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual3 <> "" AND B.doc_std_name LIKE CONCAT(A.manual3, ' %');

SELECT * FROM CIBmatch_summarize_matching WHERE match_type = 'manual3|like_ctry';

SELECT COUNT(*) FROM CIBmatch_summarize_matching WHERE match_type = 'magerman|like_ctry';

UPDATE CIBmatch_summarize_matching AS A
INNER JOIN CIBmatch_global_ultimate_owners AS B
ON A.new_bvd_id = B.new_bvd_id 
SET A.name_for_match = B.magerman
WHERE A.match_type = 'magerman|like_ctry';

SELECT * FROM CIBmatch_summarize_matching WHERE match_type = 'magerman|like_ctry'

-- Updated Rows	27406 
CREATE TABLE CIBmatch_summarize_matching_2
SELECT * FROM CIBmatch_summarize_matching
GROUP BY new_bvd_id, doc_std_name_id, match_type;

CREATE TABLE CIBmatch_subsidiaries (
company_name VARCHAR(255) NULL,
company_bvd_id VARCHAR(255) NULL,
company_or_subs_name VARCHAR(255) NULL,
company_or_subs_bvd_id VARCHAR(255) NULL,
company_cnty_iso VARCHAR(255) NULL,
company_or_subs_cnty_iso VARCHAR(255) NULL,
company_guo_bvd_id VARCHAR(255) NULL,
company_guo_name VARCHAR(255) NULL,
company_or_subs_operating_revenue_usd VARCHAR(255) NULL,
company_nace VARCHAR(255) NULL,
company_or_subs_nace VARCHAR(255) NULL,
guo_or_subs_city VARCHAR(255) NULL,
latitude VARCHAR(255) NULL,
longitude VARCHAR(255) NULL,
company_entity_id VARCHAR(255) NULL,
company_or_subs_entity_id VARCHAR(255) NULL
);

-- Updated Rows	321402
LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/[CIB] Matching with patstat/cib2_firmreg_r4_copie_mars_2019.txt/cib2_firmreg_r4_copie_mars_2019.csv' 
INTO TABLE `CIBmatch_subsidiaries` 
FIELDS TERMINATED BY ';'
ENCLOSED BY '"' 
IGNORE 1 LINES;

CREATE INDEX CIBmatch_subsidiaries_company_bvd_id_IDX USING BTREE ON t_juan.CIBmatch_subsidiaries (company_bvd_id);

/*
 	CA201213525L
	CN9360141492
	CN9380370627
	DE6070163481
	IN0012662272
	US125520074L
	US126568602L
	US132941730L
	US174267390L
	US208709325L
	US943120386
	VE30016LV
*/
UPDATE CIBmatch_subsidiaries AS A
INNER JOIN CIBmatch_global_ultimate_owners AS B
ON A.company_name = B.original
SET A.company_bvd_id = B.new_bvd_id
WHERE A.company_bvd_id <> B.new_bvd_id; 

SELECT * FROM CIBmatch_subsidiaries
WHERE company_bvd_id NOT IN (SELECT new_bvd_id FROM CIBmatch_global_ultimate_owners)
GROUP BY company_bvd_id;

-- Updated Rows	3919
DELETE FROM CIBmatch_subsidiaries
WHERE company_or_subs_bvd_id IN (SELECT new_bvd_id FROM CIBmatch_global_ultimate_owners);

SELECT COUNT(*) FROM CIBmatch_subsidiaries;

SELECT company_or_subs_name, company_or_subs_bvd_id FROM CIBmatch_subsidiaries
INTO OUTFILE '/home/gnupablo/cibmatch_subsidiaries.csv' 
FIELDS ENCLOSED BY '"'
TERMINATED BY ','  
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n' ;

CREATE TABLE CIBmatch_subsidiaries_2_harmonization ( 
    original VARCHAR(255),
	magerman VARCHAR(255),
	patstat_std VARCHAR(255),
	bvd_id VARCHAR(255)
);

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/[CIB] Matching with patstat/CIBv2/data.csv' 
INTO TABLE `CIBmatch_subsidiaries_2_harmonization` 
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
IGNORE 1 LINES;


CREATE TABLE CIBmatch_subsidiaries_match_doc_std_guo ( 
    guo_original VARCHAR(255),
	doc_std_guo VARCHAR(255),
	match_type_for_guo VARCHAR(255),
	subs_original VARCHAR(255),
	name_for_match VARCHAR(255),
	subs_bvd_id VARCHAR(255),
	match_type_for_sub VARCHAR(255)
);

-- Updated Rows	2715
INSERT INTO CIBmatch_subsidiaries_match_doc_std_guo
SELECT A.original as 'guo_original', A.doc_std_name as 'doc_std_guo', A.match_type as 'match_type_guo', 
B.original as 'subs_original', B.original as 'name_for_match', B.bvd_id as 'subs_bvd_id',
'original_sub|exact' as 'match_type_subs'
FROM CIBmatch_summarize_matching_2 AS A
INNER JOIN CIBmatch_subsidiaries_2_harmonization AS B
ON A.doc_std_name = B.original
WHERE match_type <> "original|exact"
OR match_type <> "magerman|exact"
OR match_type <> "patstat_std|exact"
OR match_type <> "manual|exact"
OR match_type <> "manual2|exact"
OR match_type <> "manual3|exact"; 

-- Updated Rows	6344
INSERT INTO CIBmatch_subsidiaries_match_doc_std_guo
SELECT A.original as 'guo_original', A.doc_std_name as 'doc_std_guo', A.match_type as 'match_type_guo', 
B.original as 'subs_original', B.original as 'name_for_match', B.bvd_id as 'subs_bvd_id',
'magerman_sub|exact' as 'match_type_subs'
FROM CIBmatch_summarize_matching_2 AS A
INNER JOIN CIBmatch_subsidiaries_2_harmonization AS B
ON A.doc_std_name = B.magerman
WHERE match_type <> "original|exact"
OR match_type <> "magerman|exact"
OR match_type <> "patstat_std|exact"
OR match_type <> "manual|exact"
OR match_type <> "manual2|exact"
OR match_type <> "manual3|exact"; 

-- Updated Rows	585
INSERT INTO CIBmatch_subsidiaries_match_doc_std_guo
SELECT A.original as 'guo_original', A.doc_std_name as 'doc_std_guo', A.match_type as 'match_type_guo', 
B.original as 'subs_original', B.original as 'name_for_match', B.bvd_id as 'subs_bvd_id',
'patstat_std|exact' as 'match_type_subs'
FROM CIBmatch_summarize_matching_2 AS A
INNER JOIN CIBmatch_subsidiaries_2_harmonization AS B
ON A.doc_std_name = B.patstat_std
WHERE match_type <> "original|exact"
OR match_type <> "magerman|exact"
OR match_type <> "patstat_std|exact"
OR match_type <> "manual|exact"
OR match_type <> "manual2|exact"
OR match_type <> "manual3|exact";

SELECT COUNT(*) FROM (
SELECT COUNT(*) FROM CIBmatch_subsidiaries_match_doc_std_guo
GROUP BY doc_std_guo) AS Z;

-- ************************************
-- Like prefix 
-- ************************************

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE B.doc_std_name LIKE CONCAT('% ', A.original);

SELECT COUNT(*) FROM CIBmatch_summarize_matching WHERE match_type = 'original|like_prefix_ctry';

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.patstat_std <> "" AND B.doc_std_name LIKE CONCAT('% ', A.patstat_std);

SELECT COUNT(*) FROM CIBmatch_summarize_matching WHERE match_type = 'patstat_std|like_prefix_ctry';

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.magerman, 
	   B.doc_std_name_id, B.doc_std_name, 'magerman|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.magerman <> "" AND B.doc_std_name LIKE CONCAT('% ', A.magerman);

SELECT * FROM CIBmatch_summarize_matching WHERE match_type = 'magerman|like_prefix_ctry';

INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'manual|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual <> "" AND B.doc_std_name LIKE CONCAT('% ', A.manual);

SELECT * FROM CIBmatch_summarize_matching WHERE match_type = 'manual|like_prefix_ctry';

-- Update row 7
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual2, 
	   B.doc_std_name_id, B.doc_std_name, 'manual2|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual2 <> "" AND B.doc_std_name LIKE CONCAT('% ', A.manual2);

SELECT * FROM CIBmatch_summarize_matching WHERE match_type like '%|like_prefix_ctry';

-- Update row 1
INSERT INTO CIBmatch_summarize_matching
SELECT A.new_bvd_id, A.original, A.manual3, 
	   B.doc_std_name_id, B.doc_std_name, 'manual3|like_prefix_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE A.manual3 <> "" AND B.doc_std_name LIKE CONCAT('% ', A.manual3);

CREATE TABLE CIBmatch_summarize_matching_3
SELECT * FROM CIBmatch_summarize_matching
WHERE match_type like '%|like_prefix_ctry'
GROUP BY new_bvd_id, doc_std_name_id, match_type;

-- I have removed from the table when we have in the name_for_match
-- the values 'ISRAEL', 'CHINA' and 'BANK'
CREATE TABLE CIBmatch_summarize_matching_count3
SELECT A.*, COUNT(*) FROM CIBmatch_summarize_matching_3 AS A
INNER JOIN patstatAvr2017.applt_addr_ifris AS B
ON A.doc_std_name_id = B.doc_std_name_id
GROUP BY A.doc_std_name_id, A.match_type;

SELECT * FROM CIBmatch_summarize_matching_count3;

CREATE TABLE CIBmatch_global_ultimate_owners_NOT_FOUND1
SELECT 	* FROM CIBmatch_global_ultimate_owners WHERE new_bvd_id 
NOT IN (SELECT new_bvd_id FROM CIBmatch_summarize_matching);

CREATE TABLE CIBmatch_summarize_matching_NOT_FOUND1 ( 
	new_bvd_id VARCHAR(255),
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id VARCHAR (255),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	country VARCHAR(255),
	N_Patents VARCHAR(255)
);

INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.original = B.doc_std_name;

INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.magerman, 
	   B.doc_std_name_id, B.doc_std_name, 'magerman|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.magerman = B.doc_std_name;

INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.patstat_std = B.doc_std_name;

-- 4
INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'manual|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.manual = B.doc_std_name;

-- 3
INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.manual2, 
	   B.doc_std_name_id, B.doc_std_name, 'manual2|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.manual2 = B.doc_std_name;

-- 0
INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.manual3, 
	   B.doc_std_name_id, B.doc_std_name, 'manual3|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.manual3 = B.doc_std_name;

INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents
	   FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON B.iso_ctry = A.cnty_iso
WHERE B.doc_std_name LIKE CONCAT(A.original, ' %');

INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE B.doc_std_name LIKE CONCAT(A.patstat_std, ' %');


INSERT INTO CIBmatch_summarize_matching_NOT_FOUND1
SELECT A.new_bvd_id, A.original, A.manual, 
	   B.doc_std_name_id, B.doc_std_name, 'manual|like_ctry' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry
WHERE B.doc_std_name LIKE CONCAT(A.manual, ' %');

SELECT COUNT(*) FROM (
SELECT * FROM CIBmatch_summarize_matching_NOT_FOUND1) AS Z;

CREATE TABLE CIBmatch_applt_risis_patents_personid AS
SELECT A.* FROM patstatAvr2017_lab.applt_addr_ifris AS A 
INNER JOIN patstatAvr2017.tls201_appln_ifris AS B ON A.appln_id = B.appln_id
WHERE (A.`type`='legal' OR A.`type` IS NULL)
AND B.appln_filing_year > 1999 AND B.appln_first_priority_year = 0
GROUP BY A.person_id, iso_ctry;

-- 2478972
SELECT COUNT(*) FROM CIBmatch_applt_risis_patents_personid;

-- Updated Rows	1,011,692
DELETE FROM CIBmatch_applt_risis_patents_personid WHERE iso_ctry = "";

-- 1,467,280
SELECT COUNT(*) FROM CIBmatch_applt_risis_patents_personid;

/* ===================== SUBSIDIARIES MATCH =============================== */

UPDATE CIBmatch_subsidiaries_2_harmonization AS A
INNER JOIN CIBmatch_subsidiaries AS B
ON A.bvd_id = B.company_or_subs_bvd_id
SET A.cnty_iso = B.company_or_subs_cnty_iso;

CREATE TABLE CIBmatch_summarize_matching_SUBSIDIARIES ( 
	sub_bvd_id VARCHAR(255),
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id VARCHAR (255),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	country VARCHAR(255),
	N_Patents VARCHAR(255)
);

-- 4567
INSERT INTO CIBmatch_summarize_matching_SUBSIDIARIES
SELECT A.bvd_id, A.original, A.original, 
	   B.doc_std_name_id, B.doc_std_name, 'original|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_subsidiaries_2_harmonization AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.original = B.doc_std_name;

-- 4239
INSERT INTO CIBmatch_summarize_matching_SUBSIDIARIES
SELECT A.bvd_id, A.original, A.magerman, 
	   B.doc_std_name_id, B.doc_std_name, 'magerman|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_subsidiaries_2_harmonization AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.magerman = B.doc_std_name;

-- 432
INSERT INTO CIBmatch_summarize_matching_SUBSIDIARIES
SELECT A.bvd_id, A.original, A.patstat_std, 
	   B.doc_std_name_id, B.doc_std_name, 'patstat_std|exact' as match_type, 
	   A.cnty_iso, 0 AS N_Patents FROM CIBmatch_subsidiaries_2_harmonization AS A
INNER JOIN CIBmatch_applt_risis_patents AS B
ON A.cnty_iso = B.iso_ctry 
WHERE A.patstat_std = B.doc_std_name;

SELECT COUNT(*) FROM CIBmatch_global_ultimate_owners_NOT_FOUND1 
WHERE new_bvd_id NOT IN (SELECT new_bvd_id FROM CIBmatch_summarize_matching_NOT_FOUND1);


SELECT COUNT(*) FROM (SELECT * FROM CIBmatch_summarize_matching_SUBSIDIARIES
GROUP BY doc_std_name_id) AS Z;

/* ======================================================================== */

-- test
SELECT COUNT(*) FROM patstatAvr2017.applt_addr_ifris WHERE doc_std_name='BOSCH GMBH ROBERT';


UPDATE CIBmatch_summarize_matching_NOT_FOUND1 AS A
SET N_Patents = (SELECT COUNT(*) 
				 	FROM patstatAvr2017.applt_addr_ifris AS B
				 WHERE A.doc_std_name_id = B.doc_std_name_id
				 GROUP BY A.doc_std_name_id, A.match_type);

-- 45'151.547
SELECT COUNT(*) FROM (
SELECT B.doc_std_name_id FROM t_juan.CIBmatch_applt_risis_patents AS A
INNER JOIN patstatAvr2017.applt_addr_ifris AS B 
ON A.doc_std_name_id = B.doc_std_name_id
GROUP BY B.appln_id) AS Z;

-- 
SELECT COUNT(*) FROM (
SELECT A.* FROM patstatAvr2017_lab.applt_addr_ifris AS A 
INNER JOIN patstatAvr2017.tls201_appln_ifris AS B ON A.appln_id = B.appln_id
WHERE (A.`type`='legal' OR A.`type` IS NULL)
AND B.appln_filing_year > 1999 AND B.appln_first_priority_year = 0
GROUP BY A.appln_id) AS Z;

SELECT COUNT(*) FROM CIBmatch_summarize_matching
GROUP BY doc_std_name_id;
