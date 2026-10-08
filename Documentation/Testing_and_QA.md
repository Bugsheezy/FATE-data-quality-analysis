# Testing and Quality Assurance

## FATE — Enrolment Data Quality Analysis

### 1. Purpose

Document the testing and quality assurance activities performed on the synthetic FATE enrolment data quality dataset.

The objectives are to:

- Verify database record counts and data integrity.
- Validate SQL investigation execution and analytical outputs.
- Assess compliance with defined data quality rules.
- Reconcile SQL findings with Power BI reporting.
- Verify Power BI refresh stability.
- Investigate potential reporting inconsistencies.
- Distinguish completed validation from outstanding risks and limitations.

This document provides a record of completed tests, observed results and further investigation requirements.

### 2. Environment

| Component | Environment |
|---|---|
| Organisation | Fictional Academy of Training and Education (FATE) |
| Database platform | Microsoft SQL Server |
| Database name | FATE_Analytics |
| SQL development | SQL Server Management Studio (SSMS) |
| Data preparation and modelling | Power Query |
| Reporting and calculations | Power BI Desktop / DAX |
| Dataset | Synthetic student, enrolment and exception records |
| Validation date | 8 October 2026 |

All tests were performed using synthetic data. Results do not represent actual organisational performance.

---

### 3. Database Record Validation (QA01–QA04)

**Objective:** Confirm that the source database contains the expected number of records across the four principal tables.

The following checks were executed in SQL Server Management Studio.

| Test | Table | Expected | Actual | Result |
|---|---|---:|---:|---|
| QA01 | Students | 4,200 | 4,200 | PASS |
| QA02 | Enrolments | 10,075 | 10,075 | PASS |
| QA03 | Exceptions | 3,800 | 3,800 | PASS |
| QA04 | DQ_Rules | 7 | 7 | PASS |

**Result: PASS**

All four source-table record counts matched the established project baseline.

These tests confirm record-count consistency at the time of validation. They do not independently establish the accuracy of individual records.

---

### 4. SQL Investigation Execution (QA05–QA08)

**Objective:** Confirm that the principal analytical SQL investigations execute successfully against the FATE database.

| Test | Investigation | Result |
|---|---|---|
| QA05 | Duplicate rate by campus | Executed successfully |
| QA06 | Withdrawal/remediation overlap | Executed successfully |
| QA07 | Remediation performance by exception | Executed successfully |
| QA08 | Exception trends by reporting run | Executed successfully |

All four investigations executed and returned results.

**Result: EXECUTION VERIFIED**

Successful execution confirms that the SQL queries ran without reported errors.

It does not independently establish that every analytical assumption, relationship or business-rule interpretation is correct.

Analytical results must be assessed separately against source data, expected calculations and business requirements.

---

### 5. SQL Results Reconciliation

**Objective:** Verify that analytical summaries reconcile with the expected underlying dataset totals.

The following arithmetic checks were performed against the displayed SQL results:

| Validation | Expected | Actual | Result |
|---|---:|---:|---|
| Exception occurrences across seven categories | 3,800 | 3,800 | PASS |
| Exception occurrences across six reporting runs | 3,800 | 3,800 | PASS |
| Open exception occurrences | 1,305 | 1,305 | PASS |
| Enrolment totals across campuses | 10,075 | 10,075 | PASS |

**Result: PASS**

The examined SQL summaries reconciled to the documented dataset totals.

These results establish internal consistency for the aggregations tested.

---

### 6. Referential Integrity Validation (QA09–QA11)

**Validation date:** 8 October 2026

**Objective:** Identify missing parent records and invalid resolution-date ordering.

| Test | Description | Failed Records | Result |
|---|---|---:|---|
| QA09 | Exceptions without matching enrolments | 0 | PASS |
| QA10 | Enrolments without matching students | 0 | PASS |
| QA11 | Resolution dates before reporting dates | 0 | PASS |

**Result: PASS**

All three checks returned zero failures in SQL Server.

The results confirm that:

- All tested exception records have matching enrolment records.
- All tested enrolment records have matching student records.
- No tested non-null resolution date precedes its associated reporting date.

These checks establish referential integrity and chronological consistency for the relationships and date conditions examined.

---

### 7. Additional Data Quality Validation (QA12–QA16)

**Validation date:** 8 October 2026

**Objective:** Verify selected business-rule constraints, remediation-status consistency and record relationships.

| Test | Description | Failed Records | Result |
|---|---|---:|---|
| QA12 | Exception codes match DQ rule IDs | 0 | PASS |
| QA13 | Invalid remediation statuses | 0 | PASS |
| QA14 | Resolved exceptions without resolution dates | 0 | PASS |
| QA15 | Open exceptions with resolution dates | 0 | PASS |
| QA16 | Exception and enrolment StudentID mismatches | 0 | PASS |

**Result: PASS**

All five tests returned zero failures.

These checks confirm that the tested records satisfy the specified:

- Exception-code and rule-reference relationships.
- Remediation-status value requirements.
- Resolution-date consistency requirements.
- Student-reference consistency requirements.

Passing these checks does not mean that every exception classification is necessarily correct.

Whether a record genuinely breaches a business rule may require additional contextual or historical information.

---

### 8. Exception-to-Source Reconciliation (QA17)

**Validation date:** 8 October 2026

**Objective:** Compare recorded exception occurrences against current enrolment attributes to identify potential inconsistencies requiring investigation.

#### 8.1 Reconciliation Results

| Exception | Total Occurrences | For Review | Affected Enrolments for Review | Open for Review |
|---|---:|---:|---:|---:|
| EX01 — Incomplete Contact Details | 762 | 46 | 46 | 14 |
| EX02 — Missing LMS Unit Link | 619 | 193 | 134 | 72 |
| EX05 — Legacy Migration Mismatch | 431 | 48 | 48 | 12 |
| EX06 — Fee/Product Validation | 867 | 40 | 40 | 18 |
| **Total** | **2,679** | **327** | **268 category-level counts** | **116** |

Of the 2,679 exception occurrences examined, 327 (12.2%) met at least one diagnostic condition requiring review.

These are potential inconsistencies, not confirmed data errors.

#### 8.2 Key Findings

**EX02 — Missing LMS Unit Link**

EX02 generated the largest number of flagged exception occurrences, with 193 occurrences involving 134 affected enrolments.

The business rule requires clarification regarding whether On Campus enrolments may also require LMS access.

**Exception status and current source attributes**

Some open exceptions were associated with enrolments whose current attributes no longer indicated the originally recorded issue.

This may reflect legitimate changes after the exception was created or potentially outdated remediation statuses.

**Historical data limitations**

The dataset does not provide historical snapshots of enrolment attributes for each exception reporting date.

Consequently, the analysis cannot definitively determine the validity of every historical exception.

#### 8.3 Interpretation Limitations

The reconciliation compares current enrolment attributes against historical exception occurrences.

Without event-level historical information, flagged cases may represent:

- Valid historical exceptions.
- Issues corrected after the original reporting date.
- Exception classification problems.
- Incomplete or ambiguous business-rule definitions.

The affected-enrolment figures are category-level counts. They must not be interpreted as 268 unique enrolments across all four exception categories.

#### 8.4 Recommended Actions

1. Clarify the business requirements for each affected exception rule.
2. Investigate open exceptions that conflict with current enrolment attributes.
3. Introduce historical attribute tracking where justified.
4. Reconcile exception statuses after source-record changes.
5. Establish a review process for potential false positives.

**Result: INVESTIGATION REQUIRED**

The investigation identified 327 occurrences requiring further assessment.

The available evidence does not establish that these are confirmed errors.

No source records were modified during this investigation.

---

### 9. SQL-to-Power BI Reconciliation (QA18)

**Validation date:** 8 October 2026

**Environment:** Power BI Desktop and documented SQL Server baseline

**Objective:** Verify that Power BI dashboard metrics reconcile with SQL results and that the underlying DAX measures implement the intended calculations.

#### 9.1 Dashboard Metric Reconciliation

| Metric | SQL Baseline | Power BI Result | Result |
|---|---:|---:|---|
| Total Enrolments | 10,075 | 10,075 | PASS |
| Affected Enrolments | 2,723 | 2,723 | PASS |
| Affected Rate | 27.03% | 27.03% | PASS |
| Total Exception Occurrences | 3,800 | 3,800 | PASS |
| Open Exceptions | 1,305 | 1,305 | PASS |

All five inspected dashboard metrics matched the documented baseline.

#### 9.2 DAX Measure Validation

The following Power BI measures were inspected.

**Total Enrolments**

`COUNTROWS(Enrolments)`

Counts the enrolment records in the current filter context.

**Affected Enrolments**

`DISTINCTCOUNT(Exceptions[EnrolmentID])`

Counts distinct enrolment identifiers associated with exception records.

This prevents enrolments with multiple exception occurrences from being counted multiple times.

**Affected Rate**

`DIVIDE([Affected Enrolments], [Total Enrolments])`

Calculates the proportion of enrolments affected by at least one recorded exception.

The measure returned 27.03% when formatted to two decimal places.

**Total Exception Occurrences**

`COUNTROWS(Exceptions)`

Counts the total exception records in the current filter context.

**Open Exceptions**

`CALCULATE([Total Exception Occurrences], Exceptions[RemediationStatus] = "Open")`

Counts exception occurrences with an Open remediation status.

The inspected measures were consistent with their intended calculation definitions.

#### 9.3 Additional Integrity Validation

A read-only DAX query was executed in Power BI Desktop to verify enrolment identifier uniqueness and identify blank enrolment references.

| Check | Expected | Actual | Result |
|---|---:|---:|---|
| Total enrolment rows | 10,075 | 10,075 | PASS |
| Unique enrolment IDs | 10,075 | 10,075 | PASS |
| Blank enrolment IDs | 0 | 0 | PASS |
| Blank exception enrolment IDs | 0 | 0 | PASS |

The query executed successfully.

The results confirmed that:

- The Enrolments table contained 10,075 records.
- All 10,075 enrolment identifiers were unique.
- No blank enrolment identifiers were detected in the Enrolments table.
- No blank enrolment references were detected in the Exceptions table.

#### 9.4 Outcome

**Result: PASS**

All five inspected Power BI metrics reconciled with the documented SQL baseline.

Their DAX measure definitions were reviewed, and the additional identifier-integrity checks passed.

This establishes reconciliation for the tested metrics. It does not independently validate every Power BI transformation, measure, relationship or visual.

---

### 10. Power BI Refresh Verification (QA19)

**Validation date:** 8 October 2026

**Environment:** Power BI Desktop — local QA backup copy

**File:** FATE_Data_Quality_Analysis_QA_Backup.pbix

**Objective:** Verify that the existing Power BI report can refresh without reported errors and that its principal analytical results remain consistent afterwards.

#### 10.1 Refresh Procedure

A separate backup copy of the Power BI project was created before testing.

The existing report was refreshed in Power BI Desktop.

The refresh was reported to have completed without errors.

Following the refresh, the Data Quality Overview page was inspected to verify the displayed results and visual integrity.

#### 10.2 Post-Refresh Reconciliation

| Metric | Expected | After Refresh | Result |
|---|---:|---:|---|
| Total Enrolments | 10,075 | 10,075 | PASS |
| Affected Enrolments | 2,723 | 2,723 | PASS |
| Affected Rate | 27.03% | 27.03% | PASS |
| Total Exception Occurrences | 3,800 | 3,800 | PASS |
| Open Exceptions | 1,305 | 1,305 | PASS |

All five inspected KPI values remained unchanged after the refresh.

#### 10.3 Visual Verification

The following four Overview page visualisations remained populated:

1. Affected Rate by Source System.
2. Open Rate by Exception Type.
3. Exception Volume by Type.
4. Exception Trend by Reporting Run.

No missing visuals or unexpected changes were identified in the reviewed Overview page.

#### 10.4 Outcome

**Result: PASS**

The refresh was reported as successful, and the inspected dashboard metrics and charts remained consistent.

This establishes refresh stability for the tested local Power BI report.

The test does not constitute verification of scheduled refresh in the Power BI Service or independently establish that the upstream source extract was complete.

---

### 11. Reporting-Run Coverage Investigation (QA20)

**Validation date:** 8 October 2026

**Environment:** SQL Server Management Studio — FATE_Analytics

**Objective:** Investigate the substantial decline in exception occurrences during the final reporting run and assess whether reporting coverage is comparable with previous runs.

#### 11.1 Reporting-Run Comparison

Six reporting runs were examined.

| Reporting Date | Exception Occurrences | Days Since Previous Run |
|---|---:|---:|
| 2 March 2026 | 614 | — |
| 16 March 2026 | 758 | 14 |
| 30 March 2026 | 743 | 14 |
| 13 April 2026 | 747 | 14 |
| 27 April 2026 | 720 | 14 |
| 11 May 2026 | 218 | 14 |
| **Total** | **3,800** | |

The final reporting run recorded 218 exception occurrences compared with 720 in the preceding run.

This represents:

- An absolute decrease of 502 exception occurrences.
- A proportional decrease of 69.72%.
- A continued reporting interval of 14 days.

The reporting schedule remained regular, but the final run's exception volume was substantially lower than earlier runs.

This warrants investigation before interpreting the reduction as an improvement.

#### 11.2 Exception Category Comparison

All seven exception categories remained represented in the final reporting run.

Every category experienced a reduction.

| Exception Code | 27 April | 11 May | Change |
|---|---:|---:|---:|
| EX01 | 136 | 23 | -83.09% |
| EX02 | 112 | 71 | -36.61% |
| EX03 | 65 | 13 | -80.00% |
| EX04 | 79 | 12 | -84.81% |
| EX05 | 83 | 48 | -42.17% |
| EX06 | 170 | 27 | -84.12% |
| EX07 | 75 | 24 | -68.00% |
| **Total** | **720** | **218** | **-69.72%** |

**Observations**

- All seven categories declined.
- EX06 experienced the largest absolute reduction, falling by 143 occurrences.
- EX04 experienced the largest proportional reduction at 84.81%.
- EX02 declined by 36.61%, considerably less than most other categories.

The anomaly was not restricted to a single exception category.

#### 11.3 Campus Comparison

Exception occurrences were compared across the eight FATE campuses using the current enrolment-to-campus relationships.

| Campus | 27 April | 11 May | Change |
|---|---:|---:|---:|
| Harbour City | 123 | 30 | -75.61% |
| Lakeside | 98 | 30 | -69.39% |
| Redgum | 91 | 25 | -72.53% |
| Metro South | 87 | 23 | -73.56% |
| Riverbend | 87 | 31 | -64.37% |
| Highland | 81 | 31 | -61.73% |
| Northgate | 80 | 26 | -67.50% |
| Greenfield | 73 | 22 | -69.86% |
| **Total** | **720** | **218** | **-69.72%** |

**Observations**

- All eight campuses appeared in both reporting runs.
- Every campus experienced a reduction.
- The reductions ranged from 61.73% to 75.61%.
- No campus was entirely absent from the final run's recorded exceptions.

The widespread decline indicates that the anomaly was not isolated to one campus.

However, the analysis does not establish that all expected enrolments were processed.

Campus relationships reflect current enrolment attributes and may not represent historical assignments at the time of each reporting run.

#### 11.4 Source-System Comparison

Exception occurrences were also compared across the two source systems.

| Source System | 27 April | 11 May | Change |
|---|---:|---:|---:|
| EBS Migrated | 201 | 61 | -69.65% |
| PeopleSoft | 519 | 157 | -69.75% |
| **Total** | **720** | **218** | **-69.72%** |

**Observations**

- Both source systems remained represented.
- EBS Migrated exception occurrences declined by 69.65%.
- PeopleSoft exception occurrences declined by 69.75%.
- The proportional reductions were nearly identical.

These results provide further evidence that the decline was widespread rather than restricted to a particular source system.

The source-system comparison uses currently recorded enrolment attributes.

#### 11.5 Consolidated Findings

The investigation established the following:

1. The final reporting run contained 502 fewer exception occurrences than the preceding run.
2. The decrease represented 69.72% of the preceding run's exception volume.
3. Reporting intervals remained consistent at 14 days.
4. All seven exception categories remained represented, but every category declined.
5. All eight campuses remained represented, but every campus declined.
6. Both source systems experienced nearly identical proportional declines.
7. The available data does not establish whether the final run processed the complete expected enrolment population.

The collective findings indicate a broad reporting anomaly.

The decline may reflect genuine operational improvement, reduced reporting coverage, changes in exception detection, differences in the processed population or other factors.

The available evidence cannot distinguish conclusively between these explanations.

#### 11.6 Limitations

The current dataset does not provide sufficient reporting-run metadata to determine:

- The number of enrolments evaluated during each reporting run.
- Whether the final reporting run completed all expected processing stages.
- Whether source extracts contained all expected records.
- Whether exception detection rules changed between reporting runs.
- Whether the observed reduction resulted from genuine remediation.
- Whether differences in the reporting population affected exception volumes.

Exception occurrence counts alone cannot establish source-population completeness.

The continued presence of every campus, exception category and source system does not prove that all expected records were processed.

Historical source-population counts, execution logs and reporting-run completeness indicators would be required for a definitive assessment.

#### 11.7 Recommended Actions

1. Introduce unique reporting-run identifiers and execution logs.
2. Record the expected and actual source-population counts for each reporting run.
3. Reconcile extracted, processed, rejected and successfully evaluated records.
4. Capture extraction timestamps, processing timestamps and run-completion statuses.
5. Maintain a record of data-quality rule versions and detection-logic changes.
6. Establish exception-volume anomaly thresholds.
7. Flag unusually large reporting changes for review before they are presented as operational improvements.
8. Introduce historical attribute tracking where necessary to support accurate comparisons.

#### 11.8 Outcome

**Result: INVESTIGATION REQUIRED**

The SQL investigations confirmed a 69.72% reduction in exception occurrences in the final reporting run.

The decline was widespread across exception categories, campuses and source systems.

However, the available evidence does not establish whether the reduction represents genuine improvement or incomplete reporting coverage.

Reporting completeness remains unverified.

No source records were modified during this investigation.

---

### 12. Outstanding Quality Checks

The following matters remain unresolved.

**QA17 — Exception-to-Source Reconciliation**

Potential inconsistencies identified during exception-to-source reconciliation require additional investigation and business-rule clarification.

The flagged occurrences must not be treated as confirmed errors without further evidence.

**QA20 — Reporting-Run Coverage**

The final reporting run recorded an unusually large decline in exception occurrences.

Additional reporting-run metadata, source-population reconciliation and execution evidence are required to establish whether the reporting population was complete and comparable.

**Status:** INVESTIGATION REQUIRED

QA18 SQL-to-Power BI reconciliation and QA19 local Power BI refresh verification have passed for the checks performed.

The outstanding QA17 and QA20 investigations do not invalidate those completed tests, but they limit the conclusions that can be drawn about the overall analytical solution.

---

### 13. General Limitations

The FATE dataset is synthetic and does not represent actual organisational records or operational performance.

The testing activities were performed against the available project environment and data.

Several limitations apply:

- Synthetic records may not reproduce every complexity encountered in production systems.
- Historical attribute snapshots are not available for every exception reporting date.
- Reporting-run metadata is insufficient to establish the completeness of every historical run.
- Successful SQL execution does not independently prove analytical correctness.
- Matching aggregated metrics does not validate every underlying data transformation.
- The local Power BI refresh test does not verify scheduled service refresh.
- Associations observed in the data do not independently establish root causes.
- Proposed process improvements and controls have not been demonstrated to be effective in an operational environment.

The identified risks and recommendations should be interpreted within these constraints.

---

### 14. Conclusion

The FATE testing and quality assurance activities established a documented validation baseline for the synthetic enrolment data quality analysis.

Database record counts, selected referential-integrity checks, business-rule validation checks and analytical aggregation reconciliations passed.

The principal SQL investigations executed successfully.

QA18 confirmed that five inspected Power BI metrics reconciled with the documented SQL baseline. The associated DAX measures were reviewed, and additional enrolment-identifier integrity checks passed.

QA19 confirmed that the locally refreshed Power BI report retained its expected KPI values and populated Overview page visualisations, based on the reported refresh outcome and post-refresh inspection.

Two investigations identified matters requiring further assessment.

QA17 flagged 327 exception occurrences for review due to potential inconsistencies between recorded exceptions and current enrolment attributes. These findings remain subject to historical-data limitations and business-rule clarification.

QA20 identified a 69.72% reduction in exception occurrences during the final reporting run. The decline affected all examined exception categories, campuses and source systems, but reporting completeness could not be established using the available data.

**Overall assessment: COMPLETED VALIDATION CHECKS PASSED; IDENTIFIED RISKS REMAIN UNDER INVESTIGATION.**

The completed tests support the reliability of the specific calculations and relationships examined. They do not establish that every aspect of the analytical solution or underlying reporting process has been fully validated.

The unresolved findings provide a basis for further data governance, reporting controls and continuous improvement.

No source records were modified as part of the QA17 or QA20 investigations.
