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
/*          pam_results                                                       */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*                                             Version 0.1 - Jan de 2020      */
/* ************************************************************************** */


CREATE TABLE pam_results (
    id VARCHAR(255) NULL,
    doc_std_name VARCHAR(255) NULL,
    doc_std_name_id VARCHAR(255) NULL,
    `check` VARCHAR(255) NULL,
    orbis_id VARCHAR(255) NULL,
    orbis_name VARCHAR(255) NULL,
    name_type VARCHAR(255) NULL,
    number_patents VARCHAR(255) NULL,
    elastic_score VARCHAR(255) NULL,
    levensthein_score VARCHAR(255) NULL,
    jaro_winkler_score VARCHAR(255) NULL,
    ratcliff_obershelp_score VARCHAR(255) NULL,
    pam_score VARCHAR(255) NULL,
    query_type VARCHAR(255) NULL
);

