/* ************************************************************************** */
/* LISIS Laboratoire Interdisciplinaire Sciences Innovations Sociétés         */
/* http://umr-lisis.fr/                                                       */
/*                                                                            */
/* This script contains every required create statement in order to           */
/* build the new corporate invention board database                           */
/*                                                                            */
/*                                                                            */
/*            Juan Pablo O    juanpablo.ospinadelgado@esiee.fr                */
/*                                                                            */
/*                                                                            */
/*     Name of tables :                                                       */
/*                                                                            */
/*     CIBmatch_global_ultimate_owners                                        */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                             Version 1.0 - May de 2019      */
/* ************************************************************************** */


/* *************************** Guo Harmonization **************************** */

-- The table stores all the name variations for guos 
CREATE TABLE CIBmatch_global_ultimate_owners ( 
	new_bvd_id INTEGER NOT NULL DEFAULT '0',
    original VARCHAR(255),
	magerman VARCHAR(255),
	patstat_std VARCHAR(255),
	manual VARCHAR(255),
	manual2 VARCHAR(255),
	manual3 VARCHAR(255),
	cnty_iso VARCHAR(2)
); 

/* *************************** Patent applicants **************************** */ 
 
-- The table stores legal applicant that have priority patent from 2000 onward
CREATE TABLE `CIBmatch_applt_risis_patents` (
  `appln_id` int(10) NOT NULL DEFAULT '0',
  `person_id` int(10) NOT NULL DEFAULT '0',
  `doc_std_name_id` int(10) NOT NULL DEFAULT '0',
  `person_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `person_ctry_code` varchar(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `source` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `methode` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_final` varchar(300) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `adr_final` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `invt_seq_nr` smallint(4) DEFAULT NULL,
  `iso_ctry` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `doc_std_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `psn_id` int(11) DEFAULT NULL,
  KEY `CIBmatch_applt_risis_patents_compound_iso_docn` (`doc_std_name`,`iso_ctry`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


/* *************************** Matching log **************************** */ 

-- The table stores the register of match for every used method
CREATE TABLE CIBmatch_summarize_matching ( 
	new_bvd_id INTEGER NOT NULL DEFAULT '0',
    original VARCHAR(255),
	name_for_match VARCHAR(255),
	doc_std_name_id VARCHAR (255),
	doc_std_name VARCHAR(255),
 	match_type VARCHAR(255),
	country VARCHAR(2),
	N_Patents int(10)
);

