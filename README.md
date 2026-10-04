# FATE | Enrolment Data Quality & Operational Improvement

A portfolio case study investigating recurring enrolment data-quality exceptions within **FATE — Fictional Academy of Training and Education**, a synthetic statewide vocational education provider.

The project demonstrates an end-to-end analytical workflow using **SQL Server / T-SQL, Power Query, Power BI, DAX, data-quality analysis, root-cause analysis, process improvement and data governance**.

> **Important:** FATE is fictional and all data used in this project is synthetic. No real student, employer or organisational data is included.

---

## Project Overview

FATE was experiencing recurring enrolment exceptions across its student administration processes.

Operational teams were correcting individual records, but recurring defects continued to generate remediation workload. Management needed to understand:

- the scale of the data-quality problem;
- which exception types generated the greatest workload;
- whether certain systems, locations or delivery modes carried greater risk;
- whether records were repeatedly returning in exception reports;
- which patterns suggested systemic rather than isolated issues;
- how remediation processes could be improved;
- what preventative controls should be introduced.

The project was designed to move beyond simply reporting exception counts and instead identify **systemic causes, operational impacts and sustainable controls**.

---

## Business Questions

The analysis addressed six core questions:

1. What is the scale and composition of the enrolment data-quality problem?
2. Which exception types, locations, systems and processes generate the greatest risk or workload?
3. Are records repeatedly appearing after identification or remediation?
4. What patterns indicate systemic rather than isolated problems?
5. What are the likely root causes and downstream operational consequences?
6. What controls, monitoring and process improvements should FATE implement?

---

## Tools & Capabilities

| Area | Tools / Techniques |
|---|---|
| Database | SQL Server 2025 |
| Querying | T-SQL |
| Data preparation | Power Query |
| Analysis | SQL, DAX, Power BI |
| Data modelling | Relational modelling, one-to-many relationships |
| Data Quality | Completeness, uniqueness, validity, consistency |
| Investigation | Segmentation, recurrence analysis, exception-rate analysis |
| Root Cause Analysis | System, process, location and workflow investigation |
| Business Analysis | Business questions, process risks, controls and recommendations |
| Governance | Data-quality rules, ownership, monitoring and escalation |
| Visualisation | Power BI dashboards |
| Version-ready documentation | GitHub-style project structure and case study |

---

## Dataset

The synthetic project dataset contains:

| Dataset | Records |
|---|---:|
| Students | 4,200 |
| Enrolments | 10,075 |
| Exception occurrences | 3,800 |
| Reporting runs | 6 |
| Data-quality rules | 7 |

The data represents fictional enrolments across multiple campuses, regions, faculties, study modes and student-administration systems.

### Main tables

**Students**
- Student identifier
- Date of birth
- Home region
- Residency

**Enrolments**
- Enrolment and student identifiers
- Campus and region
- Product and qualification
- Faculty
- Study mode
- Source system
- Enrolment status
- Contact-information indicators
- LMS link status
- Fee/product status
- Migration indicator

**Exceptions**
- Exception occurrence
- Enrolment and student identifiers
- Exception code and type
- Data-quality dimension
- Severity
- Reporting date
- Remediation status
- Resolution date
- Remediation action

**DQ Rules**
- Rule identifier
- Data-quality dimension
- Rule definition
- Failure indicator
- Business impact

---

## Analytical Architecture

The project uses the following analytical flow:

```text
Synthetic Source Data
        ↓
SQL Server
        ↓
T-SQL Investigation
        ↓
Power Query Preparation
        ↓
Power BI Data Model
        ↓
DAX Measures
        ↓
Management Reporting
        ↓
Root Cause Analysis
        ↓
Process & Governance Recommendations
```

The Power BI model uses:

```text
Students
   1
   │
   *
Enrolments
   1
   │
   *
Exceptions
```

`DQ_Rules` is retained as a separate governance/reference table.

---

## Data Preparation

Power Query was used to prepare the SQL Server data for analytical modelling.

Key preparation activities included:

- validating column data types;
- explicitly applying Australian date handling;
- standardising student, enrolment and product identifiers;
- preserving null resolution dates for unresolved exceptions;
- creating a `ResolutionDays` field;
- validating relational keys before creating the Power BI model.

Examples of standardised identifiers include:

```text
StudentID     S001086
EnrolmentID   E0000001
ProductID     P108
CampusID      C08
```

This ensured the relationships between Students, Enrolments and Exceptions were reliable.

---

## SQL Analysis

T-SQL was used to investigate the exception population rather than simply extract data for visualisation.

The analysis included:

- dataset profiling;
- distinct affected-record calculations;
- exception composition;
- unresolved workload;
- source-system comparisons;
- delivery-mode comparisons;
- recurrence analysis;
- migration investigation;
- campus-level duplicate analysis;
- withdrawal/remediation overlap;
- remediation performance;
- reporting-run trends.

Techniques demonstrated include:

- `INNER JOIN`
- `LEFT JOIN`
- `COUNT(DISTINCT)`
- `CASE`
- `GROUP BY`
- Common Table Expressions (`CTEs`)
- conditional aggregation
- calculated rates
- segmentation
- denominator-aware comparisons
- date-difference analysis

The complete analysis is available in:

```text
SQL/FATE_SQL_Analysis.sql
```

---

# Key Findings

## 1. Data-quality exceptions affected more than one quarter of enrolments

Of **10,075 enrolments**, **2,723** experienced at least one exception.

**Affected enrolment rate: 27.03%**

A total of **2,005 students** were represented in the affected enrolment population.

---

## 2. A substantial remediation backlog remained

Across **3,800 exception occurrences**:

- **2,495** were resolved;
- **1,305** remained open;
- overall open rate was **34.34%**.

Average resolution time for resolved exceptions was approximately **9.5 days**.

---

## 3. Fee/Product Validation generated the greatest workload

Exception volume by type:

| Exception type | Occurrences | Affected enrolments |
|---|---:|---:|
| Fee/Product Validation | 867 | 748 |
| Incomplete Contact Details | 762 | 666 |
| Missing LMS Unit Link | 619 | 381 |
| Legacy Migration Mismatch | 431 | 277 |
| Incomplete Enrolment | 425 | 385 |
| Potential Duplicate Enrolment | 350 | 303 |
| Withdrawal / Remediation Overlap | 346 | 294 |

Volume alone, however, did not identify the most systemic problems.

---

## 4. LMS and migration problems showed the strongest recurrence

The highest occurrence-per-affected-enrolment ratios were:

| Exception type | Occurrences per affected enrolment |
|---|---:|
| Missing LMS Unit Link | **1.62** |
| Legacy Migration Mismatch | **1.56** |
| Withdrawal / Remediation Overlap | 1.18 |
| Fee/Product Validation | 1.16 |
| Potential Duplicate Enrolment | 1.16 |
| Incomplete Contact Details | 1.14 |
| Incomplete Enrolment | 1.10 |

This indicates that **Missing LMS Unit Link** and **Legacy Migration Mismatch** were more likely to recur after initial identification, suggesting systemic rather than isolated defects.

---

## 5. Migrated records carried materially higher risk

Affected-enrolment rates differed significantly by source system:

| Source system | Affected rate |
|---|---:|
| EBS Migrated | **35.34%** |
| PeopleSoft | **25.16%** |

Migrated records therefore showed approximately a **10 percentage-point higher exception exposure**.

---

## 6. Migration problems were geographically concentrated

Legacy migration mismatch rates among migrated records were:

| Region | Migration mismatch rate |
|---|---:|
| Western | **17.36%** |
| Coastal | 12.47% |
| Northern | 11.47% |
| Central | 8.22% |

The Western region's rate was more than twice that of Central, suggesting a concentrated migration-quality problem rather than an organisation-wide random distribution.

---

## 7. Duplicate risk was concentrated at specific campuses

The strongest duplicate-affected rates were:

| Campus | Duplicate-affected rate |
|---|---:|
| Harbour City | **6.56%** |
| Metro South | **5.25%** |
| Riverbend | 2.37% |
| Highland | 2.31% |
| Greenfield | 2.22% |

The sharp difference between the two leading campuses and the remainder suggests local process or record-creation controls require further review.

---

## 8. Withdrawal/remediation overlap exposed a process-control failure

Withdrawal/remediation overlap was highly concentrated among withdrawn records:

| Enrolment status | Overlap rate |
|---|---:|
| Withdrawn | **15.82%** |
| Completed | 0.33% |
| Active | 0.32% |
| Pending | 0.12% |

This strongly suggests remediation activity was continuing after records had already entered the withdrawal process.

The issue therefore represents not only a data-quality defect, but also a **workflow and business-process control problem**.

---

## Power BI — Data Quality Overview

The first report page provides an executive overview of:

- total enrolments;
- affected enrolments;
- affected students;
- exception volume;
- open workload;
- affected and open rates;
- resolution performance;
- source-system risk;
- exception composition;
- reporting-run trends.

![Data Quality Overview](Images/01_Data_Quality_Overview.png)

---

## Power BI — Investigation & Root Cause

The second report page focuses on diagnostic analysis:

- migration mismatch by region;
- duplicate-affected rate by campus;
- withdrawal/remediation overlap;
- recurring exception behaviour.

![Investigation and Root Cause](Images/02_Investigation_Root_Cause.png)

---

# Root Cause Assessment

The analysis identified several different classes of underlying issue.

### Migration quality

Higher exception rates among migrated records, particularly in the Western region, suggest migration-related mapping, transformation or validation weaknesses.

### LMS linkage

High recurrence of missing LMS unit links suggests record-level remediation is correcting symptoms without consistently addressing the upstream process or integration responsible for the linkage.

### Duplicate creation

Concentration at Harbour City and Metro South suggests localised workflow, user-process or record-creation controls may differ from other campuses.

### Withdrawal workflow

The strong relationship between withdrawn enrolments and remediation overlap indicates that remediation workflows do not sufficiently account for changes in enrolment lifecycle status.

---

# Recommended Controls

## 1. Migration validation

Introduce pre-validation and reconciliation checks for migrated records, with targeted investigation of Western-region migration outcomes.

## 2. Duplicate prevention

Review record-creation processes at Harbour City and Metro South and introduce duplicate checks before new enrolment records are committed.

## 3. Withdrawal-status validation

Check current enrolment status before remediation work is assigned or actioned.

Records already progressing through withdrawal should be paused, filtered or routed through the appropriate withdrawal process.

## 4. Recurrence monitoring

Introduce recurrence thresholds for repeated LMS and migration exceptions.

Repeated failures should trigger escalation from individual-record remediation to root-cause investigation.

## 5. Data ownership

Assign clear ownership for major data-quality domains and exception categories.

Owners should be responsible for:

- monitoring;
- investigation;
- remediation;
- escalation;
- preventative controls;
- closure validation.

## 6. Ongoing reporting

Continue monitoring:

- exception rates;
- recurrence;
- unresolved workload;
- resolution time;
- location/system concentrations;
- control effectiveness.

---

# Data Quality Framework

The project uses seven defined data-quality rules spanning key dimensions including:

- **Completeness**
- **Uniqueness**
- **Validity**
- **Consistency**

Each rule connects:

```text
Business Requirement
        ↓
Data Quality Rule
        ↓
Validation / Exception
        ↓
Investigation
        ↓
Root Cause
        ↓
Control
        ↓
Monitoring
```

This approach shifts data-quality management from reactive record correction toward sustainable prevention and governance.

---

# Skills Demonstrated

### Data Analysis
- exploratory analysis;
- segmentation;
- KPI design;
- comparative rates;
- recurrence analysis;
- trend analysis;
- interpretation of operational data.

### SQL / T-SQL
- joins;
- CTEs;
- aggregations;
- conditional logic;
- distinct counts;
- calculated rates;
- date calculations;
- analytical query design.

### Power Query
- key standardisation;
- type validation;
- locale handling;
- null handling;
- calculated columns;
- transformation sequencing.

### Power BI / DAX
- relational modelling;
- reusable measures;
- KPI cards;
- interactive cross-filtering;
- management dashboards;
- investigative reporting.

### Data Quality
- quality dimensions;
- exception management;
- recurring defect analysis;
- remediation monitoring;
- rule-based controls.

### Business Analysis
- business-question definition;
- process-risk identification;
- root-cause investigation;
- business-control design;
- recommendations.

### Governance & Process Improvement
- data ownership;
- preventative controls;
- monitoring thresholds;
- remediation workflow improvement;
- escalation design.

---

# Repository Structure

```text
FATE/
│
├── README.md
│
├── Data/
│
├── Documentation/
│   ├── Data_Dictionary.md
│   ├── Data_Quality_Rules.md
│   ├── Process_Improvement.md
│   └── Testing_and_QA.md
│
├── Images/
│   ├── 01_Data_Quality_Overview.png
│   └── 02_Investigation_Root_Cause.png
│
├── PowerBI/
│   └── FATE_Data_Quality_Analysis.pbix
│
└── SQL/
    └── FATE_SQL_Analysis.sql
```

---

# Project Status

**Core analytical release complete**

Completed:

- synthetic dataset;
- SQL Server implementation;
- T-SQL investigation;
- Power Query preparation;
- relational data model;
- DAX measures;
- Power BI reporting;
- root-cause analysis;
- control recommendations.

Planned supporting evidence:

- detailed data dictionary;
- documented data-quality rules;
- current-state and future-state process analysis;
- testing and QA evidence.

Potential later extension:

- Python/pandas validation workflow;
- automated exception monitoring;
- responsible AI-assisted triage assessment.

---

## Development Note

AI-assisted tools were used during development to support ideation, troubleshooting, documentation and iterative problem solving.

Analytical decisions, query execution, validation, interpretation, Power BI modelling and final recommendations were reviewed and controlled by the project author.

This reflects a **human-in-the-loop approach to AI-assisted analytical development**.

---

## Disclaimer

This project is a fictional portfolio case study.

**FATE — Fictional Academy of Training and Education** is not a real education provider. All student, enrolment, system, campus and exception data is synthetic and was created specifically for analytical demonstration purposes.