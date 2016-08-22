#SELECT distinct social_network_type_code, left(social_url,16) FROM weddingwire.vendor_social_network;

CREATE TABLE master_dim.lu_social_network_type_code (social_network_type_code INT, name VARCHAR(20));
INSERT	master_dim.lu_social_network_type_code VALUES (100,'Facebook'),(200,'Twitter'),(300,'LinkedIn'),(400,'Pinterest');


