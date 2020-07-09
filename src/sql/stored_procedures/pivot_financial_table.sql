CREATE PROCEDURE pivot_financial_table(IN tables_name VARCHAR(255),
    IN number_of_pivots INT(2))
BEGIN
    DECLARE x  INT;

    SET x = 1;

    loop_label:  LOOP
    IF  x > number_of_pivots THEN
        LEAVE  loop_label;
    END  IF;

    SET @year_subtr = x - 1;
    SET @query := CONCAT('
        INSERT INTO tmp_cib_firm_financial_data
        SELECT  guo_orbis_id,
        last_year - ', @year_subtr, ',
        operating_revenue_last_year_eur', x, ',
        operating_revenue_last_year_usd', x, ',
        net_income_last_year_eur', x, ',
        net_income_last_year_usd', x, ',
        total_assests_last_year_eur', x, ',
        total_assests_last_year_usd', x, ',
        number_employees', x, ',
        roe_percent_before_taxes', x, ',
        roa_percent_before_taxes', x, '
        FROM   tmp_cluttered_financial_data');

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET  x = x + 1;
END LOOP;
END
