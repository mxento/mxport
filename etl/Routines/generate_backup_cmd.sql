drop procedure ww_etl.generate_backup_cmd;
delimiter $$
create definer='etl'@'%' procedure ww_etl.generate_backup_cmd (in t_schema varchar(50), in db_pass varchar(50))
begin

declare s varchar(21000);
declare s2 varchar(21000);
declare stmt varchar(21000);
declare i integer;

set s = concat('mysqldump -uetl -p', db_pass, ' ', t_schema, ' --routines --extended-insert ');

#### ignore all temporary tables

select count(*) into @view_cnt
 from information_schema.tables where table_schema='vendor_dw' and table_name like '%temp%';

set i = 0;

while i < @view_cnt do

	select concat(' --ignore_table=', group_concat(concat(t_schema, '.', table_name) separator ' --ignore_table=')) t into s2
		from (	select table_name from information_schema.tables where table_schema=t_schema and table_name like '%temp%' limit 20 offset i ) x;

	set s = concat(s, s2);

	set i = i + 20;

end while;

set s = concat(left(s, length(s) - 16 - length(t_schema)));
#### ignore all views

select count(*) into @view_cnt
from information_schema.views where table_schema = t_schema;

set i = 0;

while i < @view_cnt do

	#prepare stmt from 'select concat('' --ignore_table='', group_concat(table_name separator '' --ignore_table='')) t 
	#	from (	select * from information_schema.views where table_schema=''vendor_dw'' limit 30 offset 0 ) x';
	
	#select @t_schema;
	
	#execute stmt using @t_schema;

	select concat(' --ignore_table=', group_concat(concat(t_schema, '.', table_name) separator ' --ignore_table=')) t into s2
		from (	select table_name from information_schema.views where table_schema=t_schema limit 20 offset i ) x;

	set s = concat(s, s2);

	set i = i + 20;

end while;

set s = concat(left(s, length(s) - 16 - length(t_schema)), ' > ', t_schema, '_bk.sql');
select s as echo;

end$$
