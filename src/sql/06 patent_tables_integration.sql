
/* Enrich the cib_patent_actor table using the matching obtained by PAM System */
INSERT INTO cib_patents_actors
SELECT *
FROM   risis_patent_database.rpd_actors
WHERE  doc_std_name_id IN (SELECT doc_std_name_id
                           FROM   tmp_pam_results_guo);

INSERT INTO cib_patents_actors
SELECT *
FROM   risis_patent_database.rpd_actors
WHERE  doc_std_name_id IN (SELECT doc_std_name_id
                           FROM   tmp_pam_results_subsidiaries); 

/* Create the linkage between firms and patents */
UPDATE cib_patents_actors A
       INNER JOIN tmp_pam_results_guo B
               ON A.doc_std_name_id = B.doc_std_name_id
SET    A.guo_orbis_id = B.guo_orbis_id;

UPDATE cib_patents_actors A
       INNER JOIN tmp_pam_results_subsidiaries B
               ON A.doc_std_name_id = B.doc_std_name_id
SET    A.guo_orbis_id = B.guo_orbis_id; 


/* 
   Generate the rest of tables from risis patent database, based on 
   the initial table cib_patent_actor
*/

INSERT INTO cib_patents_inventors
SELECT *
FROM   risis_patent_database.rpd_inventors
WHERE  appln_id IN (SELECT appln_id
                    FROM   cib_patents_actors); 
                    
INSERT INTO cib_patents_priority_attributes
SELECT *
FROM   risis_patent_database.rpd_priority_attributes
WHERE  appln_id IN (SELECT appln_id
                    FROM   cib_patents_actors); 
                    
INSERT INTO cib_patents_technological_classification
SELECT *
FROM   risis_patent_database.rpd_technological_classification
WHERE  appln_id IN (SELECT appln_id
                    FROM   cib_patents_actors); 
                    
INSERT INTO cib_patents_textual_information
SELECT *
FROM   risis_patent_database.rpd_textual_information
WHERE  appln_id IN (SELECT appln_id
                    FROM   cib_patents_actors); 
                    
INSERT INTO cib_patents_values
SELECT *
FROM   risis_patent_database.rpd_values
WHERE  appln_id IN (SELECT appln_id
                    FROM   cib_patents_actors); 
