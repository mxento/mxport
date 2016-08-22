use master_dim; 

drop TABLE if exists master_dim.lu_tables;
delimiter $$
CREATE TABLE master_dim.lu_tables 
( `lu_tables_sk` int(11) AUTO_INCREMENT,
  `server_and_port` varchar(30) null, 
  `schema_name` varchar(35) null, 
  `table_name` varchar(100) null, 
  `made_by` varchar(50) null, 
  `notes` varchar(3000) null,
  `created_datetime` datetime null, 
  `last_updated_datetime` datetime null, 
  primary key  (`lu_tables_sk`),
  KEY `table_idx` (`table_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_general_ci
$$

select * from master_dim.lu_tables;
/*
Error Code: 144. Table '.\master_dim\lu_tables' is marked as crashed and last (automatic?) repair failed
*/