/*
Answer: What are the top skills based on salary?
Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROm job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25


/*

Big Data & Engineering Skills Drive the Highest Salaries – Tools like PySpark ($208K), Databricks, Scala, and cloud infrastructure skills show that top-paying “analyst” roles are heavily engineering-focused and work with large-scale data systems.

Machine Learning & Python Are Strong Salary Boosters – Skills like pandas, numpy, scikit-learn, DataRobot, and Watson indicate that analysts who can build models and work in ML environments earn significantly more than traditional reporting-focused analysts.

Modern Cloud + DevOps Environments Pay More – Kubernetes, Airflow, GCP, GitLab, and Bitbucket suggest that analysts embedded in production, automated, cloud-based workflows command higher salaries than those in traditional BI-only roles.
*/

