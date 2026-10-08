# FATE Process Improvement Analysis

## Purpose and scope

This document translates the findings from **FATE — Story 01: The Exception** into proposed operational improvements, preventative controls and governance arrangements.

FATE (Fictional Academy of Training and Education) is a fictional vocational education provider. All records, organisations, campuses, processes and outcomes described here are **synthetic**. This is a portfolio case study, not an account of an implemented organisational change.

**Evidence standard:** The analyses demonstrate observed patterns and data-quality checks. They do not, by themselves, prove the operational cause of each exception or the effectiveness of proposed controls. A current-state process is modelled from the fictional scenario; its steps have not been established through interviews or process observation.

---

## Problem statement

In the fictional scenario, FATE uses periodic exception reports to identify enrolment data-quality problems. Teams investigate and correct individual records, while management needs greater visibility of unresolved work, repeated exception occurrences, concentrated risks and potentially unnecessary remediation.

The analytical objectives are to:

1. Identify concentrations of exception workload and risks.
2. Distinguish observed patterns from root-cause hypotheses.
3. Specify preventative and detective controls that could reduce avoidable work.
4. Establish clear ownership, escalation and closure requirements.
5. Describe how improvements would be tested and measured before claiming benefits.

---

## Modelled current-state process

```text
Enrolment created or updated
             |
             v
Operational processing
             |
             v
Scheduled exception report
             |
             v
Exception identified and assigned
             |
             v
Manual investigation
             |
             v
Record-level remediation or disposition
             |
             v
Exception marked closed or remains open
             |
             v
Next reporting run
             |
             +----> Another occurrence may be recorded
```

### Current-state risks to investigate

- Issues may be discovered after records enter downstream workflows.
- Remediation may focus on individual occurrences without assessing repeated patterns.
- A report may retain an exception after source attributes have changed.
- Enrolment lifecycle changes may affect whether remediation remains appropriate.
- High-risk campuses, systems or processes may require targeted rather than uniform controls.
- Exception ownership and escalation triggers may not be consistently defined.

These are **scenario risks and hypotheses**, not independently observed staff practices.

---

## Evidence and process implications

### 1. LMS linkage: high occurrence frequency and rule ambiguity

**Observed evidence**

- EX02 (Missing LMS Unit Link): **619 occurrences** across **381 affected enrolments**.
- **1.62 occurrences per affected enrolment**, the highest value among the seven exception categories.
- The **238 occurrences above a one-per-enrolment baseline** do not prove 238 failures after completed remediation.
- QA17 flagged **193 EX02 occurrences** involving **134 distinct enrolments**; **72 flagged occurrences** had an Open remediation status.
- The diagnostic flagged records whose current study mode or LMS linkage did not align with the narrow online-enrolment condition used for review.

**Interpretation and uncertainty**

Repeated reporting may reflect an unresolved issue, different reporting snapshots, a genuinely new incident or a previously corrected issue. On Campus courses may also require LMS linkage. The dataset lacks historical source-attribute snapshots needed to distinguish these explanations.

**Proposed response**

Clarify the applicable LMS rule by course and delivery mode; reconcile open exceptions with current source attributes; investigate historical cases where possible; monitor repeated combinations of enrolment and exception code; escalate verified persistent failures to a nominated systems or integration owner.

### 2. Migration: uneven exception exposure

**Observed evidence**

- Affected-enrolment rate: **35.34% for EBS Migrated** versus **25.16% for PeopleSoft**.
- EX05 migration-mismatch rates among migrated records: **Western 17.36%**, **Coastal 12.47%**, **Northern 11.47%**, **Central 8.22%**.
- EX05 generated **1.56 occurrences per affected enrolment**.
- QA17 flagged **48 occurrences** associated with enrolments whose current `MigrationFlag` was False; **12** of these remained Open.

**Interpretation and uncertainty**

The differences justify a prioritised reconciliation review. They do not identify a specific transformation or mapping defect, and current migration flags may not reflect the attributes at the reporting date.

**Proposed response**

Review migration mapping and validation specifications, investigate the Western-region segment first, retain source-to-target reconciliation evidence, and verify how migration classification is recorded and preserved over time.

### 3. Duplicate enrolments: campus concentration

**Observed evidence**

- EX03 duplicate-affected enrolment rates: **Harbour City 6.56%** and **Metro South 5.25%**.
- Other displayed campuses have lower rates; this is a concentration, not proof of a local procedural defect.

**Interpretation and uncertainty**

Potential contributors include record-search behaviour, legitimate duplicate scenarios, warning controls or local workflow differences. A process review would be required to distinguish them.

**Proposed response**

Test search-before-create practices, review duplicate-detection criteria and legitimate exceptions, and prioritise a targeted review at the two highest-rate campuses before considering broader changes.

### 4. Withdrawal/remediation overlap: lifecycle-control risk

**Observed evidence**

- EX04 overlap rates by **current enrolment status**: Withdrawn **15.82%**, Completed **0.33%**, Active **0.32%**, Pending **0.12%**.

**Interpretation and uncertainty**

This association suggests a lifecycle-control risk. The dataset does **not** record the complete timestamped status history needed to prove remediation continued *after* a withdrawal event. Some remediation may remain appropriate under withdrawal-specific rules.

**Proposed response**

Check current enrolment status and applicable business rules before assigning or actioning remediation. Record the reason for any exclusion, pause or rerouting decision, and retain status-change timestamps where feasible.

### 5. QA17: exception-to-source reconciliation

QA17 compares historical exception occurrences with **currently stored** enrolment attributes for selected rules.

| Category | Occurrences examined | Flagged for review | Flagged and Open |
|---|---:|---:|---:|
| EX01 — Incomplete Contact Details | 762 | 46 | 14 |
| EX02 — Missing LMS Unit Link | 619 | 193 | 72 |
| EX05 — Legacy Migration Mismatch | 431 | 48 | 12 |
| EX06 — Fee/Product Validation | 867 | 40 | 18 |
| **Total** | **2,679** | **327** | **116** |

**327 of 2,679 occurrences (12.2%)** were flagged for investigation. This is **not** a confirmed false-positive or data-error rate. Cases may involve historical changes, rule ambiguity, stale exception status, or incorrect classification. QA17 did not test all seven exception categories.

**Proposed response:** Clarify affected business rules, compare open exceptions to current source information, retain historical snapshots where useful, and classify investigation outcomes before any record is closed or reclassified.

---

## Root-cause hypotheses and verification needs

| Hypothesis | Why investigate it? | Evidence required before confirmation |
|---|---|---|
| LMS validation or integration gaps | High EX02 occurrence frequency and QA17 inconsistencies | Rule applicability, interface logs, status history and incident timelines |
| Migration mapping or reconciliation gaps | Higher migrated-record exposure and regional concentration | Source-to-target samples, mappings, transformation specifications and audit logs |
| Campus-specific record-creation practices | Higher duplicate-affected rates at two campuses | Procedure walkthroughs, user research, legitimate-duplicate criteria and control tests |
| Incomplete lifecycle checks in remediation | EX04 is concentrated among withdrawn enrolments | Withdrawal timestamps, remediation timestamps and workflow rules |
| Weak reconciliation or closure governance | QA17 identified open exceptions not aligned with current attributes | Case histories, status update rules, ownership and closure audit trail |

These are **candidate explanations**, not findings that a system or team has been proven deficient.

---

## Proposed future-state process

```text
Enrolment created or updated
             |
             v
Applicable upfront business-rule checks
             |----> Failure: correct or apply approved exception path
             v
Operational processing
             |
             v
Scheduled monitoring with source/snapshot context
             |
             v
Exception identified and recorded
             |
             v
Validate rule applicability, source status and lifecycle
             |----> No longer actionable / rule unclear:
             |      review, document and route appropriately
             v
Assign accountable owner and action
             |
             v
Remediate, correct process, or formally accept exception
             |
             v
Check for repeated occurrences and systemic concentrations
             |----> Threshold met: investigate possible root cause
             v
Validate closure with dated evidence
             |
             v
Monitor subsequent runs and control performance
```

**Important distinction:** A repeated occurrence is a signal to investigate, not automatic evidence that the same defect recurred after successful remediation.

---

## Recommended process improvements

### 1. Preventative validation

**Action:** Define and test mandatory-field, contact-detail, fee/product, duplicate and applicable LMS linkage checks before downstream progression. Make room for approved exceptions where business rules require them.

**Proposed owner:** Student administration process owner with system/data owners.

**Acceptance evidence:** Approved rule specifications, test cases for valid/invalid records, and monitoring of rejected or overridden cases.

**Expected benefit (unverified):** Fewer avoidable exceptions reaching downstream remediation.

### 2. Lifecycle-aware remediation

**Action:** Check current enrolment status before assigning or actioning remediation; distinguish items needing withdrawal-specific processing from those safe to pause, exclude or reroute.

**Proposed owner:** Enrolment operations manager.

**Acceptance evidence:** A documented decision matrix, test cases for each lifecycle state and an audit trail of decisions.

**Expected benefit (unverified):** Less avoidable processing and fewer conflicting workflows.

### 3. Exception-to-source reconciliation and closure

**Action:** Introduce a review of open exceptions whose current source attributes no longer appear to support their classification. Preserve reporting-time attributes where feasible.

**Proposed owner:** Data-quality lead and relevant rule owners.

**Acceptance evidence:** Disposition codes distinguishing valid historical exceptions, corrected records, rule-definition gaps and potential false positives; reviewed QA17 cases; documented closure decisions.

**Expected benefit (unverified):** Better confidence in exception reporting and closure status.

### 4. Repeated-occurrence monitoring and escalation

**Action:** Monitor combinations of enrolment and exception code across reporting runs. Separate unresolved repetition from verified reappearance after closure. Escalate patterns meeting documented thresholds.

**Proposed owner:** Data-quality lead; relevant system/process owner for escalations.

**Acceptance evidence:** Agreed thresholds, dated case histories, escalation records and evidence that repeated patterns were reviewed.

**Expected benefit (unverified):** Earlier investigation of potentially systemic issues.

### 5. Targeted migration reconciliation

**Action:** Review higher-rate migrated populations, initially Western-region records, against documented source-to-target expectations; test whether results generalise before expanding the intervention.

**Proposed owner:** Migration/system data owner.

**Acceptance evidence:** Reconciliation samples, mapping decisions and signed-off exception dispositions.

**Expected benefit (unverified):** Better prioritisation of migration-quality work.

### 6. Targeted duplicate-prevention review

**Action:** Examine search-before-create workflows, duplicate warnings and authorised duplicate scenarios at Harbour City and Metro South.

**Proposed owner:** Enrolment operations and student-system owner.

**Acceptance evidence:** Process walkthroughs, agreed duplicate criteria and controlled test cases.

**Expected benefit (unverified):** Improved early detection of unnecessary duplicate records.

### 7. Rule ownership and governance

**Action:** Assign an accountable owner to each data-quality rule, with agreed definitions, escalation authority, review frequency and closure standards.

**Proposed owner:** FATE data-governance function (fictional design role).

**Acceptance evidence:** Rule catalogue with ownership, version history and decisions about QA17 ambiguities.

**Expected benefit (unverified):** More consistent control decisions and transparent accountability.

---

## Proposed escalation model

| Trigger | Initial response | Escalation condition |
|---|---|---|
| First detected occurrence | Investigate and remediate/disposition | Material impact or rule ambiguity |
| Multiple occurrences for an enrolment/rule | Check whether the issue is unresolved, new or historically resolved | Repeated unaddressed pattern |
| Concentrated rates by campus, region or source | Compare denominators and investigate context | Confirmed material concentration requiring intervention |
| Current attributes conflict with open exception | Reconcile QA17-style evidence and check history | Cannot resolve with available evidence or rule ownership |
| Verified reappearance after closure | Confirm earlier resolution and event timing | Refer to system/process owner for root-cause review |

---

## Performance measures and evaluation

The proposed future state should monitor:

- Total exception occurrences and distinct affected enrolments.
- Affected-enrolment rate, with its denominator and reporting period defined.
- Open occurrences and open rate.
- Average resolution days for resolved occurrences.
- Occurrences per affected enrolment **and**, where historical evidence permits, confirmed post-remediation recurrence.
- Rates by campus, region, source system and delivery mode.
- Current open exceptions that do not align with source attributes.
- Time to reconcile and disposition flagged exceptions.
- Number of escalations and closure decisions with adequate supporting evidence.
- Data coverage and completeness for each reporting run.

### Verification approach before claiming benefits

1. Agree on rule applicability and timestamp definitions with fictional business owners.
2. Establish a comparable baseline across equivalent reporting periods and populations.
3. Pilot selected controls using test records or a synthetic before/after scenario.
4. Reconcile counts, rates and dispositions against independently checked queries.
5. Measure control adoption and outcome changes, noting changes in reporting coverage.
6. Record unintended consequences, legitimate exceptions, resourcing assumptions and limitations.

**No realised time savings, cost savings or reductions in exceptions are claimed in this case study.** Benefits are proposed and require future evaluation.

---

## Risks and dependencies

- **Historical evidence:** The dataset lacks complete status and source-attribute histories; some QA17 cases cannot be definitively classified.
- **Rule ambiguity:** Delivery-mode applicability for LMS requirements and other rule boundaries require business confirmation.
- **Reporting coverage:** The final reporting run contains **218 exception occurrences**, substantially fewer than earlier runs; this must not be presented as proven improvement without establishing comparable coverage.
- **Operational feasibility:** Source-system changes, audit logging and automated checks would require technical assessment and stakeholder approval.
- **Synthetic scenario:** Results illustrate analytical techniques and proposed decisions, not real organisational outcomes.

---

## Business analysis contribution

This case study demonstrates how synthetic operational data can be used to:

1. Define business problems and testable analytical questions.
2. Profile data, compare rates and surface risk concentrations.
3. Distinguish evidence from causal hypotheses and unresolved discrepancies.
4. Model a plausible current-state workflow and design a proposed future state.
5. Define controls, ownership, escalation logic and acceptance evidence.
6. Identify measurement and validation requirements before claiming benefits.

The deliverable is a **proposed process-improvement design** supported by analysis, not a completed implementation or verified organisational transformation.
