SELECT * FROM master_dim.lu_year;

create table master_dim.lu_year like vendor_dw.lu_year;
insert into master_dim.lu_year select * from vendor_dw.lu_year order by year_id;

update master_dim.lu_year set year_start_day_id = date_format(year_start_date, '%Y%m%d');

CREATE TABLE master_dim.`lu_year` (
  `year_sk` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `year_id` smallint(6) unsigned NOT NULL,
  `year_start_day_id` int(10) unsigned DEFAULT NULL,
  `year_start_date` date DEFAULT NULL,
  `year_duration` smallint(6) unsigned DEFAULT NULL,
  `prev_year_id` smallint(6) unsigned DEFAULT NULL,
  `last_update_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`year_sk`),
  UNIQUE KEY `year_id_UNIQUE` (`year_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
