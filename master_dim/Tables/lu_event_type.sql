USE master_dim;

CREATE TABLE `lu_event_type` (
  `EVENT_TYPE_CODE` int(10) unsigned NOT NULL DEFAULT '0',
  `EVENT_DESC` varchar(255) DEFAULT '',
  `LAST_UPDATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EVENT_TYPE_CODE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT	lu_event_type (event_type_code, event_desc)
	  SELECT 1, 'Anniversary'
UNION SELECT 2, 'Baby Shower, Milestone'
UNION SELECT 3, 'Bar, Bat Mitzvah'
UNION SELECT 4, 'Birthday'
UNION SELECT 5, 'Bridal Shower'
UNION SELECT 6, 'Christening'
UNION SELECT 7, 'Corporate Event'
UNION SELECT 8, 'Debutante Ball'
UNION SELECT 9, 'Engagement Party'
UNION SELECT 10, 'Graduation'
UNION SELECT 11, 'Holiday Party'
UNION SELECT 12, 'Memorial'
UNION SELECT 13, 'Prom'
UNION SELECT 14, 'Quinceanera'
UNION SELECT 15, 'Sweet 16'
UNION SELECT 16, 'Wedding'