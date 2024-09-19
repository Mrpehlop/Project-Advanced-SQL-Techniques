-- **Project: Comprehensive SQL Data Cleaning and Transformation**

-- **Section 1: Basic Data Retrieval and Transformation**

-- Retrieve and calculate additional data from employee demographics
SELECT first_name, 
       last_name, 
       birth_date,
       age,
       (age + 10) * 10 + 10 AS calculated_age
FROM parks_and_recreation.employee_demographics;

-- Retrieve distinct first names and genders
SELECT DISTINCT first_name, gender
FROM parks_and_recreation.employee_demographics;

-- Filter employee demographics based on birth year
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date LIKE '1989%';

-- Aggregate data by gender
SELECT gender, 
       AVG(age) AS average_age, 
       MAX(age) AS max_age, 
       MIN(age) AS min_age, 
       COUNT(age) AS count_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

-- Filter groups with average age greater than 40
SELECT gender, 
       AVG(age) AS average_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- Aggregate salary data for manager roles
SELECT occupation, 
       AVG(salary) AS average_salary
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- Paginate results to retrieve a specific record
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 2, 1;

-- Use alias for average age
SELECT gender, 
       AVG(age) AS avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- Join employee demographics with employee salary
SELECT dem.employee_id, 
       dem.age, 
       sal.occupation
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Right join employee demographics with employee salary
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id;

-- Self join to find consecutive employee records
SELECT emp1.employee_id AS emp_santa,
       emp1.first_name AS first_name_santa,
       emp1.last_name AS last_name_santa,
       emp2.employee_id AS emp_name,
       emp2.first_name AS first_name_emp,
       emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
    ON emp1.employee_id + 1 = emp2.employee_id;

-- Join multiple tables
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN employee_salary AS sal
    ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
    ON sal.dept_id = pd.department_id;

-- Union to combine distinct records from different tables
SELECT first_name, last_name
FROM parks_and_recreation.employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

-- Union with additional labels
SELECT first_name, last_name, 'old man' AS label
FROM parks_and_recreation.employee_demographics
WHERE age > 40 AND gender = 'male'
UNION
SELECT first_name, last_name, 'old lady' AS label
FROM parks_and_recreation.employee_demographics
WHERE age > 40 AND gender = 'female'
UNION
SELECT first_name, last_name, 'Highly paid employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

-- String functions
SELECT LENGTH('skyfall') AS length_of_skyfall;

SELECT first_name, LENGTH(first_name) AS name_length
FROM parks_and_recreation.employee_demographics
ORDER BY name_length;

SELECT UPPER('sky') AS upper_sky;
SELECT LOWER('sky') AS lower_sky;

SELECT first_name, UPPER(first_name) AS upper_first_name
FROM parks_and_recreation.employee_demographics;

SELECT TRIM('       sky          ') AS trimmed_sky;
SELECT LTRIM('       sky          ') AS left_trimmed_sky;
SELECT RTRIM('       sky          ') AS right_trimmed_sky;

-- Retrieve and clean data from employee demographics
SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT first_name, age, gender
FROM parks_and_recreation.employee_demographics
WHERE gender = 'female' AND age > 30;

SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age ASC;

-- Case statement to categorize ages
SELECT first_name, last_name, age,
       CASE 
           WHEN age <= 30 THEN 'young'
           WHEN age BETWEEN 31 AND 50 THEN 'LMOOT'
           WHEN age >= 50 THEN 'old'
       END AS age_bracket
FROM parks_and_recreation.employee_demographics;

-- Conditional salary updates
SELECT first_name, last_name, salary,
       CASE
           WHEN salary < 50000 THEN salary * 1.05
           WHEN salary >= 50000 THEN salary * 1.07
       END AS new_salary,
       CASE
           WHEN dept_id = 6 THEN salary * 0.10
           ELSE 0
       END AS bonus
FROM employee_salary;

-- Concatenate first and last names
SELECT first_name, last_name,
       CONCAT(first_name, ' ', last_name) AS full_name
FROM parks_and_recreation.employee_demographics;

-- Join product and sales tables
SELECT p.product_id, s.year, s.price
FROM product p
JOIN sales s
    ON p.product_id = s.product_id;

-- Aggregate salary data by gender after join
SELECT dem.gender, 
       AVG(sal.salary) AS average_salary, 
       MIN(sal.salary) AS min_salary, 
       COUNT(sal.salary) AS count_salary
FROM parks_and_recreation.employee_demographics dem
JOIN employee_salary sal
    ON dem.employee_id = sal.employee_id
GROUP BY dem.gender;

-- Subquery to include average salary
SELECT first_name, salary, 
       (SELECT AVG(salary) FROM employee_salary) AS avg_salary
FROM employee_salary
GROUP BY first_name, salary;

-- **Section 2: Data Cleaning and Transformation**

-- Retrieve records from the layoffs table
SELECT * FROM world_layoffs;

-- Retrieve records from the employee_demographics table
SELECT * FROM parks_and_recreation.employee_demographics;

-- Create a staging table for data cleaning
CREATE TABLE layoffs_staging LIKE layoffs;

-- Retrieve records from the staging table
SELECT * FROM layoffs_staging;

-- Insert data into the staging table
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Identify duplicates in the staging table
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
               stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Filter records by company
SELECT * FROM layoffs_staging WHERE company = 'Casper';

-- Create a final staging table with cleaned data
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` DATE,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert cleaned data into the new staging table
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
           stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Standardize data in the final staging table
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry names
UPDATE layoffs_staging2
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- Remove trailing periods from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert date format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Handle null and blank values
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Retrieve records from the cleaned staging table
SELECT * FROM layoffs_staging2;

-- Drop the row_num column from the final staging table
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
