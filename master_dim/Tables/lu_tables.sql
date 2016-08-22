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
   `caveats` mediumtext null,
    documented_flag tinyint(1) unsigned null,
   `created_datetime` datetime null, 
   `last_updated_datetime` datetime null, 
   primary key  (`lu_tables_sk`),
   KEY `table_idx` (`table_name`)
 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_general_ci
 $$

-- code to insert new tables accessible
INSERT INTO `master_dim`.`lu_tables`
(`server_and_port`,
`schema_name`,
`table_name`,
`made_by`,
`notes`,
`created_datetime`,
`last_updated_datetime`)
VALUES
('bi 3306',  
'vendor_dw',
'lu_vendor',
'mx',
'test',
now(),
now()
);
 

alter table master_dim.lu_tables add column `caveats` mediumtext null after notes;
alter table master_dim.lu_tables add column documented_flag tinyint(1) unsigned null after caveatslu_tables;


select * from master_dim.lu_tables;