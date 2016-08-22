drop procedure ww_etl.check_job_code;

delimiter $$

create procedure ww_etl.check_job_code(in job_code int)
begin

select job_code into @job_code;

set @s = 'select * from ww_etl.lu_etl_job_codes where job_code = ?';
	prepare stmt from @s;
	execute stmt using @job_code;

set @s = 'select * from ww_etl.etl_job_log where job_code = ? order by 1 desc limit 100';
	prepare stmt from @s;
	execute stmt using @job_code;

end$$

call ww_etl.check_job_code(83);