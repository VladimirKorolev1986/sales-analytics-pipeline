create schema if not exists core;
drop table if exists core.geolocation;

create table core.geolocation as 
select geolocation_zip_code_prefix, 
		avg(geolocation_lat) as latitude,
		avg(geolocation_lng) as longitude
from staging.olist_geolocation_dataset
group by geolocation_zip_code_prefix