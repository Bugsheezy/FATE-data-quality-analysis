
# FATE | Reproduction and Setup Guide

## Enrolment Data Quality & Operational Improvement

This guide explains how to recreate the FATE analytical environment using the synthetic datasets, SQL scripts, Power BI report and validation evidence provided in this repository.

**FATE** stands for **Fictional Academy of Training and Education**.

The project demonstrates data analysis, data quality, reporting, business analysis, process improvement and quality assurance within a simulated vocational education organisation.

All data is synthetic. No real student, employer or organisational data is required.

> Reproducibility note: These instructions describe a recommended setup workflow. They have not yet been independently validated on a fresh SQL Server installation and should not be interpreted as a record of the exact original installation process.

---

# 1. Requirements

The following applications are required to reproduce the complete analytical environment.

| Application | Purpose |
|---|---|
| Microsoft SQL Server | Store and query the synthetic dataset |
| SQL Server Management Studio (SSMS) | Import data and execute T-SQL investigations |
| Power BI Desktop | Open the analytical report and validate DAX measures |
| Git or a web browser | Obtain the published repository files |

The original development environment used SQL Server 2025.

A compatible local SQL Server edition may also be used, provided the database schema and query functionality are supported.

You will need permission to create a database and import CSV files.

If SQL Server or Power BI Desktop is unavailable, the published SQL, DAX, documentation and report screenshots can still be reviewed directly on GitHub.

---

# 2. Download the Project

Open the repository:

https://github.com/Bugsheezy/FATE-data-quality-analysis

Select:

**Code → Download ZIP**

Extract the downloaded archive into a folder on your computer.

The project contains the following structure:

```text
FATE-data-quality-analysis/
|
|-- README.md
|-- REPRODUCE.md
|-- .gitignore
|
|-- Data/
|   |-- Students.csv
|   |-- Enrolments.csv
|   |-- Exceptions.csv
|   `-- DQ_Rules.csv
|
|-- Documentation/
|   |-- Data_Dictionary.md
|   |-- Data_Quality_Rules.md
|   |-- Process_Improvement.md
|   `-- Testing_and_QA.md
|
|-- Images/
|   |-- 01_Data_Quality_Overview.png
|   `-- 02_Investigation_Root_Cause.png
|
|-- PowerBI/
|   |-- FATE_Data_Quality_Analysis.pbix
|   `-- QA18_PowerBI_Reconciliation.dax
|
`-- SQL/
    |-- FATE_SQL_Analysis.sql
    `-- QA20_Reporting_Run_Coverage.sql
```

The CSV files contain the source data.

The SQL and DAX files contain executable analytical and validation queries.

The Power BI file contains the existing reporting solution.

The Markdown documents provide business context, rule definitions, testing evidence and proposed improvements.

---

# 3. Create the SQL Server Database

Open SQL Server Management Studio.

Connect to your local SQL Server instance.

Select **New Query** and execute:

```sql
IF DB_ID(N'FATE_Analytics') IS NULL
    CREATE DATABASE FATE_Analytics;
GO
```

The database will be created if it does not already exist.

Confirm that `FATE_Analytics` appears under Databases in Object Explorer.

**Important:** These instructions assume a new, empty database. Do not import the CSV files into an existing populated FATE database without first checking for duplicate records or conflicting table definitions.

---

# 4. Import the Synthetic Datasets

Four CSV files are provided.

| Source File | SQL Destination | Expected Records |
|---|---|---:|
| Data/Students.csv | dbo.Students | 4,200 |
| Data/Enrolments.csv | dbo.Enrolments | 10,075 |
| Data/Exceptions.csv | dbo.Exceptions | 3,800 |
| Data/DQ_Rules.csv | dbo.DQ_Rules | 7 |

## Import Procedure

In SSMS:

1. Expand **Databases**.
2. Right-click `FATE_Analytics`.
3. Select **Tasks → Import Flat File**.
4. Browse to the required CSV file.
5. Confirm the destination table name.
6. Review the detected columns and data types.
7. Complete the import.
8. Repeat for each remaining CSV file.

Ensure that:

- The first CSV row is interpreted as column headers.
- Tables are created in the `dbo` schema.
- Identifier fields remain text.
- Date fields use appropriate date types.
- Nullable fields are handled correctly.
- Imported column names remain compatible with the published SQL and Power BI model.

## Important Data-Type Considerations

### Identifiers

Identifiers must be preserved as text to retain their formatting and leading zeros.

Examples:

```text
StudentID       S001086
EnrolmentID     E0000001
ProductID       P108
CampusID        C08
ExceptionCode   EX02
```

Do not convert these fields to integers.

### Dates

The source CSV files use ISO-style dates.

Review these columns:

- DateOfBirth
- StartDate
- ReportDate
- ResolvedDate

Use appropriate SQL date types.

`ResolvedDate` must allow null values because unresolved exception occurrences do not necessarily have a resolution date.

### Boolean Indicators

The enrolment data contains fields such as:

- EmailPresent
- PhonePresent
- MigrationFlag

These may contain `TRUE` and `FALSE` values.

Where supported, use a compatible SQL `bit` representation.

If the import wizard cannot convert these values correctly, preserve them as text and apply a deliberate conversion strategy before connecting Power BI.

Ensure the final column definitions are compatible with the analytical queries.

### Data Quality Rule Columns

`DQ_Rules.csv` includes column headings containing spaces:

- `Failure indicator`
- `Business impact`

Some documentation uses underscore-separated forms.

Review the actual imported column names and ensure any SQL or Power Query references use the correct names.

### CSV Handling

The supplied CSV files use UTF-8 encoding.

If the import wizard reports parsing errors, review character encoding, quoted text, delimiters and date conversion settings.

Do not modify synthetic data values simply to suppress an import error.

**Note:** Importing CSV files does not necessarily establish SQL primary-key or foreign-key constraints. The published QA checks validate selected record relationships independently.

---

# 5. Verify Database Record Counts

After importing the four datasets, open a new SQL query and execute:

```sql
USE FATE_Analytics;
GO

SELECT
    'Students' AS TableName,
    COUNT(*) AS TotalRecords
FROM dbo.Students

UNION ALL

SELECT
    'Enrolments',
    COUNT(*)
FROM dbo.Enrolments

UNION ALL

SELECT
    'Exceptions',
    COUNT(*)
FROM dbo.Exceptions

UNION ALL

SELECT
    'DQ_Rules',
    COUNT(*)
FROM dbo.DQ_Rules;
```

## Expected Results

| Table | Expected Records |
|---|---:|
| Students | 4,200 |
| Enrolments | 10,075 |
| Exceptions | 3,800 |
| DQ_Rules | 7 |

All four totals should match the documented baseline.

If a count differs, investigate the import before proceeding.

Matching record counts alone does not establish that every imported column has the correct data type or value.

---

# 6. Execute the Primary SQL Analysis

Open the following file in SQL Server Management Studio:

`SQL/FATE_SQL_Analysis.sql`

Ensure the active database is `FATE_Analytics`.

The script contains nine numbered sections.

## Analytical Investigations

| Section | Investigation |
|---|---|
| 1 | Duplicate-affected enrolment rate by campus |
| 2 | Withdrawal/remediation overlap |
| 3 | Remediation performance by exception |
| 4 | Exception trends by reporting run |

These investigations examine how exceptions are distributed across enrolments, locations, statuses and reporting periods.

## Validation and Integrity Checks

| Section | Test Reference | Purpose |
|---|---|---|
| 5 | QA01–QA04 | Database record-count validation |
| 6 | QA09–QA11 | Referential integrity and resolution-date validation |
| 7 | QA12 | Data-quality rule coverage |
| 8 | QA13–QA16 | Remediation and record consistency |
| 9 | QA17 | Exception-to-source reconciliation |

Execute each section and review the results.

Successful execution demonstrates that a query runs without reported SQL errors.

It does not independently prove that every analytical assumption or business-rule interpretation is correct.

Detailed validation outcomes are recorded in:

[Testing and Quality Assurance](Documentation/Testing_and_QA.md)

---

# 7. Reproduce QA17 — Exception-to-Source Reconciliation

QA17 is included in Section 9 of:

`SQL/FATE_SQL_Analysis.sql`

The investigation compares recorded exception occurrences with currently stored enrolment attributes.

It examines four exception categories:

- EX01 — Incomplete Contact Details
- EX02 — Missing LMS Unit Link
- EX05 — Legacy Migration Mismatch
- EX06 — Fee/Product Validation

## Documented Results

| Validation | Result |
|---|---:|
| Exception occurrences examined | 2,679 |
| Occurrences flagged for review | 327 |
| Flagged occurrences with Open status | 116 |

Approximately 12.2% of the examined occurrences met at least one diagnostic condition requiring investigation.

**Recorded outcome: INVESTIGATION REQUIRED**

These findings represent potential inconsistencies, not confirmed errors.

The comparison relies on current enrolment attributes rather than historical attribute snapshots.

Business-rule clarification and additional historical evidence would be required to determine the validity of individual flagged occurrences.

No source records need to be modified to reproduce this investigation.

---

# 8. Open the Power BI Report

Open:

`PowerBI/FATE_Data_Quality_Analysis.pbix`

using Power BI Desktop.

The report contains two pages:

1. **Data Quality Overview**
2. **Investigation & Root Cause**

The existing Power BI project may reference the original development SQL Server instance.

You may need to update the database connection before refreshing.

## Reconnect the Data Source

In Power BI Desktop:

1. Select **Home → Transform data → Data source settings**.
2. Locate the SQL Server connection.
3. Select **Change Source**, if available.
4. Enter your local SQL Server instance name.
5. Use the database name `FATE_Analytics`.
6. Provide the appropriate authentication credentials.
7. Confirm the connection.
8. Select **Close & Apply**.
9. Refresh the report.

If Change Source is unavailable, open Power Query and review the Source step for each relevant query.

Ensure that the imported SQL columns and data types match the expectations of the existing transformations.

Do not delete existing Power BI measures or relationships simply to resolve a connection problem.

### Calculated Fields

The report uses a calculated `ResolutionDays` field prepared during data transformation.

This field is not part of the original raw Exceptions CSV and should not be expected in the source file.

---

# 9. Verify the Power BI Dashboard

Once the report refreshes, open **Data Quality Overview**.

Clear any active filters or selections that would restrict the displayed dataset.

## Expected Metrics

| Metric | Expected Value |
|---|---:|
| Total Enrolments | 10,075 |
| Affected Enrolments | 2,723 |
| Affected Rate | 27.03% |
| Total Exception Occurrences | 3,800 |
| Open Exceptions | 1,305 |
| Open Rate | 34.34% |
| Affected Students | 2,005 |
| Average Resolution Time | Approximately 9.5 days |

Also verify that the following charts display data:

- Affected Rate by Source System
- Open Rate by Exception Type
- Exception Volume by Type
- Exception Trend by Reporting Run

The second report page should also display its existing diagnostic charts and analytical findings.

A successful refresh and matching KPI totals provide evidence of consistency for the inspected results.

They do not establish that every Power Query transformation, DAX measure or analytical interpretation has been independently verified.

---

# 10. Reproduce QA18 — Power BI Reconciliation

Open the published file:

`PowerBI/QA18_PowerBI_Reconciliation.dax`

This query reproduces the validation of five principal Power BI metrics and four identifier-integrity checks.

## Execution

In Power BI Desktop:

1. Open the existing FATE Power BI project.
2. Select **DAX Query View**.
3. Create a new query.
4. Copy the contents of `QA18_PowerBI_Reconciliation.dax`.
5. Paste the query into the DAX editor.
6. Select **Run**.
7. Examine the resulting table.

This is a read-only DAX query.

It does not modify the model, source data or existing measures.

## Expected Results

| Validation | Expected |
|---|---:|
| Total Enrolments | 10,075 |
| Affected Enrolments | 2,723 |
| Affected Rate | 27.03% |
| Total Exception Occurrences | 3,800 |
| Open Exceptions | 1,305 |
| Total Enrolment Rows | 10,075 |
| Unique Enrolment IDs | 10,075 |
| Blank Enrolment IDs | 0 |
| Blank Exception Enrolment IDs | 0 |

Depending on formatting, Affected Rate may appear as a decimal of approximately `0.2703`, equivalent to 27.03%.

The recorded validation on 8 October 2026 returned the expected results.

**Recorded outcome: PASS**

The result confirms reconciliation for the tested metrics and identifier conditions.

It does not independently validate every measure in the Power BI model.

---

# 11. Reproduce QA19 — Power BI Refresh Verification

QA19 assessed whether the Power BI report could refresh locally without reported errors while retaining its expected KPI values.

## Recommended Procedure

1. Create a backup copy of the existing Power BI file.
2. Open the backup in Power BI Desktop.
3. Confirm the SQL Server data-source connection.
4. Select **Home → Refresh**.
5. Wait for the refresh to complete.
6. Review any errors or warnings.
7. Recheck the five principal KPI values.
8. Confirm the Overview page charts remain populated.

## Recorded Outcome

On 8 October 2026:

- A local backup copy of the report was used.
- Refresh was reported to have completed without errors.
- Five inspected KPI values remained consistent.
- Four Overview page charts remained populated.

**Recorded outcome: PASS**

The test establishes the observed behaviour of the inspected local Power BI report.

It does not verify scheduled Power BI Service refresh or the completeness of every upstream reporting run.

---

# 12. Reproduce QA20 — Reporting-Run Coverage Investigation

Open:

`SQL/QA20_Reporting_Run_Coverage.sql`

in SQL Server Management Studio.

Confirm that the active database is `FATE_Analytics`.

The script contains four read-only investigations.

| Section | Investigation |
|---|---|
| QA20.1 | Reporting-run trends and intervals |
| QA20.2 | Exception-category comparison |
| QA20.3 | Campus comparison |
| QA20.4 | Source-system comparison |

The analysis focuses on the final two reporting runs:

- 27 April 2026
- 11 May 2026

## Reporting-Run Results

| Reporting Date | Exception Occurrences |
|---|---:|
| 2 March 2026 | 614 |
| 16 March 2026 | 758 |
| 30 March 2026 | 743 |
| 13 April 2026 | 747 |
| 27 April 2026 | 720 |
| 11 May 2026 | 218 |

The final run recorded 502 fewer occurrences than the preceding run.

This represents a decline of 69.72%.

## Additional Findings

The investigation established that:

- Reporting intervals remained consistent at 14 days.
- All seven exception categories remained represented.
- All eight campuses remained represented.
- Both source systems remained represented.
- Every examined exception category and campus recorded a decline.
- Both source systems experienced approximately 70% reductions.

The source-system comparison returned:

| Source System | 27 April | 11 May | Change |
|---|---:|---:|---:|
| EBS Migrated | 201 | 61 | -69.65% |
| PeopleSoft | 519 | 157 | -69.75% |

## Interpretation

**Recorded outcome: INVESTIGATION REQUIRED**

The SQL results establish that a substantial decline occurred.

They do not establish whether the decline resulted from:

- Genuine reductions in data-quality problems.
- Incomplete reporting coverage.
- Changes in source-population size.
- Incomplete source extraction.
- Changes in exception detection rules.
- Other changes in the reporting process.

The comparison of campuses and source systems uses current enrolment attributes.

Additional execution logs, expected source-population counts and historical processing information would be required to determine the cause.

The decline must not be presented as confirmed operational improvement.

---

# 13. Review the Business Analysis and Process Recommendations

The repository includes supporting professional documentation.

| Document | Purpose |
|---|---|
| Data_Dictionary.md | Explains the dataset structure and field definitions |
| Data_Quality_Rules.md | Documents the data-quality rules |
| Process_Improvement.md | Records process analysis and proposed controls |
| Testing_and_QA.md | Records validation procedures, results and limitations |

The project recommendations address:

- Migration validation and reconciliation.
- Duplicate enrolment prevention.
- Withdrawal-status checks before remediation.
- Monitoring of repeated exception occurrences.
- Data ownership and escalation.
- Reporting-run completeness controls.
- Ongoing operational reporting.

These recommendations have not been demonstrated to produce real organisational improvements.

The project uses synthetic data, and proposed control effectiveness remains a future validation activity.

---

# 14. Expected Project Outputs

A successful reproduction of the analytical workflow should provide:

1. Four imported SQL Server tables matching the documented source counts.
2. Executable T-SQL diagnostic investigations.
3. Database integrity and data-quality validation outputs.
4. QA17 exception-to-source reconciliation results.
5. A connected and populated Power BI report.
6. DAX reconciliation and identifier-integrity results for QA18.
7. A locally refreshed Power BI report for QA19.
8. QA20 reporting-run comparison outputs.
9. Supporting documentation and analytical recommendations.

The purpose of reproduction is to demonstrate analytical consistency and provide an opportunity for independent inspection.

It is not to manufacture a successful test result or eliminate documented limitations.

---

# 15. Limitations

The following limitations apply.

### Synthetic Data

All records are fictional and do not represent actual operational performance.

### Environment Compatibility

SQL Server editions, data types, authentication and Power BI connection settings may vary across machines.

The import and setup workflow has not yet been independently validated on a fresh installation.

### Historical Attributes

The dataset does not provide complete historical enrolment-attribute snapshots for every exception reporting date.

This limits definitive interpretation of QA17 findings.

### Reporting Completeness

The project lacks sufficient historical reporting-run metadata to establish the completeness of the final reporting population.

QA20 remains unresolved.

### Analytical Interpretation

Multiple exception occurrences do not independently establish recurrence after successful remediation.

Observed associations do not independently prove root causes.

### Control Effectiveness

Recommended business-process changes and preventative controls have not been implemented and evaluated in an actual organisational environment.

---

# 16. Reproduction Checklist

Use this checklist when independently reproducing the project.

- [ ] Repository downloaded and extracted.
- [ ] SQL Server database created.
- [ ] Students.csv imported.
- [ ] Enrolments.csv imported.
- [ ] Exceptions.csv imported.
- [ ] DQ_Rules.csv imported.
- [ ] Source-table record counts validated.
- [ ] Primary SQL investigations executed.
- [ ] Referential-integrity checks reviewed.
- [ ] QA17 reconciliation executed and interpreted.
- [ ] Power BI report opened.
- [ ] Power BI source connection configured.
- [ ] Power BI report refreshed.
- [ ] Principal KPI values reconciled.
- [ ] QA18 DAX validation executed.
- [ ] QA19 refresh behaviour reviewed.
- [ ] QA20 reporting-run comparison executed.
- [ ] Outstanding risks and limitations reviewed.

Do not mark a step as completed unless it has actually been performed.

---

# 17. Supporting Resources

- [Main Project README](README.md)
- [SQL Analysis](SQL/FATE_SQL_Analysis.sql)
- [QA20 SQL Investigation](SQL/QA20_Reporting_Run_Coverage.sql)
- [Power BI Project](PowerBI/FATE_Data_Quality_Analysis.pbix)
- [QA18 DAX Validation](PowerBI/QA18_PowerBI_Reconciliation.dax)
- [Data Dictionary](Documentation/Data_Dictionary.md)
- [Data Quality Rules](Documentation/Data_Quality_Rules.md)
- [Process Improvement Analysis](Documentation/Process_Improvement.md)
- [Testing and Quality Assurance](Documentation/Testing_and_QA.md)

---

# 18. Disclaimer

FATE — Fictional Academy of Training and Education — is a synthetic professional portfolio project.

The datasets, investigations, analytical findings and proposed improvements were developed for learning and demonstration purposes.

AI-assisted tools supported aspects of development, technical learning, troubleshooting and documentation.

The project author remains responsible for executing and reviewing the analysis, validating findings and communicating limitations.

No real organisational or student data is included.
