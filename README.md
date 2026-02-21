# Introduction
Dive into the data job market! Focusing on data
analyst roles, this project explores 💵 top-paying
jobs, 🔥in-demand skills, and 📈 where high demand
meets high salary in data analytics.

🔍SQL queries? Check them out here: [project_sql_folder](/project_sql/). ⏳

# Background
Driven by a quest to navigate the data analyst job
market more effectively, this project was born
from a desire to pinpoint top-paid and in-demand
skills, streamlining others work to find optimal
jobs.

Data hails from my [SQL COURSE](https://lukebarousse.com/sql). It's packed with insights
on job titles, salaries, locations, and essential
skills.

## The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying
jobs?
3. What skills are most in demand for data
analysts?
4. Which skills are associated with higher
salaries?
5. What are the most optimal skills to learn?

# Tools I Used

For my deep dive into the data analyst job market,
I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to
query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management
system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-tg for database
management and executing SQL queries.
- **Git & GitHub:** Essential for version control and
sharing my SQL scripts and analysis, ensuring
collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating
specific aspects of the data analyst job market.
Here's how I approached each question:

## 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles I filtered
data analyst positions by average yearly salary
and location, focusing on remote jobs. This query
highlights the high paying opportunities in the
field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM   
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs
in 2023:
- **Wide Salary Range :** Top 10 paying data
analyst roles span from $184,000 to $650,000,
indicating significant salary potential in the
field.
- **Diverse Employers :** Companies like
SmartAsset, Meta, and AT&T are among those
offering high salaries, showing a broad interest
across different industries.
- **Job Title Variety :** There's a high diversity
in job titles, from Data Analyst to Director of
Analytics, reflecting varied roles and
specializations within data analytics.

![Top Paying Roles](assets\1_top_paying_roles.png)

**Bar graph visualizing the salary for the top 10
salaries for data analysts; ChatGPT generated this
graph from my SQL query results**

## 2. Skills for Top Paying Jobs
To identify the highest-paying skills, I joined job postings with their associated skills and calculated the average yearly salary for each skill. I filtered for data analyst roles with defined salaries and ranked the skills by highest average pay. This query highlights which technical skills are most financially rewarding in the data analyst job market.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM   
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE   
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

Here's the breakdown of the most demanded skills for data analysts in 2023, based on job postings:
- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

![Top Paying Skills](assets\2_top_paying_skills.png)


## 3. In-demand skills for Data Analyst
To identify the most in-demand skills, I analyzed the frequency of skills listed across data analyst job postings. By joining job postings with their associated skills and counting occurrences, I ranked the skills based on how often they appear. This query highlights the technical skills employers are seeking most in the data analyst job market.

```sql
SELECT 
    skills,
    COUNT(job_postings_fact.job_id) as demand_count
FROm job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

### 🔎 Key Takeaways

- **SQL** is the most in-demand skill for Data Analysts.
- **Excel** remains a core business analysis tool.
- **Python** strengthens automation and advanced analytics capabilities.
- **Tableau** and **Power BI** are essential for data visualization and reporting.

| Rank | Skill     | Demand Count |
|------|----------|-------------|
| 1    | SQL      | 7,291       |
| 2    | Excel    | 4,611       |
| 3    | Python   | 4,330       |
| 4    | Tableau  | 3,745       |
| 5    | Power BI | 2,609       |

## 4. Top Paying skills for Data Analyst
To identify the highest-paying skills, I calculated the average yearly salary associated with each skill listed in data analyst job postings. By filtering for roles with specified salaries and grouping skills accordingly, I ranked them based on their average compensation. This query highlights which technical skills are associated with the highest earning potential in the data analyst job market.

```sql
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
```
### 📊 Breakdown of Top Paying Skills for Data Analysts (2023)

#### 🔥 High Demand for Big Data & Machine Learning Skills
Top salaries are commanded by analysts skilled in big data technologies (**PySpark, Couchbase**), machine learning tools (**DataRobot, Jupyter**), and Python libraries (**Pandas, NumPy**).  
This reflects the industry's strong valuation of advanced data processing and predictive modeling capabilities.

#### ⚙️ Software Development & Deployment Proficiency
Knowledge of development and deployment tools (**GitLab, Kubernetes, Airflow**) indicates a lucrative crossover between data analysis and data engineering.  
There is a premium on skills that support automation, CI/CD workflows, and efficient data pipeline management.

#### ☁️ Cloud Computing Expertise
Familiarity with cloud and data engineering platforms (**Elasticsearch, Databricks, GCP**) underscores the growing importance of cloud-based analytics environments.  
Cloud proficiency significantly boosts earning potential in modern data analytics roles.


| Skill          | Average Salary ($) |
|---------------|--------------------|
| PySpark      | 208,172            |
| Bitbucket    | 189,155            |
| Couchbase    | 160,515            |
| Watson       | 160,515            |
| DataRobot    | 155,486            |
| GitLab       | 154,500            |
| Swift        | 153,750            |
| Jupyter      | 152,777            |
| Pandas       | 151,821            |
| Elasticsearch| 145,000            |

---
## 💰 Top 10 Highest Paying Skills for Data Analysts (2023)



## 5. Optimal skills to learn to become a Data Analyst
To determine the most optimal skills to learn, I analyzed both skill demand and average salary data for data analyst roles. By combining frequency of job postings with compensation insights, I identified skills that offer strong market demand and high earning potential. This query highlights the most strategic skills to develop for maximizing career opportunities and salary growth in the data analyst field.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim. skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim. job_id
INNER JOIN skills_dim ON skills_job_dim. skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
### Breakdown of the Results for Top 10 Optimal Skills for Data Analysts (2023)

- **Strong Core Programming & Analytics Foundation:** The highest demand skills such as Python, R, and SAS show that employers continue to prioritize strong analytical programming capabilities. Python, in particular, dominates job postings, reflecting its versatility in data cleaning, automation, statistical analysis, and machine learning workflows. This indicates that solid programming skills remain the backbone of modern data analytics roles.

- **Business Intelligence & Data Visualization Strength:** High demand for Tableau and Looker demonstrates the importance of translating data into actionable business insights. Organizations value analysts who can not only extract data but also present it clearly through dashboards and reports that support strategic decision-making.

- **Cloud & Data Platform Proficiency:** Skills in Azure and AWS show that cloud computing knowledge significantly enhances earning potential. As companies increasingly migrate to cloud-based infrastructures, analysts who understand cloud data environments gain a competitive advantage in both employability and salary growth.

- **Modern Data Warehousing & Database Expertise:** Technologies such as Snowflake, Oracle, and SQL Server reflect the importance of working efficiently with structured enterprise data. Strong database knowledge enables analysts to optimize queries, manage large datasets, and collaborate effectively with data engineering teams.

| Skill        | Demand Count | Average Salary ($) |
|-------------|-------------|--------------------|
| Python      | 236         | 101,397            |
| Tableau     | 230         | 99,288             |
| R           | 148         | 100,499            |
| SAS         | 63          | 98,902             |
| Looker      | 49          | 103,795            |
| Snowflake   | 37          | 112,948            |
| Oracle      | 37          | 104,534            |
| SQL Server  | 35          | 97,786             |
| Azure       | 34          | 111,225            |
| AWS         | 32          | 108,317            |

## 🚀 Top 10 Optimal Skills to Learn for Data Analysts

# What I Learned

Throughout this adventure, I've turbocharged my
SQL toolkit with some serious firepower:

- **Complex Query Crafting :** Mastered the art
of advanced SQL, merging tables like a pro and
wielding WITH clauses for ninja-level temp table
maneuvers.
- **Data Aggregation :** Got cozy with GROUP BY
and turned aggregate functions like COUNT() and AVG
() into my data-summarizing sidekicks.
- **Analytical Wizardry :** Leveled up my
real-world puzzle-solving skills, turning
questions into actionable, insightful SQL queries.

# Conclusions

### Insights


1.**Top Paying Jobs**  
The highest-paying roles combine data analysis with cloud, engineering, and advanced technical expertise. Hybrid positions that go beyond reporting into infrastructure and scalable systems offer the strongest compensation growth.

2.**Top Paying Skills for Jobs**
Skills tied to big data, cloud platforms, and machine learning tools consistently drive higher salaries. Technical specialization significantly increases market value.

3.**In-Demand Skills**
Core tools such as Python, SQL, and data visualization platforms dominate job postings. Foundational analytics skills remain essential for entering and sustaining a data analyst career.

4.**Skills with High Salaries**  
Advanced technical skills, particularly in big data and cloud ecosystems, command premium pay. Infrastructure-related expertise generally earns more than basic reporting tools.

5.**Optimal Skills for Job Market Value**  
The most valuable skill set combines programming, visualization, cloud knowledge, and data warehousing. A balanced technical stack maximizes both employability and salary potential.

### Closing Thoughts.
This project enhanced my SQL skills and provided
valuable insights into the data analyst job
market. The findings from the analysis serve as a
guide to prioritizing skill development and job
search efforts. Aspiring data analysts can better
position themselves in a competitive job market by
focusing on high-demand, high-salary skills. This
exploration highlights the importance of
continuous learning and adaptation to emerging
trends in the field of data analytics