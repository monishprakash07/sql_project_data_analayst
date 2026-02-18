/*
Practice Problem 6
Create Tables from Other Tables
· Create three tables:
o Jan 2023 jobs
o Feb 2023 jobs
° Mar 2023 jobs
. Foreshadowing: This will be used in another practice problem below.
· Hints:
o Use CREATE TABLE table_name AS syntax to create your table
o Look at a way to filter out only specific months ( EXTRACT )
*/

-- January jobs
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February jobs
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March jobs
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

