-- 2.1 Schema Definition 

CREATE TABLE mobility_events
(
    time_stamp DateTime64(3),
    deviceID UInt64,
    latitude Float64,
    longitude Float64,
    horizontal_accuracy Float32,
    city_code Enum8(
        'JK-CENTRAL' = 1,
        'JK-SOUTH'   = 2,
        'JK-EAST'    = 3,
        'JK-WEST'    = 4,
        'DPK'        = 5,
        'BGR'        = 6,
        'TGR'        = 7,
        'BKS'        = 8
    )
)
ENGINE = ReplacingMergeTree(time_stamp)
PARTITION BY toYYYYMM(time_stamp)
ORDER BY (city_code, time_stamp, deviceID);

-- 3.1 District Reach
SELECT
    uniqCombined(deviceID) AS unique_devices
FROM mobility_events
WHERE
    time_stamp >= now() - INTERVAL 7 DAY
    AND pointInPolygon(
        (longitude, latitude),
        [
            (106.812391, -6.219406),
            (106.80919, -6.222216),
            (106.799788, -6.22877),
            (106.799154, -6.228997),
            (106.795837, -6.229281),
            (106.796385, -6.226472),
            (106.796068, -6.223606),
            (106.794741, -6.223152),
            (106.795347, -6.218782),
            (106.79702, -6.218612),
            (106.795087, -6.21288),
            (106.791829, -6.208766),
            (106.792405, -6.207772),
            (106.796155, -6.207574),
            (106.796875, -6.204793),
            (106.799557, -6.201416),
            (106.800567, -6.200139),
            (106.802845, -6.199004),
            (106.805123, -6.195656),
            (106.805498, -6.192904),
            (106.806738, -6.189016),
            (106.810459, -6.188846),
            (106.810689, -6.188591),
            (106.810372, -6.185015),
            (106.814467, -6.181724),
            (106.816803, -6.181979),
            (106.821677, -6.18337),
            (106.823263, -6.183483),
            (106.823292, -6.186973),
            (106.822542, -6.186973),
            (106.822455, -6.188619),
            (106.821129, -6.191598),
            (106.820696, -6.194323),
            (106.820783, -6.195826),
            (106.822974, -6.197586),
            (106.822744, -6.202637),
            (106.8226, -6.202693),
            (106.821677, -6.209361),
            (106.8196, -6.213221),
            (106.818389, -6.214639),
            (106.816774, -6.215888),
            (106.812391, -6.219406)
        ]
    );

-- 3.2 Commuter Patterns
SELECT deviceID
FROM mobility_events
GROUP BY deviceID
HAVING
    countIf(
        city_code = 'JK-SOUTH'
        AND toHour(time_stamp) BETWEEN 9 AND 16
    ) > 0
AND
    countIf(
        city_code IN ('DPK', 'BGR')
        AND (
            toHour(time_stamp) > 21
            OR toHour(time_stamp) <= 5
        )
    ) > 0;

-- 3.3 Joins
SELECT m.*
FROM mobility_events m
ANY INNER JOIN jakarta_poi p
ON
    m.latitude BETWEEN p.latitude - 0.001
                  AND p.latitude + 0.001
AND m.longitude BETWEEN p.longitude - 0.001
                   AND p.longitude + 0.001
WHERE greatCircleDistance(
        m.latitude, m.longitude,
        p.latitude, p.longitude
      ) <= 100;