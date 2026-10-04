# FATE Process Improvement Analysis

## Purpose

This document translates the analytical findings from the FATE Enrolment Data Quality project into business-process improvements.

The objective is to move from reactive record correction toward preventative controls, clearer ownership and lower recurring remediation workload.

FATE is fictional and all data used in this project is synthetic.

---

# Problem Statement

FATE's existing exception-management process is primarily reactive.

Operational teams identify and remediate individual enrolment records after exceptions appear in recurring reports.

This approach corrects records, but it does not consistently prevent the underlying issue from recurring.

The analysis identified several examples where recurring exceptions are better understood as **process-control problems** rather than isolated data errors.

---

# Current-State Process

```text
Enrolment Created / Updated
        |
        v
Operational Processing
        |
        v
Recurring Exception Report
        |
        v
Exception Identified
        |
        v
Manual Investigation
        |
        v
Record-Level Remediation
        |
        v
Exception Closed
        |
        v
Next Reporting Run
        |
        +----> Exception may recur
```

## Current-State Characteristics

- Controls are heavily dependent on downstream exception reporting.
- Problems are usually detected after the record has already entered operational workflows.
- Remediation focuses primarily on individual records.
- Repeated exceptions may be treated as separate operational tasks.
- System, process, location and workflow concentrations may not automatically trigger escalation.
- Record status can change while remediation remains in progress.
- Ownership of recurring defects may be unclear.

---

# Key Process Issues Identified

## 1. Recurring LMS linkage defects

### Evidence

Missing LMS Unit Link had:

- 619 exception occurrences;
- 381 affected enrolments;
- 238 repeat occurrences;
- **1.62 occurrences per affected enrolment**.

This was the highest recurrence ratio observed.

### Process interpretation

The process appears capable of correcting individual LMS link failures, but the underlying system or integration condition may remain unresolved.

### Risk

Repeated remediation consumes operational capacity without preventing further failures.

---

## 2. Migration defects are not evenly distributed

### Evidence

Overall affected rates:

- EBS Migrated: **35.34%**
- PeopleSoft: **25.16%**

Migration mismatch rates by region:

- Western: **17.36%**
- Coastal: 12.47%
- Northern: 11.47%
- Central: 8.22%

### Process interpretation

Migration quality issues are concentrated, indicating that a universal remediation approach may not be appropriate.

### Risk

Without targeted reconciliation, higher-risk migrated populations continue to generate downstream exceptions.

---

## 3. Duplicate enrolments are concentrated at specific campuses

### Evidence

Duplicate-affected rates:

- Harbour City: **6.56%**
- Metro South: **5.25%**
- remaining campuses: approximately 1.6% to 2.4%.

### Process interpretation

The issue may reflect local differences in:

- record-creation practices;
- search-before-create behaviour;
- training;
- workflow design;
- duplicate detection controls.

### Risk

A general organisation-wide correction strategy may fail to address local root causes.

---

## 4. Remediation continues after withdrawal

### Evidence

Withdrawal/remediation overlap rates:

- Withdrawn: **15.82%**
- Completed: 0.33%
- Active: 0.32%
- Pending: 0.12%

### Process interpretation

The remediation workflow is not sufficiently responding to changes in enrolment status.

### Risk

Teams may spend time remediating records that should instead be:

- excluded;
- paused;
- redirected;
- handled under withdrawal-specific rules.

This creates unnecessary processing and potential conflict between workflows.

---

# Root Cause Themes

The evidence suggests four major root-cause themes.

## System / Integration

Examples:

- repeated LMS linkage failures;
- migration mismatches.

Potential causes:

- incomplete integration logic;
- mapping issues;
- delayed synchronisation;
- transformation defects;
- insufficient upstream validation.

---

## Process

Examples:

- withdrawal/remediation overlap;
- recurring record-level corrections.

Potential causes:

- lifecycle status not checked before remediation;
- downstream processes not updated when status changes;
- exception handling focused on closure rather than prevention.

---

## Local Operational Practice

Example:

- elevated duplicate rates at Harbour City and Metro South.

Potential causes:

- inconsistent record-search practices;
- different local workflows;
- training gaps;
- insufficient duplicate-warning controls.

---

## Governance

Potential causes:

- unclear ownership of recurring exception categories;
- limited escalation criteria;
- insufficient recurrence monitoring;
- unresolved distinction between record-level remediation and systemic investigation.

---

# Future-State Process

```text
Enrolment Created / Updated
        |
        v
Upfront Validation Controls
        |
        +----> Failure -> Correct before progression
        |
        v
Operational Processing
        |
        v
Automated / Scheduled DQ Monitoring
        |
        v
Exception Identified
        |
        v
Lifecycle / Context Validation
        |
        +----> Withdrawn / no longer relevant -> Exclude or reroute
        |
        v
Record-Level Remediation
        |
        v
Recurrence Check
        |
        +----> Repeated / concentrated issue
        |             |
        |             v
        |       Root Cause Escalation
        |             |
        |             v
        |       System / Process Control
        |
        v
Closure Validation
        |
        v
Ongoing Monitoring
```

---

# Recommended Process Improvements

## 1. Add preventative validation before downstream processing

Introduce checks before records progress into downstream workflows.

Examples:

- mandatory-field validation;
- contact-detail validation;
- fee/product validation;
- duplicate detection;
- LMS linkage confirmation.

### Expected benefit

Reduces avoidable exceptions before they become remediation tasks.

---

## 2. Add lifecycle-status checks to remediation

Before remediation is assigned or actioned, validate current enrolment status.

### Proposed logic

```text
IF EnrolmentStatus = Withdrawn
THEN
    Exclude, pause or route to withdrawal-specific handling
ELSE
    Continue standard remediation
```

### Expected benefit

Reduces unnecessary remediation and conflicting administrative actions.

---

## 3. Introduce recurrence thresholds

Repeated occurrences should trigger escalation.

Example:

```text
First occurrence
    -> Record remediation

Repeated occurrence
    -> Investigate recurrence

Repeated systemic pattern
    -> Root cause / control escalation
```

### Expected benefit

Prevents teams from repeatedly correcting symptoms without addressing underlying causes.

---

## 4. Introduce targeted migration reconciliation

Migration controls should prioritise high-risk populations rather than treating all migrated records equally.

Priority:

1. Western region
2. Coastal region
3. Northern region
4. Central region

### Expected benefit

Directs validation effort toward areas with the highest demonstrated risk.

---

## 5. Review duplicate-creation processes at high-risk campuses

Conduct targeted process review at:

- Harbour City;
- Metro South.

Review:

- search-before-create behaviour;
- duplicate warnings;
- user guidance;
- training;
- system controls;
- local workflow variations.

### Expected benefit

Addresses the concentrated source of duplicate risk.

---

## 6. Establish clear exception ownership

Assign a business or data owner for each major exception category.

Owner responsibilities should include:

- monitoring;
- investigation;
- remediation standards;
- recurrence review;
- control implementation;
- escalation;
- closure validation.

### Expected benefit

Improves accountability and reduces repeated unresolved systemic issues.

---

# Proposed Escalation Model

| Condition | Response |
|---|---|
| One-off exception | Record-level remediation |
| Repeated exception on same record | Recurrence investigation |
| Elevated rate by location/system/process | Targeted root-cause investigation |
| Persistent recurrence after remediation | Control redesign |
| Material operational impact | Formal escalation to data/process owner |

---

# Proposed Performance Measures

The future-state process should monitor:

- affected-enrolment rate;
- total exception volume;
- open exception rate;
- average resolution time;
- recurrence rate;
- exception rate by system;
- exception rate by campus;
- exception rate by region;
- overlap with lifecycle statuses;
- percentage of recurring issues escalated to root cause;
- reduction in repeated exceptions following control changes.

---

# Expected Benefits

The proposed future-state process is expected to:

- reduce recurring remediation workload;
- identify systemic issues earlier;
- improve record quality before downstream use;
- reduce unnecessary work on withdrawn records;
- improve accountability;
- strengthen data governance;
- improve confidence in reporting;
- shift data quality from reactive correction toward prevention.

---

# Business Analysis Contribution

This process-improvement assessment demonstrates the use of analytical findings to:

1. identify operational problems;
2. distinguish symptoms from root causes;
3. map current-state workflows;
4. identify control gaps;
5. design future-state processes;
6. define escalation rules;
7. recommend measurable improvements.

The analysis therefore extends beyond data reporting into business analysis and operational improvement.