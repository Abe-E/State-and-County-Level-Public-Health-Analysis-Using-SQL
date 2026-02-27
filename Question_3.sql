SELECT 
    E.State,
    E.Per_Capita_Income,
    RANK() OVER (ORDER BY E.Per_Capita_Income DESC) AS Income_Rank,
    C.Disease_AgeAdj_Prev,
    RANK() OVER (ORDER BY C.Disease_AgeAdj_Prev DESC) AS COPD_Prevalence_Rank
FROM 
    (SELECT 
        State,
        Estimate AS Per_Capita_Income 
    FROM 
        us_economy_data
    WHERE 
        `Label (Grouping)` = 'Per capita income (dollars)'
    ) AS E
INNER JOIN 
    (SELECT 
        LocationDesc AS State,
        AVG(DataValue) AS Disease_AgeAdj_Prev
    FROM 
        us_chronic_data_cleaned
    WHERE 
        Topic LIKE '%Chronic Obstructive Pulmonary Disease%' 
        AND Question LIKE '%Chronic obstructive pulmonary disease among adults%'
        AND DataValueType LIKE '%Age-adjusted Prevalence%' 
        AND Stratification1 = 'Overall'
        AND LocationDesc != 'United States'
    GROUP BY 
        LocationDesc
    ) AS C
    ON E.State = C.State 
WHERE
    E.State != 'Puerto Rico' 
ORDER BY 
    COPD_Prevalence_Rank ASC;
