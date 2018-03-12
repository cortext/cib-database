# CIB (Corporate Invetion Board)

The CIB (Corporate Invention Board) dataset is a database characterising the patent portfolios of the largest industrial firms worldwide. 
The CIB combines information extracted from the Industrial R&D Investment Scoreboard (EU Commission), the ORBIS financial database and 
the PATSTAT-IFRIS patent database - an enriched version of the Patstat EPO database.

## Importing Data

Based on the columns defined by ORBIS exported files, were created the first tables, the aim is to import all the ORBIS data file's 
into the new table. How is not clear the data type, it was assigned VARCHAR type to the columns.

```sql
CREATE TABLE `guo_all_data` (
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
To extract this information from the ORBIS structured csv file, it was used a simple bash script, that
extract 
