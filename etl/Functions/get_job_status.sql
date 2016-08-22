-- create function to check status for a paricular job_code for the current run
delimiter $$
create function  ww_etl.get_job_status (in_job_code int) returns int(1)
    READS SQL DATA
    DETERMINISTIC
begin 
declare return_status int;
set return_status = (select status from ww_etl.lu_etl_job_codes where job_code = in_job_code);
RETURN return_status;
end$$



