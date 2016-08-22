create table ww_etl.etl_job_code_groups
(
group_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
parent_job_code smallint(6) NOT NULL,
job_code smallint(6) NOT NULL,
primary key  (group_id),
KEY `job_code_idx` (job_code)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_general_ci;
