SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;


SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date::DATE as DATE
FROM    job_postings_fact;


/*
::TIMESTAMP
*/
SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date AS date_time
FROM    job_postings_fact
LIMIT 5;

/*
TIMEZONE WITH TIMESTAMP - AT TIME ZONE KEYWORD TO CONVERT UTC TO EST
*/
SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time
FROM    job_postings_fact
LIMIT 5;

/*
EXTRACT KEYWORD - TO EXTRACT SPECIFIC KEY VALUE FROMT THE ACTUAL COLUMN
eg., extracting month value from the job_posted_date column
*/

SELECT 
    job_title_short as title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date_time,
    EXTRACT(MONTH FROM job_posted_date) as date_month,
    EXTRACT(YEAR FROM job_posted_date) as date_year
FROM    job_postings_fact
LIMIT 5;

