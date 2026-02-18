/*
CASE STATMEMNTS
*/

/*

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/
SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE   
            'Onsite'
    END AS location_category
FROM   
    job_postings_fact;



SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE    'Onsite'
    END AS location_category
FROM   
    job_postings_fact
WHERE
    job_title = 'Data Analyst'
GROUP BY
    location_category;


/*
Practice Problem 1
Question:

I want to categorize the salaries from each job posting. To see if it fits in my desired salary range.
· Put salary into different buckets

. Define what's a high, standard, or low salary with our own conditions
. Why? It is easy to determine which job postings are worth looking at based on salary.
Bucketing is a common practice in data analysis when viewing categories.
. I only want to look at data analyst roles
· Order from highest to lowest
*/

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 15000 AND salary_year_avg < 30000 THEN 'Low salary'
        WHEN salary_year_avg >= 30000 AND salary_year_avg < 50000 THEN 'Standard Salary'
        ELSE 'High salary'
    END AS salary_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary_category;


