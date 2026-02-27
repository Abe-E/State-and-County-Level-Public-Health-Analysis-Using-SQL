SELECT 
Chronic.Stratification1 AS Gender,
AVG(Chronic.DataValue) AS "Coronary Heart Disease Mortality", 
Chronic.DataValueType
FROM 
us_chronic_data_cleaned AS Chronic 
WHERE 
Chronic.YearStart = 2021 
AND 
Chronic.Question LIKE "%Coronary heart disease mortality%" 
AND 
Chronic.DataValueType LIKE "Crude Rate"
AND 
(Chronic.Stratification1 LIKE "Male" OR Chronic.Stratification1 LIKE "Female")
GROUP BY 
Chronic.Stratification1,
Chronic.DataValueType