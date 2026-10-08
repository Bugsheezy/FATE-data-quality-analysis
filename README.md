
# FATE | Enrolment Data Quality & Operational Improvement

A professional data analysis and business improvement portfolio project developed around **FATE — Fictional Academy of Training and Education**, a synthetic statewide vocational education provider.

The project investigates enrolment data-quality exceptions, evaluates operational risks, identifies patterns requiring further investigation and develops evidence-based recommendations for improving data quality and administrative processes.

It demonstrates an integrated analytical workflow using:

- Microsoft SQL Server and T-SQL
- Power Query
- Power BI and DAX
- Data analysis and visualisation
- Data quality and governance
- Root-cause assessment
- Business analysis
- Process improvement
- Testing and quality assurance

> **Data disclosure:** FATE is a fictional organisation. All students, enrolments, campuses, systems and exception records are synthetic. No real organisational or student information is used.

---

## 1. Project Overview

FATE operates as a fictional vocational education provider with multiple campuses, regions, faculties and student administration processes.

Within this simulated environment, enrolment data-quality exceptions create potential administrative workload, reporting uncertainty and downstream operational risks.

Exception records may involve incomplete information, duplicate enrolments, missing learning-management-system links, migration-related inconsistencies, fee/product validation problems or conflicts with enrolment withdrawal processes.

Although operational teams can remediate individual records, correcting exceptions one at a time does not necessarily address the conditions that produce them.

This project examines the available evidence to identify where further investigation, improved controls and process changes may be justified.

### Business Objectives

The analysis aims to:

1. Establish the scale of enrolment data-quality issues.
2. Identify exception categories generating substantial workload.
3. Compare exception exposure across campuses, regions and source systems.
4. Investigate multiple exception occurrences affecting the same enrolments.
5. Identify patterns that may indicate broader process or system weaknesses.
6. Assess remediation workload and operational risks.
7. Develop practical recommendations for preventative controls.
8. Validate analytical outputs and document unresolved data-quality risks.

The objective is not simply to identify incorrect records, but to demonstrate how data can support better operational decisions.

---

## 2. Business Questions

The investigation addresses six central questions.

**1. How significant is the data-quality problem?**

Determine the number of enrolments affected, total exception occurrences and proportion of unresolved issues.

**2. Where are exceptions concentrated?**

Compare exception categories, campuses, regions, source systems and enrolment characteristics.

**3. Are some enrolments affected by multiple exception occurrences?**

Examine occurrence frequency and identify potential repeat-processing or monitoring risks.

**4. Which patterns warrant deeper investigation?**

Distinguish isolated record problems from patterns that may indicate process or system-level weaknesses.

**5. What are the potential operational consequences?**

Consider remediation workload, delays, reporting reliability and unnecessary administrative effort.

**6. What improvements should be considered?**

Develop evidence-based recommendations for validation, monitoring, governance and administrative processes.

---

## 3. Tools and Capabilities

| Area | Tools and Techniques |
|---|---|
| Database | Microsoft SQL Server |
| Data querying | T-SQL |
| Data preparation | Power Query |
| Analytical modelling | Relational data modelling |
| Data analysis | SQL, DAX and Power BI |
| Data visualisation | Power BI reports and dashboards |
| Data quality | Completeness, uniqueness, validity and consistency |
| Investigation | Segmentation, aggregation, comparative rates and exception analysis |
| Business analysis | Business questions, operational risks and requirements |
| Process improvement | Root-cause assessment and recommended controls |
| Data governance | Business rules, ownership, monitoring and escalation |
| Testing and QA | SQL validation, DAX reconciliation and refresh verification |
| Version control | Git and GitHub |
| Documentation | Data dictionary, rule catalogue, QA report and reproduction guide |

Each tool serves a specific analytical or business purpose rather than being included solely as a technical demonstration.

---

## 4. Synthetic Dataset

The analysis uses a synthetic dataset designed to reflect realistic enrolment administration and data-quality conditions.

### Dataset Summary

| Dataset | Records |
|---|---:|
| Students | 4,200 |
| Enrolments | 10,075 |
| Exception occurrences | 3,800 |
| Data-quality rules | 7 |
| Reporting runs | 6 |

The dataset includes multiple fictional campuses, regions, faculties, study modes and student administration systems.

### Main Tables

**Students**

Contains student-level information, including:

- Student identifier
- Date of birth
- Home region
- Residency information

**Enrolments**

Contains enrolment-level attributes, including:

- Enrolment identifier
- Student identifier
- Campus and region
- Faculty
- Qualification and product
- Study mode
- Source system
- Enrolment status
- Contact-information indicators
- LMS unit-link status
- Fee/product validation status
- Migration indicator

**Exceptions**

Contains recorded data-quality exception occurrences, including:

- Exception occurrence identifier
- Enrolment identifier
- Student identifier
- Exception code and description
- Data-quality dimension
- Severity
- Reporting date
- Remediation status
- Resolution date
- Remediation action

**DQ_Rules**

Provides the business-rule reference information used to interpret and validate recorded exceptions.

It includes:

- Rule identifier
- Data-quality dimension
- Rule definition
- Failure conditions
- Potential business impact

The complete field definitions are available in the [Data Dictionary](Documentation/Data_Dictionary.md).

The rules are documented in the [Data Quality Rules Catalogue](Documentation/Data_Quality_Rules.md).

---

## 5. Analytical Architecture

FATE combines database investigation, analytical modelling, reporting and business improvement assessment.

```text
Synthetic Source Data
         |
         v
    SQL Server
         |
         +---- T-SQL Investigation
         |          |
         |          v
         |    Data Quality Validation
         |
         +---- Power Query
                    |
                    v
             Power BI Model
                    |
                    v
                DAX Measures
                    |
                    v
          Analytical Dashboards
                    |
                    v
          Findings and Insights
                    |
                    v
          Root-Cause Assessment
                    |
                    v
         Recommended Improvements
```

### Relational Data Model

The principal analytical relationships follow this structure:

```text
Students
   |
   | One-to-Many
   v
Enrolments
   |
   | One-to-Many
   v
Exceptions
```

`DQ_Rules` is maintained as a separate governance and reference table.

This structure supports analysis at different levels, including:

- Individual students
- Enrolments
- Exception occurrences
- Exception categories
- Campuses and regions
- Source systems
- Reporting periods

An important distinction is maintained between **exception occurrences** and **unique affected enrolments**, because one enrolment may have multiple recorded exceptions.

---

## 6. Data Preparation and Modelling

Power Query was used to prepare the SQL Server data for reporting and analysis.

Preparation activities included:

- Reviewing and assigning appropriate column data types.
- Applying Australian date interpretation.
- Standardising student and enrolment identifiers.
- Preserving null resolution dates for unresolved exceptions.
- Creating the `ResolutionDays` field.
- Checking relational identifiers.
- Preparing data for the Power BI model.

Examples of synthetic identifiers include:

```text
StudentID      S001086
EnrolmentID    E0000001
ProductID      P108
CampusID       C08
```

Additional SQL validation was performed to check relationships between students, enrolments and exceptions.

The resulting data model supports reusable DAX measures and comparative reporting.

---

## 7. SQL Analysis

T-SQL was used to investigate exception patterns, compare operational risks and validate the underlying data.

### Published Analytical Investigations

The primary SQL script contains four diagnostic investigations.

| Investigation | Analytical Purpose |
|---|---|
| Duplicate rate by campus | Identify campuses with higher proportions of duplicate-affected enrolments |
| Withdrawal/remediation overlap | Compare withdrawal-related exceptions across enrolment statuses |
| Remediation performance | Assess open exception workload and resolution times |
| Exception trends by reporting run | Examine exception volumes and unresolved workload across reporting periods |

The script also includes database record-count validation, referential-integrity checks, business-rule consistency checks and exception-to-source reconciliation.

### SQL Techniques Demonstrated

- `INNER JOIN`
- `LEFT JOIN`
- Common Table Expressions (CTEs)
- `COUNT` and `COUNT(DISTINCT)`
- `CASE` expressions
- Conditional aggregation
- Percentage and rate calculations
- `DATEDIFF`
- Null handling
- Referential-integrity validation
- Business-rule validation

**Published SQL evidence:**

[View FATE SQL Analysis](SQL/FATE_SQL_Analysis.sql)

A separate QA20 SQL script documents the reporting-run coverage investigation.

[View QA20 Reporting-Run Coverage Investigation](SQL/QA20_Reporting_Run_Coverage.sql)

---

# 8. Key Analytical Findings

## 8.1 More Than One Quarter of Enrolments Were Affected

The dataset contains **10,075 enrolments**, of which **2,723** experienced at least one recorded exception.

| Metric | Result |
|---|---:|
| Total enrolments | 10,075 |
| Affected enrolments | 2,723 |
| Affected enrolment rate | 27.03% |
| Affected students | 2,005 |

**Finding:** Data-quality exceptions affected approximately 27% of enrolments.

This demonstrates the scale of the issue within the simulated organisation.

---

## 8.2 A Substantial Remediation Backlog Remained

The exception dataset contains 3,800 recorded occurrences.

| Metric | Result |
|---|---:|
| Total exception occurrences | 3,800 |
| Resolved occurrences | 2,495 |
| Open occurrences | 1,305 |
| Open rate | 34.34% |
| Average resolution time | Approximately 9.5 days |

**Finding:** More than one-third of recorded exception occurrences remained open.

This represents a substantial potential workload for administrative remediation processes.

---

## 8.3 Fee/Product Validation Generated the Highest Exception Volume

Exception occurrences were distributed across seven categories.

| Exception Type | Occurrences | Affected Enrolments |
|---|---:|---:|
| Fee/Product Validation | 867 | 748 |
| Incomplete Contact Details | 762 | 666 |
| Missing LMS Unit Link | 619 | 381 |
| Legacy Migration Mismatch | 431 | 277 |
| Incomplete Enrolment | 425 | 385 |
| Potential Duplicate Enrolment | 350 | 303 |
| Withdrawal / Remediation Overlap | 346 | 294 |
| **Total Occurrences** | **3,800** | |

Fee/Product Validation accounted for the largest volume of exception occurrences.

However, exception volume alone does not establish which category creates the greatest systemic or operational risk.

---

## 8.4 LMS Linkage and Migration Issues Had Higher Occurrence Frequency

The analysis compared recorded exception occurrences with the number of distinct enrolments affected by each category.

| Exception Type | Occurrences per Affected Enrolment |
|---|---:|
| Missing LMS Unit Link | 1.62 |
| Legacy Migration Mismatch | 1.56 |
| Withdrawal / Remediation Overlap | 1.18 |
| Fee/Product Validation | 1.16 |
| Potential Duplicate Enrolment | 1.16 |
| Incomplete Contact Details | 1.14 |
| Incomplete Enrolment | 1.10 |

**Finding:** Missing LMS Unit Link and Legacy Migration Mismatch had the highest occurrence-to-affected-enrolment ratios.

These results justify further investigation into repeated exception occurrences.

They do not independently prove that previously resolved exceptions reoccurred or establish a specific systemic cause.

---

## 8.5 Migrated Enrolments Had Higher Exception Exposure

Affected-enrolment rates differed between the two source systems.

| Source System | Affected Rate |
|---|---:|
| EBS Migrated | 35.34% |
| PeopleSoft | 25.16% |

Migrated enrolments had an affected rate approximately 10.2 percentage points higher than PeopleSoft enrolments.

**Finding:** The observed difference suggests that migrated records warrant additional investigation and potentially more targeted validation controls.

The results do not independently prove that migration processes caused the exceptions.

---

## 8.6 Migration Mismatches Were Concentrated Geographically

Migration mismatch rates were compared across regions.

| Region | Migration Mismatch Rate |
|---|---:|
| Western | 17.36% |
| Coastal | 12.47% |
| Northern | 11.47% |
| Central | 8.22% |

The Western region recorded the highest observed rate.

**Finding:** The regional difference supports prioritising further investigation into migration validation, data transformation and source-record consistency.

The underlying cause remains a hypothesis until additional process or technical evidence is available.

---

## 8.7 Duplicate Enrolment Risk Varied by Campus

Duplicate-affected enrolment rates were compared across campuses.

| Campus | Duplicate-Affected Rate |
|---|---:|
| Harbour City | 6.56% |
| Metro South | 5.25% |
| Riverbend | 2.37% |
| Highland | 2.31% |
| Greenfield | 2.22% |

Harbour City and Metro South recorded noticeably higher rates than the other listed campuses.

**Finding:** The concentration supports further review of local enrolment creation practices, duplicate-prevention controls and administrative workflows.

---

## 8.8 Withdrawal and Remediation Overlap Indicated a Workflow Risk

Withdrawal-related exception rates were compared across enrolment statuses.

| Enrolment Status | Overlap Rate |
|---|---:|
| Withdrawn | 15.82% |
| Completed | 0.33% |
| Active | 0.32% |
| Pending | 0.12% |

Withdrawn enrolments had a substantially higher overlap rate.

**Finding:** The relationship suggests a potential process-control risk when exception remediation and enrolment withdrawal activities intersect.

The available data does not establish the chronological order of withdrawal and remediation activities.

Additional lifecycle timestamps or process evidence would be needed to determine whether remediation continued unnecessarily after withdrawal began.

---

# 9. Power BI Reporting

Two Power BI report pages were developed to communicate analytical results and support further investigation.

## Report 1 — Data Quality Overview

The first report provides a management-level view of enrolment data quality.

It includes:

- Total enrolments
- Affected enrolments and students
- Total exception occurrences
- Open exception workload
- Affected and open rates
- Average resolution time
- Affected rate by source system
- Open rate by exception type
- Exception volume by category
- Exception trends by reporting run

![FATE Data Quality Overview](Images/01_Data_Quality_Overview.png)

## Report 2 — Investigation & Root Cause

The second report focuses on patterns that warrant further investigation.

It includes:

- Migration mismatch rates by region
- Duplicate-affected rates by campus
- Withdrawal/remediation overlap by enrolment status
- Exception occurrences per affected enrolment
- Analytical findings
- Recommended preventative controls

![FATE Investigation and Root Cause](Images/02_Investigation_Root_Cause.png)

### Power BI Project File

[View Power BI Project](PowerBI/FATE_Data_Quality_Analysis.pbix)

The report contains reusable DAX measures, relational modelling and visualisations intended to support both management reporting and diagnostic analysis.

The displayed metrics were subsequently reviewed through QA18 and QA19.

---

# 10. Testing and Quality Assurance

Testing and validation form an important part of the project.

The purpose is to distinguish successful query execution from reliable analytical results and to identify assumptions or limitations that require further investigation.

Testing activities were documented on **8 October 2026**.

## QA Summary

| Test Reference | Validation Area | Outcome |
|---|---|---|
| QA01–QA04 | Database record-count validation | PASS |
| QA05–QA08 | SQL investigation execution | EXECUTED |
| QA09–QA11 | Referential integrity and resolution-date checks | PASS |
| QA12–QA16 | Data-quality rules and record consistency | PASS |
| QA17 | Exception-to-source reconciliation | INVESTIGATION REQUIRED |
| QA18 | SQL-to-Power BI reconciliation and identifier checks | PASS |
| QA19 | Local Power BI refresh verification | PASS |
| QA20 | Reporting-run coverage investigation | INVESTIGATION REQUIRED |

The completed tests provide evidence for the specific calculations and integrity conditions examined.

They do not establish that the entire analytical solution is free of errors or that all underlying business rules have been independently validated.

**Complete QA documentation:**

[Testing and Quality Assurance Report](Documentation/Testing_and_QA.md)

---

## QA17 — Exception-to-Source Reconciliation

QA17 compared selected recorded exceptions with currently stored enrolment attributes.

The investigation focused on four exception categories.

| Exception | Occurrences Examined | Flagged for Review | Flagged and Open |
|---|---:|---:|---:|
| EX01 — Incomplete Contact Details | 762 | 46 | 14 |
| EX02 — Missing LMS Unit Link | 619 | 193 | 72 |
| EX05 — Legacy Migration Mismatch | 431 | 48 | 12 |
| EX06 — Fee/Product Validation | 867 | 40 | 18 |
| **Total** | **2,679** | **327** | **116** |

**Result: INVESTIGATION REQUIRED**

Of the 2,679 occurrences examined, 327 (12.2%) met diagnostic conditions requiring further investigation.

These findings represent potential inconsistencies rather than confirmed data errors.

### Key Observations

- EX02 accounted for the largest number of flagged occurrences.
- Some open exceptions were associated with current enrolment attributes that no longer indicated the recorded issue.
- Historical enrolment-attribute snapshots were not available for each reporting date.
- The EX02 rule requires clarification regarding LMS requirements for different study modes.

Historical exceptions may have been valid when recorded, even if current attributes no longer show the original condition.

QA17 therefore remains an investigation rather than a completed correction exercise.

[View QA17 SQL Investigation](SQL/FATE_SQL_Analysis.sql)

---

## QA18 — SQL-to-Power BI Reconciliation

QA18 compared the existing Power BI measures with documented SQL baseline values.

### Metric Reconciliation

| Metric | SQL Baseline | Power BI Result | Outcome |
|---|---:|---:|---|
| Total Enrolments | 10,075 | 10,075 | PASS |
| Affected Enrolments | 2,723 | 2,723 | PASS |
| Affected Rate | 27.03% | 27.03% | PASS |
| Total Exception Occurrences | 3,800 | 3,800 | PASS |
| Open Exceptions | 1,305 | 1,305 | PASS |

The underlying DAX measures were reviewed.

### Additional Integrity Validation

A read-only DAX query was executed in Power BI Desktop.

| Check | Actual | Outcome |
|---|---:|---|
| Total enrolment rows | 10,075 | PASS |
| Unique enrolment IDs | 10,075 | PASS |
| Blank enrolment IDs | 0 | PASS |
| Blank exception enrolment IDs | 0 | PASS |

**Result: PASS**

All five inspected Power BI metrics reconciled with the SQL baseline.

The additional identifier-integrity checks also passed.

This establishes consistency for the metrics and conditions tested, rather than independent verification of every transformation or calculation within the report.

**Published DAX evidence:**

[QA18 Power BI Reconciliation Query](PowerBI/QA18_PowerBI_Reconciliation.dax)

---

## QA19 — Power BI Refresh Verification

QA19 assessed whether the local Power BI report could refresh without reported errors while retaining its expected analytical values.

The test was performed using a separate local backup of the Power BI project.

### Validation Activities

- A local Power BI refresh was performed.
- The refresh completed without reported errors.
- Five dashboard KPI values were checked against the existing baseline.
- All four Data Quality Overview charts remained populated.

### Outcome

**Result: PASS**

The inspected metrics remained consistent after the refresh.

This confirms the documented local refresh behaviour.

It does not constitute verification of scheduled refresh in Power BI Service or prove that every historical reporting run was complete.

[View QA19 Documentation](Documentation/Testing_and_QA.md)

---

## QA20 — Reporting-Run Coverage Investigation

QA20 investigated a substantial decline in exception occurrences during the final reporting run.

### Reporting-Run Comparison

| Reporting Date | Exception Occurrences |
|---|---:|
| 2 March 2026 | 614 |
| 16 March 2026 | 758 |
| 30 March 2026 | 743 |
| 13 April 2026 | 747 |
| 27 April 2026 | 720 |
| 11 May 2026 | 218 |

The final run recorded **502 fewer occurrences**, representing a **69.72% decrease** from the preceding run.

Reporting intervals remained consistent at 14 days.

### Investigation Findings

Further SQL comparisons established that:

- All seven exception categories remained represented, but every category declined.
- All eight campuses remained represented, but every campus declined.
- Both source systems experienced nearly identical proportional reductions.

### Source-System Comparison

| Source System | 27 April | 11 May | Change |
|---|---:|---:|---:|
| EBS Migrated | 201 | 61 | -69.65% |
| PeopleSoft | 519 | 157 | -69.75% |
| **Total** | **720** | **218** | **-69.72%** |

The consistency of the decline across multiple dimensions indicates a broad reporting anomaly.

However, it does not establish the reason for the reduction.

### Unresolved Reporting Risk

The available dataset does not contain sufficient information to determine:

- Whether every expected enrolment was evaluated during the final run.
- Whether the source extract was complete.
- Whether all processing stages completed successfully.
- Whether exception detection rules changed.
- Whether the reduction represents genuine operational improvement.

Additional execution logs, source-population counts and reporting-run metadata would be required.

**Result: INVESTIGATION REQUIRED**

The decline must not be presented as confirmed operational improvement or confirmed reporting failure.

**Published SQL evidence:**

[QA20 Reporting-Run Coverage Investigation](SQL/QA20_Reporting_Run_Coverage.sql)

---

# 11. Root-Cause Assessment

The analytical results identify potential systemic risk areas.

These are evidence-based hypotheses, not proven root causes.

## Migration Quality

Higher exception exposure among migrated enrolments, particularly in the Western region, suggests that migration mapping, transformation or validation processes may warrant further review.

## LMS Linkage

The higher occurrence frequency associated with Missing LMS Unit Link exceptions suggests a need to examine integration processes, linkage validation and exception-classification requirements.

## Duplicate Enrolment Creation

Higher duplicate-affected rates at Harbour City and Metro South suggest that local record-creation processes and duplicate-prevention controls should be investigated.

## Withdrawal and Remediation

The concentration of withdrawal/remediation overlap among withdrawn enrolments suggests that remediation workflows should consider enrolment lifecycle status.

Additional process evidence is required to establish the sequence of administrative actions.

## Reporting Completeness

QA20 demonstrated that substantial changes in reported exception volumes require verification of the processed population before they can be interpreted as meaningful performance improvements.

These observations inform the proposed controls below.

---

# 12. Proposed Process Improvements

The recommendations are derived from the synthetic analysis.

They have not been implemented or demonstrated to produce real operational improvements.

## 12.1 Migration Validation

Introduce additional checks for migrated records, including:

- Pre-migration validation.
- Source-to-target reconciliation.
- Mapping and transformation checks.
- Targeted investigation of regions with higher observed mismatch rates.

## 12.2 Duplicate Prevention

Review record-creation practices and consider preventative controls such as:

- Duplicate detection before record creation.
- Standardised enrolment search procedures.
- Clear handling of possible duplicate records.
- Monitoring of campus-level duplicate rates.

## 12.3 Withdrawal-Status Validation

Introduce validation of current enrolment status before remediation activities are assigned or performed.

Records progressing through withdrawal should be reviewed and routed according to the applicable business process.

## 12.4 Exception Recurrence Monitoring

Monitor multiple exception occurrences affecting the same enrolments.

Investigation should distinguish between:

- Historical occurrences of an unresolved issue.
- Newly created exceptions.
- Reopened issues.
- Potential classification problems.
- Repeated process or system failures.

## 12.5 Data Ownership and Governance

Establish clear responsibility for:

- Data-quality rule definitions.
- Exception monitoring.
- Investigation and remediation.
- Escalation.
- Validation of resolution.
- Review of recurring problems.
- Preventative-control effectiveness.

## 12.6 Reporting-Run Completeness Controls

Introduce reporting controls to capture:

- Unique reporting-run identifiers.
- Expected source-population counts.
- Actual processed-record counts.
- Rejected or excluded records.
- Execution timestamps.
- Run-completion status.
- Data-quality rule versions.
- Significant changes in exception volumes.

Unusual reporting changes should be investigated before being communicated as operational improvements.

## 12.7 Continuous Monitoring

Develop regular monitoring of:

- Affected-enrolment rates.
- Exception volumes.
- Open remediation workload.
- Resolution performance.
- Multiple exception occurrences.
- System and location concentrations.
- Reporting completeness.
- Control effectiveness.

Detailed recommendations are recorded in the:

[Process Improvement Analysis](Documentation/Process_Improvement.md)

---

# 13. Data Quality and Governance Framework

FATE applies seven documented data-quality rules across important quality dimensions.

These include:

- **Completeness**
- **Uniqueness**
- **Validity**
- **Consistency**

The framework connects business requirements, data-quality rules, validation results and operational improvement.

```text
Business Requirements
         |
         v
Data Quality Rules
         |
         v
Validation and Monitoring
         |
         v
Exception Identification
         |
         v
Investigation
         |
         v
Root-Cause Assessment
         |
         v
Recommended Controls
         |
         v
Ongoing Evaluation
```

The intended direction is to move from reactive exception correction toward more effective prevention, monitoring and governance.

Implementation and measured effectiveness remain future activities.

---

# 14. Skills Demonstrated

## Data Analysis

- Exploratory analysis
- Dataset segmentation
- KPI development
- Comparative rates
- Trend analysis
- Exception frequency analysis
- Evidence-based interpretation

## SQL and T-SQL

- Relational queries
- Joins
- CTEs
- Aggregations
- Conditional logic
- Distinct counts
- Date calculations
- Data integrity testing
- Analytical query development

## Power Query

- Data-type validation
- Identifier standardisation
- Date and locale handling
- Null handling
- Calculated fields
- Data preparation for modelling

## Power BI and DAX

- Relational data modelling
- DAX measures
- KPI reporting
- Comparative visualisations
- Management reporting
- Diagnostic dashboards
- Metric reconciliation
- Refresh validation

## Data Quality and Testing

- Data quality dimensions
- Business-rule validation
- Referential integrity
- Exception investigation
- Source-record reconciliation
- Testing documentation
- Identification of unresolved risks

## Business Analysis

- Business problem definition
- Analytical question development
- Process-risk identification
- Root-cause assessment
- Business-rule interpretation
- Recommendations and controls

## Process Improvement and Governance

- Current-state assessment
- Future-state recommendations
- Data ownership
- Preventative controls
- Monitoring and escalation
- Reporting completeness requirements

## Professional Documentation

- Technical documentation
- Analytical findings
- Test evidence
- Reproducible queries
- Project structure
- Version control and GitHub publication

---

# 15. Reproducing the Project

The repository contains the synthetic project datasets, SQL analysis, Power BI file and supporting documentation.

A reproduction guide explains how to:

1. Prepare a compatible SQL Server environment.
2. Create the FATE analytical database.
3. Import the synthetic datasets.
4. Run the SQL investigations.
5. Reconnect the Power BI project to the database.
6. Execute the published validation queries.

**Setup instructions:**

[Reproduction and Setup Guide](REPRODUCE.md)

The setup procedure is documented, but independent reproduction on a fresh SQL Server installation has not yet been verified.

---

# 16. Repository Structure

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

---

# 17. Project Status

**Status: Core analytical release published. Validation evidence and supporting documentation available.**

## Completed Work

- Synthetic dataset development.
- SQL Server database implementation.
- Four principal SQL diagnostic investigations.
- Database record-count validation.
- Referential-integrity and business-rule checks.
- Exception-to-source reconciliation investigation (QA17).
- Power Query preparation and relational modelling.
- Two Power BI analytical report pages.
- DAX measures and management KPIs.
- SQL-to-Power BI metric reconciliation (QA18).
- Enrolment identifier integrity validation.
- Local Power BI refresh verification (QA19).
- Reporting-run coverage investigation (QA20).
- Analytical findings and root-cause hypotheses.
- Recommended operational and governance controls.
- Data dictionary and rule catalogue.
- Process improvement documentation.
- Testing and quality assurance report.
- Published SQL and DAX validation scripts.
- Reproduction guide.

## Published Technical Evidence

| Deliverable | Location |
|---|---|
| SQL investigations and integrity checks | [FATE_SQL_Analysis.sql](SQL/FATE_SQL_Analysis.sql) |
| QA20 reporting-run investigation | [QA20_Reporting_Run_Coverage.sql](SQL/QA20_Reporting_Run_Coverage.sql) |
| Power BI report | [FATE_Data_Quality_Analysis.pbix](PowerBI/FATE_Data_Quality_Analysis.pbix) |
| QA18 DAX validation | [QA18_PowerBI_Reconciliation.dax](PowerBI/QA18_PowerBI_Reconciliation.dax) |
| Testing and QA | [Testing_and_QA.md](Documentation/Testing_and_QA.md) |
| Data dictionary | [Data_Dictionary.md](Documentation/Data_Dictionary.md) |
| Data quality rules | [Data_Quality_Rules.md](Documentation/Data_Quality_Rules.md) |
| Process improvement | [Process_Improvement.md](Documentation/Process_Improvement.md) |
| Reproduction guide | [REPRODUCE.md](REPRODUCE.md) |

## Outstanding Investigations

### QA17 — Exception-to-Source Reconciliation

327 of 2,679 examined exception occurrences require further investigation.

Historical attribute limitations and business-rule interpretation prevent definitive classification of the flagged records as errors.

### QA20 — Reporting-Run Coverage

The final reporting run recorded 69.72% fewer exception occurrences than the previous run.

The available data cannot establish whether this reflects genuine improvement or incomplete reporting coverage.

Additional reporting-run metadata and source-population evidence are required.

Neither unresolved investigation is presented as a confirmed operational failure or improvement.

## Potential Future Development

- Python and pandas validation workflows.
- Automated data-quality checks.
- Reporting-run completeness monitoring.
- Automated exception anomaly detection.
- Exception prioritisation and alerting.
- Responsible AI-assisted exception triage assessment.
- Additional control-effectiveness testing.
- Expanded data governance and process improvement analysis.

These potential extensions are not represented as completed work.

---

# 18. Development Note

AI-assisted tools were used during project development to support:

- Ideation
- Technical learning
- Query development and troubleshooting
- Documentation
- Debugging
- Iterative problem-solving

The project author retained responsibility for reviewing the analysis, executing queries, checking results, validating Power BI calculations and evaluating the recommendations.

AI-generated outputs were not treated as verified evidence without being checked against the project data and implemented work.

This reflects a **human-in-the-loop approach to AI-assisted analytical development**.

---

# 19. Disclaimer

This project is a fictional professional portfolio demonstration.

**FATE — Fictional Academy of Training and Education** is not a real education provider.

All student, enrolment, campus, source-system and exception data is synthetic.

The analysis is intended to demonstrate technical capabilities, analytical reasoning, business understanding and practical approaches to data quality and operational improvement.

Findings and recommendations do not represent the actual performance, systems or processes of any real organisation.
