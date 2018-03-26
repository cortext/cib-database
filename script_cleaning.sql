/*  
    Wendel: FR572174035
    Constantia Flexibles Group GMBH: AT9110696673    
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="FR572174035"
WHERE bvd_id="AT9110696673";

DELETE FROM companies
WHERE bvd_id="AT9110696673";

/*
    Syngenta AG: CHCHE101160902
    China National Chemical Corporation: CN9360650064:
*/ 
UPDATE consolidated_subsidiaries 
SET bvd_id="CN9360650064"
WHERE bvd_id="CHCHE101160902";

DELETE FROM companies
WHERE bvd_id="CHCHE101160902";

/*
    China Faw Co., Ltd.: CN9366690312
    China FAW Group Corporation (The First Automobile Factory): CN9363384623
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="CN9363384623"
WHERE bvd_id="CN9366690312";

DELETE FROM companies
WHERE bvd_id="CN9366690312";

/*
    Great Wall Technology Company Limited: CN30078PC
    China Electronics Corporation: CN9360812936
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="CN9360812936"
WHERE bvd_id="CN30078PC";

DELETE FROM companies
WHERE bvd_id="CN30078PC";

/*
    Wuxi Suntech Power Co., Ltd.: CN9360001812
    Shunfeng International Clean Energy Limited: KY40148WB
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="KY40148WB"
WHERE bvd_id="CN9360001812";

DELETE FROM companies
WHERE bvd_id="CN9360001812";

/*
    BYK-Chemie GmbH: DE5390001671	
    Altana AG: DE5390076535
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="DE5390076535"
WHERE bvd_id="DE5390001671";

DELETE FROM companies
WHERE bvd_id="DE5390001671";

/*
    Clearswift Group Ltd: GB08012246	
    RUAG Holding AG: CHCHE100944120
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="CHCHE100944120"
WHERE bvd_id="GB08012246";

DELETE FROM companies
WHERE bvd_id="GB08012246";

/*
    Horizon Pharma Ireland Limited:	IE376554
*/
DELETE FROM companies
WHERE bvd_id="IE376554";

/*
    Pirelli & C. S.P.A.: IT00860340157	
    China National Chemical Corporation: CN9360650064
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="CN9360650064"
WHERE bvd_id="IT00860340157";

DELETE FROM companies
WHERE bvd_id="IT00860340157";

/*
    Homeaway, Inc.: USMCFA14	
    Expedia INC: US202705720
*/
UPDATE consolidated_subsidiaries 
SET bvd_id="US202705720"
WHERE bvd_id="USMCFA14";

DELETE FROM companies
WHERE bvd_id="USMCFA14";


/*
    Volkswagen AG:	DE2070000543	
    Porsche Automobil Holding SE: DE7330003759
    Scania Cv Aktiebolag: SE5560840976

*/

-- SPLIT VW AND PORCHE
DELETE FROM consolidated_subsidiaries 
WHERE subs_bvd_id="SE5560840976" and bvd_id="DE7330003759";

DELETE FROM companies
WHERE bvd_id="SE5560840976"

UPDATE consolidated_subsidiaries 
SET bvd_id="DE2070000543"
WHERE bvd_id="SE5560840976";

CREATE TABLE tmp_for_delete
SELECT subs_bvd_id FROM 
consolidated_subsidiaries WHERE bvd_id="DE2070000543"
GROUP BY subs_bvd_id;

DELETE FROM consolidated_subsidiaries
WHERE bvd_id="DE7330003759" AND subs_bvd_id IN (SELECT subs_bvd_id FROM 
cib_PatApr17_v2_lab.tmp_for_delete);

DELETE FROM consolidated_subsidiaries
WHERE subs_bvd_id="DE2070000543";


/*

*/
UPDATE consolidated_subsidiaries 
SET bvd_id="TW04541302"
WHERE bvd_id="CA35574NC";

UPDATE consolidated_subsidiaries 
SET bvd_id="KY40148WB"
WHERE bvd_id="CN9360001812";

UPDATE consolidated_subsidiaries 
SET bvd_id="CN9363384623"
WHERE bvd_id="CN9366690312";

UPDATE consolidated_subsidiaries 
SET bvd_id="GB07524813"
WHERE bvd_id="ESA48179196";

UPDATE consolidated_subsidiaries 
SET bvd_id="SE5560003468"
WHERE bvd_id="FR400782017";

UPDATE consolidated_subsidiaries 
SET bvd_id="GBSC036219"
WHERE bvd_id="GB01675285";

UPDATE consolidated_subsidiaries 
SET bvd_id="DE2010000581"
WHERE bvd_id="GB02180851";

UPDATE consolidated_subsidiaries 
SET bvd_id="CN9360650064"
WHERE bvd_id="IT00860340157";

UPDATE consolidated_subsidiaries 
SET bvd_id="JP9020001031109"
WHERE bvd_id="JP8030001014831";

UPDATE consolidated_subsidiaries 
SET bvd_id="JP8010401050387"
WHERE bvd_id="SE5560836461";

UPDATE consolidated_subsidiaries 
SET bvd_id="TW84149961"
WHERE bvd_id="TW16657967";

UPDATE consolidated_subsidiaries 
SET bvd_id="CA30019NC"
WHERE bvd_id="US202960116";

UPDATE consolidated_subsidiaries 
SET bvd_id="US770118518"
WHERE bvd_id="US251799439";

UPDATE consolidated_subsidiaries 
SET bvd_id="US050315468"
WHERE bvd_id="US411443470";

UPDATE consolidated_subsidiaries 
SET bvd_id="US911144442"
WHERE bvd_id="US770333710";

UPDATE consolidated_subsidiaries 
SET bvd_id="GB06270876"
WHERE bvd_id="US800318351";

UPDATE consolidated_subsidiaries 
SET bvd_id="US270306875"
WHERE bvd_id="US942586591";

UPDATE consolidated_subsidiaries 
SET bvd_id="CN9361203598"
WHERE bvd_id="CN9360000761";
