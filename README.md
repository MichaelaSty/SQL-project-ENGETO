# SQL-project-ENGETO

## Analyzing salaries and food prices in Czech Republic using SQL

#### Project assignment: <br>
Please prepare a comprehensive data documentation that compares the availability of food products based on average incomes over a specific period of time.

As additional data, please prepare a table with the GDP, GINI coefficient, and population of other European countries during the same period, to provide an overview for comparison with the Czech Republic.


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
    * column region_code: <br>
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

##  Creating primary table <br>
I will create the primary table **t_michaela_styskalova_project_sql_primary_final**, which will be used as a basis for solving individual research questions. <br>
 
First, I will extract data from the 'czechia_payroll' table and name it 'wages'. The 'wages' CTE contains the average wages of different industry branches in Czechia as well as the average wages per year for all industries from the 'czechia_payroll' table. <br> 
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/b3ecd0c146304d37fa9a511225057273c4eefead/SQL_script.sql#L5-L17

Next, I will include data from the 'czechia_price' dataset, which will be named 'prices'. The 'prices' CTE contains the average prices, name and measuring units of different food categories in Czechia from the 'czechia_price' and 'czechia_price_category' tables: <br> 
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/e72ee5b3697d8e5379a174729be1612616411cbe/SQL_script.sql#L18-L32

Final select, forming the primary table. The join is based on the matching year of the wage and price data:
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/9aa06b2b9193c6713593958c0a0a3ec9ec22a604/SQL_script.sql#L33-L49

## Question 1: Are wages rising in all industries over the years, or falling in some? <br>
The query selects the current and previous year wages for each industry and calculates the percentage change. The results are filtered to show only the industry branches with a negative percentage change in wages: <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/39de4fea69ccdf0ae1dd8245c5f503d6d71eafe3/SQL_script.sql#L52-L70

**Conclusion Q1:** <br>
The industry branch codes H, N, Q, and S have shown rising wages over the years. While other industry branch codes also have an increasing wage trend, there have been declines in certain years and sectors. This can be observed in the final selection. <br>

## **Question 2:** How many liters of milk and kilograms of bread can be bought in the first and last comparable periods in the available price and wage data? <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/9aa06b2b9193c6713593958c0a0a3ec9ec22a604/SQL_script.sql#L88-L103

**Conclusion Q2:** <br>
For the first period (year 2006) can be bought: <br>
	* 1172 pcs of 	'111301 - Chléb konzumní kmínový' and <br>
	* 1308 pcs of 	'114201 - Mléko polotučné pasterované'. <br>
	<br>
For the last comparable period (2018) can be bought <br>
	* 1278 pcs of  	'111301 - Chléb konzumní' kmínový and <br>
	* 1563 pcs of 	'114201 - Mléko polotučné pasterované'.<br>


## **Question 3:** Which food category is increasing in price the slowest (has the lowest percentage year-on-year increase)? <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/fecb2ba6a848e424e528519e9fec1669f00e6534/SQL_script.sql#L120-L151

**Conclusion Q3:** <br>
The lowest percentage year-on-year increase (-30.28 %) can be found in the category 'Rajská jablka červená kulatá' from the year 2006 to 2007. <br>


## **Question 4:** Has there been a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)? <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/1208a31672da8d32bbd849c1e658cac8f72ea68c/SQL_script.sql#L163-L224

**Conclusion Q4:** <br> 
There was no year in which the year-on-year price change of the consumer basket exceeded the year-on-year wage change by more than 10%.<br>

## **Question 5:** Does the level of GDP affect changes in wages and food prices? Or, if the GDP increases more significantly in one year, will this be reflected in food prices or wages in the same or the following year by a more significant increase? <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/ff2bed99207f3752de0cce58641b4be67e4a5bff/SQL_script.sql#L236-L312

Finding max value in data: <br> 
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/d58d67d2bed2611fcdf286008fbd904b93ae9d54/SQL_script.sql#L312-L317

I have selected the maximum percentage GDP change (5.57 %), which was during the years 2006 - 2007 for further analysis. <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/1cd8bc83048414c9a24bf912e0736060d0687031/SQL_script.sql#L319-L328

Conclusion Q5: Yes, the higher level of GDP increase food prices and wages during current year and also next year. <br>

##  Creating secondary table <br>
I will create a secondary table called 't_michaela_styskalova_project_sql_secondary_final', which will serve as an additional material. <br>
https://github.com/MichaelaSty/SQL-project-ENGETO/blob/ed54ce724abba92b96187bfa16276e6cb4169f68/t_michaela_styskalova_project_sql_secondary_final.sql#L1-L25
