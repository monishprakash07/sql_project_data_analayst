-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION
-- Get jobs and companies from february
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION
-- Get jobs and companies from march
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

/*
UNIION ALL - combining tables with all the duplicates values

*/

-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL
-- Get jobs and companies from february
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL
-- Get jobs and companies from march
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

/*

Practice Problem 1
Question:

. Get the corresponding skill and skill type for each job posting in q1

. Includes those without any skills, too

. Why? Look at the skills and the type for each job in the first quarter that has a salary >
$70,000

*/

WITH q1postings AS (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
)

SELECT
    q1postings.salary_year_avg AS q1salary,
    sd.skills,
    sd.type
FROM skills_job_dim AS sjd
INNER JOIN q1postings ON q1postings.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE   
    q1salary > 70000


/*
Find job postings from the first quarter that have a salary greater thar
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an averag& yearly salary > $70,000
*/

SELECT 
    quarter_jobs.job_title_short,
    quarter_jobs.job_location,
    quarter_jobs.job_via,
    quarter_jobs.job_posted_date::DATE,
    quarter_jobs.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_jobs
WHERE
    quarter_jobs.salary_year_avg > 70000 AND  
    quarter_jobs.job_title_short= 'Data Analyst'  
    