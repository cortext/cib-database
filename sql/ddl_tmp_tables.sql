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
/*          tmp_pam_results_guo                                               */
/*          tmp_pam_results_subsidiaries                                      */
/*          tmp_cib_firm                                                      */
/*          tmp_cib_firm_names                                                */
/*          tmp_cib_firm_sector                                               */
/*          tmp_cib_firm_financial_data                                       */
/*          tmp_cluttered_financial_data                                      */
/*          tmp_orbis_firm_address                                            */
/*          tmp_prepare_address_to_geocode                                    */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                             Version 0.2 - Jan de 2020      */
/* ************************************************************************** */


/* TABLES TO LOAD THE RESULTS OBTAINED BY THE MATCHING SYSTEM */

CREATE TABLE tmp_pam_results_guo
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
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE tmp_pam_results_subsidiaries
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
)
engine=myisam
DEFAULT charset=utf8;


/* TABLES REQUIRES FOR LOADING AND PROCESS THE DATA EXTRACTED FROM ORBIS  */

CREATE TABLE tmp_cib_firms
(
    guo_orbis_id                VARCHAR(255) NULL,
    name                        VARCHAR(255) NULL,
    iso_ctry                    VARCHAR(255) NULL,
    nace2_main_section          VARCHAR(255) NULL,
    category                    VARCHAR(255) NULL,
    status                      VARCHAR(255) NULL,
    quoted                      VARCHAR(255) NULL,
    i_guo                       VARCHAR(255) NULL,
    incorporation_date          VARCHAR(255) NULL,
    last_year_account_available VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE tmp_cib_firm_names
(
    guo_orbis_id       VARCHAR(255) NULL,
    previous_name      VARCHAR(255) NULL,
    previous_name_date VARCHAR(255) NULL,
    aka_name           VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE tmp_cib_firm_sector
(
    guo_orbis_id          VARCHAR(255) NULL,
    nace2_primary_code    VARCHAR(255) NULL,
    nace2_primary_label   VARCHAR(255) NULL,
    nace2_secondary_code  VARCHAR(255) NULL,
    nace2_secondary_label VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE `tmp_cib_firm_financial_data` (
    `firmreg_id` varchar(16) NOT NULL,
    `year` varchar(255) DEFAULT NULL,
    `operating_revenue_eur` varchar(255) DEFAULT NULL,
    `operating_revenue_usd` varchar(255) DEFAULT NULL,
    `net_income_eur` varchar(255) DEFAULT NULL,
    `net_income_usd` varchar(255) DEFAULT NULL,
    `total_assests_eur` varchar(255) DEFAULT NULL,
    `total_assests_usd` varchar(255) DEFAULT NULL,
    `number_employees` varchar(255) DEFAULT NULL,
    `roe_percent_before_taxes` varchar(255) DEFAULT NULL,
    `roa_percent_before_taxes` varchar(255) DEFAULT NULL,
    `r&d_investment_eur_millions` varchar(255) DEFAULT NULL

) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*

The tmp_cluttered_financial_data table now is created dynamically using
a stored procedure, please refer to:

src/sql/stored_procedures/dynamic_financial_table.sql

and is generated at the following script:

src/sql/03 firm_financial_table.sql

CREATE TABLE tmp_cluttered_financial_data
(
    guo_orbis_id                                           VARCHAR(255) NULL,
    `last_year`                                            VARCHAR(255) NULL,
    operating_revenue_last_year                            VARCHAR(255) NULL,
    operating_revenue_previous_last_year                   VARCHAR(255) NULL,
    operating_revenue_two_years_previous_last_year         VARCHAR(255) NULL,
    total_assests_last_year                                VARCHAR(255) NULL,
    total_assests_previous_last_year                       VARCHAR(255) NULL,
    total_assests_two_years_previous_last_year             VARCHAR(255) NULL,
    number_employees_last_year                             VARCHAR(255) NULL,
    number_employees_previous_last_year                    VARCHAR(255) NULL,
    number_employees_two_years_previous_last_year          VARCHAR(255) NULL,
    pl_before_taxes_last_year                              VARCHAR(255) NULL,
    pl_before_taxes_previous_last_year                     VARCHAR(255) NULL,
    pl_before_taxes_two_years_previous_last_year           VARCHAR(255) NULL,
    roe_using_pl_before_taxes_last_year                    VARCHAR(255) NULL,
    roe_using_pl_before_taxes_previous_last_year           VARCHAR(255) NULL,
    roe_using_pl_before_taxes_two_years_previous_last_year VARCHAR(255) NULL,
    roa_using_pl_before_taxes_last_year                    VARCHAR(255) NULL,
    roa_using_pl_before_taxes_previous_last_year           VARCHAR(255) NULL,
    roa_using_pl_before_taxes_two_years_previous_last_year VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;
 */

CREATE TABLE tmp_orbis_firm_address
(
    guo_orbis_id        VARCHAR(255) NULL,
    address_line1       VARCHAR(255) NULL,
    address_line2       VARCHAR(255) NULL,
    address_line3       VARCHAR(255) NULL,
    address_line4       VARCHAR(255) NULL,
    postcode            VARCHAR(255) NULL,
    city                VARCHAR(255) NULL,
    country_iso_code    VARCHAR(255) NULL,
    country_region      VARCHAR(255) NULL,
    country_region_type VARCHAR(255) NULL,
    nuts1               VARCHAR(255) NULL,
    nuts2               VARCHAR(255) NULL,
    msa                 VARCHAR(255) NULL,
    world_region        VARCHAR(255) NULL,
    us_state            VARCHAR(255) NULL,
    county              VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE tmp_prepare_address_to_geocode
(
    guo_orbis_id VARCHAR(255) NULL,
    address      TEXT CHARACTER SET utf8
)
engine=myisami
DEFAULT charset=utf8;


CREATE TABLE tmp_firmreg_id
(
    guo_orbis_id VARCHAR(255) NULL,
    firmreg_id   VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;


CREATE TABLE `tmp_r&d_investments_data`
(
    firmreg_id    VARCHAR(255) NULL,
    `r&d_2017`    VARCHAR(255) NULL,
    `r&d_2016`    VARCHAR(255) NULL,
    `r&d_2015`    VARCHAR(255) NULL,
    `r&d_2014`    VARCHAR(255) NULL,
    `r&d_2013`    VARCHAR(255) NULL,
    `r&d_2012`    VARCHAR(255) NULL,
    `r&d_2011`    VARCHAR(255) NULL,
    `r&d_2010`    VARCHAR(255) NULL,
    `r&d_2009`    VARCHAR(255) NULL,
    `r&d_2008`    VARCHAR(255) NULL,
    `r&d_2007`    VARCHAR(255) NULL,
    `r&d_2006`    VARCHAR(255) NULL,
    `r&d_2005`    VARCHAR(255) NULL,
    `r&d_2004`    VARCHAR(255) NULL
)
engine=myisam
DEFAULT charset=utf8;
