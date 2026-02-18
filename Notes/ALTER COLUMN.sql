/*
RENAME COLUMN NAME
*/

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;


/*
ALTER COLUMN NAME
*/

ALTER TABLE job_applied 
ALTER COLUMN contact_name TYPE TEXT;


/*
DROP COLUMN NAME
*/
ALTER TABLE job_applied 
DROP COLUMN contact_name;


SELECT *
FROM job_applied;