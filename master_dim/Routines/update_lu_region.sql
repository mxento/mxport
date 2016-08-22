-- up synch_region_unified_name_convention.rb

Drop PROCEDURE if exists master_dim.update_lu_region;
DELIMITER $$
CREATE DEFINER = `etl`@`%` PROCEDURE master_dim.update_lu_region()
begin 

DECLARE proc_name_var varchar(200);
DECLARE batch_start datetime;
DECLARE error_msg varchar(400);
DECLARE log_msg varchar(400);
DECLARE job_code smallint;

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
set error_msg = concat(error_msg, ' - ', @p1, ': ', @p2);
call ww_etl.etl_job_log_update (job_code, concat(error_msg, ' - ', @p1, ': ', @p2));
select proc_name_var, ' failed at ' as error, now() `time`, 'Last successful step = ' as msg, log_msg;
-- set job status to 1 for failure
call ww_etl.update_etl_job_status(job_code, 1); SELECT concat('MySQL Error for ', proc_name_var);
-- the below 5 lines is optional - it will re-raise
SIGNAL SQLSTATE
'ERR0R'
SET
MESSAGE_TEXT = @p2,
MYSQL_ERRNO = @p1;

END;

-- make sure name and job c0de
SET proc_name_var = 'update_lu_region';
SET batch_start = now();
SET log_msg = concat('start ', proc_name_var, ' ' , batch_start);
SET error_msg = concat('Error in ', proc_name_var);
SET job_code = 284;

call ww_etl.update_etl_job_status(job_code, 9);

call ww_etl.etl_job_log_update (job_code, log_msg);

-- find region name diffs -- update last change
-- update all records to old type

update staging.region_differences
set change_type = 'old';

insert into staging.region_differences
(region_code, old_region_name, new_region_name, change_type, last_updated_datetime)
select a.region_code, a.region_name old_region_name, b.region_name new_region_name, 'new',  now() as last_updated_datetime
from master_dim.lu_region a
inner join weddingwire.region_lkup b on a.region_code = b.region_code 
and a.region_name <> b.region_name;


SELECT ROW_COUNT() into @r;
SET log_msg = concat(proc_name_var, ' step 1 (insert) ended ', now(), ': rows updated:', @r );
call ww_etl.etl_job_log_update (job_code, log_msg);

-- find display name diffs -- update last change

update staging.region_display_name_differences
set change_type = 'old';


insert into staging.region_display_name_differences
(region_code, old_region_display_name, new_region_display_name, change_type, last_updated_datetime)
select  a.region_code, b.region_display_name as old_region_display_name, a.display_name new_region_display_name, 'new',  now() as last_updated_datetime
from staging.import_region_unified_name_convention a
inner join master_dim.lu_region b on a.region_code = b.region_code
and a.display_name <> b.region_display_name;

SELECT ROW_COUNT() into @r;
SET log_msg = concat(proc_name_var, ' step 2 (insert) ended ', now(), ': rows updated:', @r );
call ww_etl.etl_job_log_update (job_code, log_msg);


-- now updates.. based on staging differences - only 'new' records

update master_dim.lu_region a
inner join staging.region_differences b  on a.region_code = b.region_code
set a.region_name = b.new_region_name
where b.change_type = 'new';

SELECT ROW_COUNT() into @r;
SET log_msg = concat(proc_name_var, ' step 3 (udpated) ended ', now(), ': rows updated:', @r );
call ww_etl.etl_job_log_update (job_code, log_msg);

update master_dim.lu_region a
 -- update ww_dev.lu_region a
inner join staging.region_display_name_differences b  on a.region_code = b.region_code
set a.region_display_name = b.new_region_display_name
where b.change_type = 'new';

SELECT ROW_COUNT() into @r;
SET log_msg = concat(proc_name_var, ' step 4 (udpated) ended ', now(), ': rows updated:', @r );
call ww_etl.etl_job_log_update (job_code, log_msg);


-- near end

SET log_msg = concat(proc_name_var, ' finished at ', now(), ' that started at ',batch_start);
call ww_etl.etl_job_log_update (job_code, log_msg);
-- set job status to 0 for success
call ww_etl.update_etl_job_status(job_code, 0);


end$$