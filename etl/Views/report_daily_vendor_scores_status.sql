drop view if exists ww_etl.Report_daily_vendor_score_status ;

create view ww_etl.Report_daily_vendor_score_status as

select batch_id, version, count(*) as row_ct, date(date_loaded) as date_of_load, 
min(date_loaded) start_time, max(date_loaded) end_time
from vendor_dw.vendor_score_archive
# where datediff(now(), date_loaded) < 5
group by version, batch_id, date(date_loaded)
order by batch_id desc;


# select * from ww_etl.Report_daily_vendor_score_status ; 