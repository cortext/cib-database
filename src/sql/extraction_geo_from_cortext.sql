
/* 
    This script has to be run into the sqlite db which can be downloaded from
    Cortext platform. The db should contains the geographical results.
*/

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

