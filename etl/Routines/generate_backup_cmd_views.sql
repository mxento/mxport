
DELIMITER $$
CREATE DEFINER=`etl`@`%` PROCEDURE ww_etl.`generate_backup_cmd_views`(in t_schema varchar(50), in db_pass varchar(50))
begin


set group_concat_max_len = 650000;

select concat('mysqldump -uetl -p', db_pass, ' ', t_schema, ' --force --skip-lock-tables --quick ' ,
group_concat( table_name separator ' '), ' > ', t_schema, '/', t_schema, '_views.sql') as echo from information_schema.views where table_schema=t_schema;

end$$
DELIMITER ;
