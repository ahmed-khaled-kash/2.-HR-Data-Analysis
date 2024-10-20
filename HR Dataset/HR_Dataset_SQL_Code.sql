select * from uncleaned_hr_report$;

-- Remove rows with duplicate Employee IDs
DELETE FROM uncleaned_hr_report$
WHERE [Employee ID] IN (
    SELECT [Employee ID]
    FROM (
        SELECT [Employee ID], COUNT(*) AS count
        FROM uncleaned_hr_report$
        GROUP BY [Employee ID]
        HAVING COUNT(*) > 1
    ) AS duplicates
);

-- Fill missing genders with 'U' (Unknown)
UPDATE uncleaned_hr_report$
SET Gender = 'U'
WHERE Gender IS NULL;

-- Fill missing departments with 'Unknown'
UPDATE uncleaned_hr_report$
SET Department = 'Unknown'
WHERE Department IS NULL;

-- Fill missing performance ratings with 'Average'
UPDATE uncleaned_hr_report$
SET [Performance Rating] = 'Average'
WHERE [Performance Rating] IS NULL;

-- Remove rows with NULL Employee ID
DELETE FROM uncleaned_hr_report$
WHERE [Employee ID] IS NULL;

-- Updating DateOfBirth to 'YYYY-MM-DD' format
UPDATE uncleaned_hr_report$
SET [Date of Birth] = CONVERT(varchar(10), [Date of Birth], 23)
WHERE [Date of Birth] IS NOT NULL;

-- Updating Date of Hire to 'YYYY-MM-DD' format
UPDATE uncleaned_hr_report$
SET [Date of Hire] = CONVERT(varchar(10), [Date of Hire], 23)
WHERE [Date of Hire] IS NOT NULL;

-- Updating Last Promotion Date to 'YYYY-MM-DD' format
UPDATE uncleaned_hr_report$
SET [Last Promotion Date] = CONVERT(varchar(10), [Last Promotion Date], 23)
WHERE [Last Promotion Date] IS NOT NULL;

-- Standardize Gender to 'M' and 'F'
UPDATE uncleaned_hr_report$
SET Gender = 'M'
WHERE Gender IN ('Male', 'M');

UPDATE uncleaned_hr_report$
SET Gender = 'F'
WHERE Gender IN ('Female', 'F');

-- Standardize Department names
UPDATE uncleaned_hr_report$
SET Department = 'HR'
WHERE Department IN ('hr', 'Human Resources');

UPDATE uncleaned_hr_report$
SET Department = 'Finance'
WHERE Department IN ('finance', 'FIN');

-- Standardize Job Titles
UPDATE uncleaned_hr_report$
SET [Job Title] = 'Data Analyst'
WHERE [Job Title] LIKE '%Analyst%';

UPDATE uncleaned_hr_report$
SET [Job Title] = 'Software Engineer'
WHERE [Job Title] LIKE '%Engineer%';

-- Remove salary outliers (salaries below $10,000 or above $200,000)
DELETE FROM uncleaned_hr_report$
WHERE [Annual Salary] < 10000 OR [Annual Salary] > 200000;

-- Remove unrealistic years at company (negative values)
DELETE FROM uncleaned_hr_report$
WHERE [Years at Company] < 0;

-- Remove invalid email addresses (email without '@')
DELETE FROM uncleaned_hr_report$
WHERE Email NOT LIKE '%@%';

-- Remove invalid phone numbers (less than 10 digits)
UPDATE uncleaned_hr_report$
SET [Phone Number] = NULL
WHERE LEN(REPLACE([Phone Number], '-', '')) < 10;

-- Update YearsAtCompany based on DateOfHire and current year
UPDATE uncleaned_hr_report$
SET [Years at Company] = DATEDIFF(YEAR, [Date of Hire], GETDATE())
WHERE [Date of Hire] IS NOT NULL;

-- Check for any remaining null values
SELECT * FROM uncleaned_hr_report$
WHERE [Employee ID] IS NULL OR Gender IS NULL OR Department IS NULL;

-- Verify that no duplicate Employee IDs remain
SELECT [Employee ID], COUNT(*)
FROM uncleaned_hr_report$
GROUP BY [Employee ID]
HAVING COUNT(*) > 1;

-- Check for invalid dates or outliers in salaries
SELECT * FROM uncleaned_hr_report$
WHERE [Annual Salary] < 10000 OR [Annual Salary] > 200000;

