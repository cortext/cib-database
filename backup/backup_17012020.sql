
CREATE TABLE cib_guo_rpd_actor  (
doc_std_name_id VARCHAR(255) NULL,
orbis_id VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/cib_guo_rpd__actor.csv' 
INTO TABLE `cib_guo_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'database modeling/cib_guo_rpd__actor_to_check.csv' 
INTO TABLE `cib_guo_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

CREATE TABLE cib_guo_rpd_actor2
SELECT * FROM cib_guo_rpd_actor cgra
GROUP BY doc_std_name_id, orbis_id;
	
DROP TABLE cib_guo_rpd_actor;
ALTER TABLE cib_guo_rpd_actor2 RENAME TO cib_guo_rpd_actor;

SELECT * FROM cib_guo_rpd_actor cgra
GROUP BY doc_std_name_id
HAVING COUNT(*) > 1;

CREATE TABLE cib_subsidiaries_rpd_actor  (
doc_std_name_id VARCHAR(255) NULL,
subsidiary_orbis_id VARCHAR(255) NULL,
guo_orbis_id VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/cib_subsidiaries_rpd__actor.csv' 
INTO TABLE `cib_subsidiaries_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'database modeling/cib_subsidiaries_rpd__actor_to_check.csv' 
INTO TABLE `cib_subsidiaries_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'database modeling/cib_guo_rpd_actor_new.csv' 
INTO TABLE `cib_guo_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'database modeling/cib_subsidiaries_rpd_actor_new.csv' 
INTO TABLE `cib_subsidiaries_rpd_actor` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

-- Updated Rows	29
DELETE cgra.* FROM cib_guo_rpd_actor cgra
WHERE orbis_id IN ('US128459140L','GBML3986606',
'US230320592L','JP8060001005638','DE7010090852','FR504340407','US650773649')

-- Updated Rows	29
DELETE csra.* FROM cib_subsidiaries_rpd_actor csra
WHERE guo_orbis_id IN ('US128459140L','GBML3986606',
'US230320592L','JP8060001005638','DE7010090852','FR504340407','US650773649')

DELETE csra.* FROM cib_subsidiaries_rpd_actor csra
WHERE doc_std_name_id IN (SELECT doc_std_name_id FROM cib_guo_rpd_actor cgra);

CREATE TABLE cib_patents_actors
SELECT ra.* FROM risis_patents_17_2_0.rpd_actors ra
WHERE doc_std_name_id IN (SELECT doc_std_name_id FROM cib_guo_rpd_actor cgra )
OR doc_std_name_id IN (SELECT doc_std_name_id FROM cib_subsidiaries_rpd_actor csra);

-- Updated Rows	15653988
CREATE TABLE cib_patents_inventors
SELECT ri.* FROM risis_patents_17_2_0.rpd_inventors ri
WHERE appln_id IN (SELECT appln_id FROM cib_patents_actors cpa);

-- Updated Rows	6129331
CREATE TABLE cib_patents_value
SELECT rpv.* FROM risis_patents_17_2_0.rpd_patent_value rpv
WHERE appln_id IN (SELECT appln_id FROM cib_patents_actors cpa);

-- Updated Rows	6129331
CREATE TABLE cib_patents_priority_attributes
SELECT rpa.* FROM risis_patents_17_2_0.rpd_priority_attributes rpa
WHERE appln_id IN (SELECT appln_id FROM cib_patents_actors cpa);

-- Updated Rows	18095635
CREATE TABLE cib_patents_technological_classification
SELECT rtc.* FROM risis_patents_17_2_0.rpd_technological_classification rtc
WHERE appln_id IN (SELECT appln_id FROM cib_patents_actors cpa);

-- Updated Rows	6129331
CREATE TABLE cib_patents_textual_infromation
SELECT rti.* FROM risis_patents_17_2_0.rpd_textual_information rti
WHERE appln_id IN (SELECT appln_id FROM cib_patents_actors cpa);

CREATE TABLE cib_firm_names  (
guo_orbis_id VARCHAR(255) NULL,
previous_name VARCHAR(255) NULL,
previous_name_date VARCHAR(255) NULL,
aka_name VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/Orbis data/Export 16_01_2020 11_13_3989 com_names_CIB2.csv' 
INTO TABLE `cib_firm_names` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

CREATE TABLE cib_firms  (
guo_orbis_id VARCHAR(255) NULL,
name VARCHAR(255) NULL,
iso_ctry VARCHAR(255) NULL,
nace2_main_section VARCHAR(255) NULL,
category VARCHAR(255) NULL,
status VARCHAR(255) NULL,
quoted VARCHAR(255) NULL,
I_GUO VARCHAR(255) NULL,
incorporation_date VARCHAR(255) NULL,
last_year_account_available VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/Orbis data/Export 16_01_2020_3989_firms_sdd_view_cib2.csv' 
INTO TABLE `cib_firms` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;


CREATE TABLE cib_firm_sector  (
	guo_orbis_id VARCHAR(255) NULL,
	nace2_primary_code VARCHAR(255) NULL,
	nace2_primary_label VARCHAR(255) NULL,
	nace2_secondary_code VARCHAR(255) NULL,
	nace2_secondary_label VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/Orbis data/Export 16_01_2020 13_27_3989 comp_sectors_CIB2.csv' 
INTO TABLE `cib_firm_sector` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

/*
 * ========== FINANCIAL DATA ========
 * 
 */

CREATE TABLE cib_firm_financial_data  (
guo_orbis_id VARCHAR(255) NULL,
year VARCHAR(255) NULL,
operating_revenue VARCHAR(255) NULL,
total_assests VARCHAR(255) NULL,
number_employees VARCHAR(255) NULL,
pl_before_taxes VARCHAR(255) NULL,
roe_using_pl_before_taxes VARCHAR(255) NULL,
roa_using_pl_before_taxes VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/Orbis_financial_data03.csv' 
INTO TABLE `cib_firm_financial_data` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

UPDATE cib_firm_financial_data
SET year = year - 1;

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/Orbis_financial_data02.csv' 
INTO TABLE `cib_firm_financial_data` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

UPDATE cib_firm_financial_data
SET year = year - 1;

LOAD DATA LOCAL INFILE '/home/gnupablo/Projects/UPEM/Orbis_financial_data01.csv' 
INTO TABLE `cib_firm_financial_data` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

CREATE TABLE copy_cib_firm_financial_data
SELECT * FROM cib_firm_financial_data cffd; 


UPDATE cib_firm_financial_data
SET operating_revenue =  NULL
WHERE operating_revenue = "n.a.";

UPDATE cib_firm_financial_data
SET total_assests =  NULL
WHERE total_assests = "n.a.";

UPDATE cib_firm_financial_data
SET number_employees =  NULL
WHERE number_employees = "n.a.";

UPDATE cib_firm_financial_data
SET pl_before_taxes =  NULL
WHERE pl_before_taxes = "n.a.";

UPDATE cib_firm_financial_data
SET roe_using_pl_before_taxes =  NULL
WHERE roe_using_pl_before_taxes = "n.a."
OR roe_using_pl_before_taxes = "n.s.";

UPDATE cib_firm_financial_data
SET roa_using_pl_before_taxes =  NULL
WHERE roa_using_pl_before_taxes = "n.a."
OR roa_using_pl_before_taxes = "n.s.";

/*
 * ========== END FINANCIAL DATA ========
 * 
 */



/*
 * ========== GEO ========
 * 
 */


CREATE TABLE cib_firm_address  (
guo_orbis_id VARCHAR(255) NULL,
address_line1 VARCHAR(255) NULL,
address_line2 VARCHAR(255) NULL,
address_line3 VARCHAR(255) NULL,
address_line4 VARCHAR(255) NULL,
postcode VARCHAR(255) NULL,
city VARCHAR(255) NULL,
country_iso_code VARCHAR(255) NULL,
country_region VARCHAR(255) NULL,
country_region_type VARCHAR(255) NULL,
nuts1 VARCHAR(255) NULL,
nuts2 VARCHAR(255) NULL,
msa VARCHAR(255) NULL,
world_region VARCHAR(255) NULL,
us_state VARCHAR(255) NULL,
county VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE 'database modeling/Orbis data/Export 16_01_2020 10_53_3989 comp_address_CIB2.csv' 
INTO TABLE `cib_firm_address` FIELDS TERMINATED BY '\t'
ENCLOSED BY '"'
IGNORE 1 LINES;

SELECT * FROM cib_firm_address;

CREATE TABLE t_juan.cib_firm_address_geocode as
SELECT guo_orbis_id, CONCAT(address_line1, ', ', address_line2, 
', ', address_line3, ', ', address_line4) AS address FROM cib_firm_address cfa;

SELECT TRIM(TRAILING ', ' FROM address) FROM t_juan.cib_firm_address_geocode;

UPDATE t_juan.cib_firm_address_geocode
SET address = TRIM(TRAILING ', ' FROM address);

CREATE TABLE t_juan.final_firm_address_geocode
SELECT A.guo_orbis_id, 
CONCAT(A.address, ', ', B.postcode, ', ', B.city, ', ', B.country_region) as address
FROM t_juan.cib_firm_address_geocode A
INNER JOIN cib_firm_address B ON A.guo_orbis_id = B.guo_orbis_id;

CREATE TABLE `cib_firm_address_final` (
  `guo_orbis_id` varchar(50) NOT NULL DEFAULT '0',
  `address_company` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `label_geocoding` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `iso_ctry` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `continent_final` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `confidence` float DEFAULT NULL,
  `iso3` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `rurban_area_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `rurban_area_name` varchar(75) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `rurban_area_characteristics` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `nuts_source` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `nuts_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1

UPDATE cib_firm_address_geocoding
SET country = "Republic of Korea"
WHERE country = "South Korea";

UPDATE cib_firm_address_geocoding
SET country = "Russian Federation"
WHERE country = "Russia"; 

UPDATE cib_firm_address_geocoding
SET country = "Hong Kong"
WHERE country = "Hong Kong S.A.R."; 

SELECT cfag.address, cfag.country, B.country_iso_code FROM cib_firm_address_geocoding cfag
INNER JOIN cib_firm_address B ON cfag.guo_orbis_id = B.guo_orbis_id
WHERE cfag.country <> B.country_iso_code
AND cfag.country <> "United States"
AND cfag.country <> ""
AND B.country_iso_code NOT LIKE "%(United Kingdom)%" ;

UPDATE cib_firm_address_geocoding cfag
INNER JOIN cib_firm_address B ON cfag.guo_orbis_id = B.guo_orbis_id
SET cfag.country = B.country_iso_code,
	cfag.city = B.city,
	cfag.region = B.country_region_type,
	cfag.label = "",
	cfag.confidence = "",
	cfag.iso3 = "",
	cfag.latitude = "",
	cfag.longitude = "",
	cfag.layer = ""
WHERE cfag.country <> B.country_iso_code
AND cfag.country <> "United States"
AND cfag.country <> ""
AND B.country_iso_code NOT LIKE "%(United Kingdom)%";

SELECT LENGTH(nace2_secondary_label) as cn FROM cib_firm_sector cfn
ORDER BY cn DESC;

CREATE TABLE cib_firm_names_copy
SELECT * FROM cib_firm_names;

UPDATE cib_firm_sector
SET nace2_primary_code = NULL
WHERE nace2_primary_code = "";

UPDATE cib_firm_sector
SET nace2_secondary_code = NULL
WHERE nace2_secondary_code = "";


SELECT LENGTH(nace2_secondary_label) as cn FROM cib_firm_sector cfn
ORDER BY cn DESC;


SELECT cpa.appln_id, cpa.risis_register_id, cgpa.guo_orbis_id FROM cib_patents_actors cpa


UPDATE cib_patents_actors cpa
INNER JOIN cib_guo_patents_actor cgpa ON cpa.doc_std_name_id = cgpa.doc_std_name_id
SET cpa.risis_register_id = cgpa.guo_orbis_id;

UPDATE cib_patents_actors cpa
INNER JOIN cib_subsidiaries_patents_actor cspa ON cpa.doc_std_name_id = cspa.doc_std_name_id
SET cpa.risis_register_id = cspa.guo_orbis_id;



SELECT DISTINCT(LENGTH(nuts_source)) as cn FROM cib_patents_actors cpa
ORDER BY cn DESC;


SELECT SUBSTRING(nuts_id, 12, 10) as nuts_id FROM spatial_information si;
WHERE;
 
UPDATE spatial_information
SET nuts_source = SUBSTRING(nuts_id, 1, 10);

UPDATE spatial_information
SET nuts_id1 = SUBSTRING(nuts_id, 12, 10);

SELECT * FROM cib_firm_address_geocoding cfag;

CREATE TABLE cib_firm_address_geocoding2
SELECT cfag.*, B.nuts_id, B.nuts_source, B.rurban_area_id, B.rurban_area_name FROM cib_firm_address_geocoding cfag
INNER JOIN spatial_information B ON cfag.guo_orbis_id = B.guo_orbis_id; 


SELECT guo_orbis_id, address, CONCAT(city,', ',country) as new_address FROM cib_firm_address_geocoding2 cfag
WHERE city <> "" and longitude = "";


UPDATE final_address_no_city
SET nuts_source = SUBSTRING(nuts_extract, 1, 10);

UPDATE final_address_no_city
SET nuts_id = SUBSTRING(nuts_extract, 12, 10);


UPDATE cib_firm_address_geocoding2 A
INNER JOIN final_address_no_city B ON A.guo_orbis_id = B.guo_orbis_id
SET A.label = B.label,
	A.city = B.city,
	A.confidence = B.confidence,
	A.country = B.country,
	A.iso3 = B.iso3,
	A.latitude = B.latitude,
	A.longitude = B.longitude,
	A.layer = B.layer,
	A.nuts_id = B.nuts_id,
	A.nuts_source = B.nuts_source,
	A.region = B.region,
	A.rurban_area_id = B.rurban_area_id,
	A.rurban_area_name = B.rurban_area_name;
	
 
