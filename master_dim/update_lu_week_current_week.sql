drop procedure if exists master_dim.update_lu_week_current_week;

delimiter $$

CREATE DEFINER=`etl`@`%` PROCEDURE master_dim.`update_lu_week_current_week`()
begin 
DECLARE max_badges_sashes_id_va int;

    DECLARE proc_name_var varchar(200);
    DECLARE batch_start datetime;
        DECLARE error_msg varchar(200);
        DECLARE log_msg varchar(200);
        DECLARE job_code smallint;


DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
        ROLLBACK;
        call ww_etl.etl_job_log_update (job_code, error_msg);
        select proc_name_var, ' failed at ' as error, now() `time`, 'Last successful step = ' as msg, log_msg;
    -- set job status to 1 for failuremaster_dim
    select ww_etl.set_job_status(job_code,1);
        SELECT concat('MySQL Error for ', proc_name_var);
END;

-- make sure name and job c0de
SET proc_name_var = 'update_lu_week_current_week';
SET batch_start = now();
SET log_msg = concat('start ', proc_name_var, ' ' , batch_start);
SET error_msg = concat('Error in ', proc_name_var);
SET job_code = 61;

select ww_etl.set_job_status(job_code,9);

call ww_etl.etl_job_log_update (job_code, log_msg);

start transaction;

-- update current_week_flag
-- first reset all to zero
update master_dim.lu_week
set current_week_flag = 0;

-- then set only current month to 1
update master_dim.lu_week
set current_week_flag = 1
where now() between start_date and end_date;



commit;
-- near end

SET log_msg = concat(proc_name_var, ' finished at ', now(), ' that started at ',batch_start);
call ww_etl.etl_job_log_update (job_code, log_msg);
-- set job status to 0 for success
select ww_etl.set_job_status(job_code,0);


end$$

-- chekc 
-- select * from master_dim.lu_week
-- where current_week_flag = 1;

