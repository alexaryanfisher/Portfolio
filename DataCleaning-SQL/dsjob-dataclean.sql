/*Data Cleaning within SQL

The dataset used for this project was found within the Kaggle datasets called Data Science Jobs in Glassdoor.
Two different datasets were included within the file, but only the uncleaned data was utilized to show the various ways to clean the data.

The original data included a total of 15 columns and a total of 672 records.
The columns were noted as follows:

Index: Unique identifier
Job Title: Title of the job posting.
Salary Estimate: Salary range for the noted position.
Job Description: Full description of the job posting within Glassdoor.
Rating: Rating of the job posting.
Company: Name of the company hiring.
Location: Location of where the position will be based.
Headquarters: Location of the company's headquarters.
Size: Size of the company by total number of employees.
Ownership: Describes the company type
Founded: The year the company was Founded
Industry: Describes the industry field the position is within.
Sector: Describes the sector of industry field the position is within.
Revenue: Total Revenue of the Company
Competitors: Competitor companies within the same industry.

The Data Cleaning Steps included correcting column formatting, updating missing values, removing duplicates, and dropping unneeded columns.
*/


--- Viewing Original Data to review the information found within.

SELECT *
FROM public.dsjobs;

--- Updating and correcting job titles to be more uniform for the main Data Science Jobs such as Data Scientist, Data Analyst, Data Engineer, and Machine Learning positions.

UPDATE public.dsjobs
SET job_title = 'Data Scientist'
WHERE job_title LIKE '%Data Scientist%';

UPDATE public.dsjobs
SET job_title ='Machine Learning Scientist'
WHERE job_title LIKE '%Machine Learning Scientist%' OR job_title LIKE '%Scientist - Machine Learning%';

UPDATE public.dsjobs
SET job_title = 'Data Analyst'
WHERE job_title LIKE '%Data Analyst%';

UPDATE public.dsjobs
SET job_title = 'Data Engineer'
WHERE job_title LIKE '%Data Engineer%' OR job_title LIKE '%Data Analytics Engineer%';

UPDATE public.dsjobs
SET job_title = 'Machine Learning Engineer'
WHERE job_title LIKE '%Machine Learning Engineer%';

UPDATE public.dsjobs
SET job_title = 'Other'
WHERE job_title NOT LIKE '%Data Scientist%' AND job_title NOT LIKE '%Machine Learning Engineer%'AND job_title NOT LIKE '%Machine Learning Scientist%'  AND job_title NOT LIKE '%Data Engineer%' AND job_title NOT LIKE '%Data Analyst%';

--- Show Unique Job Titles

SELECT DISTINCT job_title
FROM public.dsjobs
ORDER BY job_title;

--- Counting the different job titles

SELECT job_title, count(*)
FROM public.dsjobs
GROUP BY job_title
HAVING count(*) > 1
ORDER BY count(*) desc;

--- Adding state abbreviation for New Jersey

UPDATE public.dsjobs
SET location = 'New Jersey, NJ'
WHERE location = 'New Jersey';

--Splitting the Salary Column into two different columns to capture the starting and ending salary range for the posted position.

---First, Create a new column for the new variables.

ALTER TABLE public.dsjobs
ADD COLUMN salary_start character varying COLLATE pg_catalog."default",
ADD COLUMN salary_end character varying COLLATE pg_catalog."default";

--- Next, Update the values with the split data.

UPDATE public.dsjobs
SET salary_start = SPLIT_PART(salary, '-', 1),
	salary_end = TRIM(SPLIT_PART(salary, '-', 2), '(Glassdoor est.)');

--- Converting index, rating, and salary formats to numeric

ALTER TABLE public.dsjobs
ALTER COLUMN index TYPE NUMERIC USING
TO_NUMBER(index, '999'),
ALTER COLUMN rating TYPE NUMERIC USING
TO_NUMBER(rating, '999D9'),
ALTER COLUMN salary_start TYPE NUMERIC USING
TO_NUMBER(salary_start, '999999') * 1000,
ALTER COLUMN salary_end TYPE NUMERIC USING
TO_NUMBER(salary_end, '999999') * 1000

--Splitting the location column into another column to capture the location state for the posted position.
	
--- Create a new column for the new variable, location_state.

ALTER TABLE public.dsjobs
ADD COLUMN location_state character varying COLLATE pg_catalog."default"

--- Update the values with the split data.

UPDATE public.dsjobs
SET location_state = SPLIT_PART(location, ',',2);

SELECT * FROM public.dsjobs;

--- Moving unneeded columns into another table. It's always best practice not to delete data from tables. I decided to move the unneeded variables to another table if needed again they can be joined to this table in the future.

--- Declaring the additional table---

CREATE TABLE temp_dsjobs(
    job_description character varying,
    salary character varying,
    competitors character varying,
    founded  numeric,
    industry character varying,
    revenue character varying)
 
--- Copying data into the additional table---

    INSERT INTO temp_dsjobs
	SELECT job_description, salary, competitors, founded, industry, revenue
	FROM public.dsjobs;

SELECT * FROM temp_dsjobs;

--- Removing moved columns from the original table

ALTER TABLE public.dsjobs
DROP COLUMN job_description,
DROP COLUMN salary,
DROP COLUMN competitors,
DROP COLUMN founded,
DROP COLUMN industry,
DROP COLUMN revenue;

SELECT * FROM dsjobs;

--- Fill Unknown/Null Values, Null values within this Dataset were noted as a -1 or blank value.

UPDATE public.dsjobs
SET rating = '0'
WHERE rating = '-1';

UPDATE public.dsjobs
SET headquarters = 'Unknown'
WHERE headquarters = '-1';

UPDATE public.dsjobs
SET ownership = 'Unknown'
WHERE ownership = '-1';

UPDATE public.dsjobs
SET sector = 'Unknown'
WHERE sector = '-1';

UPDATE public.dsjobs
SET size = 'Unknown'
WHERE size = '-1';

UPDATE public.dsjobs
SET location_state = 'Other'
WHERE location_state = '';

---Remove Duplicates with the use of a CTE

WITH cte AS(
		SELECT *,
			ROW_NUMBER() OVER(
			PARTITION BY job_title,
				rating,
				headquarters,
				company,
				sector,
				location,
				salary_end,
				salary_start
				ORDER BY 
					index
					) AS row_num
		FROM public.dsjobs
	)
	DELETE 
	FROM dsjobs
	WHERE index IN (SELECT index from cte WHERE row_num <> 1);

--- Final Cleaned Dataset. Containing a total of 12 columns and 654 rows.

SELECT * FROM public.dsjobs;
