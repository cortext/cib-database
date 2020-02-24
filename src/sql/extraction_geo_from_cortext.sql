
/* 
    This script has to be run into the sqlite db which can be downloaded from
    Cortext platform. The db should contains the geographical results.
*/

SELECT address,
       label,
       longitude,
       latitude,
       confidence,
       city,
       region,
       country,
       iso3,
	   substr(B.data, 1, 10) AS nuts_id,
	   substr(B.data, 12, 10) AS nuts_source,
       C.data AS rurban_area_id,
	   D.data AS rurban_area_name
FROM   geo_address A
	   LEFT JOIN map_id_NUTS B
			  ON A.id = B.id
       LEFT JOIN map_id_urban_areas C
              ON A.id = C.id
	   LEFT JOIN map_urban_areas D
              ON A.id = D.id;  
