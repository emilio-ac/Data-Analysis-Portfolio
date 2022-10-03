
-- View the raw dataset that is being worked with.

SELECT *
FROM data_analysis..co2_emissions

-- The first query is to order the Running total for each country in descending order for the years 1990 through 2019

SELECT country_name, region, running_total
FROM data_analysis..co2_emissions
ORDER BY 3 DESC

--These two lines from this query delete a column of data from the original excel file to cut back on redundancy.
--DELETE FROM data_analysis..co2_emissions
--WHERE country_name= 'Global Total'

-- Running this will show the ten nations that give off the most emissions in the world.

SELECT *
FROM data_analysis..co2_emissions
WHERE running_total > (SELECT AVG(running_total) FROM data_analysis..co2_emissions) 
ORDER BY running_total DESC 
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY

-- In contrast a query to show the ten nations that give off the least emissions, 
-- excluding the select few that give off zero emissions overall year round or an amount too small to be quantified(metric tons/capita).

SELECT *
FROM data_analysis..co2_emissions
WHERE running_total < (SELECT AVG(running_total) FROM data_analysis..co2_emissions) 
ORDER BY running_total ASC 
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY

-- This query totals the amount of co2 emissions produced by region and uses the year 1990 as a base to order the data in descending order.

SELECT region,
COUNT(*) AS count,
SUM("1990") AS '1990', SUM("1991") AS '1991', SUM("1992") AS '1992', SUM("1993") AS '1993', SUM("1994") AS '1994', SUM("1995") AS '1995',
SUM("1996") AS '1996', SUM("1997") AS '1997', SUM("1998") AS '1998', SUM("1999") AS '1999', SUM("2000") AS '2000', SUM("2001") AS '2001', 
SUM("2002") AS '2002', SUM("2003") AS '2003', SUM("2004") AS '2004', SUM("2005") AS '2005', SUM("2006") AS '2006', SUM("2007") AS '2007', 
SUM("2008") AS '2008', SUM("2009") AS '2009', SUM("2010") AS '2010', SUM("2011") AS '2011', SUM("2012") AS '2012', SUM("2013") AS '2013', 
SUM("2014") AS '2014', SUM("2015") AS '2015', SUM("2016") AS '2016', SUM("2017") AS '2017', SUM("2018") AS '2018', SUM("2019") AS '2019'
FROM data_analysis..co2_emissions
GROUP BY region 
ORDER BY "1990" DESC

-- A query that totals all emissions each year.

SELECT
COUNT(*) AS count,
SUM("1990") AS '1990', SUM("1991") AS '1991', SUM("1992") AS '1992', SUM("1993") AS '1993', SUM("1994") AS '1994', SUM("1995") AS '1995',
SUM("1996") AS '1996', SUM("1997") AS '1997', SUM("1998") AS '1998', SUM("1999") AS '1999', SUM("2000") AS '2000', SUM("2001") AS '2001', 
SUM("2002") AS '2002', SUM("2003") AS '2003', SUM("2004") AS '2004', SUM("2005") AS '2005', SUM("2006") AS '2006', SUM("2007") AS '2007', 
SUM("2008") AS '2008', SUM("2009") AS '2009', SUM("2010") AS '2010', SUM("2011") AS '2011', SUM("2012") AS '2012', SUM("2013") AS '2013', 
SUM("2014") AS '2014', SUM("2015") AS '2015', SUM("2016") AS '2016', SUM("2017") AS '2017', SUM("2018") AS '2018', SUM("2019") AS '2019'
FROM data_analysis..co2_emissions



-- CREATING A TEMP TABLE(using previous queries totals) TO CALCULATE RATE OF CHANGE PER YEAR.
-- We first drop the table in order to make our queries executable multiple times and to avoid errors.

DROP TABLE IF EXISTS #temp_global_totals
CREATE TABLE #temp_global_totals (
count int,
"1990" float,"1991" float,"1992" float,"1993" float,"1994" float,"1995" float,"1996" float,"1997" float,"1998" float,"1999" float,
"2000" float,"2001" float,"2002" float,"2003" float,"2004" float,"2005" float,"2006" float,"2007" float,"2008" float,"2009" float,
"2010" float,"2011" float,"2012" float,"2013" float,"2014" float,"2015" float,"2016" float,"2017" float,"2018" float,"2019" float
)
INSERT INTO #temp_global_totals
SELECT
COUNT(*) AS count,
SUM("1990") AS '1990', SUM("1991") AS '1991', SUM("1992") AS '1992', SUM("1993") AS '1993', SUM("1994") AS '1994', SUM("1995") AS '1995',
SUM("1996") AS '1996', SUM("1997") AS '1997', SUM("1998") AS '1998', SUM("1999") AS '1999', SUM("2000") AS '2000', SUM("2001") AS '2001', 
SUM("2002") AS '2002', SUM("2003") AS '2003', SUM("2004") AS '2004', SUM("2005") AS '2005', SUM("2006") AS '2006', SUM("2007") AS '2007', 
SUM("2008") AS '2008', SUM("2009") AS '2009', SUM("2010") AS '2010', SUM("2011") AS '2011', SUM("2012") AS '2012', SUM("2013") AS '2013', 
SUM("2014") AS '2014', SUM("2015") AS '2015', SUM("2016") AS '2016', SUM("2017") AS '2017', SUM("2018") AS '2018', SUM("2019") AS '2019'
FROM data_analysis..co2_emissions

-- Using the temp table we just created we can calculate the rate of change from year to year as a percent value. 

INSERT INTO #temp_global_totals
SELECT NULL, NULL, (ABS("1991"-"1990")/"1991")*100, (ABS("1992"-"1991")/"1992")*100, (ABS("1993"-"1992")/"1993")*100, (ABS("1994"-"1993")/"1994")*100,
(ABS("1995"-"1994")/"1995")*100, (ABS("1996"-"1995")/"1996")*100, (ABS("1997"-"1996")/"1997")*100, (ABS("1998"-"1997")/"1998")*100, (ABS("1999"-"1998")/"1999")*100,
(ABS("2000"-"1999")/"2000")*100, (ABS("2001"-"2000")/"2001")*100, (ABS("2002"-"2001")/"2002")*100, (ABS("2003"-"2002")/"2003")*100, (ABS("2004"-"2003")/"2004")*100,
(ABS("2005"-"2004")/"2005")*100, (ABS("2006"-"2005")/"2006")*100, (ABS("2007"-"2006")/"2007")*100, (ABS("2008"-"2007")/"2008")*100, (ABS("2009"-"2008")/"2009")*100,
(ABS("2010"-"2009")/"2010")*100, (ABS("2011"-"2010")/"2011")*100, (ABS("2012"-"2011")/"2012")*100, (ABS("2013"-"2012")/"2013")*100, (ABS("2014"-"2013")/"2014")*100,
(ABS("2015"-"2014")/"2015")*100, (ABS("2016"-"2015")/"2016")*100, (ABS("2017"-"2016")/"2017")*100, (ABS("2018"-"2017")/"2018")*100, (ABS("2019"-"2018")/"2019")*100
FROM #temp_global_totals

-- This final query allows us to see the calculations performed above.

SELECT *
FROM #temp_global_totals
--DELETE FROM #temp_global_totals

-- Insights compiled in using above queries can be visualized in the following dashboard:
-- https://public.tableau.com/views/co2_emission_dash/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link