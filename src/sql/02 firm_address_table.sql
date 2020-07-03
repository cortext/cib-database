

INSERT INTO tmp_prepare_address_to_geocode
SELECT guo_orbis_id,
Concat(address_line1, ', ', address_line2, ', ', address_line3, ', ',
    address_line4) AS address
FROM   tmp_orbis_firm_address cfa;

UPDATE tmp_prepare_address_to_geocode
SET address = TRIM(TRAILING ', ' FROM address);

INSERT INTO tmp_address_to_geocode
SELECT A.guo_orbis_id,
CONCAT(A.address, ', ', B.postcode, ', ', B.city, ', ', B.country_region) as address
FROM tmp_prepare_address_to_geocode A
INNER JOIN tmp_orbis_firm_address B ON A.guo_orbis_id = B.guo_orbis_id;


/*
Thus the tmp_address_to_geocode table must be extracted into a csv file and then proceed
on geocoding them in Cortext, also they have to be enriched with the mapping exploring tool
in order to obtain the nuts and rural-urban area information.


This script has to be run into the sqlite db which can be downloaded from
Cortext platform. The db should contains the geographical results.


SELECT B.data                 AS guo_orbis_id,
address,
label,
longitude,
latitude,
confidence,
city,
region,
country,
iso3,
Substr(C.data, 1, 10)  AS nuts_id,
Substr(C.data, 12, 10) AS nuts_source,
D.data                 AS rurban_area_id,
E.data                 AS rurban_area_name
FROM   geo_address A
LEFT JOIN guo_orbis_id B
ON A.id = B.id
LEFT JOIN map_id_nuts C
ON A.id = C.id
LEFT JOIN map_id_urban_areas D
ON A.id = D.id
LEFT JOIN map_urban_areas E
ON A.id = E.id;
 */


/*
This load statement is here because it makes more sense, since the file "extraction_geo_cortext.csv"
is generated specifically from this script
 */
LOAD data local INFILE '/../../data/geocoding_data_sample/extraction_geo_cortext.csv'
INTO TABLE tmp_cib_firm_address
CHARACTER SET utf8
fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

INSERT INTO cib_firm_address 
SELECT * FROM tmp_cib_firm_address;
