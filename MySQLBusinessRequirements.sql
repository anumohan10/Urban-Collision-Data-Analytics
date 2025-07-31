--1.How many accidents occurred in NYC, Austin and Chicago?
select count(*),s.`Source`
from FACT_ACCIDENTS a join DIM_Source s ON a.SK_Source=s.sk_source
group by a.SK_Source;

--2.Which areas in the 3 cities had the greatest number of accidents?
WITH RankedAccidents AS (
  SELECT 
    a.sk_location, 
    s.SOURCE, 
    l.street_name,
    COUNT(*) AS maxAccidents,
    DENSE_RANK() OVER (
      PARTITION BY a.sk_source 
      ORDER BY COUNT(*) DESC
    ) AS SourceRank
  FROM FACT_ACCIDENTS a 
  JOIN DIM_Location l ON a.sk_location = l.sk_location
  JOIN DIM_Source s ON a.sk_source = s.sk_source
  GROUP BY a.sk_location, a.sk_source, l.street_name
)
SELECT 
  ra.sk_location, 
  ra.SOURCE, 
  ra.street_name,
  ra.maxAccidents,
  ra.SourceRank
FROM RankedAccidents ra
WHERE ra.SourceRank <= 3
ORDER BY ra.SOURCE, ra.SourceRank;


--3.How many accidents resulted in just injuries?-> overall
select count(*) as NumAccidents from FACT_ACCIDENTS 
where injuries_total>0 and total_Killed<=0;

--3.How many accidents resulted in just injuries? -> by city
select count(*) as NumAccidents, s.SOURCE 
from FACT_ACCIDENTS a join DIM_Source s on a.SK_Source=s.sk_source
where a.injuries_total>0 and a.total_Killed<=0
group by a.sk_source
ORDER BY count(*) DESC;

--4.How often are pedestrians involved in accidents?
select count(*) as NumAccidents from FACT_ACCIDENTS 
where is_pedestrian=1;

select count(*) as NumAccidents, s.SOURCE 
from FACT_ACCIDENTS a join DIM_Source s on a.SK_Source=s.sk_source
where a.is_pedestrian=1
group by a.sk_source;

--5.When do most accidents happen? seasonality report
SELECT count(*) as NumAccidents, d.season
from FACT_ACCIDENTS a join DIM_DATE d on a.SK_Date=d.SK_Date
GROUP BY d.season
order by count(*) desc;


--6.How many motorists are injured or killed in accidents?
select sum(motorist_killed_count + motorist_injury_count) as NumMotorist 
from FACT_ACCIDENTS 
where motorist_killed_count >0 or motorist_injury_count> 0;

-- -> by city
select sum(a.motorist_killed_count + a.motorist_injury_count) as NumMotorist , s.SOURCE 
from FACT_ACCIDENTS a join DIM_Source s on a.SK_Source=s.sk_source
where a.motorist_killed_count >0 or a.motorist_injury_count> 0
group by a.sk_source;

--7.Which top 5 areas in 3 cities have the most fatal number of accidents?
WITH RankedAccidents AS (
  SELECT 
    a.sk_location, 
    s.SOURCE, 
    l.street_name,
    SUM(a.total_Killed) as totalKilled,
    DENSE_RANK() OVER (
      PARTITION BY s.SOURCE 
      ORDER BY SUM(a.total_Killed) DESC, COUNT(*) DESC
    ) AS SourceRank
  FROM FACT_ACCIDENTS a 
  JOIN DIM_Location l ON a.sk_location = l.sk_location
  JOIN DIM_Source s ON a.sk_source = s.sk_source
  WHERE (l.latitude <> -1 ) and ( l.longitude <> -1)
  GROUP BY a.sk_location, s.SOURCE, l.street_name
)
SELECT 
  ra.sk_location, 
  ra.SOURCE, 
  ra.street_name,
  ra.totalKilled,
  ra.SourceRank
FROM RankedAccidents ra
WHERE ra.SourceRank <= 5
ORDER BY ra.SOURCE, ra.totalKilled DESC, ra.SourceRank;

--8.Time based analysis of accidents
------Time of the day, day of the week, weekdays or weekends.
SELECT count(*) as NumAccidents,t.time_period
from FACT_ACCIDENTS a join DIM_TIME t on a.SK_Time=t.SK_Time
GROUP BY t.time_period
ORDER BY count(*) desc;

SELECT count(*) as NumAccidents,d.DayOfWeek
from FACT_ACCIDENTS a join DIM_DATE d on a.SK_Date=d.SK_Date
GROUP BY d.DayOfWeek
ORDER BY count(*) desc;

SELECT count(*) as NumAccidents,d.WeekDays_weekends
from FACT_ACCIDENTS a join DIM_DATE d on a.SK_Date=d.SK_Date
GROUP BY d.WeekDays_weekends
ORDER BY count(*) desc;

--9.Fatality analysis
------Are pedestrians killed more often than road users?
SELECT 
  (SELECT SUM(PEDESTRIAN_KILLED_COUNT) FROM FACT_ACCIDENTS) AS TotalPedestrianFatalities,
  (SELECT SUM(road_users_killed) FROM FACT_ACCIDENTS) AS TotalMotoristFatalities,
  CASE
    WHEN (SELECT SUM(PEDESTRIAN_KILLED_COUNT) FROM FACT_ACCIDENTS) > 
         (SELECT SUM(road_users_killed) FROM FACT_ACCIDENTS) 
    THEN 'Pedestrians killed more often'
    WHEN (SELECT SUM(PEDESTRIAN_KILLED_COUNT) FROM FACT_ACCIDENTS) < 
         (SELECT SUM(road_users_killed) FROM FACT_ACCIDENTS) 
    THEN 'Road Users killed more often'
    ELSE 'Pedestrians and Road Users killed equally often'
  END AS FatalityComparison

--10.What are the most common factors involved in accidents?
SELECT count(*) as NumAccidents,c.contributing_factor_code,c.contributing_factor_description
from FACT_CONTRIBUTION f join Dim_Contribution c on f.sk_contribution=c.sk_contribution
GROUP BY f.sk_contribution
order by count(*) desc
limit 10;

--11.Store vehicle type/vehicles involved in accidents at its least graunality
SELECT count(*) as NumAccidents,v.VEHICLE_CODE,v.VEHICLE_TYPE
from FACT_VEHICLE f join DIM_Vehicle_Type v on f.SK_VEHICLE_TYPE=v.SK_VEHICLE_TYPE
GROUP BY f.SK_VEHICLE_TYPE
order by count(*) desc
limit 10;

--12.Using Austin and NYC datasets, Create a visualization to show number of incidents that involved more than 2 vehicles. Show this data as a comparision between these 2 cities.
    SELECT count(*) as NumAccidents,s.SOURCE
    from FACT_VEHICLE v join FACT_ACCIDENTS a  on v.sk_fact_accidents=a.sk_fact_accidents
    join DIM_Source s on a.SK_Source=s.sk_source
    where v.units_involved>2 
    group by a.sk_source;