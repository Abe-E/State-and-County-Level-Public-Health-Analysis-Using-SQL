SELECT 
E.State,
E.Per_Capita_Income,
C.Disease_AgeAdj_Prev AS "COPD Age-Adjusted Prevalence"
FROM 
(SELECT 
State,
Estimate AS "Per_Capita_Income" 
FROM 
us_economy_data
WHERE 
`Label (Grouping)` LIKE "Per capita income (dollars)")  AS E
INNER JOIN 
(SELECT 
LocationDesc AS State,
AVG(DataValue) AS Disease_AgeAdj_Prev
FROM 
us_chronic_data_cleaned
WHERE 
Topic LIKE "%Chronic Obstructive Pulmonary Disease%" 
AND 
Question LIKE "%Chronic obstructive pulmonary disease among adults%"
AND 
DataValueType LIKE "%Age-adjusted Prevalence%" 
AND 
Stratification1 LIKE "Overall"
AND 
LocationDesc NOT LIKE "United States"
GROUP BY 
LocationDesc) AS C
ON E.State = C.State 
WHERE
 E.State NOT LIKE "Puerto Rico" 
ORDER BY 
C.Disease_AgeAdj_Prev DESC
