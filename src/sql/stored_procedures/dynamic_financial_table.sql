CREATE PROCEDURE dynamic_financial_table(IN tables_name VARCHAR(255),
    IN number_of_columns INT(2))

BEGIN
    DECLARE x  INT;
    DECLARE operating_column  LONGTEXT DEFAULT '';
    DECLARE assests_column  LONGTEXT DEFAULT '';
    DECLARE net_income_column  LONGTEXT DEFAULT '';
    DECLARE employees_column  LONGTEXT DEFAULT '';
    DECLARE roe_column  LONGTEXT DEFAULT '';
    DECLARE roa_column  LONGTEXT DEFAULT '';

    -- counter
    SET x = 1;

    SET @table = tables_name;

    -- List of columns name
    SET @str_operating_revenue = 'operating_revenue';
    SET @str_total_assests = 'total_assests';
    SET @str_net_income = 'net_income';
    SET @str_number_employees = 'number_employees';
    SET @roe_before_taxes_percentage = 'roe_percent_before_taxes';
    SET @roa_before_taxes = 'roa_percent_before_taxes';

    -- Suffix concatenated to the column name
    SET @last_year_eur = '_last_year_eur';
    SET @last_year_usd = '_last_year_usd';

    -- No dynamic columns
    SET @id = 'n VARCHAR(255) NULL,';
    SET @company_name = 'name VARCHAR(255) NULL,';
    SET @guo_orbis = 'guo_orbis_id VARCHAR(255) NULL,';
    SET @last_year = 'last_year VARCHAR(255) NULL,';

    loop_label:  LOOP
    IF  x > number_of_columns THEN
        LEAVE  loop_label;
    END  IF;

    -- Columns concatenated with last_year_eur and last_year_usd
    -- e.g: operating_revenue_last_year_eur1 VARCHAR(255 NULL)

    SET operating_column = CONCAT(operating_column, @str_operating_revenue,
        @last_year_eur, x, ' TEXT NULL,');
    SET operating_column = CONCAT(operating_column, @str_operating_revenue,
        @last_year_usd, x, ' TEXT NULL,');

    -- Net_income
    SET net_income_column = CONCAT(net_income_column, @str_net_income,
        @last_year_eur, x, ' TEXT NULL,');
    SET net_income_column = CONCAT(net_income_column, @str_net_income,
        @last_year_usd, x, ' TEXT NULL,');

    -- Assets
    SET assests_column = CONCAT(assests_column, @str_total_assests,
        @last_year_eur, x, ' TEXT NULL,');
    SET assests_column = CONCAT(assests_column, @str_total_assests,
        @last_year_usd, x, ' TEXT NULL,');

    -- Employees
    SET employees_column = CONCAT(employees_column, @str_number_employees,
        x, ' TEXT NULL,');

    --  ROE
    SET roe_column = CONCAT(roe_column, @roe_before_taxes_percentage,
        x, ' TEXT NULL,');

    --  ROA
    SET roa_column = CONCAT(roa_column, @roa_before_taxes,
        x, ' TEXT NULL,');

    SET  x = x + 1;

END LOOP;

-- Remove last comma in order to build a well formatted query
SET roa_column = TRIM(',' FROM roa_column);

-- Concatenate all the columns that were dynamically generated
SET @query :=CONCAT('CREATE TABLE ',@table,
    '( ',@id, @company_name, @guo_orbis, @last_year, operating_column, assests_column,
        net_income_column, employees_column, roe_column, roa_column, ');');

-- SELECT @query;
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END
