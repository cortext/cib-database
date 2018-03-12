# CIB (Corporate Invetion Board)

The CIB (Corporate Invention Board) dataset is a database characterising the patent portfolios of the largest industrial firms worldwide. 
The CIB combines information extracted from the Industrial R&D Investment Scoreboard (EU Commission), the ORBIS financial database and 
the PATSTAT-IFRIS patent database - an enriched version of the Patstat EPO database.

## Importing The ORBIS Data

**ORBIS** has information on over 280 million companies across the globe. It’s the resource for company data. And it makes simple to compare 
companies internationally. Orbis is mostly used to find, analyse and compare companies for better decision making and increased efficiency.

Based on the columns defined by ORBIS exported files, were created the first tables, the aim is to import all the ORBIS data file's 
into the new table. How is not clear the data type, it was assigned VARCHAR type to the columns.

```sql
CREATE TABLE `orbis_all_data` (
  `mark` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `company_name` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `cnty_iso` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_id` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_bvd_id` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_name` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `entity_type` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `category` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `operating_revenue_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace_primary` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace_secondary` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `previous_company_name` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_subs` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_level` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_name` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_bvd_id` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_cnty_iso` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_nace` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_direct` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_total` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_status` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_info_source` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_info_posbl_change` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_city` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_type` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_info_date` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_operating_revenue_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_no_employees` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `subs_total_assets_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvb_indep_indic` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_nace` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_direct` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_total` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_no_employees` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_city` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `latitude` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `longitude` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `info_date_operating_revenue` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `net_income_eur` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `net_income_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `info_date_total_assets` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_employees` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `date_info_no_employees` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `total_assets_eur` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `total_assets_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `current_market_eur` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `current_market_usd` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_exchange` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `status_list` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_indep_indic` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_companies_corp_group` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_recorded_subs` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_production_site` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_distribution_site` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_domestic_cnty` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_foreign_cnty` VARCHAR(100) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf16;
```
To extract this information from the ORBIS structured csv file, it was used a simple bash script, this 
script extracts the header information and concatenate it with the SQL create statement and the "varchar" data type.

```bash
#!/bin/sh
# pass in the file name as an argument: ./crate_table.sh filename.csv
echo "create table $1 ( "
head -1 $1 | sed -e "s/,/ varchar(255),\n/g"
echo " varchar(255) );"
```
To proceed with the importing process was necessary, first, to convert all the format files txt to csv and second, 
concatenate the files into bigger pieces in order to upload them into a remote database. The following scripts 
were used for this purpose.

```bash
# Rename all *.txt to *.csv
for f in *.txt; do 
mv -- "$f" "${f%.txt}.csv"
done
```

```bash
# Concatenate all the csv files
awk '
    FNR==1 && NR!=1{next;}{print}
    ' $(ls -t) > all.csv
```

```bash
# Add break line to the concatenated file
for file in *.csv; do
    echo -e "\n" >> "$file"
done
```

The next sentence uploads all the orbis data into the previously created table.

```sql
use `database_name`;

LOAD DATA LOCAL INFILE '/path/to/file/all.csv' 
INTO TABLE `orbis_all_data` FIELDS TERMINATED BY '\t'
ESCAPED BY ''
IGNORE 1 LINES;
```
#### Cleaning imported data

Delete some residuals

```sql
DELETE FROM guo_all_data WHERE mark = "??Mark";
DELETE FROM guo_all_data WHERE mark = '﻿"Mark"	Company name';
DELETE FROM guo_all WHERE bvd_id="BvD ID number";
DELETE FROM guo_all WHERE bvd_id="GBGGLP1545" LIMIT 1;
```

### The Data Model

The data model for the first phase (Orbis) is only composed of two tables, one that 
contains the companies and the other one that store the consolidated subsidiaries from 
these firms. Here is the create statement for both tables.

```sql

CREATE TABLE `companies` (
  `company_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `cnty_iso` varchar(2) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_id` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `guo_bvd_id` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `guo_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `entity_type` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `operating_revenue_usd` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace_primary` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `nace_secondary` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `previous_company_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_subs` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvb_indep_indic` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_nace` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_direct` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_total` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_no_employees` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `guo_city` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `latitude` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `longitude` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `info_date_operating_revenue` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `net_income_eur` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `net_income_usd` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `info_date_total_assets` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_employees` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `date_info_no_employees` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `total_assets_eur` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `total_assets_usd` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `current_market_eur` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `current_market_usd` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_exchange` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `status_list` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bvd_indep_indic` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_companies_corp_group` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `no_recorded_subs` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_production_site` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_distribution_site` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_domestic_cnty` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `main_foreign_cnty` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  KEY `companies_bvd_id_IDX` (`bvd_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `consolidated_subsidiaries` (
  `bvd_id` varchar(100) DEFAULT NULL,
  `subs_level` int(11) DEFAULT NULL,
  `subs_name` varchar(100) DEFAULT NULL,
  `subs_bvd_id` varchar(100) DEFAULT NULL,
  `subs_cnty_iso` varchar(100) DEFAULT NULL,
  `subs_nace` varchar(100) DEFAULT NULL,
  `subs_direct` varchar(100) DEFAULT NULL,
  `subs_total` varchar(100) DEFAULT NULL,
  `subs_status` varchar(100) DEFAULT NULL,
  `subs_info_source` varchar(100) DEFAULT NULL,
  `subs_info_posbl_change` varchar(100) DEFAULT NULL,
  `subs_city` varchar(100) DEFAULT NULL,
  `subs_type` varchar(100) DEFAULT NULL,
  `subs_info_date` varchar(100) DEFAULT NULL,
  `subs_operating_revenue_usd` varchar(100) DEFAULT NULL,
  `subs_no_employees` varchar(100) DEFAULT NULL,
  `subs_total_assets_usd` varchar(100) DEFAULT NULL,
  `Also known as name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `ftype` varchar(12) DEFAULT NULL,
  KEY `consolidated_subsidiaries_subs_bvd_id_IDX` (`subs_bvd_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
```
At this point the diagram E-R is this:

![diagram](https://image.ibb.co/hLo8xF/diagram.png)

### Building the data
