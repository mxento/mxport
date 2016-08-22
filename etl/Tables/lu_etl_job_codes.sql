#--


CREATE TABLE ww_etl.`lu_etl_job_codes` (
  `lu_etl_job_codes_sk` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_code` smallint(6) DEFAULT NULL,
  `job_description` varchar(300) DEFAULT NULL,
  `job_frequency` varchar(25) DEFAULT NULL,
  `created_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_run_date` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `called_from_server` varchar(45) DEFAULT NULL,
  `called_from_source` varchar(200) DEFAULT NULL,
  `notes` text,
   sf_depends_flag tinyint(1) unsigned default 0,
   sf_depends_objects varchar(500) DEFAULT NULL,
  PRIMARY KEY (`lu_etl_job_codes_sk`),
  UNIQUE KEY `job_code` (`job_code`)
) ENGINE=MyISAM AUTO_INCREMENT=572 DEFAULT CHARSET=utf8;


alter table  ww_etl.`lu_etl_job_codes` add column  sf_depends_flag tinyint(1) unsigned default 0;
alter table  ww_etl.`lu_etl_job_codes` add column  sf_depends_objects varchar(500) DEFAULT NULL;


