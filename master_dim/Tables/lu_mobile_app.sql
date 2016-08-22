DROP TABLE IF EXISTS master_dim.lu_mobile_app;
CREATE TABLE master_dim.lu_mobile_app (app_name VARCHAR(100), Android_name VARCHAR(200), Android_key VARCHAR(100), Android_active_flag TINYINT, Android_ga_profile_id INT, Apple_name VARCHAR(200), Apple_key INT, Apple_active_flag TINYINT, Apple_profile_id INT, INDEX idx_appname(App_Name));

INSERT master_dim.lu_mobile_app 
VALUES 
('VendorClients','Client Manager for Pros','com.weddingwire.vendorclients',1,95197760,'WeddingWire Client Manager for Pros',984520508,1,95197760),
('VendorReviews','Review Manager for Pros','com.weddingwire.vendorreviews',1,95190756,'WeddingWire Review Manager for Pros',972802560,1,95190756),
('ProWire','ProWire','com.ProWire.app',1,NULL,'ProWire',714567923,1,NULL),
('WeddingWire','Wedding Planning App','com.weddingwire.user',1,42116185,'WeddingWire',316565575,1,24627340),
('WedSocial','WedSocial by WeddingWire','com.weddingwire.wedsocial',1,81803665,'WedSocial - Wedding Photo Sharing',819680960,1,81803665),
('WedTeam','WedTeam - Wedding Planner App','com.weddingwire.vendorsearch',1,81814465,'WedTeam - Wedding Planner App',821189039,1,81814465),
('WedStyle',NULL,NULL,NULL,NULL,'WedStyle - Wedding Inspiration',814427349,1,81812968);

SELECT * FROM master_dim.lu_mobile_app;