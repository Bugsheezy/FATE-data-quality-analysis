
# Testing and Quality Assurance

## FATE — Story 01: The Exception

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


### Additional Integrity Validation — 8 October 2026

| Test | Description | Failed Records | Result |
|---|---|---:|---|
| QA09 | Exceptions without matching enrolments | 0 | PASS |
| QA10 | Enrolments without matching students | 0 | PASS |
| QA11 | Resolution dates before reporting dates | 0 | PASS |

All three checks returned zero failures in SQL Server.

These results confirm referential integrity for the relationships tested and valid resolution-date ordering for non-null dates.


### 6. Outstanding Quality Checks

The following checks require further verification:

- Exception records reference valid enrolments.
- Exception codes reconcile with the rule catalogue.
- Reporting and resolution dates satisfy business rules.
- SQL metrics reconcile with Power BI measures.
- Power BI refresh completes successfully.
- The final reporting run has comparable coverage to earlier reporting runs.

These tests must not be marked as passed without supporting evidence.


- Exception codes reconcile with the rule catalogue.
- Additional date and remediation-status business rules are satisfied.
- SQL metrics reconcile with Power BI measures.
- Power BI refresh completes successfully.
- The final reporting run has comparable coverage to earlier runs.


### 7. Limitations

The dataset is synthetic and its results do not represent actual organisational performance.

Identified associations do not independently prove root causes. Proposed controls and improvements require testing before effectiveness can be claimed.

### 8. Conclusion

The initial SQL record-count validation passed, and the four published analytical investigations executed successfully.

Referential-integrity and resolution-date ordering tests passed. Additional business-rule, Power BI reconciliation and reporting-coverage checks remain outstanding.

This document distinguishes completed tests from further validation requirements.
