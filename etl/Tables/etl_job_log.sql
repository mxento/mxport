CREATE TABLE ww_etl.`etl_job_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `logtime` datetime DEFAULT NULL,
  `job_code` smallint(6) DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET utf8_unicode_ci DEFAULT NULL,
  `called_from_ip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_code_idx` (`job_code`)
) ENGINE=MyISAM AUTO_INCREMENT=1820145 DEFAULT CHARSET=utf8;
