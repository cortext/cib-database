# The Corporate Invention Board Database (CIB)

The CIB (Corporate Invention Board) dataset is a database characterising the patent portfolios of the largest industrial firms worldwide. The CIB combines information extracted from the Industrial R&D Investment Scoreboard (EU Commission), the ORBIS financial database and the RISIS Patent database ( enriched version of the Patstat EPO database).

## Why CIB Database

The aim of **CIB** is to facilitate a dataset for the analysis on the transformation of global patent portfolios in the last two decades for industrial groups with the highest R&D investments and for their conrrespondent consolidate subsidiaries as well.

## How was it built

1. [About the RPD and ORBIS databases](#about-rpd-database) - A brief description about the two data sources used for generating CIB 
2. [Overview diagram](#overview-diagram) - Simple diagram describing the steps taken for building CIB
3. [Extraction of data from orbis](#extraction-of-orbis-data) - Criterias and methods for extracting orbis guo and subsidiaries
4. [Matching entities using PAM System](#matching-entities-using-pam-system) - Description of the followed process in order to link entities
5. [Database Modeling](#database-modeling) - The relational database design used for CIB database
6. [Funding](#funding) - Banner with the funding organizations

## About the RPD and ORBIS databases

## Overview diagram

### ORBIS 

**ORBIS** has information on over 280 million companies across the globe. It’s the biggest resource for company data making simple to compare companies internationally. Orbis is mostly used to find, analyse and compare companies for better decision making and increased efficiency.

### Risis patent database (RPD)

**RPD** is a patent database that has been set up using the European Patent Office (EPO) Worldwide Patent Statistical Database, henceforth PATSTAT developed by the EuropeanPatent Office. The conceptual model of the database offers the ability to manipulate relations between more than 30 tables. Each table contains a set of variables that enable studying several analytical dimensions: contents (title, abstract...), knowledge dynamics (bibliographical links for science and technology, fine grained description of the technological fields...), organizations (intellectual property through applicant names), geography (localization of the inventions and collaborations).

But **RPD** is as well an augmented version of the generic PATSTAT database in the sense that it includes a series of enrichment thanks to the filling of information missing in the initial PATSTAT database (e.g: addresses), the harmonisation of raw information from the initial PATSTAT database (e.g: country information) and the addition of new information (e.g: technological classification).

There are two repositories that includes the process for 

## Extraction of data from ORBIS

For creating **CIB** was only taken in account the subsidiaries that are consolidated, that means, the subsidiaries wherein a company have more than 50% stock purchased of the outstanding common stock, therefore the assets, liabilities, equity, income, expenses and cash flows of the parent company and its subsidiaries is presented as those of a single economic entity.

## Matching entities using PAM System 


## Database Modeling

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/cib-database/master/docs/data%20model%20diagram.png">
</p>

## Funding 
