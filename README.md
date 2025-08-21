# SQL Data Cleaning Project - Layoffs Dataset

## Overview
This project focuses on cleaning a **Layoffs Dataset** using SQL. This dataset contained duplicates, inconsistent text formats, null values, and unstructured dates. The goal was to transfer raw CSV file into clean, analysis-ready dataset. 

---

## Files in Repository 
- `layoffs.csv` - raw dataset (CSV fromat)
- `Project - data cleaning.sql` - SQL script with cleaning step
- `README.md` - Project documentation (this file)

---

## Data Cleaning Steps 
1. **Created a working copy of the dataset** to preserve the raw data
2. **Removed duplicates** using two methods:
- **Method 1 (CTE + ROW_NUMBER):**
Applied a window function with `ROW_NUMBER` inside Common Table Expression (CTE) to identify duplicate rows based on company, location, industry, layoffs, date, stage, and funding.
- **Method 2 (Create Table + ROW_NUMBER column):**
Created a new table (`layoffs_new2`) with an additional `row_num` column, inserted ranked rows using `ROW_NUMBER`, and deleted rows where `row_num > 1`
3. **Standardized text fields**:
- Trimmed extra spaces where needed.
- Unified industry labels (e.g., `Crypto`, `CryptoCurrency` → `Crypto`).
- Corrected country naming inconsistencies (`United States.` → `United States`).
4. **Formatted date field** by converting text to proper `DATE` type.
5. **Handled null or blank values**:
- Replaced blanks with `NULL`.
- Filled missing industries using company matches.
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were missing.
6. **Dropped temporary helper columns** (e.g., `row_num`).

---
## Conclusion:
This project successfully transformed a messy layoff dataset into cleaned, structured, and analysis-ready format usign SQL. 

