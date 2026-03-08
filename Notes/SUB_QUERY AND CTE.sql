/*
Subqueries: query nested inside a larger query

It can be used in SELECT , FROM , and WHERE clauses.
*/
SELECT
FROM ( -- SubQuery starts here
SELECT
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- SubQuery ends here


/*
Common Table Expressions (CTEs): define a temporary result set that you can reference
. Can reference within a SELECT, INSERT, UPDATE , or DELETE statement
. Defined with WITH
*/

WITH january_jobs AS ( -- CTE definition starts here
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here

SELECT *
FROM january_jobs;


/*
Filter the jobs that has degree requirement and you also have to display company name for the jobs
*/

SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM
        job_postings_fact
    WHERE job_no_degree_mention = TRUE
    ORDER BY
        company_id
)

SELECT DISTINCT
    cd.company_id,
    cd.name AS company_name
FROM 
    company_dim AS cd
INNER JOIN job_postings_fact AS jpf ON cd.company_id = jpf.company_id
WHERE 
    jpf.job_no_degree_mention = TRUE
ORDER BY
    cd.company_id;

/* FOR CTE ---
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)
*/

SELECT
    company_id
FROM job_postings_fact  /*QUERY NOTE: This displays multiple numbers because each
                        company has multiple job postings (i.e., these are not duplicates) */


WITH company_job_count AS (
        SELECT 
            company_id,
            COUNT(*)
        FROM  
            job_postings_fact
        GROUP BY
            company_id
)

SELECT *
FROM company_job_count;

WITH company_job_count AS (
        SELECT 
            company_id,
            COUNT(*) AS total_job_count
        FROM  
            job_postings_fact
        GROUP BY
            company_id
)

SELECT  company_dim.name AS company_name,
        company_job_count.total_job_count
FROM
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_job_count DESC;


/*
Practice Problem 1
Identify the top 5 skills that are most frequently mentioned in job postings. Use a subquery to
find the skill IDs with the highest counts in the skills_job_dim table and then join this result
with the skills_dim table to get the skill names.
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    skill_counts.skill_count
FROM(
    SELECT
    skill_id,
    COUNT(*) as skill_count
FROM skills_job_dim
GROUP BY
    skill_id
) as skill_counts
LEFT JOIN skills_dim ON skill_counts.skill_id = skills_dim.skill_id
ORDER BY skill_count DESC
LIMIT 5


/*
Practice Problem 2
Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying
the number of job postings they have. Use a subquery to calculate the total job postings per
company. A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the
number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings.
Implement a subquery to aggregate job counts per company before classifying them based on
size.
*/

SELECT 
    company_dim.company_id,
    company_dim.name as company_name,
    count_table.job_posting_count,
    CASE    
        WHEN count_table.job_posting_count < 10 THEN 'small'
        WHEN count_table.job_posting_count > 10 AND count_table.job_posting_count < 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM 
 (
    SELECT
        company_id,
        COUNT(*) as job_posting_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
 ) AS count_table
LEFT JOIN company_dim ON count_table.company_id = company_dim.company_id
ORDER BY
    job_posting_count DESC
   

/*
Practice Problem 7

Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS(
    SELECT
        skills_to_job.skill_id,
        COUNT(*) as skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_posting ON job_posting.job_id = skills_to_job.job_id
    WHERE 
        job_posting.job_work_from_home = TRUE AND
        job_posting.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    skill.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim as skill ON skill.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5