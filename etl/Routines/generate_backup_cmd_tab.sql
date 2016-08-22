delimiter $$
CREATE DEFINER=`etl`@`%` PROCEDURE `generate_backup_cmd_tab`(in t_schema varchar(50), in db_pass varchar(50), in no_data boolean)
begin

declare s varchar(21000);
declare s2 varchar(21000);
declare stmt varchar(21000);
declare i integer;

set group_concat_max_len = 65000;


set s =  concat('mysqldump -uetl -p', db_pass, ' ', t_schema, ' --force --routines --events --skip-lock-tables --quick', if( no_data , ' --no-data ', ''), ' --tab=', t_schema)
;
#### ignore all temporary tables

select count(*) into @view_cnt
 from information_schema.tables where table_schema=t_schema and (table_name like '%temp%' 
				 or table_name like '%bk' 
                 or table_name like '%backfill'
                 or table_name like '%backup%'
				 or table_name = 'tracking_pings' 
                 or table_name = 'tracking_beacons'
                 or table_name = 'hist_click_referer_parsed');

set i = 0;

while i < @view_cnt do

	select concat(' --ignore_table=', group_concat(concat(t_schema, '.', table_name) separator ' --ignore_table=')) t into s2
		from (	select table_name from information_schema.tables where table_schema=t_schema 
			and (table_name like '%temp%' 
				 or table_name like '%bk' 
                 or table_name like '%backfill'
                 or table_name like '%backup%'
				 or table_name = 'tracking_pings' 
                 or table_name = 'tracking_beacons'
                 or table_name = 'hist_click_referer_parsed') limit 20 offset i ) x;

	set s = concat(s, s2);

	set i = i + 20;

end while;

#set s = concat(left(s, length(s) - 16 - length(t_schema)));
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

#select  concat('mysqldump -uetl -p', db_pass, ' ', t_schema, ' --routines --events --no-data --no-create-info > ', t_schema, '/', t_schema, '_routines_events_bk.sql') as routines;

set s = concat(s, ' > ', t_schema, '/', t_schema, '_routines_events.sql');
select s as echo;

end