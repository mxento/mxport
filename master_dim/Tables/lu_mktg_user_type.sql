# DATA-101

USE master_dim;
CREATE TABLE `lu_mktg_user_type` (
  `code` CHAR(1) NOT NULL,
  `display_name` VARCHAR(100),
  `last_updated_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT lu_mktg_user_type (`code`, display_name) VALUES 
 ('1', 'Bride')
,('2', 'Groom')
,('3', 'Bridesmaids')
,('4', 'Groomsmen')
,('5', 'Wedding Party')
,('6', 'Guest')
,('7', 'Newlywed')
,('8', 'None');

SELECT * FROM lu_mktg_user_type;