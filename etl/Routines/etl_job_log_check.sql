
	SELECT 	j.job_code, job_description, last_run_date, status
	FROM 	ww_etl.lu_etl_job_codes j
	LEFT JOIN (select max(concat(lpad(id,10,'0'),description)) as maxdesc, job_code from ww_etl.etl_job_log group by 2) log on log.job_code = j.job_code
	WHERE 
		(
		(	job_frequency = 'Daily'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 DAY))
		 )
		OR(	job_frequency = 'Weekly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 WEEK))
		 )
		OR(	job_frequency = 'Monthly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 MONTH))
		 )
		) and not j.job_code in (102,105,107,103)
	UNION
	SELECT 	j.job_code, job_description, last_run_date, status
	FROM 	ww_etl.lu_etl_job_codes_3309 j
	LEFT JOIN (select max(concat(lpad(id,10,'0'),description)) as maxdesc, job_code from ww_etl.etl_job_log group by 2) log on log.job_code = j.job_code
	WHERE 
		(	job_frequency = 'Daily'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 DAY))
		 )
		OR(	job_frequency = 'Weekly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 WEEK))
		 )
		OR(	job_frequency = 'Monthly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 MONTH))
		 )
	UNION SELECT * from (select NULL job_code, '<br />Everything ran! Huzzah!<br />' job_description, null last_run_date, null status)b where  (select count(1) from (
	SELECT 	j.job_code, job_description, last_run_date, status
	FROM 	ww_etl.lu_etl_job_codes j
	LEFT JOIN (select max(concat(lpad(id,10,'0'),description)) as maxdesc, job_code from ww_etl.etl_job_log group by 2) log on log.job_code = j.job_code
	WHERE 
		(
		(	job_frequency = 'Daily'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 DAY))
		 )
		OR(	job_frequency = 'Weekly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 WEEK))
		 )
		OR(	job_frequency = 'Monthly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 MONTH))
		 )
		) and not j.job_code in (102,105,107,103)
	UNION
	SELECT 	j.job_code, job_description, last_run_date, status
	FROM 	ww_etl.lu_etl_job_codes_3309 j
	LEFT JOIN (select max(concat(lpad(id,10,'0'),description)) as maxdesc, job_code from ww_etl.etl_job_log group by 2) log on log.job_code = j.job_code
	WHERE 
		(	job_frequency = 'Daily'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 DAY))
		 )
		OR(	job_frequency = 'Weekly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 WEEK))
		 )
		OR(	job_frequency = 'Monthly'
		AND (status <> 0 OR last_run_date < DATE_SUB(CONCAT(CURDATE(), ' ', '23:00:00') ,INTERVAL 1 MONTH))
		 )
	)a)=0
	ORDER BY status desc, last_run_date ASC;

