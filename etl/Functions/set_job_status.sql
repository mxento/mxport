delimiter $$
create function  ww_etl.set_job_status (in_job_code int, in_status int) returns int(1)
    READS SQL DATA
    DETERMINISTIC
begin 
declare return_status int;
update ww_etl.lu_etl_job_codes set status = in_status where job_code = in_job_code;
set return_status = (select status from ww_etl.lu_etl_job_codes where job_code = in_job_code);
RETURN return_status;
end$$

