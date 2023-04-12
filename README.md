# SQL-project-ENGETO

## Analyzing salaries and food prices in Czech Republic using SQL

#### Project assignment: <br>
Please prepare a comprehensive data documentation that shows comparisons of food product availability based on average incomes over a specific period of time. <br>

As additional data, prepare a table with GDP, GINI coefficient and population of other European countries in the same period, as a primary overview for the Czech Republic.


#### Research questions: <br>
**Question 1**: Are wages rising in all industries over the years, or falling in some? <br>
**Question 2**: How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage data? <br>
**Question 3**: Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)? <br>
**Question 4**: Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)? <br>
**Question 5**: Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase? <br>

#### Primary tables: <br>
1. czechia_payroll: <br>
    * General description: information about wages in various sectors for the years 2000 to 2021 <br>
    * column industry_branch_code <br>
    	• IS NULL: contains average wages for current year for all industry branches <br>
   	• IS NOT NULL: wages are divided based on industry branch categories. <br>

	I will use both conditions to create my primary table. For research question 1, I will work with the 'IS NOT NULL' condition, while for the remaining research 		questions, I will use the 'IS NULL' condition.<br>
	 
    * column calculation_code <br>
 	• **100 Average gross monthly salary for natural person:** includes income from secondary employment, part-time employment, and other sources. <br>
        • **200 Average gross monthly salary for recalculated numbers:** reflects the average wage for full-time work, but may contain inaccuracies due to estimations. Does not take into account differences in working hours or employment type. <br>

	Since the income that people use to purchase food does not come solely from full-time work income, I will use calculation_code 100 for my analysis. <br> 

2. czechia_payroll_calculation: <br>
    * index of calculation's type in the czechia_payroll table <br>

3. czechia_payroll_industry_branch: <br> 
    * index of industry branch type (A to S) and name in the czechia_payroll table <br>

4. czechia_payroll_unit: <br> 
    * index of unit types in the czechia_payroll table <br>
    * code '200 = CZK' will be used for analysis <br>
 
5. czechia_payroll_value_type: <br>
    * index of value types in the czechia_payroll table <br>

6. czechia_price: <br> 
    * General description: information about the prices of selected foods for the years 2006 to 2018. <br>
    * column region code: <br>
	• IS NULL: contains average price for selected period of time and product <br>	
	• IS NOT NULL: contains product price, which was valid during selected period of time and region <br>

7. czechia_price_category <br>
    * General description: index of food categories which appear in the czechia_price table. <br>

#### Additional tables: <br>
1. czechia_region: <br> 
    * list of regions of the Czech Republic according to the CZ-NUTS 2 standard. <br>
3. czechia_district: <br>
    * list of districts of the Czech Republic according to the LAU standard. <br>
5. countries: <br> 
    * all kinds of information about countries in the world, for example the capital, currency, national food or average height of the population. <br>
7. economies: <br>
    * contains information about GDP, GINI, tax burden, etc. for a given state and year. <br>
