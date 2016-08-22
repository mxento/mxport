#drop table ww_etl.log_processlist;
create table ww_etl.log_processlist
(
	id int unsigned auto_increment primary key,
    day_id int unsigned not null,
    log_time time,
    process_id int unsigned,
    user varchar(100),
    host varchar(300),
    db varchar(20),
    command varchar(100),
    run_time_seconds int unsigned,
    state varchar(400),
    query mediumtext,
    loaded_datetime timestamp default current_timestamp on update current_timestamp,
    key (day_id)
);

drop event ww_etl.log_processlist_event;

delimiter $$

#CREATE DEFINER=`etl`@`%` EVENT `run_all_nightly` ON SCHEDULE EVERY 1 DAY STARTS '2014-05-09 01:00:00' ON COMPLETION PRESERVE ENABLE DO BEGIN call vendor_dw.run_all_nightly(); END

create DEFINER=`etl`@`%`  event ww_etl.log_processlist_event on schedule every 5 minute starts '2015-07-24 14:01:00' on completion preserve enable do 
if hour(now()) >= 21 or hour(now()) < 9 then
	select now() into @l_time;
	insert into ww_etl.log_processlist
	(	day_id, log_time, process_id, user, host, db, command, run_time_seconds, state, query)
	select
	date_format(@l_time, '%Y%m%d') day_id, time(@l_time) log_time, id process_id, user, host, db, command, time run_time_seconds, state, info query
	from common_schema.processlist_top where user != 'event_scheduler';
end if$$

delimiter ;

select * from ww_etl.log_processlist;

select * from ww_etl.event_info;