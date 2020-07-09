/*
 * ####################### Backups #############################
 */

CREATE DATABASE backup_CIBv2_0_1;
use backup_CIBv2_0_1;

CREATE TABLE cib_firms as
SELECT * FROM CIB_2020_v2_0_1.cib_firms cf; 

INSERT INTO cib_firm_address as
SELECT * FROM CIBv2_0_1.cib_firm_address cf; 

INSERT INTO cib_firm_financial_data as
SELECT * FROM CIBv2_0_1.cib_firm_financial_data cf; 

INSERT INTO cib_firm_names as
SELECT * FROM CIBv2_0_1.cib_firm_names cf; 

INSERT INTO cib_firm_sector as
SELECT * FROM CIBv2_0_1.cib_firm_sector cf; 

INSERT INTO cib_firm_sector as
SELECT * FROM CIBv2_0_1.cib_firm_sector cf; 

INSERT INTO cib_patents_actors as
SELECT * FROM CIBv2_0_1.cib_patents_actors cf;  
