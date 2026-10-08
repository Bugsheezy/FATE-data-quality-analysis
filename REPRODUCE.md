# FATE Story 01 — Reproducing the Analysis

## Purpose

This guide explains how to set up a **new local copy** of FATE Story 01 — *The Exception* from the repository. It is a suggested reproducibility workflow, **not a claim that these were the exact original import steps**.

FATE is fictional. All included records are synthetic. Running the queries does not change production data.

## Requirements

- Microsoft SQL Server (a supported local edition; the original project used SQL Server 2025)
- SQL Server Management Studio (SSMS)
- Power BI Desktop (Windows) to open and refresh the `.pbix`
- Permission to create a local database and import CSV files

No employer or student systems are required. A reviewer who cannot run SQL Server can still inspect the SQL, Markdown documentation and dashboard screenshots.

## 1. Download the repository

On the repository home page, choose **Code → Download ZIP** and extract the archive to a folder on your computer. You should see:

```text
Data/
  Students.csv
  Enrolments.csv
  Exceptions.csv
  DQ_Rules.csv
SQL/
  FATE_SQL_Analysis.sql
PowerBI/
  FATE_Data_Quality_Analysis.pbix
Documentation/
Images/
README.md
```

Do not use real student data when reproducing this portfolio project.

## 2. Create an empty database

In SSMS, connect to your SQL Server instance and execute:

```sql
IF DB_ID(N'FATE_Analytics') IS NULL
    CREATE DATABASE FATE_Analytics;
GO
```

These instructions assume the database and tables are empty before import. **Do not re-import the same CSV files into tables that already contain data.**

## 3. Import the four CSV files

SSMS includes **Tasks → Import Flat File** (right-click the `FATE_Analytics` database). Repeat for each CSV:

| CSV source | Destination table | Expected rows |
|---|---|---:|
| `Data/Students.csv` | `dbo.Students` | 4,200 |
| `Data/Enrolments.csv` | `dbo.Enrolments` | 10,075 |
| `Data/Exceptions.csv` | `dbo.Exceptions` | 3,800 |
| `Data/DQ_Rules.csv` | `dbo.DQ_Rules` | 7 |

Use the first CSV row as column headers. Import into the **`dbo` schema**. Review the wizard's **Modify Columns** screen before completion; automatic type detection should not be assumed correct.

### Important type checks

- Keep **all identifiers as text** (for example `S000001`, `E0000001`, `X0000001`, `EX02`, `DQ02`, `P108`, `C08`). Do not remove leading zeros.
- Use SQL `date` types for `DateOfBirth`, `StartDate`, `ReportDate` and nullable `ResolvedDate`. Source CSV dates use ISO `YYYY-MM-DD` notation.
- Map `EmailPresent`, `PhonePresent` and `MigrationFlag` to boolean/`bit` if the import wizard recognises the CSV's `TRUE`/`FALSE` values. If your wizard does not support that conversion, import as text and convert deliberately before using the report. Do not assume the original PBIX will work with different column types.
- Keep `ResolvedDate` nullable; an empty date for an Open exception is intentional.
- Treat other status/category fields as text, with enough length to preserve full values.
- `DQ_Rules.csv` has headers **`Failure indicator`** and **`Business impact`**, with spaces. The data dictionary uses the forms `Failure_indicator` and `Business_impact`. Review the imported SQL column names and adjust them or the corresponding Power Query steps consistently if necessary.
- If the wizard cannot parse a file, inspect CSV encoding and quoting (the supplied CSVs use UTF-8 and include quoted text where needed). Avoid changing the underlying data to force an import.

The provided repository documents the logical relationships, but this wizard-based import does not necessarily create SQL primary/foreign-key constraints. The QA queries test the relevant reference relationships separately.

## 4. Verify the imported tables

Execute in SSMS:

```sql
USE FATE_Analytics;
GO
SELECT 'Students' AS TableName, COUNT(*) AS Records FROM dbo.Students
UNION ALL SELECT 'Enrolments', COUNT(*) FROM dbo.Enrolments
UNION ALL SELECT 'Exceptions', COUNT(*) FROM dbo.Exceptions
UNION ALL SELECT 'DQ_Rules', COUNT(*) FROM dbo.DQ_Rules;
```

Expected counts are 4,200, 10,075, 3,800 and 7 respectively. **Stop and correct import settings if these do not match.**

## 5. Reproduce the SQL investigation

Open `SQL/FATE_SQL_Analysis.sql` in SSMS, connect to the database, and run the sections one at a time. The script contains:

- Sections 1–4: diagnostic investigations (duplicate rates, withdrawal overlap, remediation status and reporting trends)
- Section 5: table-count checks (QA01–QA04)
- Section 6: reference and date checks (QA09–QA11)
- Section 7: exception-code/rule-ID matching (QA12)
- Section 8: remediation and student-reference checks (QA13–QA16)
- Section 9: exception-to-current-source reconciliation (QA17), if present in the checked-out version

The QA05–QA08 labels in the report refer to **successful execution** of diagnostic investigations, not independent proof of every analytical conclusion.

For the supplied dataset, QA17 identified **327 occurrences for review** across EX01, EX02, EX05 and EX06. These are **not confirmed errors**, and the source tables do not contain historical attribute snapshots needed to resolve them conclusively.

Consult `Documentation/Testing_and_QA.md` for the recorded test evidence and open verification items.

## 6. Open the Power BI report

Open `PowerBI/FATE_Data_Quality_Analysis.pbix` in Power BI Desktop. The file may still reference the original development SQL Server connection.

1. Go to **Home → Transform data → Data source settings**.
2. Select the SQL Server data source and choose **Change Source**, or open **Transform data** and edit the **Source** step for the affected queries.
3. Enter **your own SQL Server instance name** and database `FATE_Analytics`.
4. Supply authentication/permissions appropriate for your local SQL Server.
5. Select **Close & Apply**, then refresh the model.
6. Review the two report pages: **Data Quality Overview** and **Investigation & Root Cause**.

If any of the imported SQL column names or types differ from the original development database, adjust the imported schema or Power Query transformation consistently rather than deleting or rewriting analysis measures.

`ResolutionDays` is calculated during data preparation; it is not a column in the raw `Exceptions.csv`.

## 7. Validate the report

Use these checks as a starting point after a successful refresh:

| Indicator | Expected result |
|---|---:|
| Total enrolments | 10,075 |
| Exception occurrences | 3,800 |
| Affected enrolments | 2,723 |
| Affected students | 2,005 |
| Open exception occurrences | 1,305 |
| Open rate | 34.34% |
| Average resolution time (resolved exceptions) | About 9.5 days |

The project recorded agreement for selected dashboard figures. **Not every DAX measure has been independently reconciled against SQL**. A successful refresh and matching summary totals should not be represented as complete measure-level verification.

## 8. Limitations and interpretation

- The six reporting runs are synthetic. The final run contains 218 occurrences, substantially fewer than previous runs; this is **not evidence of successful improvement** without comparable reporting coverage.
- Multiple exception occurrences per affected enrolment do not by themselves prove an issue returned *after successful remediation*.
- QA17 compares past exception reports with currently stored enrolment fields. Historical changes, rule-applicability questions and exception classification differences cannot all be distinguished from these files alone.
- Root causes and proposed preventive controls remain hypotheses/recommendations, not demonstrated real-world operational outcomes.

For definitions and caveats, see `README.md`, `Documentation/Data_Quality_Rules.md`, and `Documentation/Process_Improvement.md`.
