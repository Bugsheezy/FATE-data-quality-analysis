
# Testing and Quality Assurance

## FATE — Enrolment Data Quality Analysis

### 1. Purpose

Document the validation performed on the synthetic FATE data quality dataset and identify outstanding checks required for a reproducible analytical solution.

### 2. Environment

- Database: SQL Server
- Database name: FATE_Analytics
- Analysis: T-SQL, Power Query, DAX and Power BI
- Dataset: Synthetic student, enrolment and exception records
- Validation date: 8 October 2026

### 3. Database Record Validation

The following checks were executed in SQL Server Management Studio.

| Test | Table | Expected | Actual | Result |
|---|---|---:|---:|---|
| QA01 | Students | 4,200 | 4,200 | PASS |
| QA02 | Enrolments | 10,075 | 10,075 | PASS |
| QA03 | Exceptions | 3,800 | 3,800 | PASS |
| QA04 | DQ_Rules | 7 | 7 | PASS |

All four source-table record counts matched the project baseline.

### 4. SQL Investigation Execution

The following investigations were executed and returned results:

| Test | Investigation | Result |
|---|---|---|
| QA05 | Duplicate rate by campus | Executed |
| QA06 | Withdrawal/remediation overlap | Executed |
| QA07 | Remediation performance by exception | Executed |
| QA08 | Exception trends by reporting run | Executed |

Successful execution confirms that the queries ran without reported SQL errors. It does not independently establish that every analytical assumption is correct.

### 5. Results Reconciliation

The SQL output also supports these arithmetic checks:

- Seven exception categories total 3,800 occurrences.
- Six reporting runs total 3,800 occurrences.
- Open occurrences across exception categories total 1,305.
- Campus enrolment totals reconcile to 10,075.

These figures were reconciled against the displayed SQL results.


### 6. Referential Integrity Validation

| Test | Description | Failed Records | Result |
|---|---|---:|---|
| QA09 | Exceptions without matching enrolments | 0 | PASS |
| QA10 | Enrolments without matching students | 0 | PASS |
| QA11 | Resolution dates before reporting dates | 0 | PASS |

All three checks returned zero failures in SQL Server.

These results confirm referential integrity for the relationships tested and valid resolution-date ordering for non-null dates.


### 7. Additional Data Quality Validation

The following tests were executed in SQL Server on 8 October 2026.

| Test | Description | Failed Records | Result |
|---|---|---:|---|
| QA12 | Exception codes match DQ rule IDs | 0 | PASS |
| QA13 | Invalid remediation statuses | 0 | PASS |
| QA14 | Resolved exceptions without resolution dates | 0 | PASS |
| QA15 | Open exceptions with resolution dates | 0 | PASS |
| QA16 | Exception and enrolment StudentID mismatches | 0 | PASS |

All five tests returned zero failures.

These results confirm that the tested records satisfy the specified rule-code, remediation-status and student-reference checks.


### 8. Exception-to-Source Reconciliation (QA17)

**Validation date:** 8 October 2026

**Objective:** Compare reported exception occurrences with the
currently recorded enrolment attributes to identify cases
requiring further investigation.

| Exception | Total Occurrences | For Review | Affected Enrolments for Review | Open for Review |
|---|---:|---:|---:|---:|
| EX01 — Incomplete Contact Details | 762 | 46 | 46 | 14 |
| EX02 — Missing LMS Unit Link | 619 | 193 | 134 | 72 |
| EX05 — Legacy Migration Mismatch | 431 | 48 | 48 | 12 |
| EX06 — Fee/Product Validation | 867 | 40 | 40 | 18 |
| **Total** | **2,679** | **327** | **268 category-level counts** | **116** |

**Result:** INVESTIGATION REQUIRED

Of the 2,679 exception occurrences examined, 327 (12.2%)
met at least one diagnostic condition requiring review.

These are potential inconsistencies, not confirmed data errors.

### Key observations

- EX02 generated the largest number of flagged occurrences.
- Some open exceptions are associated with enrolments
  whose current attributes no longer indicate the issue.
- The current dataset does not provide historical snapshots
  of enrolment attributes for each reporting date.
- The EX02 rule requires clarification regarding whether
  On Campus enrolments may also require LMS access.

### Limitations

The comparison uses current enrolment attributes against
historical exception occurrences.

Without event-level attribute history, it is not possible
to determine whether every flagged occurrence represents:

- a valid historical exception;
- an issue corrected after the reporting date;
- an exception classification problem;
- or an incomplete business-rule definition.

The affected-enrolment counts are category-level counts.
They must not be interpreted as 268 unique enrolments
across all four exception categories.

### Recommended actions

1. Clarify the business requirements for each affected rule.
2. Investigate open exceptions that conflict with current attributes.
3. Introduce historical attribute tracking where justified.
4. Reconcile exception status after source-record changes.
5. Establish a process for reviewing potential false positives.

No source records were modified during this investigation.

### 9. SQL-to-Power BI Reconciliation (QA18)

**Validation date:** 8 October 2026

**Objective:** Verify that the Power BI dashboard metrics reconcile with the documented SQL baseline and that the underlying DAX measures use appropriate calculations.

#### Dashboard Metric Reconciliation

| Metric | SQL Baseline | Power BI Result | Status |
|---|---:|---:|---|
| Total Enrolments | 10,075 | 10,075 | PASS |
| Affected Enrolments | 2,723 | 2,723 | PASS |
| Affected Rate | 27.03% | 27.03% | PASS |
| Total Exception Occurrences | 3,800 | 3,800 | PASS |
| Open Exceptions | 1,305 | 1,305 | PASS |

The underlying DAX measures were reviewed:

- Total Enrolments: `COUNTROWS(Enrolments)`
- Affected Enrolments: `DISTINCTCOUNT(Exceptions[EnrolmentID])`
- Affected Rate: `DIVIDE([Affected Enrolments], [Total Enrolments])`
- Total Exception Occurrences: `COUNTROWS(Exceptions)`
- Open Exceptions: `CALCULATE([Total Exception Occurrences], Exceptions[RemediationStatus] = "Open")`

#### Additional Integrity Checks

A read-only DAX query was executed in Power BI Desktop.

| Test | Expected | Actual | Result |
|---|---:|---:|---|
| Total enrolment rows | 10,075 | 10,075 | PASS |
| Unique enrolment IDs | 10,075 | 10,075 | PASS |
| Blank enrolment IDs | 0 | 0 | PASS |
| Blank exception enrolment IDs | 0 | 0 | PASS |

#### Result: PASS

All five dashboard metrics matched the documented baseline.

The enrolment table contained 10,075 unique, nonblank enrolment IDs, and no blank exception enrolment references were identified.

The DAX measures were reviewed and found consistent with their intended calculation definitions.

These results establish reconciliation for the metrics and integrity checks tested. They do not independently verify every visual, data transformation or refresh operation.

### 10. Power BI Refresh Verification (QA19)

**Validation date:** 8 October 2026

**Environment:** Power BI Desktop — local QA backup copy

**Objective:** Verify that the existing Power BI report can refresh without reported errors and that its key analytical results remain consistent.

#### Refresh Validation

A refresh was initiated in Power BI Desktop.

The user reported that the refresh completed without errors. The refreshed Data Quality Overview page was visually inspected.

| Metric | Expected | Actual | Result |
|---|---:|---:|---|
| Total Enrolments | 10,075 | 10,075 | PASS |
| Affected Enrolments | 2,723 | 2,723 | PASS |
| Affected Rate | 27.03% | 27.03% | PASS |
| Total Exception Occurrences | 3,800 | 3,800 | PASS |
| Open Exceptions | 1,305 | 1,305 | PASS |

All four overview charts remained populated after the refresh.

#### Result: PASS

The refresh was reported as successful, and the five inspected KPI values remained consistent with the documented baseline.

No missing visuals or unexpected changes were identified during the post-refresh review.

This test establishes refresh stability for the inspected local Power BI report. It does not constitute verification of scheduled refresh in the Power BI Service.

### 11. Outstanding Quality Checks

The following checks remain outstanding:

- Power BI refresh completes successfully.
- The final reporting run has comparable coverage to earlier runs.

These checks must not be marked as passed without supporting evidence.

### 12. Limitations

The dataset is synthetic and its results do not represent actual organisational performance.

Identified associations do not independently prove root causes. Proposed controls and improvements require testing before effectiveness can be claimed.

### 13. Conclusion


The initial database record-count validation passed, and the four documented SQL investigations executed successfully.

Referential integrity, resolution-date ordering and the specified data-quality validation checks passed.

Exception-to-source reconciliation (QA17) identified 327 of 2,679 examined exception occurrences requiring further investigation. These findings represent potential inconsistencies rather than confirmed data errors.

SQL-to-Power BI reconciliation, Power BI refresh verification and reporting-run coverage checks remain outstanding.

The completed tests establish an initial validation baseline. Outstanding checks must be completed and documented before the analytical solution can be considered fully validated.

