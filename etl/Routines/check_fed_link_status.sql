drop procedure if exists ww_etl.check_fed_link_status;

DELIMITER $$
CREATE DEFINER=`etl`@`%` PROCEDURE `check_fed_link_status`(schema_nm varchar(30), tbl_nm varchar(100), OUT return_status int(1))
begin 
declare col_nm varchar(100);
    DECLARE proc_name_var varchar(200);
    DECLARE batch_start datetime;
    DECLARE error_msg varchar(400);
    DECLARE log_msg varchar(200);
    DECLARE job_code smallint;
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
GET DIAGNOSTICS CONDITION 1
      @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    
    SET error_msg = concat('check_fed_link_status failed at ', now(), ' time for ',schema_nm, '.', tbl_nm, ' because ', @p1, '; ',  @p2);
    call ww_etl.etl_job_log_update (job_code, error_msg);
    select ww_etl.set_job_status(job_code,1);

select 1 into return_status;
END;


thisSP:Begin
SET proc_name_var = 'check_fed_link_status';
SET batch_start = now();
SET error_msg = concat('Error in ', proc_name_var);
SET job_code = 235;

select column_name into col_nm from
(
select column_name from information_schema.columns
where table_schema = schema_nm and table_name = tbl_nm and column_key = 'PRI'
union all
select column_name from information_schema.columns
where table_schema = schema_nm and table_name = tbl_nm and column_key <> '' and column_name in ('vendor_id', 'user_id', 'wedding_id', 'id')
union all
select column_name from information_schema.columns
where table_schema = schema_nm and table_name = tbl_nm and column_key <> '' 
union all
select column_name from information_schema.columns
where table_schema = schema_nm and table_name = tbl_nm and column_name in ('vendor_id', 'user_id', 'wedding_id', 'id')
) a limit 1;


if( col_nm is null ) then
    select concat('Check_fed_link_status failed because no indexed column could be found with schema:',schema_nm,' and table:', tbl_nm);
    select 1 into return_status;
    leave thisSP;
else
    select concat('Column_name to query with = ', col_nm);
end if;

set @s = concat('SELECT case when COUNT(*) is not null then 0 else 1 end into @return FROM ',schema_nm, '.', tbl_nm, ' where ', col_nm, ' = 1');
PREPARE stmt1 FROM @s;

EXECUTE stmt1;

select @return into return_status;
select concat('Fed Link Success! with return_status = ', return_status);
DEALLOCATE PREPARE stmt1;
select ww_etl.set_job_status(job_code,0);

end;
end $$
delimiter ;