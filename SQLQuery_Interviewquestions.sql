--Interview Questions practice for various companies.



--Salaries Differences
--Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the difference in salaries.

SELECT
(SELECT MAX(salary) FROM db_employee as emp
INNER JOIN db_dept 
ON emp.department_id = db_dept.id
WHERE department = 'marketing'
)-

(SELECT MAX(salary) FROM db_employee as emp
INNER JOIN db_dept 
ON emp.department_id = db_dept.id
WHERE department = 'engineering'
) AS salary_difference





--Finding Updated Records
--We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.

select id,first_name,last_name,department_id, MAX(salary) AS current_salary from ms_employee_salary

GROUP BY id,first_name,last_name,department_id

ORDER BY id





--Top Search Results
--You're given a table that contains search results. If the 'position' column represents the position of the search results, write a query to calculate the percentage of search results that were in the top 3 position.

SELECT (SUM(CASE WHEN position <= 3 THEN 1
ELSE 0 END )::float / COUNT(result_id))*100 AS top_3_percentage FROM fb_search_results






--Bikes Last Used
--Find the last time each bike was in use. Output both the bike number and the date-timestamp of the bike's last use (i.e., the date-time the bike was returned). Order the results by bikes that were most recently used.

select bike_number,MAX(end_time) AS last_used from dc_bikeshare_q1_2012
GROUP BY bike_number 
ORDER BY last_used DESC;






--Popularity of Hack
--Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. Luckily the user IDs of employees completing the surveys were stored.
--Based on the above, find the average popularity of the Hack per office location.
--Output the location along with the average popularity.

select location,AVG(popularity) as average_popularity from facebook_employees
INNER JOIN facebook_hack_survey ON facebook_employees.id = facebook_hack_survey.employee_id
GROUP BY location;