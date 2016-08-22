DROP PROCEDURE IF EXISTS ww_etl.wait_until_jobs_finished;
DELIMITER $$
CREATE DEFINER=`etl`@`%` PROCEDURE ww_etl.wait_until_jobs_finished (
    in job_code INT,
    in check_job_codes VARCHAR(1000),
    in wait_sleep_mins INT,
    in wait_sleep_max_mins INT,
    out jobs_finished BIT
)

BEGIN

DECLARE wait_i INT;
DECLARE success_check BIT;

SET jobs_finished = 0;
SET @wait_i = 0;
SET @success_check = 0;

wait_loop:
WHILE 1 DO
    SELECT ww_etl.get_job_success_today_string(check_job_codes) into @success_check;

    IF job_code IS NOT NULL THEN
        call ww_etl.etl_job_log_update(job_code, concat('Got success_check value ', @success_check, ' @ ', now()));
    END IF;

    IF @success_check = 1 THEN
        -- If the function returns true then this will exit the WHILE loop and proceed with the rest of the job
        LEAVE wait_loop;
    ELSE
        -- Not finished yet, increase i and wait
        SET @wait_i = @wait_i + 1;

        IF @wait_i * wait_sleep_mins > wait_sleep_max_mins THEN
            IF job_code IS NOT NULL THEN
                call ww_etl.etl_job_log_update(job_code, concat('wait_sleep_max_mins exceeded @ ', now()));
            END IF;

            LEAVE wait_loop;
        ELSE
            IF job_code IS NOT NULL THEN
                call ww_etl.etl_job_log_update(job_code, concat('Sleep #', @wait_i, ' @ ', now()));
            END IF;

            DO SLEEP(60 * wait_sleep_mins);
        END IF;
    END IF;
END WHILE;

SET jobs_finished = @success_check;

END$$
