
/*
============================================================
FATE — FICTIONAL ACADEMY OF TRAINING AND EDUCATION

QA20: REPORTING-RUN COVERAGE INVESTIGATION

Purpose:
Investigate the substantial decline in recorded exception
occurrences during the final reporting run.

Database: FATE_Analytics
Platform: Microsoft SQL Server / T-SQL
Validation date: 8 October 2026

Investigations:
1. Reporting-run trends
2. Exception-category comparison
3. Campus comparison
4. Source-system comparison

Important:
All queries are read-only.

A reduction in exception occurrences does not independently
prove improved data quality or complete reporting coverage.
============================================================
*/

USE FATE_Analytics;
GO


/* =========================================================
   QA20.1 — REPORTING-RUN TREND

   Compare exception volumes, reporting intervals,
   affected enrolments and open exceptions.
========================================================= */

;WITH RunSummary AS (

    SELECT
        CAST(ReportDate AS DATE) AS ReportingDate,

        COUNT(*) AS ExceptionOccurrences,

        COUNT(DISTINCT EnrolmentID)
            AS AffectedEnrolments,

        COUNT(DISTINCT ExceptionCode)
            AS ExceptionTypes,

        SUM(
            CASE
                WHEN RemediationStatus = 'Open'
                THEN 1
                ELSE 0
            END
        ) AS OpenExceptions

    FROM dbo.Exceptions

    GROUP BY CAST(ReportDate AS DATE)

),

RunComparison AS (

    SELECT
        *,

        LAG(ExceptionOccurrences) OVER (
            ORDER BY ReportingDate
        ) AS PreviousRunOccurrences,

        LAG(ReportingDate) OVER (
            ORDER BY ReportingDate
        ) AS PreviousRunDate

    FROM RunSummary

)

SELECT
    ReportingDate,
    ExceptionOccurrences,
    AffectedEnrolments,
    ExceptionTypes,
    OpenExceptions,
    PreviousRunOccurrences,

    CAST(
        (ExceptionOccurrences - PreviousRunOccurrences)
        * 100.0
        / NULLIF(PreviousRunOccurrences, 0)
        AS DECIMAL(8, 2)
    ) AS ChangeFromPreviousPct,

    DATEDIFF(
        DAY,
        PreviousRunDate,
        ReportingDate
    ) AS DaysSincePreviousRun

FROM RunComparison

ORDER BY ReportingDate;


/*
Expected historical observation:

27 April 2026: 720 exception occurrences
11 May 2026:   218 exception occurrences

Difference: -502
Change:     -69.72%

Reporting interval: 14 days

The cause of the decline remains unverified.
*/


/* =========================================================
   QA20.2 — EXCEPTION CATEGORY COMPARISON

   Compare exception occurrences across the final
   two reporting runs.
========================================================= */

;WITH CategoryComparison AS (

    SELECT
        ExceptionCode,

        SUM(
            CASE
                WHEN CAST(ReportDate AS DATE)
                     = '2026-04-27'
                THEN 1
                ELSE 0
            END
        ) AS PreviousRun,

        SUM(
            CASE
                WHEN CAST(ReportDate AS DATE)
                     = '2026-05-11'
                THEN 1
                ELSE 0
            END
        ) AS FinalRun

    FROM dbo.Exceptions

    WHERE CAST(ReportDate AS DATE)
          IN ('2026-04-27', '2026-05-11')

    GROUP BY ExceptionCode

)

SELECT
    ExceptionCode,
    PreviousRun,
    FinalRun,

    FinalRun - PreviousRun AS Difference,

    CAST(
        (FinalRun - PreviousRun) * 100.0
        / NULLIF(PreviousRun, 0)
        AS DECIMAL(8, 2)
    ) AS ChangePct

FROM CategoryComparison

ORDER BY ExceptionCode;


/*
Historical finding:

All seven exception categories remained represented.

All seven recorded reductions.

This indicates that the decline was not restricted
to a single exception category.
*/


/* =========================================================
   QA20.3 — CAMPUS COVERAGE COMPARISON

   Compare exception occurrences by campus across
   the final two reporting runs.

   Note:
   Campus assignments are taken from the currently
   recorded enrolment attributes.

   This comparison does not independently establish
   historical source-population completeness.
========================================================= */

;WITH CampusComparison AS (

    SELECT

        COALESCE(
            en.CampusName,
            'Unknown / Unmatched'
        ) AS Campus,

        SUM(
            CASE
                WHEN CAST(ex.ReportDate AS DATE)
                     = '2026-04-27'
                THEN 1
                ELSE 0
            END
        ) AS PreviousRun,

        SUM(
            CASE
                WHEN CAST(ex.ReportDate AS DATE)
                     = '2026-05-11'
                THEN 1
                ELSE 0
            END
        ) AS FinalRun

    FROM dbo.Exceptions AS ex

    LEFT JOIN dbo.Enrolments AS en
        ON ex.EnrolmentID = en.EnrolmentID

    WHERE CAST(ex.ReportDate AS DATE)
          IN ('2026-04-27', '2026-05-11')

    GROUP BY
        COALESCE(
            en.CampusName,
            'Unknown / Unmatched'
        )

)

SELECT
    Campus,
    PreviousRun,
    FinalRun,

    FinalRun - PreviousRun AS Difference,

    CAST(
        (FinalRun - PreviousRun) * 100.0
        / NULLIF(PreviousRun, 0)
        AS DECIMAL(8, 2)
    ) AS ChangePct

FROM CampusComparison

ORDER BY PreviousRun DESC;


/*
Historical finding:

All eight campuses remained represented in both runs.

Every campus recorded a substantial decline.

This does not establish that the final reporting run
processed all expected enrolments.
*/


/* =========================================================
   QA20.4 — SOURCE SYSTEM COMPARISON

   Compare EBS Migrated and PeopleSoft exception
   occurrences across the final two reporting runs.

   Note:
   Source-system assignments are taken from current
   enrolment attributes.
========================================================= */

;WITH SourceComparison AS (

    SELECT

        COALESCE(
            en.SourceSystem,
            'Unknown / Unmatched'
        ) AS SourceSystem,

        SUM(
            CASE
                WHEN CAST(ex.ReportDate AS DATE)
                     = '2026-04-27'
                THEN 1
                ELSE 0
            END
        ) AS PreviousRun,

        SUM(
            CASE
                WHEN CAST(ex.ReportDate AS DATE)
                     = '2026-05-11'
                THEN 1
                ELSE 0
            END
        ) AS FinalRun

    FROM dbo.Exceptions AS ex

    LEFT JOIN dbo.Enrolments AS en
        ON ex.EnrolmentID = en.EnrolmentID

    WHERE CAST(ex.ReportDate AS DATE)
          IN ('2026-04-27', '2026-05-11')

    GROUP BY
        COALESCE(
            en.SourceSystem,
            'Unknown / Unmatched'
        )

)

SELECT
    SourceSystem,
    PreviousRun,
    FinalRun,

    FinalRun - PreviousRun AS Difference,

    CAST(
        (FinalRun - PreviousRun) * 100.0
        / NULLIF(PreviousRun, 0)
        AS DECIMAL(8, 2)
    ) AS ChangePct

FROM SourceComparison

ORDER BY SourceSystem;


/*
Historical findings:

EBS Migrated:
201 -> 61 (-69.65%)

PeopleSoft:
519 -> 157 (-69.75%)

Both systems experienced nearly identical proportional
reductions in recorded exception occurrences.
*/


/* =========================================================
   QA20 — OVERALL ASSESSMENT

   Result: INVESTIGATION REQUIRED

   Confirmed observations:

   - Final-run exception occurrences decreased by 69.72%.
   - Reporting intervals remained consistent.
   - All seven exception categories declined.
   - All eight campuses declined.
   - Both source systems declined.

   Not established:

   - Whether the final source extract was complete.
   - Whether all expected enrolments were evaluated.
   - Whether detection rules changed.
   - Whether the decline represents genuine improvement.

   Recommended additional evidence:

   - Reporting-run execution logs.
   - Expected and processed enrolment counts.
   - Extract completeness checks.
   - Rule-version history.
   - Historical source-population snapshots.

   The investigation identifies a reporting-coverage risk.
   It does not establish the cause of that risk.

   No database records are modified by this script.
========================================================= */
