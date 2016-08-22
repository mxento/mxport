CREATE or replace
    DEFINER = `etl`@`%` 
    SQL SECURITY DEFINER
VIEW `ww_etl`.`event_info` AS
    select 
        cast(`i`.`STARTS` as time) AS `time(i.starts)`,
        `i`.`EVENT_SCHEMA` AS `event_schema`,
        `i`.`EVENT_NAME` AS `event_name`,
        i.interval_field,
        i.status,
        `i`.`EVENT_DEFINITION` AS `body`

    from
        `information_schema`.`events` `i`
    order by 1;
