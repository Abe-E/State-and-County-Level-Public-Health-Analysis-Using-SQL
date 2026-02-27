



__Project Overview__

This project investigates public health using CDC, U.S. Census Bureau, and Colorado Central Cancer Registry data to discover patterns of chronic disease prevalence and mortality. Using MySQL, I examined how demographic and socioeconomic factors relate to health outcomes such as coronary heart disease mortality, lung and bronchus cancer incidence, and chronic obstructive pulmonary disease (COPD). 

The goal of this project was to demonstrate an ability to:
1. Import, structure, and analyze datasets from multiple sources in MySQL
2. Write SQL queries using aggregation and filtering
3. Interpret public health data in unique and meaningful ways
4. Identify socioeconomic and gender differences in health outcomes 









__Investigation 1: Sex Differences in Coronary Heart Disease Mortality (2021)__

*Overview*
This investigation examined whether there were statistically meaningful differences in coronary heart disease mortality between males and females in 2021 using CDC mortality data. 

*Method*
```
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
```

<img width="499" height="144" alt="image" src="https://github.com/user-attachments/assets/29a54c5a-2d50-4fa0-9eee-1280287b87fe" />

 
*Interpretation*

Analysis revealed that men experience, on average, 54 more deaths per 100,000 individuals from coronary heart disease mortalities in compared to females in 2021. These findings indicate a substantial sex-based disparity in cardiovascular mortality. 

Our findings are consistent with previous cardiovascular research. For example, in a review by Maas & Appelman (2010), research suggest that cardiovascular disease develops later in women. Moreover, differences in clinical presentation in women lead to an under-recognition of early heart disease and less aggressive treatment strategies in comparison to men. 


__Investigation 2: Lung and Bronchus Cancer__

*Overview*

Leveraging data from the Colorado Central Cancer Registry, I identified the top five regions in Colorado with the highest age-adjusted incidence rates of lung and bronchus cancer between 2018 and 2020.

*Method*
```
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
```

<img width="499" height="112" alt="image" src="https://github.com/user-attachments/assets/718abd68-ea6f-4a6f-a6c4-e4d4e22f9497" />


*Interpretation*

The top 5 counties with the highest incidence of lung and bronchus cancer were Cheyenne, Baca, Lincoln, Prowers, and Fremont. The most striking incidence of lung cancer is in Cheyenne, with 67 more cases than the state average of 37. Though there are numerous risk factors associated with developing lung and bronchus cancer, additional research into these counties allowed for a couple of theories. Firstly, elevated tobacco use in frontier counties such as Baca, Prowers, and Lincoln in comparison to the state average may explain the higher incidence rates. Secondly, rural counties also have fewer opportunities for early lung cancer screenings due to a lack of access to specialized healthcare facilities. Lastly, these five counties share lower median household incomes and higher poverty rates than the state average. Socioeconomic status is deeply intertwined with tobacco use, health insurance, and increased occupational exposures to carcinogens. Future solutions may include an increase in screening programs and greater healthcare equality in these areas. 







__Question 3: Socioeconomic Status and COPD__

*Overview*

To examine whether socioeconomic status (measured by per capita income) is associated with COPD prevalence across U.S. states in 2021. Using Census and CDC data, states were ranked by per capita income. COPD prevalence rates were then compared with the ranked income to identify observable trends. 

*Method*
```
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
    COPD_Prevalence_Rank ASC
```


 <img width="499" height="249" alt="image" src="https://github.com/user-attachments/assets/59dd9688-416b-45bf-a822-a132d9c9a6ee" />

 
*Interpretation*

Overall, there appears to be a strong correlation between lower SES and higher rates of COPD. By sorting to find the top 10 states with the highest COPD prevalence, we see that every single state on this list falls in the bottom third of the country for per capita income. We also see that West Virginia has the highest COPD rate and the second lowest per capita income, and Mississippi has the lowest per capita income in the country and the sixth highest COPD prevalence. States with the highest COPD and lowest per capita income ranks are also concentrated in the South and Midwest. These regions have historically faced both socioeconomic and public health challenges, which may partly explain this trend. 




__References__


**Centers for Disease Control and Prevention.** (2023). *U.S. Chronic disease indicators (CDI)* [Data set]. Data.gov. https://catalog.data.gov/dataset/u-s-chronic-disease-indicators

**Colorado Department of Public Health and Environment.** (n.d.). *Colorado Central Cancer Registry (CCCR) data*

**Maas, P., & Appelman, Y.** (2010). Gender differences in coronary heart disease. *Netherlands Heart Journal, 18*(12), 598-603. https://doi.org/10.1007/s12471-010-0841-y

**U.S. Census Bureau.** (2024). *American Community Survey (ACS)* [Data set]. U.S. Department of Commerce. https://www.census.gov/programs-surveys/acs/



