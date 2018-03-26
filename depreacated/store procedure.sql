DROP PROCEDURE IF EXISTS cib_PatApr17_v2.graph_pruning ;

DELIMITER $$
$$
CREATE DEFINER=`gnupablo`@`%` PROCEDURE `cib_PatApr17_v2`.`graph_pruning`()
BEGIN

DECLARE couples  INT;
SET couples = 1;
-- DECLARE str VARCHAR(255);
 
-- no_relation_all_zero
-- layer2_couples_from_three_companies_in_the_matrix_pairs
-- tmp_comp_subs2
-- layer2_ambiguos_pair_from_three_or_more_set
-- 1_1_two_subs_selected_to_be_treated
-- layer2_clear_subs	
	

WHILE (couples  > 0) DO

/*
MATCH THE COUPLES WITH TMP_COMP
*/
 UPDATE cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs AS A
 INNER JOIN cib_PatApr17_v2.tmp_comp_subs2 AS B
 ON (A.bvd_id1 = B.bvd_id AND A.bvd_id2 = B.subs_bvd_id)
 SET A.selected = 1;
 
/*
TAKE ALL SUBS WITH ALL SELECTE = 0 TO INSERT INTO NO RELATION TABLE
*/
 
 INSERT INTO no_relation_all_zero
 SELECT subs_bvd_id FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs 
 WHERE subs_bvd_id NOT IN ( SELECT subs_bvd_id FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs 
 WHERE selected = 1 GROUP BY subs_bvd_id)
 GROUP BY subs_bvd_id;

 DELETE A FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs A                                                                                                                 
 INNER JOIN cib_PatApr17_v2.no_relation_all_zero B ON                                                                                                       
 A.subs_bvd_id = B.subs_bvd_id; 

/*
TAKE ALL SUBS WITH ONE SELECTED COMPANY AND INSERT INTO AMBIGUOS PAIR SET
*/
 INSERT INTO `layer2_ambiguos_pair_from_three_or_more_set`
 SELECT A.subs_bvd_id, A.bvd_id2 AS bvd_id_selected1, B.bvd_id2 AS bvd_id_selected2 
 FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs AS A
 INNER JOIN (SELECT subs_bvd_id, bvd_id1, bvd_id2, selected 
             FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs WHERE selected = 1
             GROUP BY subs_bvd_id HAVING COUNT(*) < 2) AS B
 ON A.subs_bvd_id = B.subs_bvd_id AND A.bvd_id1 = B.bvd_id1 AND A.bvd_id2 <> B.bvd_id2;
 
 DELETE A FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs A                                                                                                                 
 INNER JOIN `layer2_ambiguos_pair_from_three_or_more_set`  B ON                                                                                                       
 A.subs_bvd_id = B.subs_bvd_id; 

/*
TAKE ALL SUBS WITH TWO SELECTED COMPANIES
*/
 
 INSERT INTO `1_1_two_subs_selected_to_be_treated`
 SELECT subs_bvd_id, bvd_id1, bvd_id2, selected FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs
 WHERE subs_bvd_id IN (SELECT subs_bvd_id FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs                                             
 WHERE selected = 1 
 GROUP BY subs_bvd_id
 HAVING COUNT(*) = 2) AND selected = 1
 GROUP BY subs_bvd_id,bvd_id2;

 DELETE A FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs A                                                                                                                 
 INNER JOIN `1_1_two_subs_selected_to_be_treated` B ON                                                                                
 A.subs_bvd_id = B.subs_bvd_id; 

 INSERT INTO `layer2_clear_subs`
 SELECT subs_bvd_id, bvd_id2 as selected_bvd_id FROM `1_1_two_subs_selected_to_be_treated`
 WHERE subs_bvd_id IN (SELECT subs_bvd_id FROM `1_1_two_subs_selected_to_be_treated`                                             
 WHERE selected = 1 
 GROUP BY subs_bvd_id
 HAVING COUNT(*) = 1) AND selected = 1
 GROUP BY subs_bvd_id,bvd_id2;

 DELETE A FROM `1_1_two_subs_selected_to_be_treated` AS A
 INNER JOIN `layer2_clear_subs` AS B ON A.subs_bvd_id = B.subs_bvd_id;

/*
TAKE ALL SUBS WITH MORE THAN TWO SELECTED COMPANIES
*/
 
-- GROUP BY FOR THE REPEATED BVD_ID2 AND COUNT IF WITH THIS WE HAVE
-- SUBS WITH ONLY PAIRS, AND PUT THIS INTO THE SET OF SUBS TO BE TREATED
 INSERT INTO `1_1_two_subs_selected_to_be_treated`
 SELECT subs_bvd_id,bvd_id1,bvd_id2,selected FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs WHERE
 subs_bvd_id IN ( SELECT subs_bvd_id FROM (SELECT subs_bvd_id,bvd_id1,bvd_id2  
 FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs                                             
 WHERE selected = 1 GROUP BY subs_bvd_id,bvd_id2) AS A
 GROUP BY A.subs_bvd_id HAVING COUNT(*) = 2)  AND selected=1
 GROUP BY subs_bvd_id,bvd_id2;

 DELETE A FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs A                                                                                                                 
 INNER JOIN `1_1_two_subs_selected_to_be_treated` B ON A.subs_bvd_id = B.subs_bvd_id; 

 INSERT INTO `layer2_clear_subs`
 SELECT subs_bvd_id,bvd_id2 AS selected_bvd_id FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs WHERE
 subs_bvd_id IN ( SELECT subs_bvd_id FROM (SELECT subs_bvd_id,bvd_id1,bvd_id2  
 FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs                                             
 WHERE selected = 1 GROUP BY subs_bvd_id,bvd_id2) AS A
 GROUP BY A.subs_bvd_id HAVING COUNT(*) = 1)  AND selected=1
 GROUP BY subs_bvd_id,bvd_id2;

 DELETE A FROM cib_PatApr17_v2.layer2_couples_from_three_companies_in_the_matrix_pairs AS A
 INNER JOIN `layer2_clear_subs` AS B ON A.subs_bvd_id = B.subs_bvd_id;
 
  DROP TABLE IF EXISTS `tmp2_layer2`;
 
 CREATE TABLE `tmp2_layer2` AS
 SELECT subs_bvd_id,bvd_id2 
 FROM layer2_couples_from_three_companies_in_the_matrix_pairs WHERE selected=1
 GROUP BY subs_bvd_id,bvd_id2;
 
 DROP TABLE IF EXISTS layer2_couples_from_three_companies_in_the_matrix_pairs;
 
 CREATE TABLE `layer2_couples_from_three_companies_in_the_matrix_pairs` (
  `subs_bvd_id` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_id1` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_id2` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `selected` int(11) DEFAULT NULL
 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

 INSERT INTO layer2_couples_from_three_companies_in_the_matrix_pairs
 SELECT A.subs_bvd_id, A.bvd_id2 AS bvd_id1, B.bvd_id2 AS bvd_id2, 0 AS selected
 FROM `tmp2_layer2` AS A
 INNER JOIN cib_PatApr17_v2.tmp2_layer2 AS B
 ON A.subs_bvd_id = B.subs_bvd_id AND A.bvd_id2 <> B.bvd_id2;
 
 SELECT COUNT(*) INTO couples
 FROM layer2_couples_from_three_companies_in_the_matrix_pairs;
 END WHILE;
END $$
DELIMITER ;
