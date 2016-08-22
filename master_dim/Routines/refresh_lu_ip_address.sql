-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`etl`@`%` PROCEDURE `refresh_lu_ip_address`()
BEGIN

	DECLARE proc_name_var varchar(200);
	DECLARE error_msg varchar(200);
	DECLARE log_msg varchar(200);
	DECLARE job_code smallint;
    DECLARE batch_start datetime;
	DECLARE done INT DEFAULT FALSE;
	DECLARE v_geoname_id, v_start_ip, v_end_ip INT;
	DECLARE v_country varchar(2);
	DECLARE v_city varchar(100);
	DECLARE	v_postal_code varchar(10);
	DECLARE v_latitude, v_longitude FLOAT;

	DECLARE cur CURSOR FOR 
		SELECT 	lu_ip_block.geoname_id, start_ip, end_ip, country_iso_code, city_name, postal_code, latitude, longitude
		FROM 	lu_ip_block 
		JOIN 	lu_ip_loc ON lu_ip_loc.geoname_id = lu_ip_block.geoname_id 
		WHERE 	country_iso_code IN ('US','CA') 
			AND NOT start_ip IS NULL 
		ORDER BY start_ip;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			GET DIAGNOSTICS CONDITION 1
				@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
			SET error_msg = concat('Error in ', proc_name_var, ' :' , @p1, '; ', @p2);
			CALL ww_etl.etl_job_log_update (job_code, error_msg);			
			CALL ww_etl.update_etl_job_status(job_code,1);
		END;

	SET proc_name_var = 'refresh_lu_ip_address';
	SET batch_start = now();
	SET log_msg = concat('start ', proc_name_var, ' ' , batch_start);
	SET error_msg = concat('Error in ', proc_name_var);
	SET job_code = 6;
	CALL ww_etl.etl_job_log_update (job_code, log_msg);
	CALL ww_etl.update_etl_job_status(job_code,9);

	OPEN cur;
		read_loop: LOOP
		FETCH cur INTO v_geoname_id, v_start_ip, v_end_ip, v_country, v_city, v_postal_code, v_latitude, v_longitude;
		IF done THEN
		  LEAVE read_loop;
		END IF;
		CALL ww_etl.etl_job_log_update (job_code, CONCAT('goename_id:',v_geoname_id,', start_ip:',v_start_ip,', country:',v_country,', lat:',v_latitude,', long:',v_longitude));
		WHILE v_start_ip <= v_end_ip DO
			INSERT	lu_ip_address (geoname_id, ip_address, ip_int, country, city, postal_code, latitude, longitude) VALUES (v_geoname_id, INET_NTOA(v_start_ip), v_start_ip, v_country, v_city, v_postal_code, v_latitude, v_longitude);
			SET v_start_ip = v_start_ip + 1;
		END WHILE;
		END LOOP;
	CLOSE cur;

	SET	log_msg = concat(proc_name_var, ' finished at ', now(), ' that started at ',batch_start);
	CALL ww_etl.etl_job_log_update (job_code, log_msg);
	CALL ww_etl.update_etl_job_status(job_code,0);
END