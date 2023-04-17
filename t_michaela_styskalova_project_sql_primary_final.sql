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
