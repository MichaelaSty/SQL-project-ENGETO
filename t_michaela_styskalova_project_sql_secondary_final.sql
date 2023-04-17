-- Creating secondary table
CREATE OR REPLACE TABLE t_michaela_styskalova_project_SQL_secondary_final AS (
SELECT
	c.country,
	c.continent,
	c.population,
	c.region_in_world,
	e.`year`,
	round(e.GDP,0) AS 'GDP',
	e.gini
FROM countries c
LEFT JOIN economies e
	ON c.country = e.country
WHERE 
	continent = 'Europe' 
	AND `year` BETWEEN 2000 AND 2021
GROUP BY 
	c.country,
	c.continent,
	c.population,
	c.region_in_world,
	e.`year`,
	e.GDP,
	e.gini
);
