# FATE Data Dictionary

## Purpose

This document defines the core datasets and fields used in the FATE Enrolment Data Quality & Operational Improvement project.

FATE - Fictional Academy of Training and Education - is a fictional organisation and all records in this project are synthetic.

---

# 1. Students

**Purpose:** Contains core student-level demographic and location information.

**Grain:** One row per student.

**Row count:** 4,200

| Field | Data Type | Description |
|---|---|---|
| StudentID | Text | Unique student identifier. Standardised format: `S000001`. |
| DateOfBirth | Date | Student date of birth. Parsed using Australian date conventions. |
| HomeRegion | Text | Student's fictional home region. |
| Residency | Text | Residency classification, such as Domestic or International. |

**Primary key:** `StudentID`

---

# 2. Enrolments

**Purpose:** Contains enrolment-level information used to analyse student administration activity, operational processes and exception exposure.

**Grain:** One row per enrolment.

**Row count:** 10,075

| Field | Data Type | Description |
|---|---|---|
| EnrolmentID | Text | Unique enrolment identifier. Standardised format: `E0000001`. |
| StudentID | Text | Student identifier linking the enrolment to the Students table. |
| CampusID | Text | Fictional campus identifier, e.g. `C08`. |
| CampusName | Text | Fictional campus name. |
| Region | Text | Fictional organisational region associated with the campus. |
| ProductID | Text | Course/product identifier. Standardised format: `P108`. |
| ProductName | Text | Name of the qualification or course product. |
| QualificationLevel | Text | Qualification level associated with the enrolment. |
| Faculty | Text | Faculty responsible for the product. |
| StudyMode | Text | Delivery mode, such as Online or On Campus. |
| SourceSystem | Text | Student administration source, such as PeopleSoft or EBS Migrated. |
| StartDate | Date | Enrolment commencement date. |
| EnrolmentStatus | Text | Current enrolment lifecycle status, such as Active, Completed, Pending or Withdrawn. |
| EmailPresent | True/False | Indicates whether an email address is present. |
| PhonePresent | True/False | Indicates whether a phone number is present. |
| LMSUnitLinkStatus | Text | Indicates whether the required LMS unit linkage is present. |
| FeeProductStatus | Text | Indicates whether fee/product configuration is valid or requires review. |
| MigrationFlag | True/False | Indicates whether the enrolment originated from the legacy migration process. |

**Primary key:** `EnrolmentID`

**Foreign key:** `StudentID` → `Students[StudentID]`

---

# 3. Exceptions

**Purpose:** Contains individual data-quality exception occurrences identified across recurring reporting runs.

**Grain:** One row per exception occurrence.

**Row count:** 3,800

| Field | Data Type | Description |
|---|---|---|
| ExceptionOccurrenceID | Text | Unique identifier for each exception occurrence. Format: `X0000001`. |
| ReportDate | Date | Reporting date on which the exception was identified. |
| EnrolmentID | Text | Enrolment associated with the exception. |
| StudentID | Text | Student associated with the exception. |
| ExceptionCode | Text | Coded exception category, e.g. `EX01`. |
| ExceptionType | Text | Business-readable exception name. |
| DQDimension | Text | Data-quality dimension represented by the exception, such as Completeness, Validity, Consistency or Uniqueness. |
| Severity | Text | Exception severity classification, such as Medium or High. |
| RemediationStatus | Text | Current remediation status, primarily Open or Resolved. |
| ResolvedDate | Date | Date the exception was resolved. Null where the exception remains open. |
| RemediationAction | Text | Action taken or required, such as record remediation, system correction or pending investigation. |
| ResolutionDays | Whole Number | Number of days between ReportDate and ResolvedDate. Null for unresolved exceptions. |

**Primary key:** `ExceptionOccurrenceID`

**Foreign key:** `EnrolmentID` → `Enrolments[EnrolmentID]`

---

# 4. DQ_Rules

**Purpose:** Defines the data-quality rules used to interpret exception categories and their business impact.

**Grain:** One row per data-quality rule.

**Row count:** 7

| Field | Data Type | Description |
|---|---|---|
| RuleID | Text | Unique identifier for the data-quality rule. |
| Dimension | Text | Data-quality dimension associated with the rule. |
| Rule | Text | Business rule describing the expected condition. |
| Failure_indicator | Text | Condition indicating the rule has failed. |
| Business_impact | Text | Description of the operational or business impact of the failure. |

**Primary key:** `RuleID`

---

# Data Model

The analytical model uses the following relationships:

```text
Students
   1
   |
   *
Enrolments
   1
   |
   *
Exceptions
```

Relationship definitions:

| From | To | Cardinality | Filter Direction |
|---|---|---|---|
| Students[StudentID] | Enrolments[StudentID] | One-to-many | Single |
| Enrolments[EnrolmentID] | Exceptions[EnrolmentID] | One-to-many | Single |

`DQ_Rules` is retained as a separate governance and reference table.

---

# Identifier Standardisation

During Power Query preparation, several identifiers imported from SQL Server as numeric values were standardised into business-readable keys.

Examples:

| Entity | Standard Format |
|---|---|
| Student | `S000001` |
| Enrolment | `E0000001` |
| Product | `P108` |
| Campus | `C08` |
| Exception occurrence | `X0000001` |

This ensured consistent relationship keys across the Power BI model.

---

# Date Handling

Date fields were explicitly interpreted using the **English (Australia)** locale.

Key date fields include:

- Students[DateOfBirth]
- Enrolments[StartDate]
- Exceptions[ReportDate]
- Exceptions[ResolvedDate]

The project uses the Australian `DD/MM/YYYY` convention for display and interpretation.

---

# Data Classification

All records are:

- fictional;
- synthetically generated;
- created for portfolio demonstration;
- free from real student or employer information.

No real personal or organisational data is included.