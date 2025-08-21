-- SQL DATA CLEANING PROJECT – LAYOFFS DATASET

-- Goal: Clean the raw layoffs dataset for analysis
-- Steps:
--   1. Create working copy
--   2. Remove duplicates (2 methods)
--   3. Standardize text fields
--   4. Format dates
--   5. Handle null / blank values
--   6. Drop unnecessary columns


-- 1. CREATE A WORKING COPY OF THE RAW DATA
CREATE TABLE layoffs_new LIKE layoffs;

INSERT INTO layoffs_new
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_new;



-- 2. REMOVE DUPLICATES

-- Method 1: Using CTE + ROW_NUMBER

WITH duplicate_CTE AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_new
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;   -- duplicate candidates

-- (Rows identified above can be deleted if needed)


-- Method 2: Create New Table + ROW_NUMBER Column

CREATE TABLE layoffs_new2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);

INSERT INTO layoffs_new2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry,
                        total_laid_off, percentage_laid_off,
                        `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_new;

-- Delete duplicate rows
DELETE
FROM layoffs_new2
WHERE row_num > 1;

SELECT * 
FROM layoffs_new2;   -- duplicates removed



-- 3. STANDARDIZE TEXT FIELDS

-- Trim spaces in company names
UPDATE layoffs_new2
SET company = TRIM(company);

-- Standardize industry names
UPDATE layoffs_new2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize country names
UPDATE layoffs_new2
SET country = 'United States'
WHERE country LIKE 'United States%';



-- 4. FORMAT DATE FIELD

-- Convert text to DATE type
UPDATE layoffs_new2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_new2
MODIFY COLUMN `date` DATE;



-- 5. HANDLE NULL OR BLANK VALUES

-- Replace blank industries with NULL
UPDATE layoffs_new2
SET industry = NULL
WHERE industry = '';

-- Fill missing industries using company matches
UPDATE layoffs_new2 t1
JOIN layoffs_new2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Delete rows with both layoffs and percentage missing
DELETE
FROM layoffs_new2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;



-- 6. DROP UNNECESSARY COLUMNS

ALTER TABLE layoffs_new2
DROP COLUMN row_num;



-- ==============================================
-- CLEANED DATASET READY FOR ANALYSIS
-- Final Table: layoffs_new2
-- ==============================================
SELECT * FROM layoffs_new2;
