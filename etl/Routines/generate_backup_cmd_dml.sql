drop procedure ww_etl.generate_backup_cmd_dml;
delimiter $$
create definer='etl'@'%' procedure ww_etl.generate_backup_cmd_dml (in t_schema varchar(50), in db_pass varchar(50))
begin

declare s varchar(21000);
declare s2 varchar(21000);
declare stmt varchar(21000);
declare i integer;

set group_concat_max_len = 65000;

select  concat('mysqldump -uetl -p', db_pass, ' ', t_schema, ' --routines --events --no-data --no-create-info > ', t_schema, '/', t_schema, '_routines_events_bk.sql') as routines;

#set s = concat(left(s, length(s) - 16 - length(t_schema)), ' > ', t_schema, '_bk.sql');
#select s as echo;

end$$
