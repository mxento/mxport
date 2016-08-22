
drop procedure ww_etl.report_etl_job_status;
delimiter $$

CREATE DEFINER=`etl`@`%` PROCEDURE ww_etl.`report_etl_job_status`()
begin

drop table if exists ww_etl.temp_jobs;

CREATE TABLE ww_etl.`temp_jobs` (
  `job_code` smallint(6) DEFAULT NULL,
  `job_description` varchar(500) DEFAULT NULL,
  `job_frequency` varchar(25) DEFAULT NULL,
  `called_from_server` varchar(45) DEFAULT NULL,
  `called_from_source` varchar(200) DEFAULT NULL,
  `last_run_date` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `sf_depends_flag` tinyint(1) unsigned DEFAULT '0',
  `sf_depends_objects` varchar(500) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into ww_etl.temp_jobs
SELECT 	j.job_code, 
job_description, 
job_frequency, called_from_server, called_from_source,last_run_date, status, sf_depends_flag, sf_depends_objects
FROM 	ww_etl.lu_etl_job_codes j
WHERE 
	(
	# Daily runs
	(	job_frequency = 'Daily'
			AND (status <> 0 OR 
					(
					last_run_date < 
						CASE WHEN DAYOFWEEK(NOW()) = 2  AND j.job_code IN (229,209,80,211,216,82,83,217,218,219,210,236,242,243)
							 THEN DATE_SUB(CONCAT(CURDATE(), ' ', '12:05:00'), INTERVAL 1 DAY) 
							 ELSE DATE_SUB(CONCAT(CURDATE(), ' ', '18:33:00'), INTERVAL 1 DAY)
						END				
					)
				)
		 )
	#weekly Runs
	OR(	job_frequency = 'Weekly'
			AND (status <> 0 OR 
			(last_run_date < 
				Case when j.job_code in (225)
				THEN DATE_SUB(date_sub(now(),INTERVAL 1 WEEK), interval 4 hour)
				end
			)
		)
	 )
	
	# monthly runs
	OR(	job_frequency = 'Monthly'
	AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '21:03:00'), INTERVAL 1 MONTH))
	)
	# replicated after 1AM, but completed

) 
AND NOT j.job_code IN (102,105,107,103)
;

insert into ww_etl.temp_jobs
SELECT 	j.job_code, 
concat('**late rep warning** ', job_description) job_description, 
job_frequency, called_from_server, called_from_source,last_run_date, status, sf_depends_flag, sf_depends_objects
FROM 	ww_etl.lu_etl_job_codes j
WHERE 
( job_frequency = 'Daily' 
			and status = 0 
            and job_frequency = 'Daily' 
            and j.job_code between 1000 and 2999 
            and j.job_code not in (1006, 1007, 1008, 1042, 2005,2036,2037,2038,2040,2041,2042,2043,2044,2046,2048 ) 
            and time(last_run_date) > ('01:00:00')
            and last_run_date > curdate()
)
;


select * from ww_etl.temp_jobs
union

SELECT * 
FROM 	(SELECT NULL job_code, 'Everything ran! Huzzah!' job_description, NULL job_frequency, NULL last_run_date, NULL called_from_server, NULL called_from_source, NULL status, NULL sf_depends_flag, NULL sf_depends_objects)b 
WHERE  	(SELECT COUNT(1) FROM ww_etl.temp_jobs)=0
ORDER BY status DESC, last_run_date ASC;
    
drop table ww_etl.temp_jobs;
    
end