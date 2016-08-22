USE ww_etl;
DROP FUNCTION IF EXISTS get_job_success_today_string;
DELIMITER $$
CREATE DEFINER=`etl`@`%` FUNCTION `get_job_success_today_string`(in_job_codes VARCHAR(1000)) RETURNS BIT
    READS SQL DATA
BEGIN 
DECLARE num_complete_jobs INT;

SET num_complete_jobs = (SELECT COUNT(*)                    
                         FROM 	ww_etl.lu_etl_job_codes 
                         WHERE	FIND_IN_SET(job_code,in_job_codes) AND
                         status = 0 AND DATE(last_run_date) = DATE(NOW()));

RETURN num_complete_jobs = (LENGTH(in_job_codes) - LENGTH(REPLACE(in_job_codes,',','')) + 1);
END$$
