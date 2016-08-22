DROP TABLE IF EXISTS geoip_blocks;
CREATE TABLE geoip_blocks (
		startIpNum int(10) unsigned NOT NULL,
		endIpNum int(10) unsigned NOT NULL,
		locId int(10) unsigned NOT NULL,
		PRIMARY KEY (endIpNum)
	);
DROP TABLE IF EXISTS geoip_location;
CREATE TABLE geoip_location(
		locId int(10) unsigned NOT NULL,
		country char(2) NOT NULL,
		region char(2) NOT NULL,
		city varchar(50),
		postalCode char(5) NOT NULL,
		latitude float,
		longitude float,
		metroCode INT default null,
		areaCode int default null,
		PRIMARY KEY (locId)
	);

LOAD DATA LOCAL INFILE '/Users/timothykovacs/Downloads/GeoLiteCity_20140701/GeoLiteCity-Blocks.csv'
		INTO TABLE geoip_blocks
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n'
		IGNORE 2 LINES;
LOAD DATA LOCAL INFILE '/Users/timothykovacs/Downloads/GeoLiteCity_20140701/GeoLiteCity-Location.csv'
		INTO TABLE geoip_location
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n'
		IGNORE 2 LINES;

select * from geoip_location;
select * from geoip_blocks;

SELECT l.country,l.region,l.city 
      FROM geoip_location l JOIN geoip_blocks b ON (l.locId=b.locId)
      WHERE INET_ATON('209.152.131.3') >= b.startIpNum
      AND INET_ATON('209.152.131.3') <= b.endIpNum;

SELECT INET_ATON('209.152.131.3');