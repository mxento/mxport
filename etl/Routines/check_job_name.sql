drop procedure ww_etl.check_job_name;

delimiter $$

create procedure ww_etl.check_job_name(in job_name char(100))
begin

select job_name into @job_name;

set @s = concat('select * from ww_etl.lu_etl_job_codes where job_description like ''%', @job_name, '%''');
	prepare stmt from @s;
	execute stmt ;

set @s = concat('select * from ww_etl.etl_job_log where description like ''%', @job_name, '%'' order by 1 desc limit 100');
	prepare stmt from @s;
	execute stmt ;

end$$

call ww_etl.check_job_name('lu_vendor');