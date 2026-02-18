
/*
1. The Salary Tier Breakdown
Goal: Categorize job postings into salary tiers and find the top-performing companies.

Task: Create a CTE that calculates the average yearly salary for each company. In your main query, use a CASE statement to label companies as 'High Paying' (>$150k), 'Medium Paying' ($100k-$150k), or 'Low Paying' (<$100k).

Constraint: Only include jobs that are "Work from Home" (job_work_from_home = TRUE).
*/


WITH company_salaries AS (
    SELECT 
        company_id,
        AVG(salary_year_avg) as avg_salary
    FROM job_postings_fact
    WHERE
        salary_year_avg is not NULL AND
        job_work_from_home = TRUE
    GROUP BY
        company_id
)

SELECT
    company_salaries.company_id,
    company_dim.name as company_name,
    CASE
        WHEN company_salaries.avg_salary < 100000 THEN 'Low Pay'
         WHEN company_salaries.avg_salary > 100000 AND company_salaries.avg_salary < 150000 THEN 'Medium Pay'
        ELSE 'Hight Pay'
    END AS category
FROM
    company_salaries
LEFT JOIN company_dim on company_dim.company_id = company_salaries.company_id

-----------------------------------------------------------------------------------------

/*
Practice Problem 3: Remote vs. On-Site Skill Value
Determine if certain skills command a higher salary when the job is remote versus when it is on-site.
The Task:
Create a CTE that joins the job_postings_fact, skills_job_dim, and skills_dim tables.
Inside that CTE, use a CASE statement to create a new column called location_category.
If job_work_from_home is TRUE, label it 'Remote'.
Otherwise, label it 'On-Site'.

In your main query, Group by this new location_category and the skill_name to find the average yearly salary (salary_year_avg) 
for each combination.
*/

WITH skill_pay_stats AS( 
        -- CTE: Combine job data with skills and categorize by location
    SELECT
        sjd.skill_id,
        sd.skills as skill_name,
        salary_year_avg as avg_yearly_salary,
        CASE
            WHEN jpf.job_work_from_home = TRUE THEN 'Remote Jobs'
            ELSE 'On-site jobs'
        END AS location_category
    FROM 
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.salary_year_avg is NOT NULL -- Constraint: Remove empty salaries
)

SELECT
    skill_name,
    skill_pay_stats.location_category,
    ROUND(AVG(avg_yearly_salary),2) as round_avg_salary
FROM skill_pay_stats
GROUP BY
    skill_name,
    location_category


/*
Practice Problem 4: The "Missing Degree" Advantage
Identify companies that are posting "Senior-level" roles but do not require a formal degree, highlighting companies that prioritize skills over education.

The Task:
Use a Subquery to identify all job_ids from the job_postings_fact table where job_no_degree_mention is TRUE.
Join this result with the company_dim table to get the company names.
Use a CASE statement to look at the job_title and categorize the seniority:
If the title contains 'Senior', 'Lead', or 'Manager', label it 'Senior'.
Otherwise, label it 'Junior/Mid'.
Group by the company name and this new seniority category.
Filter the results using a HAVING clause to only show the counts for 'Senior' roles.
*/

SELECT
    name as company_name,
    CASE 
        WHEN jpf.job_title LIKE '%Senior%' THEN 'Senior'
        WHEN jpf.job_title LIKE '%Lead%' THEN 'Senior'
        WHEN jpf.job_title LIKE '%Manager%' THEN 'Senior'
        ELSE 'Junior/mid'
    END AS seniory_level,
    COUNT(DISTINCT jpf.job_id) as job_count
FROM company_dim
INNER JOIN job_postings_fact as jpf ON jpf.company_id = company_dim.company_id
WHERE
    jpf.job_id IN (
        SELECT 
            job_id
        FROM job_postings_fact
        WHERE job_no_degree_mention = TRUE
    )
GROUP BY
company_name,
seniory_level
HAVING
    -- -- Filtering to only show the "Senior" counts as requested
CASE 
    WHEN jpf.job_title LIKE '%Senior%' THEN 'Senior'
    WHEN jpf.job_title LIKE '%Lead%' THEN 'Senior'
    WHEN jpf.job_title LIKE '%Manager%' THEN 'Senior'
    ELSE 'Junior/mid'
END = 'Senior'
ORDER BY
    job_count DESC

/*
Practice Problem 5: High-Growth Skill Analysis by Month
Analyze the demand for skills during the final quarter of 2023 (October, November, and December) to 
see which skills were trending as the year ended.

The Task:
Create a CTE that joins job_postings_fact and skills_job_dim.
Inside the CTE, extract the month from the job_posted_date.
Filter (using WHERE) for the year 2023 and only for months 10, 11, and 12.
In the main query, Join the CTE with skills_dim to get the skill names.
Group by the month and the skill name.
Count the mentions and sort them to see the top skills for each of those three months.
*/

WITH month_job_stats AS
(
    SELECT 
    skills_job_dim.skill_id,
    EXTRACT(YEAR FROM jpf.job_posted_date) as Year_posted,
    EXTRACT(MONTH FROM jpf.job_posted_date) as month_posted
FROM    
    skills_job_dim
INNER JOIN job_postings_fact as jpf ON jpf.job_id = skills_job_dim.job_id
WHERE   
    (EXTRACT(YEAR FROM jpf.job_posted_date) = 2023 AND EXTRACT(MONTH FROM jpf.job_posted_date) >= 10)
)

SELECT 
    sd.skills as skill_name,
    month_posted,
    Year_posted,
    count(*) as top_skills
FROM month_job_stats
INNER JOIN skills_dim as sd on sd.skill_id = month_job_stats.skill_id
GROUP BY
    skill_name,
    month_posted
order by
    month_posted,
    top_skills DESC

/*
Problem 6: The "Skill Pay Gap" Analysis
Goal: Identify which programming skills have the largest price difference between Senior and Junior roles.

The Task:
Create a CTE that joins job_postings_fact, skills_job_dim, and skills_dim.
Inside the CTE, use a CASE statement to label jobs as 'Senior' (if the title contains 'Senior', 'Lead', or 'Manager') 
or 'Junior/Mid' (all others).
Filter for skills where the type is 'programming' and the salary_year_avg is not NULL.
In your main query, calculate the average salary for 'Senior' and 'Junior/Mid' for each skill.
Calculate the difference (Senior Avg - Junior Avg) and sort by the largest gap.
*/

WITH skill_stats as (
SELECT
    sd.skills as skill_name,
    jpf.salary_year_avg as avg_yearly_salary,
    CASE 
        WHEN jpf.job_title LIKE '%Senior%' THEN 'Senior'
        WHEN jpf.job_title LIKE '%Lead%' THEN 'Senior'
        WHEN jpf.job_title LIKE '%Manager%' THEN 'Senior'
        ELSE 'Junior/mid'
    END AS seniority_level
FROM job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim as sd ON sd.skill_id = sjd.skill_id
WHERE 
    sd.type = 'programming' AND jpf.salary_year_avg IS NOT NULL
)

SELECT 
    skill_name,
    -- Calculate specific averages using CASE inside AVG
    ROUND(AVG(CASE WHEN seniority_level = 'Senior' THEN avg_yearly_salary END), 2) AS senior_avg_salary,
    ROUND(AVG(CASE WHEN seniority_level = 'Junior/Mid' THEN avg_yearly_salaryEND), 2) AS junior_avg_salary,
    -- Calculate the "Pay Gap"
    ROUND(
        AVG(CASE WHEN seniority_level = 'Senior' THEN avg_yearly_salary END) - 
        AVG(CASE WHEN seniority_level = 'Junior/Mid' THEN avg_yearly_salary END), 2
    ) AS pay_gap
FROM 
    skill_stats
GROUP BY 
    skill_name
HAVING 
    -- Ensure we have data for both categories to avoid NULL gaps
    AVG(CASE WHEN seniority_level = 'Senior' THEN avg_yearly_salary END) IS NOT NULL
    AND AVG(CASE WHEN seniority_level = 'Junior/Mid' THEN avg_yearly_salary END) IS NOT NULL
ORDER BY 
    pay_gap DESC;

/*
Problem 7: Identifying "Consistent" Top Employers
Goal: Find companies that posted at least one High-Paying job (>$150k) in every month of the last quarter of 2023 (Oct, Nov, Dec).

The Task:

Filter job_postings_fact for jobs where salary_year_avg > 150000 and the year is 2023.

Extract the Month from the posting date.

Group by company_id and count the number of unique months (10, 11, or 12) they posted in.

Use a HAVING clause to only keep companies where that count of unique months is exactly 3.

Join with company_dim to get the company names.
*/

SELECT 
    company_dim.company_id,
    name as company_name
FROM company_dim
INNER JOIN job_postings_fact as jpf ON jpf.company_id = company_dim.company_id
WHERE jpf.salary_year_avg > 150000 AND
    (EXTRACT(MONTH from jpf.job_posted_date) = 10 or EXTRACT(MONTH from jpf.job_posted_date) = 11 
        or EXTRACT(MONTH from jpf.job_posted_date)=12)
GROUP BY
    company_dim.company_id
HAVING(
    COUNT(DISTINCT EXTRACT(MONTH from jpf.job_posted_date)) = 3
)
ORDER BY
    company_name