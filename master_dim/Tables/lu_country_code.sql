CREATE TABLE `lu_country_code` (
  `country_code` char(15) NOT NULL DEFAULT '',
  `country_code_UN` char(15) DEFAULT NULL,
  `country_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`country_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
