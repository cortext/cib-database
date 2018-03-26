# CIB (Corporate Invention Board)

The CIB (Corporate Invention Board) dataset is a database characterising the patent portfolios of the largest industrial firms worldwide. The CIB combines information extracted from the Industrial R&D Investment Scoreboard (EU Commission), the ORBIS financial database and the PATSTAT-IFRIS patent database - an enriched version of the Patstat EPO database.

## Importing The ORBIS Data

**ORBIS** has information on over 280 million companies across the globe. It’s the resource for company data. And it makes simple to compare companies internationally. Orbis is mostly used to find, analyse and compare companies for better decision making and increased efficiency.

Based on the columns defined by ORBIS exported files, were created the first tables, the aim is to import all the ORBIS data file's into the new table. How is not clear the data type, it was assigned VARCHAR type to the columns.

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

Deleting some residuals

```sql
DELETE FROM guo_all_data WHERE mark = "??Mark";
DELETE FROM guo_all_data WHERE mark = '﻿"Mark"	Company name';
DELETE FROM guo_all WHERE bvd_id="BvD ID number";
DELETE FROM guo_all WHERE bvd_id="GBGGLP1545" LIMIT 1;
```

### The Data Model

The data model for the first phase (Orbis) is composed of only two tables, one that contains the companies and the other one that store the consolidated subsidiaries from these firms. Here is the create statement for both tables.

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

CREATE TABLE `subsidiaries` (
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

## Building the data

Inserting the ORBIS data into the companies and subsidiaries tables. As can be seen, the only needed filter is by the field "mark".

```sql
INSERT INTO `subsidiaries`
SELECT `BvD ID`,
`Level`,
`Subsidiary name`,
`Subsidiary BvD ID`,
......
......
`Also known as name` FROM `orbis_all_data` WHERE mark = "";

INSERT INTO `companies`
SELECT `company_name`,
`cnty_iso`,
`bvd_id`,
.....
.....
NULL as `ftype` FROM `orbis_all_data` WHERE mark <> "";
```
### Consolidated subsidiaries

For CIB was only taken in account the subsidiaries that are consolidated, that means, the subsidiaries wherein a company have more than 50% stock purchased of the outstanding common stock, therefore the assets, liabilities, equity, income, expenses and cash flows of the parent company and its subsidiaries is presented as those of a single economic entity.

#### Criteria 1

The extracted subsidiaries were filtered by the field subs_status, when the value was UO (ultimate owner) or UO+ (global ultimate owner) which is, the subsidiaries that already have a company that ultimately owns them or controls them.

``` sql 

CREATE TABLE 01_subsidaries_uo_uop AS
SELECT * FROM subsidiaries WHERE subs_status = 'UO' OR subs_status = 'UO+';
```

As many subsidiaries still belonged to multiple companies, it was necessary to filter again, but, based on the level of the 
subsidiary regarding the company. So was selected the record with the highest level.

```sql
CREATE TABLE 02_subsidaries_filter_min_level
SELECT a.*
FROM 01_subsidaries_uo_uop a
INNER JOIN (
   SELECT bvd_id, subs_bvd_id, MIN(subs_level) as subs_level
   FROM 01_subsidaries_uo_uop
   GROUP BY subs_bvd_id, bvd_id
   HAVING COUNT(*) > 1
) b ON a.bvd_id = b.bvd_id AND a.subs_bvd_id = b.subs_bvd_id AND a.subs_level = b.subs_level

CREATE TABLE 02_subsidaries_filter_min_level_take_max_subs_direct
SELECT *, MAX(subs_direct)
FROM  .`02_subsidaries_filter_min_level`
GROUP BY subs_bvd_id
HAVING COUNT(*) > 1

DELETE FROM 02_subsidaries_filter_min_level
WHERE subs_bvd_id IN (SELECT subs_bvd_id FROM 02_subsidaries_filter_min_level_take_max_subs_direct);

INSERT INTO 02_subsidaries_filter_min_level
SELECT * FROM 02_subsidaries_filter_min_level_take_max_subs_direct;

DELETE A FROM 01_subsidaries_uo_uop A
INNER JOIN 02_subsidaries_filter_min_level B ON
A.subs_bvd_id = B.subs_bvd_id;

INSERT INTO 01_subsidaries_uo_uop
SELECT * FROM 02_subsidaries_filter_min_level
```

#### Criteria 2

Still with a remaining good amount of the subsidiaries without being analyzed, was used the fields subs_total and subs_direct to determine the rest of consolidated subsidiaries. In ORBIS, "subs_directs" is the "Percentage Owned Direct" where a consolidate entity is represented by the "WO" (wholly owned) code or "MO" (majority owned) code, these symbolize 100% and >50.1% of ownership respectively. Subs_total is the "Percentage Owned Total", this variable is a combination of numbers and string representations such as '>75.00'. Thus the following script extracts all these cases and create a new table with the final filter. (The list of subs_direct values was obtained by doing a `distinct` selection over the field)  

```sql
CREATE TABLE 02_subsidiaries_filter_MO_WO_51 AS
SELECT * FROM subsidiaries WHERE subs_direct='MO' OR subs_direct='WO' OR subs_direct > 50 OR
subs_total='MO' OR subs_total='WO' OR subs_total > 50 OR subs_direct IN
('>50.00','>50.01','>53.00','>54.99','>55.00','>58.00','>60.00','>65.00',
'>66.90','>67.00','>69.00','>70.00','>73.00','>75.00','>80.00','>84.00','>85.00','>89.00','>90.00',
'>93.00','>94.00','>94.90','>95.00','>96.00','>96.60','>97.00','>98.00','>99.00','>99.90','>99.99')
OR subs_total IN ('>50.00','>50.01','>53.00','>54.99','>55.00','>58.00','>60.00','>65.00',
'>66.90','>67.00','>69.00','>70.00','>73.00','>75.00','>80.00','>84.00','>85.00','>89.00','>90.00',
'>93.00','>94.00','>94.90','>95.00','>96.00','>96.60','>97.00','>98.00','>99.00','>99.90','>99.99');
```
Again, is required to check if exist duplicate subsidiaries in the table and clean them based on level, besides deleting the overlapping records between criteria one and criteria two. 

```sql
CREATE TABLE 02_01_subsidiaries_filter_MO_WO_51
SELECT A.* FROM 02_subsidiaries_filter_MO_WO_51 AS A
LEFT JOIN 01_subsidaries_uo_uop AS B
ON A.subs_bvd_id = B.subs_bvd_id
WHERE B.subs_bvd_id IS NULL;

-- Subsidiaries that belongs only to one company
CREATE TABLE finalfilter_uo_uop_mo_wo_51 AS
SELECT *, '2' AS ftype FROM `02_01_subsidiaries_filter_MO_WO_51`
GROUP BY subs_bvd_id
HAVING COUNT(*) < 2;

-- Subsidiaries 
CREATE TABLE consolidated_subsidiaries
SELECT *, '2' AS ftype FROM 02_01_subsidiaries_filter_MO_WO_51
GROUP BY subs_bvd_id
HAVING COUNT(*) < 2;

-- Transforming levels from orbis into numbers
UPDATE 02_01_subsidiaries_filter_MO_WO_51_temp AS t1
INNER JOIN (SELECT LENGTH(`subs_level`) - LENGTH(REPLACE(`subs_level`, '.', '')) AS level2, id
   FROM 02_01_subsidiaries_filter_MO_WO_51_temp) AS t2
ON t2.id = t1.id
SET t1.`subs_level` = t2.level2;

-- Taking from level1 the subsidiaries that belongs to two companies and are in level 1
SELECT A1.company_name, B1.* FROM companies AS A1
INNER JOIN (
SELECT A.* FROM 02_01_subsidiaries_filter_MO_WO_51_level_1 AS A
INNER JOIN (
SELECT subs_bvd_id FROM 02_01_subsidiaries_filter_MO_WO_51_level_1
GROUP BY subs_bvd_id
HAVING COUNT(subs_bvd_id) > 1) AS B ON A.subs_bvd_id = B.subs_bvd_id) AS B1
ON A1.bvd_id = B1.bvd_id
ORDER BY B1.subs_bvd_id;

CREATE TABLE 02_02_subsidiaries_filter_MO_WO_51_only_highest_level AS
SELECT A.* FROM 02_02_subsidiaries_filter_MO_WO_51 AS A
INNER JOIN (
SELECT bvd_id, subs_name, subs_bvd_id, MIN(subs_level) as subs_level FROM 02_02_subsidiaries_filter_MO_WO_51
GROUP BY bvd_id, subs_bvd_id) AS B
ON A.bvd_id = B.bvd_id AND A.subs_bvd_id = B.subs_bvd_id AND A.subs_level = B.subs_level
ORDER BY A.subs_bvd_id;

INSERT INTO consolidated_subsidiaries
SELECT *, '3' AS ftype FROM 02_02_subsidiaries_filter_MO_WO_51_only_highest_level
GROUP BY subs_bvd_id
HAVING COUNT(*) < 2;
```
#### Final checks

As a result, there is the companies table and the 'consolidated_subsidiaries' table, in the second one was made a final verification uploading the resulted data into ORBIS platform to determine the real and final consolidated entities. 

Based on the previous revisions, it was done a cleaning process to merger some companies or transfer a subsidiary to another company. Is important to clarify that these changed might be already done in the continue updates made by ORBIS. The script with the cleaning action can be found as 'script_cleaning.sql'.


#### Deprecated

The next url contain a stored procedure that was written in order to detect which subsidiaries were consolidated and which no. But this action was replaced by manual verification with ORBIS platform.
Even so the function can be analyzed in the following link.

[-- Deprecated Work --](/DEPRECATED.md)
