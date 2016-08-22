truncate table master_dim.lu_quarter;

insert into master_dim.lu_quarter
(quarter_id, quarter_start_date, quarter_desc, year_id, quarter_duration,
prev_quarter_id, last_year_quarter_id)
select
quarter_id, quarter_date, quarter_desc, year_id, quarter_duration,
prev_quarter_id, ly_quarter_id
from vendor_dw.lu_quarter
order by quarter_id
;

select * 
from master_dim.lu_quarter;

update master_dim.lu_quarter set quarter_start_day_id = date_format(quarter_start_date, '%Y%m%d');

update master_dim.lu_quarter q 
join master_dim.lu_quarter p on q.quarter_sk = p.quarter_sk - 1 
set q.next_quarter_id = p.quarter_id
;

CREATE TABLE master_dim.`lu_quarter` (
  `quarter_sk` int(11) NOT NULL AUTO_INCREMENT,
  `quarter_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `quarter_start_date` date DEFAULT NULL,
  `quarter_start_day_id` int(10) unsigned DEFAULT NULL,
  `quarter_desc` varchar(50) DEFAULT NULL,
  `year_id` smallint(6) unsigned DEFAULT NULL,
  `quarter_duration` smallint(6) unsigned DEFAULT NULL,
  `prev_quarter_id` smallint(6) unsigned DEFAULT NULL,
  `next_quarter_id` smallint(5) unsigned DEFAULT NULL,
  `last_year_quarter_id` smallint(6) unsigned DEFAULT NULL,
  `last_update_datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`quarter_sk`),
  UNIQUE KEY `QUARTER_ID_UNIQUE` (`quarter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
