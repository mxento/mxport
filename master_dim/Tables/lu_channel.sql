CREATE TABLE `lu_channel` (
  `partner_id` bigint(20) unsigned DEFAULT NULL,
  `active_flag` tinyint(1) DEFAULT NULL,
  `confirm_flag` tinyint(1) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `parent_channel_code` varchar(10) DEFAULT NULL,
  `parent_channel_name` varchar(50) DEFAULT NULL,
  UNIQUE KEY `cidx` (`parent_channel_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert master_dim.lu_channel select * from vendor_dw.lu_channel;