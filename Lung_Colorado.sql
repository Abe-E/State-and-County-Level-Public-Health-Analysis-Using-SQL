SELECT 
Measure,
GeographyName,
Convert(GeographyValue, Decimal) AS "Incidence Rate", 
StateValue
FROM 
Disease_Injury 
WHERE
GeographyValue IS NOT NULL
AND 
Measure LIKE "%Lung%"   
AND
GeographyName NOT LIKE "%HSR%"
AND 
GeographyName NOT LIKE "%Colorado%"
ORDER BY 
Convert(GeographyValue, Decimal) DESC