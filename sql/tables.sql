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

CREATE TABLE CIBmatch_global_ultimate_owners ( 
	new_bvd_id INTEGER NOT NULL,
    original VARCHAR(255),
	magerman VARCHAR(255),
	patstat_std VARCHAR(255),
	manual VARCHAR(255),
	manual2 VARCHAR(255),
	manual3 VARCHAR(255),
	cnty_iso VARCHAR(2)
); 


