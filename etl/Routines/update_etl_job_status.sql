-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
drop procedure if exists ww_etl.`update_etl_job_status`;
DELIMITER $$

CREATE DEFINER=`etl`@`%` PROCEDURE ww_etl.`update_etl_job_status`(in in_job_code smallint, in in_status int)
begin 

    DECLARE proc_name_var varchar(200);
    DECLARE batch_start datetime;
        DECLARE error_msg varchar(200);
        DECLARE log_msg varchar(200);
        

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
     GET DIAGNOSTICS CONDITION 1
                        @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
                set error_msg = concat(error_msg, ' - ', @p1, ': ', @p2);
        call ww_etl.etl_job_log_update (job_code, concat(error_msg, ' - ', @p1, ': ', @p2));
        select proc_name_var, ' failed at ' as error, now() `time`, 'Last successful step = ' as msg, log_msg;
    -- set job status to 1 for failure
    select ww_etl.set_job_status(job_code,1);
        SELECT concat('MySQL Error for ', proc_name_var);
END;


update ww_etl.lu_etl_job_codes 
set status = in_status, last_run_date = now() 
where job_code = in_job_code;



end

$$