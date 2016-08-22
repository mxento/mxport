use master_dim;

DELIMITER | 
CREATE EVENT IF NOT EXISTS update_lu_month_current_month ON SCHEDULE EVERY 1 DAY STARTS '2014-08-14 01:00:00' DO BEGIN CALL master_dim.update_lu_month_current_month(); END | 
DELIMITER | 
CREATE EVENT IF NOT EXISTS update_lu_week_current_week ON SCHEDULE EVERY 1 DAY STARTS '2014-08-14 01:00:00' DO BEGIN CALL master_dim.update_lu_week_current_week(); END | 


show events;