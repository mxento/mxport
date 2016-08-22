
use ww_etl;

drop event ww_etl.run_monthly_tasks;

DELIMITER | 

CREATE EVENT IF NOT EXISTS ww_etl.run_monthly_tasks ON SCHEDULE EVERY 1 MONTH STARTS '2014-05-01 06:00:00' on completion preserve DO BEGIN CALL ww_etl.run_monthly_tasks();  CALL vendor_dw.run_crm_daily_facts(); END | 


DELIMITER | 

CREATE EVENT IF NOT EXISTS ww_etl.run_flush_all_tables ON SCHEDULE EVERY 1 DAY STARTS '2014-07-07 00:55:00:00' ON COMPLETION PRESERVE DO BEGIN call ww_etl.`flush_fed_tables`(0); END |

DELIMITER | 

CREATE EVENT IF NOT EXISTS ww_etl.run_flush_all_tables ON SCHEDULE EVERY 1 DAY STARTS '2014-07-07 23:30:00:00' ON COMPLETION PRESERVE DO BEGIN call ww_etl.`flush_fed_tables`(0); END |

