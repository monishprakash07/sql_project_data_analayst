
/*
finding each month has how many job postings for data analyst 
by counting job id with respect to month and grouping it with month
*/

SELECT  
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM   
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;

--------------------------------------------
/*
Practice Problem 1
Write a query to find the average salary both yearly ( salary_year_avg )and hourly
( salary_hour_avg ) for job postings that were posted after June 1, 2023. Group the results by
job schedule type.
*/

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS avg_yearly_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date) > 2023 
    OR (EXTRACT(YEAR FROM job_posted_date) = 2023 AND EXTRACT(MONTH FROM job_posted_date) > 6)
    OR (EXTRACT(YEAR FROM job_posted_date) = 2023 AND EXTRACT(MONTH FROM job_posted_date) = 6 AND EXTRACT(DAY FROM job_posted_date) > 1)
GROUP BY 
    job_schedule_type;


/*
Practice Problem 2
Write a query to count the number of job postings for each month in 2023, adjusting the
job_posted_date to be in 'America/New_York' time zone before extracting (hint) the month.
Assume the job_posted_date is stored in UTC. Group by and order by the month.
*/

SELECT 
    COUNT(job_id) AS job_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month

/*
Practice Problem 3
Write a query to find companies (include company name) that have posted jobs offering health
insurance, where these postings were made in the second quarter of 2023. Use date extraction
to filter by quarter.
*/

SELECT
    job_id,
    companies.name as company_name,
    EXTRACT(YEAR FROM job_posted_date) as Year_posted,
    EXTRACT(MONTH FROM job_posted_date) as month_posted
FROM job_postings_fact
LEFT JOIN company_dim  as companies ON job_postings_fact.company_id = companies.company_id  
WHERE
    (EXTRACT(YEAR FROM job_posted_date) = 2023 AND EXTRACT(MONTH FROM job_posted_date) > 6) AND
    job_health_insurance IS TRUE