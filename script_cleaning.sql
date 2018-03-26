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
