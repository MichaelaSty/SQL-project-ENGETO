/* 	Michaela Stýskalová
	Discord: Michaela St.#9278
*/

-- Creating primary table
CREATE OR REPLACE TABLE t_michaela_styskalova_project_sql_primary_final AS 
WITH 
wages AS (
	SELECT 
		payroll_year,
		industry_branch_code,
		round(avg(value),2) AS wages
	FROM czechia_payroll 
	WHERE 
		value_type_code = 5958 AND calculation_code = 100
	GROUP BY industry_branch_code, payroll_year
),
prices AS (
	SELECT
		cp.category_code,
		cpc.name AS 'category_name',
		cpc.price_value,
		cpc.price_unit, 
		round(avg(cp.value),2) AS 'avg_annual_price',
		year(cp.date_from) AS 'pricing_year',
		cp.region_code 
	FROM czechia_price cp
	JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
	WHERE cp.region_code IS NULL 
	GROUP BY cp.category_code, pricing_year, cpc.name, cpc.price_value, cpc.price_unit 
)
SELECT 
	p.avg_annual_price AS 'unit_price',
	p.category_code AS 'category_code',
	p.category_name, 
	p.price_value,
	p.price_unit, 
	p.pricing_year AS 'pricing_year',
	w.payroll_year AS 'payroll_year',
	w.industry_branch_code AS 'industry_branch_code',
	w.wages AS 'wages',
	CASE 	WHEN p.avg_annual_price IS NULL THEN 0
		ELSE floor(w.wages /p.avg_annual_price)
		END AS 'pcs'
FROM wages w
LEFT JOIN prices p
    ON p.pricing_year = w.payroll_year
;

-- Question 1: Are wages rising in all industries over the years, or falling in some?
WITH question1 AS (
SELECT
	t1.payroll_year,
	t1.industry_branch_code,
	t1.wages, 
	t2.wages AS 'prev_wages', 
	round(((t1.wages * 100) / t2.wages) - 100, 2)  AS 'pct_wage_change'
FROM t_michaela_styskalova_project_sql_primary_final  AS t1
LEFT JOIN t_michaela_styskalova_project_sql_primary_final  AS t2
	ON t1.industry_branch_code = t2.industry_branch_code
	AND t1.payroll_year = t2.payroll_year +1
GROUP BY industry_branch_code, payroll_year  
)
SELECT *
FROM question1
WHERE 
	industry_branch_code IS NOT NULL  
	AND pct_wage_change LIKE '-%';

/* 	Conclusion Q1: 
	Industry branch codes: H, N, Q, S have rising wages over the years.
	Other industry branch codes have an increasing wage trend, however, 
	a decline can be detected in certain years and sectors. This result 
	can be seen in the final selection.
 */


/* 	Question 2: How many liters of milk and kilograms of bread can be 
 	bought in the first and last comparable periods in the available 
 	price and wage data?

	114201	Mléko polotučné pasterované
	111301	Chléb konzumní kmínový

*/

SELECT
	*
FROM t_michaela_styskalova_project_sql_primary_final 
WHERE 
	category_code IN ('114201', '111301') 
	AND industry_branch_code IS NULL 
	AND (pricing_year IN (
		SELECT 
			min(pricing_year)
			FROM t_michaela_styskalova_project_sql_primary_final 
			) OR pricing_year IN (
		SELECT 
			max(pricing_year)
			FROM t_michaela_styskalova_project_sql_primary_final) 
		)
ORDER BY category_name; 

/* 	Conclusion:   
	For the first period (year 2006) can be bought: 
    	• 1172 pcs of 	'111301 - Chléb konzumní kmínový' and 
    	• 1308 pcs of 	'114201 - Mléko polotučné pasterované'.
    	
	For the last comparable period (year 2018) can be bought: 
   	• 1278 pcs of  '111301 - Chléb konzumní' kmínový and 
    	• 1563 pcs of 	'114201 - Mléko polotučné pasterované'.
*/


/* 	Question 3: Which food category is increasing in price the slowest 
	(has the lowest percentage year-on-year increase)?
*/

WITH question3 AS (
SELECT
	t1.unit_price,
	t1.category_code,
	t1.category_name, 
	t1.pricing_year, 
	t1.industry_branch_code,
	t2.pricing_year AS 'prev_pricing_year',
	t2.unit_price AS 'prev_unit_price',
	round(((t1.unit_price * 100) / t2.unit_price) - 100, 2)  AS 'pct_price_change'
FROM t_michaela_styskalova_project_sql_primary_final t1 
	LEFT JOIN t_michaela_styskalova_project_sql_primary_final t2
	ON t1.category_code = t2.category_code
	AND t1.pricing_year = t2.pricing_year +1
GROUP BY 
	t1.unit_price,
	t1.category_code, 
	t1.category_name, 
	t1.price_value, 
	t1.price_unit,
	t1.pricing_year,
	t1.industry_branch_code,
	t2.pricing_year, 
	t2.unit_price
)
SELECT *
FROM question3 
WHERE industry_branch_code IS NULL 
	AND pct_price_change IN (
		SELECT min(pct_price_change)
		FROM question3 
		WHERE pct_price_change > 0);

/* 	Conclusion: The lowest percentage year-on-year increase (0.01 %) can be
	found in the category 'Rostlinný roztíratelný tuk' from the year
	2008 to 2009 
*/


/* 	Question 4: Has there been a year in which the year-on-year increase
  	in food prices was significantly higher than wage growth (greater than 10%)?
*/

WITH wages_q4 AS (
	SELECT 
		t1.payroll_year,
		t1.industry_branch_code,
		t1.wages,
		t2.wages AS 'prev_wages',
		round(((t1.wages * 100) / t2.wages) - 100, 2) AS 'pct_wage_change',
		t1.category_code 
	FROM t_michaela_styskalova_project_sql_primary_final AS t1
	LEFT JOIN t_michaela_styskalova_project_sql_primary_final AS t2
		ON t1.payroll_year = t2.payroll_year + 1 
		WHERE t1.industry_branch_code IS NULL AND t2.industry_branch_code IS NULL  
	GROUP BY
		t1.payroll_year,
		t1.industry_branch_code,
		t1.wages,
		prev_wages,
		t1.category_code 
),
prices_q4 AS (
SELECT
	t1.category_code, 
	t1.unit_price,
	t1.pricing_year, 
	t2.pricing_year AS 'prev_pricing_year',
	t2.unit_price AS 'prev_unit_price',
	round(((t1.unit_price * 100) / t2.unit_price) - 100, 2)  AS 'pct_price_change'
FROM t_michaela_styskalova_project_sql_primary_final t1 
	LEFT JOIN t_michaela_styskalova_project_sql_primary_final t2
	ON t1.category_code = t2.category_code
	AND t1.pricing_year = t2.pricing_year +1
	WHERE t1.pricing_year > 2006
GROUP BY 
	t1.category_code, 
	t1.unit_price,
	prev_pricing_year,
	prev_unit_price
ORDER BY category_code, pricing_year 
)
SELECT
p.*,
w.*,
pct_price_change - pct_wage_change AS 'price_vs_wages'
FROM prices_q4 p
LEFT JOIN wages_q4 w
    ON p.pricing_year = w.payroll_year
    AND p.category_code = w.category_code
WHERE (pct_price_change - pct_wage_change) > 10  
GROUP BY payroll_year, p.category_code 
ORDER BY price_vs_wages DESC;

/*	Conclusion: Yes, there were 33 cases fulfilling the given condition.
	Result can be seen in final select.
*/
 
/*	Question 5: Does the level of GDP affect changes in wages 
 	and food prices? Or, if the GDP increases more significantly 
 	in one year, will this be reflected in food prices or wages in
 	the same or the following year by a more significant increase?
*/
CREATE OR REPLACE TABLE t_question5 AS (
WITH wages_q5 AS (
	SELECT 
		t1.payroll_year AS 'payroll_year',
		t2.payroll_year AS 'prev_payroll_year', 
		t1.wages,
		t2.wages AS 'prev_wages',
		round(((t1.wages * 100) / t2.wages) - 100, 2) AS 'pct_wage_change',
		t1.category_code 
	FROM t_michaela_styskalova_project_sql_primary_final AS t1
	LEFT JOIN t_michaela_styskalova_project_sql_primary_final AS t2
		ON t1.payroll_year = t2.payroll_year + 1 
		WHERE t1.industry_branch_code IS NULL AND t2.industry_branch_code IS NULL  
	GROUP BY
		t1.payroll_year,
		t1.industry_branch_code,
		t1.wages,
		prev_wages,
		t1.category_code 
),
prices_q5 AS (
SELECT
	t1.category_code, 
	t1.pricing_year, 
	t2.pricing_year AS 'prev_pricing_year',
	t1.unit_price,
	t2.unit_price AS 'prev_unit_price',
	round(((t1.unit_price * 100) / t2.unit_price) - 100, 2)  AS 'pct_price_change'
FROM t_michaela_styskalova_project_sql_primary_final t1 
	LEFT JOIN t_michaela_styskalova_project_sql_primary_final t2
	ON t1.category_code = t2.category_code
	AND t1.pricing_year = t2.pricing_year +1
	WHERE t1.pricing_year > 2006
GROUP BY 
	t1.category_code, 
	t1.unit_price,
	prev_pricing_year,
	prev_unit_price
ORDER BY category_code, pricing_year 
),
hdp AS (
SELECT
e.`year` AS 'year',
e2.`year` AS 'prev_year',
round(e.GDP,0) AS 'GDP',
round(e2.GDP,0) AS 'prev_GDP',
round(((e.GDP * 100) / e2.GDP) - 100, 2) AS 'pct_GDP_change'
FROM economies e
LEFT JOIN economies e2
ON e.`year` = e2.`year` +1
AND e.country = e2.country 
WHERE e.country = 'Czech Republic' AND e.`year` > 2000
)
SELECT
	p.category_code,
	p.pricing_year AS `year`,
	p.prev_pricing_year AS prev_year, 
	p.pct_price_change,
	w.pct_wage_change,
	h.pct_GDP_change
FROM prices_q5 p
LEFT JOIN wages_q5 w
    ON p.pricing_year = w.payroll_year
    AND p.category_code = w.category_code
LEFT JOIN hdp h
	ON h.`year` = p.pricing_year
	AND h.`prev_year` = p.prev_pricing_year 
GROUP BY 
    p.category_code,
    p.pricing_year,
    p.prev_pricing_year,
    p.pct_price_change,
    w.pct_wage_change,
    h.pct_GDP_change
);

-- Checking the maximum percentage GDP change
SELECT 
	`year`, 
	prev_year, 
	max(pct_GDP_change) AS 'max_pct_GDP_change'
FROM t_question5;

/* 	Checking the GDP impact on the prices and wages
	Setting up lower limit 2005
	Setting up upper limit 2011 	
*/

SELECT
	*
FROM t_question5 
WHERE 
	`year` > 2005 
	AND `year` < 2011;

/*	The GDP grow around 2 - 3 % per year doesn't have real impact/side effect
	on economy. For this reason I have selected the maximum percentage GDP 
	change (5.57 %), which was during the years 2006 - 2007 for further analysis.

	Conclusion: Overall economy growth (GDP increase):
		- increase the prices or slows down the price reduction trend 
		- increase the wages
*/

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
