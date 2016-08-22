use master_dim;

CREATE TABLE master_dim.`lu_week` (
  `week_sk` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `week_id` int(6) unsigned NOT NULL,
  `week_desc` varchar(100) DEFAULT NULL,
  `week_desc_name` varchar(100) DEFAULT NULL,
  `week_of_year` tinyint(3) unsigned DEFAULT NULL,
  `week_start_date` date DEFAULT NULL,
  `week_end_date` date DEFAULT NULL,
  `week_start_day_id` int(10) unsigned DEFAULT NULL,
  `week_end_day_id` int(10) unsigned DEFAULT NULL,
  `prev_week_id` int(6) unsigned DEFAULT NULL,
  `next_week_id` int(6) unsigned DEFAULT NULL,
  `last_month_week_id` int(6) unsigned DEFAULT NULL,
  `last_year_week_id` int(6) unsigned DEFAULT NULL,
  `current_week_flag` bit(1) DEFAULT b'0',
  `last_update_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`week_sk`),
  UNIQUE KEY `week_id_sk_UNIQUE` (`week_sk`),
  UNIQUE KEY `week_id_UNIQUE` (`week_id`),
  KEY `week_start_day_id_idx` (`week_start_day_id`),
  KEY `week_end_day_id` (`week_end_day_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 collate='utf8_general_ci';

select
* from master_dim.lu_day d
right join master_dim.lu_week w on d.week_id = w.week_id
where d.week_id is null;

select count(*) from vendor_dw.f_vendor_crm_adoption where week_id = 201253;

select * from vendor_dw.lu_ratecard_scd;

update
vendor_dw.lu_ratecard_scd 
set effective_begin_date = '2012-01-01', effective_begin_month_id = '201201'
where network_type_code = 2;

select * from vendor_dw.f_vendor_stats_monthly limit 1000;

truncate table master_dim.lu_week;

insert into master_dim.lu_week (week_id, start_date, end_date)
select
week_id, min(day_date), max(day_date)
from
master_dim.lu_day
group by week_id;

select * from master_dim.lu_week;

update master_dim.lu_week c join master_dim.lu_week p on c.week_id_sk = (p.week_id_sk - 1)
set c.next_week_id = p.week_id;

update master_dim.lu_week c join master_dim.lu_week p on c.week_id_sk = (p.week_id_sk + 1)
set c.prev_week_id = p.week_id;

update master_dim.lu_week set week_of_year = substring(week_id, 5, 2);
update master_dim.lu_week set start_day_id = date_format(start_date, '%Y%m%d'), end_day_id = date_format(end_date, '%Y%m%d');


update master_dim.lu_week set week_desc = concat(substring(week_id, 1, 4), ' ', date_format(start_date, '%b'), '-', day(start_date), ' to ', date_format(end_date, '%b'), '-', day(end_date));
update master_dim.lu_week set week_desc_name = concat(
	case when week_of_year = 1 then '1st'
		 when week_of_year = 2 then '2nd'
		 when week_of_year = 3 then '3rd'
		 else concat(week_of_year, 'th') end, ' week of ', substring(week_id, 1, 4));
	
update
master_dim.lu_week c
set last_month_week_id = yearweek(date_format(date_add(c.start_date, interval -1 month), '%Y%m%d'));

update
master_dim.lu_week c
set last_year_week_id = yearweek(date_format(date_add(c.start_date, interval -1 year), '%Y%m%d'));

call master_dim.update_lu_week_current_week();

