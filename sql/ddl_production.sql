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
/*          cib_firms                                                         */
/*          cib_firm_address                                                  */
/*          cib_firm_names                                                    */
/*          cib_firm_sector                                                   */
/*          cib_firm_financial_data                                           */
/*          cib_patents_actor                                                 */
/*          cib_patents_inventor                                              */
/*          cib_patents_priority_attributes                                   */
/*          cib_patents_technological_classification                          */
/*          cib_patents_textual_information                                   */
/*          cib_patents_values                                                */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                             Version 2.0.1 - Jan de 2020    */
/* ************************************************************************** */



CREATE TABLE `cib_firms`
(
    `guo_orbis_id`       VARCHAR(16) CHARACTER SET utf8 NOT NULL,
    `simplified_name`    VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    `iso_ctry`           VARCHAR(2) CHARACTER SET utf8 DEFAULT NULL,
    `nace2_main_section` VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `category`           VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `status`             VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `quoted` ENUM('yes','no') CHARACTER SET utf8 DEFAULT NULL,
    `i_guo`                       INT(1) DEFAULT NULL,
    `incorporation_date`          VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `last_year_account_available` INT(4) DEFAULT NULL,
    PRIMARY KEY (`guo_orbis_id`),
    KEY `cib_firms_guo_orbis_id_idx` (`guo_orbis_id`) using btree
)
engine=innodb DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_firm_address`
(
    `guo_orbis_id` VARCHAR(16) CHARACTER SET utf8 NOT NULL,
    `address`      VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `label`        VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `longitude` DOUBLE DEFAULT NULL,
    `latitude` DOUBLE DEFAULT NULL,
    `confidence` FLOAT DEFAULT NULL,
    `city`             VARCHAR(50) CHARACTER SET utf8 DEFAULT NULL,
    `region`           VARCHAR(50) CHARACTER SET utf8 DEFAULT NULL,
    `country`          VARCHAR(50) CHARACTER SET utf8 DEFAULT NULL,
    `iso3`             VARCHAR(3) CHARACTER SET utf8 DEFAULT NULL,
    `nuts_id`          VARCHAR(50) DEFAULT NULL,
    `nuts_source`      VARCHAR(50) CHARACTER SET utf8 DEFAULT NULL,
    `rurban_area_id`   VARCHAR(50) CHARACTER SET utf8 DEFAULT NULL,
    `rurban_area_name` VARCHAR(75) CHARACTER SET utf8 DEFAULT NULL,
    KEY `cib_firm_address_geocoding2_guo_orbis_id_idx` (`guo_orbis_id`) using btree,
    CONSTRAINT `cib_firm_address_fk` FOREIGN KEY (`guo_orbis_id`) REFERENCES `cib_firms` (`guo_orbis_id`)
)
engine=innodb DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;


-- CIB_2020_v2_lab.cib_firm_names definition

CREATE TABLE `cib_firm_names` (
    `firmreg_id` varchar(16) NOT NULL,
    `previous_name` varchar(255) DEFAULT NULL,
    `previous_name_date` varchar(50) DEFAULT NULL,
    `aka_name` varchar(255) DEFAULT NULL,
    `official_name_03_2020` varchar(255) DEFAULT NULL,
    `official_name_firmreg` varchar(255) DEFAULT NULL,
    KEY `cib_firm_names_guo_orbis_id_IDX` (`firmreg_id`) USING BTREE,
    CONSTRAINT `cib_firm_names_FK` FOREIGN KEY (`firmreg_id`) REFERENCES `cib_firms` (`firmreg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `cib_firm_sector`
(
    `guo_orbis_id`          VARCHAR(16) CHARACTER SET utf8 NOT NULL,
    `nace2_primary_code`    INT(4) DEFAULT NULL,
    `nace2_primary_label`   VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    `nace2_secondary_code`  INT(4) DEFAULT NULL,
    `nace2_secondary_label` VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
    KEY `cib_firm_sector_guo_orbis_id_idx` (`guo_orbis_id`) using btree,
    CONSTRAINT `cib_firm_sector_fk` FOREIGN KEY (`guo_orbis_id`) REFERENCES `cib_firms` (`guo_orbis_id`)
)
engine=innodb DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_firm_financial_data`
(
    `guo_orbis_id` VARCHAR(16) CHARACTER SET utf8 NOT NULL,
    `year`         INT(4) DEFAULT NULL,
    `operating_revenue` FLOAT DEFAULT NULL,
    `total_assests` FLOAT DEFAULT NULL,
    `number_employees` INT(11) DEFAULT NULL,
    `pl_before_taxes` FLOAT DEFAULT NULL,
    `roe_using_pl_before_taxes` FLOAT DEFAULT NULL,
    `roa_using_pl_before_taxes` FLOAT DEFAULT NULL,
    KEY `cib_firm_financial_data_guo_orbis_id_idx` (`guo_orbis_id`) using btree,
    CONSTRAINT `cib_firm_financial_data_fk` FOREIGN KEY (`guo_orbis_id`) REFERENCES `cib_firms` (`guo_orbis_id`)
)
engine=innodb DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_patents_actors`
(
    `appln_id`        INT(10) NOT NULL DEFAULT '0',
    `guo_orbis_id`    VARCHAR(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `person_id`       INT(10) NOT NULL DEFAULT '0',
    `person_name`     VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `doc_std_name`    VARCHAR(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `doc_std_name_id` INT(10) NOT NULL DEFAULT '0',
    `psn_id`          INT(11) DEFAULT NULL,
    `psn_name`        VARCHAR(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `psn_sector`      VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `adr_final`       VARCHAR(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `name_final`      VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `continent_final` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `iso_ctry`        VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `latitude` DOUBLE DEFAULT NULL,
    `longitude` DOUBLE DEFAULT NULL,
    `confidence` FLOAT DEFAULT NULL,
    `iso3`                        VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_id`              VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_name`            VARCHAR(75) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_characteristics` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `nuts_source`                 VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `nuts_id`                     VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `frac_actor` FLOAT DEFAULT NULL,
    PRIMARY KEY (`appln_id`,`person_id`),
    KEY `cib_patents_actors_appln_id_idx` (`appln_id`) using btree,
    KEY `cib_patents_actors_guo_orbis_id_idx` (`guo_orbis_id`) USING btree,
    KEY `cib_patents_actors_doc_std_name_id_idx` (`doc_std_name_id`) USING btree,
    KEY `cib_patents_actors_name_final_idx` (`name_final`) USING btree,
    KEY `cib_patents_actors_person_id_idx` (`person_id`) USING btree
)
engine=myisam DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_patents_inventors`
(
    `appln_id`        INT(10) NOT NULL DEFAULT '0',
    `person_id`       INT(10) NOT NULL DEFAULT '0',
    `adr_final`       VARCHAR(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `person_name`     VARCHAR(300) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `iso_ctry`        VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `continent_final` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `latitude` DOUBLE DEFAULT NULL,
    `longitude` DOUBLE DEFAULT NULL,
    `confidence` FLOAT DEFAULT NULL,
    `iso3`                        VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_id`              VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_name`            VARCHAR(75) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `rurban_area_characteristics` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `nuts_source`                 VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `nuts_id`                     VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `frac_inventor` FLOAT DEFAULT NULL,
    PRIMARY KEY (`appln_id`,`person_id`),
    KEY `cib_patents_inventors_appln_id_idx` (`appln_id`) using btree
)
engine=myisam DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_patents_priority_attributes`
(
    `appln_id`             INT(10) NOT NULL DEFAULT '0',
    `appln_kind`           VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `appln_nr`             VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `appln_auth`           VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `earliest_filing_year` SMALLINT(6) DEFAULT NULL,
    `earliest_publn_auth`  VARCHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `earliest_publn_nr`    VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `earliest_publn_year`  SMALLINT(6) DEFAULT NULL,
    `grant_year`           SMALLINT(6) DEFAULT NULL,
    PRIMARY KEY (`appln_id`),
    KEY `cib_patents_priority_attributes_appln_id_idx` (`appln_id`) using btree
)
engine=myisam DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;



CREATE TABLE `cib_patents_textual_infromation`
(
    `appln_id` INT(10) NOT NULL DEFAULT '0',
    `appln_title` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci,
    `appln_title_lg` CHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `appln_title_en` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci,
    `appln_title_en_source` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `appln_abstract` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci,
    `appln_abstract_lg` CHAR(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `appln_abstract_en` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci,
    `appln_abstract_en_source` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `ipc_description` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci,
    PRIMARY KEY (`appln_id`),
    KEY `cib_patents_textual_infromation_appln_id_idx` (`appln_id`) using btree
)
engine=myisam DEFAULT  charset=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `cib_patents_technological_classification`
(
    `appln_id`         INT(10) NOT NULL DEFAULT '0',
    `ipc_class_symbol` VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
    `frac_ipc`         DECIMAL(5,4) DEFAULT NULL,
    `domains`          VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `fields`           VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `subfields`        VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
    `ipc_class_level`  VARCHAR(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (`appln_id`,`ipc_class_symbol`),
    KEY `cib_patents_technological_classification_appln_id_idx` (`appln_id`) using btree
)
engine=myisam DEFAULT charset=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `cib_patents_value`
(
    `appln_id`              INT(10) NOT NULL DEFAULT '0',
    `granted`               INT(11) DEFAULT NULL,
    `nb_citing_docdb_fam`   SMALLINT(6) DEFAULT NULL,
    `singleton`             INT(1) NOT NULL DEFAULT '0',
    `transnat`              INT(1) NOT NULL DEFAULT '0',
    `ip5_family`            INT(1) NOT NULL DEFAULT '0',
    `triadic`               INT(1) NOT NULL DEFAULT '0',
    `ip5`                   INT(1) NOT NULL DEFAULT '0',
    `us`                    INT(1) NOT NULL DEFAULT '0',
    `ep`                    INT(1) NOT NULL DEFAULT '0',
    `jp`                    INT(1) NOT NULL DEFAULT '0',
    `cn`                    INT(1) NOT NULL DEFAULT '0',
    `kr`                    INT(1) NOT NULL DEFAULT '0',
    `pct_in_inpadoc_family` INT(1) NOT NULL DEFAULT '0',
    `nb_patents_docdb`      SMALLINT(6) DEFAULT NULL,
    `nb_offices_docdb`      SMALLINT(6) DEFAULT NULL,
    `nb_patents_inpadoc`    SMALLINT(6) DEFAULT NULL,
    `nb_offices_inpadoc`    SMALLINT(6) DEFAULT NULL,
    PRIMARY KEY (`appln_id`),
    KEY `cib_patents_value_appln_id_idx` (`appln_id`) using btree,
    KEY `cib_patents_value_triadic_idx` (`triadic`) USING btree,
    KEY `cib_patents_value_ip5_idx` (`ip5`) USING btree
)
engine=myisam DEFAULT  charset=utf8 COLLATE=utf8_unicode_ci;
