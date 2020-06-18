SET foreign_key_checks = 0;

ALTER TABLE cib_firms CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_firms A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

ALTER TABLE cib_firm_address CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_firm_address A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

ALTER TABLE cib_firm_financial_data CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_firm_financial_data A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

ALTER TABLE cib_firm_names CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_firm_names A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

ALTER TABLE cib_firm_sector CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_firm_sector A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

ALTER TABLE cib_patents_actors CHANGE guo_orbis_id firmreg_id varchar(16)
CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

UPDATE cib_patents_actors A
INNER JOIN firmreg_id B
ON A.guo_orbis_id = B.guo_orbis_id
SET A.guo_orbis_id = B.firmreg_id;

SET foreign_key_checks = 1;
