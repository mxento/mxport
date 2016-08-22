/*
call ww_etl.etl_job_log_update (1, 'start SP_UPDATE_report_vendor_appt_schedule_button');
call ww_etl.etl_job_log_update (2, 'end SP_UPDATE_report_vendor_appt_schedule_button');
11 - apps download
12 - apps download 
*/
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------

drop procedure ww_etl.etl_job_log_update;

DELIMITER $$

CREATE DEFINER=`etl`@`%` PROCEDURE ww_etl.`etl_job_log_update`(in digit int, in things varchar(1000))
begin
	#select host into @host from information_schema.processlist WHERE ID=connection_id();
    select user() into @host;
    insert into ww_etl.etl_job_log (logtime, job_code, description, called_from_ip) values (now(), digit, things, @host);
    update ww_etl.lu_etl_job_codes 
    set last_run_date = now()
    where job_code = digit;
end