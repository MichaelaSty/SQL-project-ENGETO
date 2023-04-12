# SQL-project-ENGETO

## Data about salaries and food prices and their processing using SQL.

#### Project assignment: <br>
Please prepare a comprehensive data documentation that shows comparisons of food product availability based on average incomes over a specific period of time. <br>

As additional data, prepare a table with GDP, GINI coefficient and population of other European countries in the same period, as a primary overview for the Czech Republic.


#### Research questions: <br>
**Question 1**: Are wages rising in all industries over the years, or falling in some? <br>
**Question 2**: How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage data? <br>
**Question 3**: Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)? <br>
**Question 4**: Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)? <br>
**Question 5**: Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase? <br>

#### Primary tables:
1. czechia_payroll:<br>
    • General description: information about wages in various sectors for the years 2000 to 2021 <br>
    • column industry_branch_code <br>
    IS NULL: contains average wages for current year for all industry branches <br>
   		> IS NOT NULL: wages are divided based on industry branch categories. <br>

	I will use both condition for creation of my primary table. To answer research question 1 I will work with 'IS NOT NULL' condition. For the rest of the 	research question I will use condition 'IS NULL'<br>
	
    • column calculation_code <br>
        ◦ 100 Average gross monthly salary for natural person: <br>
            ▪  includes also income from secondary employment, part-time employment, etc. <br>
        ◦ 200 Average gross monthly salary for recalculated numbers <br>  
            ▪ the calculation should reflect the average wage for full-time work <br>
            ▪ contains inaccuracies because of estimations <br>
            ▪ does not take into account different working hours and employment type <br>

	Since the income that people use to purchase food does not come solely from full-time work income, I will use calculation_code 100 for my analysis. <br> 

2. czechia_payroll_calculation:<br>
    • General description: index of calculation's type in the czechia_payroll table <br>

3. czechia_payroll_industry_branch: <br>
    • General description: index of industry branch type (A to S) and name in the czechia_payroll table <br>

4. czechia_payroll_unit <br>
    • General description: index of unit types in the czechia_payroll table <br>
    • code '200 = CZK' will be used for analysis <br>
 
5. czechia_payroll_value_type: <br>     
    • General description: index of value types in the czechia_payroll table <br>

6. czechia_price: <br> 
    • General description: information about the prices of selected foods for the years 2006 to 2018. <br>
    • column region code: <br>
		IS NULL: contains average price for selected period of time and product <br>	
		IN NOT NULL: contains product price, which was valid during selected period of time and region <br>

7. czechia_price_category <br>
	- General description: index of food categories which appear in the czechia_price table. <br>

#### Additional tables: <br>
1. czechia_region: list of regions of the Czech Republic according to the CZ-NUTS 2 standard. <br>
2. czechia_district – list of districts of the Czech Republic according to the LAU standard. <br>
3. countries - All kinds of information about countries in the world, for example the capital, currency, national food or average height of the population. <br>
4. economies - contains information about GDP, GINI, tax burden, etc. for a given state and year. <br>
