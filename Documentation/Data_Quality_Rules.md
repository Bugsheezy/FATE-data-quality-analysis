# FATE Data Quality Rules

## Purpose

This document defines the data-quality rules used in the FATE Enrolment Data Quality & Operational Improvement project.

The rules translate business expectations into measurable controls that can be monitored through SQL, Power BI and exception reporting.

FATE is fictional and all data used in this project is synthetic.

---

# Data Quality Framework

The project assesses data across four core dimensions:

| Dimension | Purpose |
|---|---|
| Completeness | Required information is present and usable. |
| Uniqueness | Records are not unnecessarily duplicated. |
| Validity | Values and configurations conform to expected business rules. |
| Consistency | Related records, systems and workflow states do not conflict. |

The control approach follows:

```text
Business Requirement
        ↓
Data Quality Rule
        ↓
Validation Check
        ↓
Exception
        ↓
Investigation
        ↓
Root Cause
        ↓
Remediation / Control
        ↓
Monitoring
```

---

# Rule Catalogue

## DQ01 - Complete Contact Details

**Dimension:** Completeness  
**Exception Code:** EX01  
**Exception Type:** Incomplete Contact Details

### Business requirement

Student enrolment records should contain sufficient contact information to support operational communication.

### Rule

An enrolment should have the required student contact information available.

### Failure indicator

One or more required contact fields are missing.

Examples:

- missing email address;
- missing phone number;
- insufficient contact information for operational follow-up.

### Business impact

Incomplete contact information may:

- delay communication with students;
- increase manual investigation;
- affect service delivery;
- create downstream remediation workload.

### Recommended control

Validate mandatory contact information before enrolment processing is completed.

---

# DQ02 - LMS Unit Link Present

**Dimension:** Completeness  
**Exception Code:** EX02  
**Exception Type:** Missing LMS Unit Link

### Business requirement

Enrolments requiring online learning content should have the correct LMS unit linkage.

### Rule

The required LMS unit link must be present and associated with the enrolment.

### Failure indicator

`LMSUnitLinkStatus` indicates that the expected LMS linkage is missing.

### Business impact

A missing LMS link may:

- prevent access to learning materials;
- create student support enquiries;
- delay study commencement;
- require manual system correction.

### Analytical finding

This exception demonstrated the **highest recurrence rate** in the project:

**1.62 occurrences per affected enrolment**

This suggests that record-level remediation alone may not address the upstream cause.

### Recommended control

Implement:

- automated LMS linkage validation;
- integration monitoring;
- recurrence thresholds;
- escalation where the same enrolment repeatedly fails.

---

# DQ03 - Unique Enrolment Record

**Dimension:** Uniqueness  
**Exception Code:** EX03  
**Exception Type:** Potential Duplicate Enrolment

### Business requirement

Each legitimate enrolment should be represented by a single appropriate record.

### Rule

New enrolments should not duplicate an existing enrolment for the same student and relevant product or enrolment context unless there is a valid business reason.

### Failure indicator

Potential duplicate records are identified through matching enrolment attributes.

### Business impact

Duplicate enrolments may:

- distort operational reporting;
- create duplicate fees or administrative activity;
- affect student records;
- increase remediation workload;
- reduce confidence in reporting.

### Analytical finding

Duplicate risk was concentrated at specific campuses.

Highest duplicate-affected rates:

- Harbour City: **6.56%**
- Metro South: **5.25%**

Other campuses were materially lower.

### Recommended control

Introduce duplicate checking before record creation and investigate local process differences at higher-risk campuses.

---

# DQ04 - Withdrawal / Remediation Compatibility

**Dimension:** Consistency  
**Exception Code:** EX04  
**Exception Type:** Withdrawal / Remediation Overlap

### Business requirement

Remediation activity should reflect the current enrolment lifecycle status.

### Rule

Records already progressing through withdrawal should not continue through standard remediation workflows unless specifically required.

### Failure indicator

An enrolment appears in remediation activity while its status indicates withdrawal.

### Business impact

This may:

- create unnecessary remediation work;
- produce conflicting administrative actions;
- increase rework;
- create inaccurate status reporting;
- delay appropriate withdrawal processing.

### Analytical finding

The exception was strongly concentrated among withdrawn enrolments:

| Status | Overlap Rate |
|---|---:|
| Withdrawn | **15.82%** |
| Completed | 0.33% |
| Active | 0.32% |
| Pending | 0.12% |

This indicates a workflow-control issue rather than random record error.

### Recommended control

Validate current enrolment status before remediation work is assigned.

Withdrawn records should be:

- paused;
- excluded;
- redirected;
- or processed under withdrawal-specific business rules.

---

# DQ05 - Migration Reconciliation

**Dimension:** Consistency  
**Exception Code:** EX05  
**Exception Type:** Legacy Migration Mismatch

### Business requirement

Records migrated from legacy systems should reconcile with the expected target-system values and structure.

### Rule

Migrated enrolments must pass validation and reconciliation checks after transformation into the target system.

### Failure indicator

A migrated record contains a mismatch between expected and migrated values or states.

### Business impact

Migration mismatches may:

- compromise record integrity;
- cause downstream processing errors;
- require manual correction;
- affect reporting confidence;
- increase operational workload.

### Analytical findings

Migrated enrolments showed materially higher overall exception exposure:

- EBS Migrated: **35.34%**
- PeopleSoft: **25.16%**

Migration mismatch was also geographically concentrated:

| Region | Migration Mismatch Rate |
|---|---:|
| Western | **17.36%** |
| Coastal | 12.47% |
| Northern | 11.47% |
| Central | 8.22% |

The exception also had a recurrence rate of:

**1.56 occurrences per affected enrolment**

### Recommended control

Introduce:

- pre-migration validation;
- post-migration reconciliation;
- targeted review of Western-region records;
- recurrence escalation;
- migration-quality ownership.

---

# DQ06 - Valid Fee / Product Configuration

**Dimension:** Validity  
**Exception Code:** EX06  
**Exception Type:** Fee/Product Validation

### Business requirement

Each enrolment should be associated with a valid product and fee configuration.

### Rule

The fee/product relationship must conform to defined enrolment and product rules.

### Failure indicator

`FeeProductStatus` indicates that the configuration requires review or fails validation.

### Business impact

Invalid fee/product configuration may:

- affect fees or charges;
- delay enrolment processing;
- require financial correction;
- create administrative rework;
- reduce reporting accuracy.

### Analytical finding

This was the **largest exception category by volume**:

**867 exception occurrences affecting 748 enrolments**

### Recommended control

Validate fee/product relationships before finalising enrolments and monitor recurring product-level failures.

---

# DQ07 - Complete Enrolment Record

**Dimension:** Completeness  
**Exception Code:** EX07  
**Exception Type:** Incomplete Enrolment

### Business requirement

Enrolment records should contain the required information before progressing through downstream processes.

### Rule

All mandatory enrolment attributes must be present before the record is considered complete.

### Failure indicator

One or more required enrolment attributes are missing or incomplete.

### Business impact

Incomplete enrolments may:

- prevent downstream processing;
- delay service delivery;
- require manual investigation;
- increase operational workload;
- reduce confidence in reporting.

### Recommended control

Apply mandatory-field validation before an enrolment reaches completion or downstream processing stages.

---

# Rule Summary

| Rule | Exception | Dimension | Primary Risk |
|---|---|---|---|
| DQ01 | Incomplete Contact Details | Completeness | Student communication and servicing |
| DQ02 | Missing LMS Unit Link | Completeness | Learning access and recurring system defects |
| DQ03 | Potential Duplicate Enrolment | Uniqueness | Duplicate records and reporting distortion |
| DQ04 | Withdrawal / Remediation Overlap | Consistency | Conflicting workflow and unnecessary remediation |
| DQ05 | Legacy Migration Mismatch | Consistency | Migration integrity and downstream errors |
| DQ06 | Fee/Product Validation | Validity | Incorrect product/fee configuration |
| DQ07 | Incomplete Enrolment | Completeness | Processing delays and incomplete records |

---

# Monitoring Approach

Each rule should be monitored using:

- exception volume;
- affected-record rate;
- recurrence rate;
- unresolved workload;
- average resolution time;
- location or system concentration;
- trend over time.

Monitoring should distinguish between:

**high-volume issues**  
and  
**high-recurrence/systemic issues**

because the largest exception category is not necessarily the highest root-cause priority.

---

# Escalation Principle

An exception should move from routine record remediation to root-cause investigation when one or more of the following occur:

- the same record repeatedly fails;
- failure rates materially exceed organisational baselines;
- the issue is concentrated in a system, campus, region or workflow;
- remediation does not reduce recurrence;
- the issue creates significant downstream operational impact.

---

# Ownership

Each data-quality rule should have an accountable business or data owner responsible for:

- rule definition;
- monitoring;
- investigation;
- remediation;
- control implementation;
- escalation;
- validation of closure.

This ensures data-quality management moves beyond reactive correction toward sustainable prevention.