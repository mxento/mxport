-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`tim`@`%` FUNCTION `fn_GMT_to_EST`(dt datetime) RETURNS datetime
BEGIN

SELECT DATE_ADD(dt, INTERVAL GMT_diff HOUR) INTO dt FROM master_dim.lu_day WHERE date_format(dt,'%Y%m%d') = day_id LIMIT 1;

RETURN dt;
END