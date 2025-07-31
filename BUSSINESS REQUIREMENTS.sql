
--Q1. How many accidents occurred in NYC, Austin and Chicago

SELECT D.SOURCE,COUNT(SK_FACT_ACCIDENTS) AS TOTAL_NO_OF_ACCIDENTS FROM FACT_ACCIDENTS F
JOIN 
	DIM_Source D ON D.SK_Source=F.SK_Source
GROUP BY 
	D.SOURCE

--Q2. Which areas in the 3 cities had the greatest number of accidents

--top areas within each city 

WITH RankedLocations AS (
    SELECT
        a.sk_location,
        s.source,  
        l.street_name,
        l.latitude,  
        l.longitude, 
        COUNT(*) AS maxAccidents,
        RANK() OVER (PARTITION BY a.sk_source ORDER BY COUNT(*) DESC) AS Rank
    FROM FACT_ACCIDENTS a
    JOIN DIM_Location l ON a.SK_Location = l.sk_location
    JOIN DIM_Source s ON a.SK_Source = s.SK_Source  
    WHERE l.latitude != -1 AND l.longitude != -1  
    GROUP BY a.sk_source, s.source, a.sk_location, l.street_name, l.latitude, l.longitude
)
SELECT
    sk_location,
    source, 
    street_name,
    latitude,
    longitude,
    maxAccidents
FROM RankedLocations
WHERE Rank <= 3
ORDER BY source, maxAccidents DESC;

	
SELECT TOP 3
    a.sk_location,
    s.source,
    COUNT(*) AS maxAccidents,
    l.street_name
FROM FACT_ACCIDENTS a
JOIN DIM_Location l ON a.SK_Location = l.sk_location
JOIN DIM_Source s ON a.SK_Source = s.SK_Source
GROUP BY a.sk_location, s.source, l.street_name
ORDER BY COUNT(*) DESC;

--Q3 How many accidents resulted in just injuries
SELECT COUNT(*) AS TOTAL_ACCIDENTS,S.SOURCE
FROM FACT_ACCIDENTS f
join DIM_SOURCE S on S.SK_Source=F.SK_Source
WHERE f.INJURIES_TOTAL>0 and f.TOTAL_KILLED<=0
GROUP BY S.SOURCE
ORDER BY TOTAL_ACCIDENTS DESC

SELECT COUNT(*) AS TOTAL_ACCIDENTS
FROM FACT_ACCIDENTS 
WHERE INJURIES_TOTAL>0 and TOTAL_KILLED<=0


--Q4 How often are pedestrians involved in accidents

SELECT COUNT(SK_FACT_ACCIDENTS) AS TOTAL_NO_OF_ACCIDENTS_WHERE_PEDESTRIANS_INVOLVED
FROM FACT_ACCIDENTS
WHERE IS_PEDESTRIAN=1

SELECT COUNT(F.SK_FACT_ACCIDENTS) AS TOTAL_NO_OF_ACCIDENTS_WHERE_PEDESTRIANS_INVOLVED,S.Source
FROM FACT_ACCIDENTS F
JOIN DIM_Source S ON S.SK_Source=F.SK_Source
WHERE IS_PEDESTRIAN=1
GROUP BY S.Source
ORDER BY TOTAL_NO_OF_ACCIDENTS_WHERE_PEDESTRIANS_INVOLVED DESC

--Q5 When do most accidents happen

SELECT COUNT(F.SK_FACT_ACCIDENTS) AS TOTAL_NO_OF_ACCIDENTS,D.Season
FROM FACT_ACCIDENTS F
JOIN DIM_DATE D ON D.SK_Date=F.SK_Date
GROUP BY D.Season
ORDER BY TOTAL_NO_OF_ACCIDENTS DESC

--Q6 How many motorists are injured or killed in accidents?

SELECT SUM(MOTORIST_INJURY_COUNT) AS TOTAL_MOTORIST_INJURED,
	   SUM(MOTORIST_KILLED_COUNT) AS TOTAL_MOTORIST_KILLED
FROM FACT_ACCIDENTS where motorist_killed_count >0 or motorist_injury_count> 0

select sum(motorist_killed_count + motorist_injury_count) as NumMotorist_Killed_Injured
from FACT_ACCIDENTS where motorist_killed_count >0 or motorist_injury_count> 0

SELECT SUM(MOTORIST_INJURY_COUNT) AS TOTAL_MOTORIST_INJURED,
	   SUM(MOTORIST_KILLED_COUNT) AS TOTAL_MOTORIST_KILLED,
	   S.SOURCE
FROM FACT_ACCIDENTS F
JOIN DIM_Source S ON F.SK_Source=S.SK_Source
GROUP BY S.SOURCE
ORDER BY S.Source ASC

--Q7 Which top 5 areas in 3 cities have the most fatal number of accidents

WITH RankedAccidents AS (
  SELECT
    a.sk_location,
    s.SOURCE,
    l.street_name,
    l.latitude,
    l.longitude, 
    SUM(a.total_Killed) AS totalKilled,
    COUNT(*) AS maxAccidents,
    DENSE_RANK() OVER (
      PARTITION BY s.SOURCE
      ORDER BY SUM(a.total_Killed) DESC, COUNT(*) DESC
    ) AS SourceRank
  FROM FACT_ACCIDENTS a
  JOIN DIM_Location l ON a.sk_location = l.sk_location
  JOIN DIM_Source s ON a.sk_source = s.sk_source
  WHERE l.latitude != -1 AND l.longitude != -1 
  GROUP BY a.sk_location, s.SOURCE, l.street_name, l.latitude, l.longitude
)
SELECT
  ra.sk_location,
  ra.SOURCE,
  ra.street_name,
  ra.latitude,
  ra.longitude,
  ra.maxAccidents,
  ra.totalKilled,
  ra.SourceRank
FROM RankedAccidents ra
WHERE ra.SourceRank <= 5
ORDER BY ra.SOURCE, ra.totalKilled DESC, ra.maxAccidents DESC, ra.SourceRank;

--Q8 Time based analysis of accidents: Time of the day, day of the week, weekdays or weekends.

SELECT COUNT(*) FROM DIM_Location
SELECT count(*) as NumAccidents,t.time_period
from FACT_ACCIDENTS a 
join DIM_TIME t on a.SK_Time=t.SK_Time
GROUP BY t.time_period;

SELECT count(*) as NumAccidents,d.Day_Of_The_Week
from FACT_ACCIDENTS a join DIM_DATE d on a.SK_Date=d.SK_Date
GROUP BY d.Day_Of_The_Week
ORDER BY count(*) desc;

SELECT count(*) as NumAccidents,d.WeekDays_weekends
from FACT_ACCIDENTS a join DIM_DATE d on a.SK_Date=d.SK_Date
GROUP BY d.WeekDays_weekends
ORDER BY count(*) desc;

-- Q9 Fatality analysis: Are pedestrians killed more often than road users?

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

--Q10 most common factors involved in accidents

SELECT TOP 10 Contributing_Factor_code,Contributing_Factor_DESCRIPTION,
COUNT(fa.SK_FACT_ACCIDENTS) AS COUNT_OF_ACCIDENTS
FROM Dim_Contribution dc
join FACT_CONTRIBUTION fc on dc.SK_Contribution=fc.SK_Contribution
join FACT_ACCIDENTS fa on fa.SK_FACT_ACCIDENTS=fc.SK_FACT_ACCIDENTS
GROUP BY Contributing_Factor_code,Contributing_Factor_DESCRIPTION
ORDER BY COUNT_OF_ACCIDENTS DESC

--Q11 Store vehicle type/vehicles involved in accidents at its least graunality

SELECT * from DIM_Vehicle_Type;

--12.Using Austin and NYC datasets, Create a visualization to show number of incidents that involved more than 2 vehicles. Show this data as a comparision between these 2 cities.

SELECT count(*) as NumAccidents,s.SOURCE
from FACT_ACCIDENTS a join FACT_VEHICLE v on v.sk_fact_accidents=a.sk_fact_accidents
join DIM_Source s on a.SK_Source=s.sk_source
where v.units_involved>2
group by a.sk_source;