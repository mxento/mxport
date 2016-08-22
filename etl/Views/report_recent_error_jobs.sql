select * from ww_etl.etl_job_log where job_code = 350 order by id desc limit 10;
select * from ww_etl.lu_etl_job_codes where job_code = 350 ;
use ww_etl;
# show tables; 
# select * from ww_etl.etl_job_log where description like '%error%' order by id desc;
# select * from ww_etl.lu_etl_job_codes;
# select DATE_SUB(now(),INTERVAL 5 day) ,  now();

drop view if exists ww_etl.report_recent_error_jobs_vw ; 
create view ww_etl.report_recent_error_jobs_vw as 
select l.id, l.logtime, l.job_code, c.job_description,  l.description as error_desc,c.last_run_date as latest_run_date, c.status as curr_status_code, 
case when c.last_run_date > logtime and status = 0 then 'good' else 'bad'
end as current_status, c.called_from_server, c.called_from_source
from ww_etl.etl_job_log l 
inner join ww_etl.lu_etl_job_codes c on c.job_code = l.job_code
where l.description like '%error%' 
and logtime >= DATE_SUB(now(),INTERVAL 2 day) 
order by id desc 
# limit 20
;

select * from ww_etl.report_recent_error_jobs_vw ;


select case when not (date_format(now(),'%Y%m%d') in (select data_day_id from vendor_dw.recently_reviewed_vendors_log group by data_day_id)) then 1 else 0 end;
	# 0 = good case  1 = bade

select case when (select count(*) ct from ww_etl.report_recent_error_jobs_vw where curr_status_code<>0)>0 then 1 else 0 end as bad_err; 

select case when (SELECT count(*) ct FROM ww_etl.report_recent_error_jobs_vw where current_status != 'good' )> 1 then 1 else 0 end as bad_jobs;


SELECT count(*) ct FROM ww_etl.report_recent_error_jobs_vw where current_status <> 'good' ;
 