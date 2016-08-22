use ww_etl;

# show table status;
#select * from etl_job_log; 
#show columns from etl_job_log




drop table if exists ww_etl.etl_job_log_archive; 

CREATE TABLE ww_etl.etl_job_log_archive
(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `logtime` datetime DEFAULT NULL,
  `job_code` smallint(6) DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET latin1 DEFAULT NULL,
  `called_from_ip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_code_idx` (`job_code`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;
