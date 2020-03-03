CREATE PROCEDURE normalize_null(
    IN table_name CHAR(50), 
    IN column_name CHAR(50)
    )
BEGIN
	
	 /*  
 	 *  This will transform heteregenous definitions to "not available" into NULL.
 	 *  when the parameters are:
 	 * 
 	 *  @table_name = cib_firm_financial_data
 	 *  @columame = roe_using_pl_before_taxes 
 	 * 
 	    UPDATE cib_firm_financial_data
		SET roe_using_pl_before_taxes =  NULL
		WHERE roe_using_pl_before_taxes = "n.a."
		OR roe_using_pl_before_taxes = "n.s."
		OR roe_using_pl_before_taxes = "#N/A"
		OR roe_using_pl_before_taxes = " ";  
 	 */
	
	SET @SQLText = 	CONCAT('UPDATE ',table_name,
	' SET ',column_name,'= NULL 
    WHERE ',column_name,'="n.a." 
	OR ',column_name,' = "n.s." 
	OR ',column_name,' = "n.s." 
	OR ',column_name,' = "#N/A" 
	OR ',column_name,' = "";');  

 	PREPARE stmt FROM @SQLText;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END 
