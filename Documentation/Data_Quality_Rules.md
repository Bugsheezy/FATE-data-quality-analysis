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

**Business Requirement → Data Quality Rule → Validation Check → Exception → Investigation → Root Cause Assessment → Remediation / Control → Monitoring**

This framework supports the identification of data-quality problems, investigation of potential causes, and development of preventative controls.

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

- Missing email address.
- Missing phone number.
- Insufficient contact information for operational follow-up.

### Business impact

Incomplete contact information may:

- Delay communication with students.
- Increase manual investigation.
- Affect service delivery.
- Create downstream remediation workload.

### QA17 — Exception-to-Source Reconciliation

QA17 identified **46 exception occurrences across 46 enrolments** where both email and phone were currently marked as present.

Fourteen occurrences remained Open.

These cases require investigation because the current source attributes do not establish why the contact-details exception was originally raised.

Possible explanations include:

- Historical changes to contact information.
- Missing additional mandatory fields.
- Incorrect exception classification.
- Exceptions remaining open following record correction.

**Assessment: INVESTIGATION REQUIRED**

These occurrences are not confirmed data errors.

### Recommended control

Validate mandatory contact information before enrolment processing is completed.

Introduce periodic reconciliation between open contact-information exceptions and the currently recorded contact attributes.

Where exceptions no longer align with current attributes, investigate whether the issue has been corrected or whether additional validation requirements apply.

---

## DQ02 - LMS Unit Link Present

**Dimension:** Completeness  
**Exception Code:** EX02  
**Exception Type:** Missing LMS Unit Link

### Business requirement

Enrolments requiring online learning content should have the correct LMS unit linkage.

### Rule

The required LMS unit link must be present and associated with the enrolment.

The applicable delivery modes must be clarified by the business owner, including whether On Campus enrolments require access to LMS learning materials.

### Failure indicator

`LMSUnitLinkStatus` indicates that the expected LMS linkage is missing.

### Business impact

A missing LMS link may:

- Prevent access to learning materials.
- Create student support enquiries.
- Delay study commencement.
- Require manual system correction.

### Analytical Finding

Missing LMS Unit Link recorded:

- **619 exception occurrences.**
- **381 affected enrolments.**
- **1.62 occurrences per affected enrolment.**

This represents occurrence frequency, not a verified post-remediation recurrence rate.

The relatively high occurrence frequency suggests that the category warrants further investigation to establish whether multiple occurrences represent ongoing unresolved problems, newly generated exceptions or issues returning after remediation.

The available evidence does not establish which explanation applies.

### QA17 — Exception-to-Source Reconciliation

Further investigation identified:

| Measure | Result |
|---|---:|
| Exception occurrences flagged for review | 193 |
| Distinct enrolments flagged for review | 134 |
| Open occurrences flagged for review | 72 |

These occurrences were flagged because the currently recorded enrolment attributes did not align with the narrow online-enrolment rule used for QA17.

Possible explanations include:

- Historical LMS statuses differing from current values.
- On Campus enrolments legitimately requiring LMS access.
- Exceptions remaining open after source-record changes.
- Incomplete or incorrectly applied business rules.

The available data cannot establish which explanation applies to each occurrence.

**Assessment: INVESTIGATION REQUIRED**

The 193 flagged occurrences are not confirmed data errors or false positives.

The business owner should clarify which delivery modes require LMS linkage.

Historical attribute tracking and reconciliation of open exceptions against current source records are recommended.

### Recommended control

Implement:

- Automated LMS linkage validation.
- Integration monitoring.
- Defined thresholds for multiple occurrences.
- Escalation where the same enrolment repeatedly generates an exception.
- Periodic reconciliation of open exceptions against current LMS linkage status.
- Investigation of potential source-system and exception-report timing differences.

Controls should distinguish between unresolved, historically resolved and newly occurring exceptions before classifying an issue as recurrent.

---

## DQ03 - Unique Enrolment Record

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

- Distort operational reporting.
- Create duplicate fees or administrative activity.
- Affect student records.
- Increase remediation workload.
- Reduce confidence in reporting.

### Analytical Finding

Duplicate enrolment risk was concentrated at specific campuses.

The highest duplicate-affected enrolment rates were:

| Campus | Duplicate-Affected Rate |
|---|---:|
| Harbour City | 6.56% |
| Metro South | 5.25% |

Other campuses recorded substantially lower rates.

These findings suggest that local record-creation processes or duplicate-prevention controls warrant further investigation.

Potential contributing factors include:

- Differences in search-before-create procedures.
- Local workflow variations.
- Inconsistent duplicate-warning controls.
- Training or procedural gaps.

These explanations remain hypotheses until confirmed through further operational investigation.

### Recommended control

Introduce duplicate checking before record creation and investigate local process differences at higher-risk campuses.

Recommended activities include:

- Reviewing search-before-create procedures.
- Validating duplicate-detection rules.
- Investigating record-creation workflows.
- Reviewing staff guidance and training.
- Monitoring duplicate-affected rates by campus.

---

## DQ04 - Withdrawal / Remediation Compatibility

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

- Create unnecessary remediation work.
- Produce conflicting administrative actions.
- Increase rework.
- Create inaccurate status reporting.
- Delay appropriate withdrawal processing.

### Analytical Finding

The exception was strongly concentrated among withdrawn enrolments:

| Enrolment Status | Overlap Rate |
|---|---:|
| Withdrawn | 15.82% |
| Completed | 0.33% |
| Active | 0.32% |
| Pending | 0.12% |

This pattern suggests a potential workflow-control risk.

However, historical enrolment-status timestamps are required to establish whether remediation continued after withdrawal.

The existing dataset does not establish the sequence of all enrolment-status changes and remediation activities.

Consequently, the observed relationship warrants further investigation rather than establishing a confirmed process failure.

### Recommended control

Validate current enrolment status before remediation work is assigned or actioned.

Withdrawn records should be:

- Paused.
- Excluded.
- Redirected.
- Processed under withdrawal-specific business rules where applicable.

Introduce lifecycle-status checks into remediation workflows.

Where appropriate, retain status-change timestamps so subsequent investigations can determine when a record entered withdrawal relative to remediation activity.

---

## DQ05 - Migration Reconciliation

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

- Compromise record integrity.
- Cause downstream processing errors.
- Require manual correction.
- Affect reporting confidence.
- Increase operational workload.

### Analytical Findings

Migrated enrolments showed materially higher overall exception exposure:

| Source System | Affected-Enrolment Rate |
|---|---:|
| EBS Migrated | 35.34% |
| PeopleSoft | 25.16% |

Migration mismatch was also geographically concentrated:

| Region | Migration Mismatch Rate |
|---|---:|
| Western | 17.36% |
| Coastal | 12.47% |
| Northern | 11.47% |
| Central | 8.22% |

The Western region recorded the highest observed migration mismatch rate.

The exception recorded an occurrence frequency of:

**1.56 occurrences per affected enrolment.**

This is an occurrence-frequency measure, not a confirmed post-remediation recurrence rate.

The findings support prioritising investigation of migrated records, particularly in the Western region.

They do not independently establish which migration or transformation process caused the observed differences.

### QA17 — Exception-to-Source Reconciliation

QA17 identified **48 exception occurrences across 48 enrolments** where `MigrationFlag` was currently FALSE.

Twelve occurrences remained Open.

The discrepancy requires investigation to determine whether it reflects:

- Historical migration information.
- Incorrect migration flags.
- Exception classification problems.
- Changes to source attributes after exception reporting.

**Assessment: INVESTIGATION REQUIRED**

Current migration indicators alone cannot establish whether these historical exceptions were incorrectly raised.

### Recommended control

Introduce:

- Pre-migration validation.
- Post-migration reconciliation.
- Targeted review of Western-region records.
- Escalation of repeated or concentrated migration exceptions.
- Migration-quality ownership.
- Reconciliation of migration-related exceptions with current migration indicators.
- Historical tracking of migration classification where justified.

---

## DQ06 - Valid Fee / Product Configuration

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

- Affect fees or charges.
- Delay enrolment processing.
- Require financial correction.
- Create administrative rework.
- Reduce reporting accuracy.

### Analytical Finding

This was the largest exception category by volume:

**867 exception occurrences affecting 748 enrolments.**

The high recorded volume makes fee/product validation an important operational monitoring priority.

However, exception volume alone does not establish the financial impact or underlying cause of individual failures.

### QA17 — Exception-to-Source Reconciliation

QA17 identified **40 exception occurrences across 40 enrolments** where `FeeProductStatus` was currently Valid.

Eighteen occurrences remained Open.

These records require investigation to establish whether:

- Fee/product configuration changed after reporting.
- Exceptions remained open after correction.
- Exceptions were incorrectly classified.
- Reporting and source-system updates occurred at different times.

**Assessment: INVESTIGATION REQUIRED**

No confirmed false-positive rate can be calculated without further historical evidence.

### Recommended control

Validate fee/product relationships before finalising enrolments and monitor recurring product-level failures.

Introduce reconciliation between open fee/product exceptions and current configuration status.

Investigate exceptions that remain open despite currently valid configurations before determining whether they require closure, reclassification or additional remediation.

---

## DQ07 - Complete Enrolment Record

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

- Prevent downstream processing.
- Delay service delivery.
- Require manual investigation.
- Increase operational workload.
- Reduce confidence in reporting.

### Recommended control

Apply mandatory-field validation before an enrolment reaches completion or downstream processing stages.

Validate the relevant completion requirements against enrolment lifecycle status before generating or actioning remediation tasks.

---

# Rule Summary

| Rule | Exception | Dimension | Primary Risk |
|---|---|---|---|
| DQ01 | Incomplete Contact Details | Completeness | Student communication and servicing |
| DQ02 | Missing LMS Unit Link | Completeness | Learning access and repeated exception occurrences |
| DQ03 | Potential Duplicate Enrolment | Uniqueness | Duplicate records and reporting distortion |
| DQ04 | Withdrawal / Remediation Overlap | Consistency | Conflicting workflows and unnecessary remediation |
| DQ05 | Legacy Migration Mismatch | Consistency | Migration integrity and downstream errors |
| DQ06 | Fee/Product Validation | Validity | Incorrect product/fee configuration |
| DQ07 | Incomplete Enrolment | Completeness | Processing delays and incomplete records |

---

# QA17 — Consolidated Exception-to-Source Reconciliation

QA17 compared selected reported exception occurrences with the currently recorded enrolment attributes.

The investigation covered EX01, EX02, EX05 and EX06.

| Exception | Total Occurrences | Flagged for Review | Open Occurrences Flagged |
|---|---:|---:|---:|
| EX01 — Incomplete Contact Details | 762 | 46 | 14 |
| EX02 — Missing LMS Unit Link | 619 | 193 | 72 |
| EX05 — Legacy Migration Mismatch | 431 | 48 | 12 |
| EX06 — Fee/Product Validation | 867 | 40 | 18 |
| **Total** | **2,679** | **327** | **116** |

Of the 2,679 exception occurrences examined, 327 (12.2%) met the diagnostic criteria for further review.

**Result: INVESTIGATION REQUIRED**

The identified occurrences are not confirmed data errors.

The investigation highlights a limitation in comparing historical exception occurrences with current enrolment attributes.

Without historical attribute snapshots, it is not possible to conclusively determine whether each flagged occurrence reflects:

- A valid historical exception.
- A source attribute corrected after reporting.
- An exception remaining open following remediation.
- An incomplete or incorrectly applied business rule.
- An incorrect exception classification.

### Recommended governance response

- Clarify applicable business-rule conditions.
- Investigate open exceptions that conflict with current source attributes.
- Introduce historical status tracking where justified.
- Reconcile exception status following source-record updates.
- Establish a documented process for investigating potential false positives.
- Retain evidence of investigation and closure decisions.

No source records were modified during QA17.

---

# Monitoring Approach

Each rule should be monitored using:

- Exception volume.
- Affected-record rate.
- Occurrences per affected enrolment.
- Unresolved workload.
- Average resolution time.
- Location or system concentration.
- Trends over time.
- Exception-to-source reconciliation outcomes.

Monitoring should distinguish between:

**High-volume issues** — categories generating substantial exception workload.

**High occurrence-frequency issues** — categories in which affected enrolments generate multiple exception occurrences.

**Confirmed recurring defects** — problems demonstrated to have returned after verified remediation.

These categories should not be treated as interchangeable.

High occurrence frequency can justify further investigation, but does not independently establish unsuccessful remediation or a systemic cause.

---

# Escalation Principle

An exception should move from routine record remediation to further investigation when one or more of the following occurs:

- The same enrolment repeatedly appears in exception reporting.
- Failure rates materially exceed organisational baselines.
- An issue is concentrated in a system, campus, region or workflow.
- A previously resolved issue is confirmed to have reappeared.
- Exception records conflict with current source attributes.
- The issue creates significant downstream operational impact.

Escalation should consider whether repeated occurrences represent:

- Unresolved exceptions.
- Repeated reporting of the same underlying issue.
- New incidents.
- Verified post-remediation recurrence.

Where the evidence is insufficient, the issue should remain classified as requiring investigation rather than being assigned an unsupported root cause.

---

# Data Ownership

Each data-quality rule should have an accountable business or data owner responsible for:

- Rule definition.
- Monitoring.
- Investigation.
- Remediation.
- Business-rule clarification.
- Control implementation.
- Escalation.
- Validation of closure.
- Review of discrepancies between reported exceptions and source records.

Defined ownership supports a transition from reactive record correction toward preventative data-quality management.

---

# Limitations

This project uses entirely synthetic data.

The documented findings represent an analytical investigation of a fictional organisation and do not establish actual operational outcomes.

The dataset does not include complete historical snapshots of enrolment attributes, lifecycle-status changes or all remediation events.

Consequently:

- Multiple exception occurrences do not necessarily represent post-remediation recurrence.
- Current source attributes cannot conclusively establish whether historical exceptions were valid.
- Statistical associations and concentrated exception rates do not independently prove operational root causes.
- Proposed controls have not been implemented or evaluated against real organisational performance.

The recommendations should be treated as proposed improvements requiring business validation, implementation and follow-up monitoring.

---

# Conclusion

The FATE Data Quality Framework connects defined business rules with analytical investigations, exception reporting, governance responsibilities and proposed preventative controls.

The initial analytical investigation identified differences in exception exposure, occurrence frequency and operational concentrations.

The subsequent QA17 reconciliation identified 327 exception occurrences requiring further investigation across four categories.

Together, these findings demonstrate the importance of validating not only whether records meet technical integrity requirements, but also whether reported exceptions remain consistent with the underlying business rules and available source information.

The recommended future-state approach combines:

1. Preventative validation.
2. Exception monitoring.
3. Source-to-exception reconciliation.
4. Root-cause investigation.
5. Clear data ownership.
6. Documented remediation decisions.
7. Ongoing control effectiveness monitoring.

This supports a more transparent, evidence-based approach to data-quality management within the fictional FATE environment.
