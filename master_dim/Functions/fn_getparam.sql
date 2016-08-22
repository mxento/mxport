DELIMITER $$
CREATE FUNCTION `fn_getparam`(param varchar(55), url varchar(2048)) RETURNS varchar(2048)
BEGIN
 
declare val varchar(2048);
declare _param varchar(60) DEFAULT CONCAT(param,'=');
 
select
case
    when locate(concat('&',_param), url) > 0
        then right(url, length(url) - (locate(concat('&',_param),url)+length(concat('&',_param))-1))
    when locate(concat('?',_param), url) > 0
        then right(url, length(url) - (locate(concat('?',_param),url)+length(concat('?',_param))-1))
    when locate(concat('#',_param), url) > 0
        then right(url, length(url) - (locate(concat('#',_param),url)+length(concat('#',_param))-1))
    when locate(_param,url) > 0
        then right(url, length(url) - (locate(_param,url)+length(_param)-1) )
else null
end
into val;
 
set val = replace(replace(left(val, locate('&',concat(val,'&'))-1),'%20',' '),'+',' ');
 
RETURN val;
END