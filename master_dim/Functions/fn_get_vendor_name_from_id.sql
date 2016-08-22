-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`etl`@`%` FUNCTION `fn_get_vendor_name_from_id`(in_vendor_id INT) RETURNS varchar(100) CHARSET utf8
BEGIN
	DECLARE name VARCHAR(100);
	SET name = (SELECT name FROM vendor_dw.lu_vendor WHERE vendor_id = in_vendor_id);
	RETURN @NAME;
END