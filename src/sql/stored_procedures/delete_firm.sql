CREATE PROCEDURE delete_firm(IN firm_id CHAR(16))
begin
  DELETE FROM cib_firms
  WHERE  guo_orbis_id = firm_id;

  DELETE FROM cib_firm_address
  WHERE  guo_orbis_id = firm_id;

  DELETE FROM cib_firm_financial_data
  WHERE  guo_orbis_id = firm_id;

  DELETE FROM cib_firm_names
  WHERE  guo_orbis_id = firm_id;

  DELETE FROM cib_firm_sector
  WHERE  guo_orbis_id = firm_id;
end 
