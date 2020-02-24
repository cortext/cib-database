-- LOAD GUO FROM ACCURATE FILE 

LOAD DATA LOCAL INFILE '../data/subs_accurate_matching_check.csv' 
INTO TABLE pam_results_subsidiaries 
CHARACTER SET UTF8 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

-- LOAD GUO FROM TO_CHECK FILE 

LOAD DATA LOCAL INFILE '../data/subs_to_checks_matching_check.csv' 
INTO TABLE pam_results_subsidiaries 
CHARACTER SET UTF8 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;


LOAD data local INFILE '../data/Export 31_01_2020 18_05_9 firms_names_CIB2.csv'
INTO TABLE `cib_firm_names` fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '../data/Export 31_01_2020_9_firms_sdd_view.csv' 
INTO TABLE `cib_firms` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '../data/Export 31_01_2020 17_53_9_firms_sector.csv' 
INTO TABLE `cib_firm_sector` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '../data/Export 31_01_2020 17_41_9_firms_finance.csv' 
INTO TABLE `cib_firm_financial_data_cluttered` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '../data/Export 31_01_2020 17_22_9_firms_address.csv' 
INTO TABLE `orbis_firm_address` FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;
