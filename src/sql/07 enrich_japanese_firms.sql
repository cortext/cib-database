/* ====================================
* JAPANESES CASES FOR CIB
* =====================================
*/
CREATE TABLE pam_results
             (
                          id                       VARCHAR(255) NULL,
                          doc_std_name             VARCHAR(255) NULL,
                          doc_std_name_id          VARCHAR(255) NULL,
                          `check`                  VARCHAR(255) NULL,
                          orbis_id                 VARCHAR(255) NULL,
                          orbis_name               VARCHAR(255) NULL,
                          name_type                VARCHAR(255) NULL,
                          number_patents           VARCHAR(255) NULL,
                          elastic_score            VARCHAR(255) NULL,
                          levensthein_score        VARCHAR(255) NULL,
                          jaro_winkler_score       VARCHAR(255) NULL,
                          ratcliff_obershelp_score VARCHAR(255) NULL,
                          pam_score                VARCHAR(255) NULL,
                          query_type               VARCHAR(255) NULL
             );LOAD data local INFILE '../data/guo_JP_accurate_matching_check.csv'
INTO TABLE pam_results
CHARACTER SET utf8
fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;LOAD data local INFILE '../data/guo_JP_to_checks_matching_check.csv'
INTO TABLE pam_results
CHARACTER SET utf8
fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;CREATE TABLE pam_results_subsidiaries
             (
                          id                       VARCHAR(255) NULL,
                          doc_std_name             VARCHAR(255) NULL,
                          doc_std_name_id          VARCHAR(255) NULL,
                          `check`                  VARCHAR(255) NULL,
                          orbis_id                 VARCHAR(255) NULL,
                          orbis_name               VARCHAR(255) NULL,
                          name_type                VARCHAR(255) NULL,
                          number_patents           VARCHAR(255) NULL,
                          elastic_score            VARCHAR(255) NULL,
                          levensthein_score        VARCHAR(255) NULL,
                          jaro_winkler_score       VARCHAR(255) NULL,
                          ratcliff_obershelp_score VARCHAR(255) NULL,
                          pam_score                VARCHAR(255) NULL,
                          query_type               VARCHAR(255) NULL,
                          guo_id                   VARCHAR(255) NULL,
                          guo_name                 VARCHAR(255) NULL
             );LOAD data local INFILE '../data/subs_JP_accurate_matching_check.csv'
INTO TABLE pam_results_subsidiaries
CHARACTER SET utf8
fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;LOAD data local INFILE '../data/subs_JP_to_checks_matching_check.csv'
INTO TABLE pam_results_subsidiaries
CHARACTER SET utf8
fields TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;DELETE
FROM   pam_results_subsidiaries_jp
WHERE  `check` = 'n';DELETE
FROM   pam_results_jp
WHERE  `check` = 'n';

-- 327SELECT Count(*)
FROM   pam_results_subsidiaries prs;DELETE c1
FROM       pam_results_subsidiaries c1
inner JOIN pam_results_subsidiaries c2
WHERE      c1.pam_score > c2.pam_score
AND        c1.doc_std_name_id = c2.doc_std_name_id ;SELECT Count(*)
FROM   pam_results_subsidiaries prs;SELECT *
FROM   pam_results_subsidiaries prs
WHERE  doc_std_name_id NOT IN
       (
              SELECT person_id
              FROM   risis_patent_database.rpd_actors ra)
insert INTO cib_2020_v2_lab.cib_patents_actors
SELECT *
FROM   cib_patents_actors_jp cpaj;UPDATE pam_results_jp A
INNER JOIN t_juan.japanese_new_cases B
ON         A.doc_std_name = B.doc_std_name
SET        A.name_final = B.name_final;ALTER TABLE cib_2020_process.pam_results_subsidiaries_jp ADD name_final VARCHAR(255) NULL;CREATE TABLE cib_patents_actors_jp
SELECT *
FROM   risis_patent_database.rpd_actors ra
WHERE  name_final IN
       (
              SELECT name_final
              FROM   pam_results_jp prj );DELETE
FROM   pam_results_subsidiaries_jp
WHERE  name_final IN
       (
              SELECT name_final
              FROM   pam_results_jp );INSERT INTO cib_patents_actors_jp
SELECT *
FROM   risis_patent_database.rpd_actors ra
WHERE  name_final IN
       (
              SELECT name_final
              FROM   pam_results_subsidiaries_jp prj )
delete
FROM   cib_2020_v2_lab.cib_patents_actors
WHERE  doc_std_name_id = 0;UPDATE cib_patents_actors_jp A
INNER JOIN pam_results_jp B
ON         A.name_final = B.name_final
SET        A.guo_orbis_id = B.orbis_id;INSERT INTO cib_patents_actors
SELECT *
FROM   risis_patent_database.rpd_actors ra
WHERE  person_id IN
       (
              SELECT doc_std_name_id
              FROM   pam_results_subsidiaries_jp prs);UPDATE cib_patents_actors_jp A
INNER JOIN pam_results_subsidiaries_jp B
ON         A.name_final = B.name_final
SET        A.guo_orbis_id = B.guo_id;INSERT INTO cib_patents_actors
SELECT *
FROM   risis_patent_database.rpd_actors ra
WHERE  person_id IN
       (
              SELECT doc_std_name_id
              FROM   pam_results_subsidiaries_jp prs);SELECT Count(*)
FROM   t_juan.japanese_names jn;CREATE TABLE jp_rpd_with_person_name
SELECT *
FROM   risis_patent_database.rpd_actors ra
WHERE  name_final IN
       (
              SELECT name_final
              FROM   t_juan.japanese_in_person_name jipn);SELECT Count(*)
FROM   t_juan.japanese_new_cases jnc;CREATE TABLE t_juan.japanese_in_person_name_2
SELECT     A.name_english,
           B.doc_std_name_id,
           A.n_appln_id,
           A.name_final
FROM       t_juan.japanese_names A
INNER JOIN risis_patent_database.rpd_actors B
ON         A.name_english = B.person_name;CREATE TABLE t_juan.japanese_in_person_name_unique
SELECT   *
FROM     t_juan.japanese_in_person_name_2 jipn
GROUP BY jipn.doc_std_name_id,
         jipn.n_appln_id,
         jipn.name_english,
         jipn.name_final;SELECT Count(*)
FROM   t_juan.japanese_in_person_name jipn;SELECT *
FROM   cib_2020_process.cib_patents_actors_jp cpaj
WHERE  name_final IN
       (
              SELECT name_final
              FROM   t_juan.japanese_in_person_name_unique jipnu);SELECT *
FROM   t_juan.japanese_in_person_name jipnu
WHERE  name_final NOT IN
       (
              SELECT name_final
              FROM   t_juan.japanese_in_person_name_unique jipn);SELECT   *
FROM     t_juan.japanese_in_person_name_unique jipnu
WHERE    name_final IN
         (
                  SELECT   name_final
                  FROM     t_juan.japanese_in_person_name_unique
                  GROUP BY name_final
                  HAVING   Count(*) > 1)
ORDER BY name_english;SELECT   *
FROM     t_juan.japanese_names
GROUP BY name_english
HAVING   Count(*) > 1;

-- 1785726UPDATE t_juan.japanese_in_person_name_unique AS A
SET    n =
       (
                SELECT   Count(*)
                FROM     risis_patent_database.rpd_actors AS B
                WHERE    A.doc_std_name_id = B.doc_std_name_id
                GROUP BY A.doc_std_name_id);SELECT     cpaj.*
FROM       cib_2020_process.cib_patents_actors_jp cpaj
INNER JOIN t_juan.japanese_in_person_name_unique B
ON         B.name_final = cpaj.name_final;SELECT cpaj.*
FROM   cib_2020_process.cib_patents_actors_jp cpaj
WHERE  risis_register_id = "";INSERT INTO cib_2020_process.cib_patents_actors_jp
SELECT     ra.*
FROM       risis_patent_database.rpd_actors ra
INNER JOIN t_juan.japanese_in_person_name_unique B
ON         B.name_final = ra.name_final;

-- 0SELECT *
FROM   cib_patents_actors_jp cpaj
WHERE  doc_std_name_id IN
       (
              SELECT doc_std_name_id
              FROM   cib_2020_v2_lab.cib_patents_actors cpa)
update cib_patents_actors_jp a
INNER JOIN t_juan.japanese_in_person_name_unique b
ON         a.name_final = b.name_final
SET        a.doc_std_name_id = b.doc_std_name_id;

-- 47,123SELECT Count(*)
FROM   cib_patents_actors_jp cpaj
WHERE  doc_std_name_id <> 0;UPDATE cib_patents_actors_jp A
INNER JOIN cib_2020_v2_lab.cib_patents_actors B
ON         A.doc_std_name_id = B.doc_std_name_id
SET        A.risis_register_id = B.guo_orbis_id;INSERT INTO cib_2020_v2_lab.cib_patents_actors
SELECT *
FROM   cib_patents_actors_jp;CREATE TABLE missing_applnid
SELECT appln_id
FROM   cib_patents_actors_jp
WHERE  appln_id NOT IN
       (
              SELECT appln_id
              FROM   cib_2020_v2_lab.cib_patents_inventors);

-- Updated Rows 124695INSERT INTO cib_2020_v2_lab.cib_patents_inventors
SELECT ri.*
FROM   risis_patent_database.rpd_inventors ri
WHERE  appln_id IN
       (
              SELECT appln_id
              FROM   missing_applnid cpa);

-- Updated Rows 49276INSERT INTO cib_2020_v2_lab.cib_patents_value
SELECT rpv.*
FROM   risis_patent_database.rpd_patent_value rpv
WHERE  appln_id IN
       (
              SELECT appln_id
              FROM   missing_applnid cpa);

-- Updated Rows 49276INSERT INTO cib_2020_v2_lab.cib_patents_priority_attributes
SELECT rpa.*
FROM   risis_patent_database.rpd_priority_attributes rpa
WHERE  appln_id IN
       (
              SELECT appln_id
              FROM   missing_applnid cpa);

-- Updated Rows 138943INSERT INTO cib_2020_v2_lab.cib_patents_technological_classification
SELECT rtc.*
FROM   risis_patent_database.rpd_technological_classification rtc
WHERE  appln_id IN
       (
              SELECT appln_id
              FROM   missing_applnid cpa);

-- Updated Rows 49276INSERT INTO cib_2020_v2_lab.cib_patents_textual_infromation
SELECT rti.*
FROM   risis_patent_database.rpd_textual_information rti
WHERE  appln_id IN
       (
              SELECT appln_id
              FROM   missing_applnid cpa);
