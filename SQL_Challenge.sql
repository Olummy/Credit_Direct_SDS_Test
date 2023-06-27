
-- Q1 ----------------------------

-- Output

--day_of_week avg_duration
--  <chr>              <dbl>
--1 Sunday              79.1

SELECT `day_of_week`, `avg_duration`
FROM (
  SELECT *, RANK() OVER (ORDER BY `avg_duration` DESC) AS `q01`
  FROM (
    SELECT `day_of_week`, AVG(`duration_minutes`) AS `avg_duration`
    FROM (
      SELECT
        `start_time`,
        `duration_minutes`,
        strftime(`start_time`, '%A') AS `day_of_week`
      FROM `biker_tbl`
    )
    GROUP BY `day_of_week`
  )
)
WHERE (`q01` <= 1)

-- The longest average trip by duration in minutes happened on Sunday. 
-- 79.1 minutes on the average was completed by the riders on Sunday.

-- Q2 ----------------

SELECT `month_year`, `count_of_trips`
FROM (
  SELECT *, RANK() OVER (ORDER BY `count_of_trips` DESC) AS `q01`
  FROM (
    SELECT `month_year`, COUNT(*) AS `count_of_trips`
    FROM (
      SELECT `start_time`, strftime(`start_time`, '%b-%Y') AS `month_year`
      FROM `biker_tbl`
    )
    GROUP BY `month_year`
  )
)
WHERE (`q01` <= 1)

-- September 2020 has the most number of trips with a total trips of 530.



-- Q3----------

SELECT
  `trip_id`,
  `subscriber_type`,
  `bikeid`,
  `start_time`,
  `start_station_id`,
  `start_station_name`,
  `end_station_id`,
  `end_station_name`,
  `duration_minutes`
FROM (
  SELECT *, RANK() OVER (ORDER BY `duration_minutes` DESC) AS `q01`
  FROM `biker_tbl`
)
WHERE (`q01` <= 1)
UNION
SELECT
  `trip_id`,
  `subscriber_type`,
  `bikeid`,
  `start_time`,
  `start_station_id`,
  `start_station_name`,
  `end_station_id`,
  `end_station_name`,
  `duration_minutes`
FROM (
  SELECT
    `trip_id`,
    `subscriber_type`,
    `bikeid`,
    `start_time`,
    `start_station_id`,
    `start_station_name`,
    `end_station_id`,
    `end_station_name`,
    `duration_minutes`,
    RANK() OVER (ORDER BY `start_time`) AS `q03`
  FROM (
    SELECT *, RANK() OVER (ORDER BY `duration_minutes`) AS `q02`
    FROM `biker_tbl`
  )
  WHERE (`q02` <= 1)
)
WHERE (`q03` <= 1)