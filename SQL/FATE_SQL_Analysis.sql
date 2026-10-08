USE FATE_Analytics;
GO

/* =========================================================
   1. DUPLICATE RATE BY CAMPUS
   Normalise duplicate volume by campus enrolment population
   ========================================================= */

WITH CampusBase AS (
    SELECT
        CampusName,
        Region,
        COUNT(*) AS TotalEnrolments
    FROM dbo.Enrolments
    GROUP BY
        CampusName,
        Region
),
DuplicateAffected AS (
    SELECT
        e.CampusName,
        e.Region,
        COUNT(DISTINCT e.EnrolmentID) AS DuplicateAffectedEnrolments
    FROM dbo.Enrolments e
    INNER JOIN dbo.Exceptions x
        ON e.EnrolmentID = x.EnrolmentID
    WHERE x.ExceptionCode = 'EX03'
    GROUP BY
        e.CampusName,
        e.Region
)
SELECT
    b.CampusName,
    b.Region,
    b.TotalEnrolments,
    ISNULL(d.DuplicateAffectedEnrolments, 0) AS DuplicateAffectedEnrolments,
    CAST(
        ISNULL(d.DuplicateAffectedEnrolments, 0) * 100.0
        / b.TotalEnrolments
        AS DECIMAL(5,2)
    ) AS DuplicateAffectedRate
FROM CampusBase b
LEFT JOIN DuplicateAffected d
    ON b.CampusName = d.CampusName
    AND b.Region = d.Region
ORDER BY DuplicateAffectedRate DESC;


/* =========================================================
   2. WITHDRAWAL / REMEDIATION OVERLAP
   Check whether EX04 aligns to withdrawn enrolments
   ========================================================= */

SELECT
    e.EnrolmentStatus,
    COUNT(DISTINCT e.EnrolmentID) AS TotalEnrolments,
    COUNT(DISTINCT CASE
        WHEN x.ExceptionCode = 'EX04'
        THEN e.EnrolmentID
    END) AS WithdrawalOverlapAffected,
    CAST(
        COUNT(DISTINCT CASE
            WHEN x.ExceptionCode = 'EX04'
            THEN e.EnrolmentID
        END) * 100.0
        / COUNT(DISTINCT e.EnrolmentID)
        AS DECIMAL(5,2)
    ) AS WithdrawalOverlapRate
FROM dbo.Enrolments e
LEFT JOIN dbo.Exceptions x
    ON e.EnrolmentID = x.EnrolmentID
GROUP BY e.EnrolmentStatus
ORDER BY WithdrawalOverlapRate DESC;


/* =========================================================
   3. REMEDIATION PERFORMANCE BY EXCEPTION
   Backlog and average resolution time
   ========================================================= */

SELECT
    ExceptionCode,
    ExceptionType,
    COUNT(*) AS TotalOccurrences,

    SUM(
        CASE
            WHEN RemediationStatus = 'Open'
            THEN 1
            ELSE 0
        END
    ) AS OpenOccurrences,

    CAST(
        SUM(
            CASE
                WHEN RemediationStatus = 'Open'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS OpenRate,

    CAST(
        AVG(
            CASE
                WHEN ResolvedDate IS NOT NULL
                THEN DATEDIFF(DAY, ReportDate, ResolvedDate) * 1.0
            END
        )
        AS DECIMAL(5,2)
    ) AS AverageResolutionDays

FROM dbo.Exceptions
GROUP BY
    ExceptionCode,
    ExceptionType
ORDER BY OpenRate DESC;


/* =========================================================
   4. EXCEPTION TREND BY REPORTING RUN
   Determine whether exception workload is changing over time
   ========================================================= */

SELECT
    ReportDate,
    COUNT(*) AS ExceptionOccurrences,
    COUNT(DISTINCT EnrolmentID) AS AffectedEnrolments,

    SUM(
        CASE
            WHEN RemediationStatus = 'Open'
            THEN 1
            ELSE 0
        END
    ) AS OpenOccurrences,

    CAST(
        SUM(
            CASE
                WHEN RemediationStatus = 'Open'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS OpenRate

FROM dbo.Exceptions
GROUP BY ReportDate
ORDER BY ReportDate;


/* =========================================================
   5. DATA VALIDATION AND RECORD COUNTS
   Verify source tables against the project baseline
   ========================================================= */

SELECT 'Students' AS TableName, COUNT(*) AS TotalRecords
FROM dbo.Students

UNION ALL

SELECT 'Enrolments', COUNT(*)
FROM dbo.Enrolments

UNION ALL

SELECT 'Exceptions', COUNT(*)
FROM dbo.Exceptions

UNION ALL

SELECT 'DQ_Rules', COUNT(*)
FROM dbo.DQ_Rules;


/* =========================================================
   6. DATA INTEGRITY VALIDATION
   Check relationships and date consistency
   ========================================================= */

-- QA09: Exceptions without matching enrolments
SELECT
    'QA09 - Orphan Exceptions' AS TestName,
    COUNT(*) AS FailedRecords
FROM dbo.Exceptions x
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Enrolments e
    WHERE e.EnrolmentID = x.EnrolmentID
)

UNION ALL

-- QA10: Enrolments without matching students
SELECT
    'QA10 - Orphan Enrolments',
    COUNT(*)
FROM dbo.Enrolments e
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Students s
    WHERE s.StudentID = e.StudentID
)

UNION ALL

-- QA11: Resolution dates before reporting dates
SELECT
    'QA11 - Invalid Resolution Dates',
    COUNT(*)
FROM dbo.Exceptions
WHERE ResolvedDate < ReportDate;


/* =========================================================
   7. DATA QUALITY RULE COVERAGE
   QA12: Verify exception codes have matching rule IDs
   ========================================================= */

SELECT
    'QA12 - Missing DQ Rule' AS TestName,
    COUNT(*) AS FailedRecords
FROM dbo.Exceptions x
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.DQ_Rules r
    WHERE r.RuleID =
        CONCAT('DQ', RIGHT(x.ExceptionCode, 2))
)
OR x.ExceptionCode IS NULL
OR x.ExceptionCode NOT LIKE 'EX[0-9][0-9]';



/* =========================================================
   8. REMEDIATION AND RECORD CONSISTENCY
   QA13–QA16
   ========================================================= */

-- QA13: Invalid remediation statuses
SELECT
    'QA13 - Invalid Remediation Status' AS TestName,
    COUNT(*) AS FailedRecords
FROM dbo.Exceptions
WHERE RemediationStatus IS NULL
   OR RemediationStatus NOT IN ('Open', 'Resolved')

UNION ALL

-- QA14: Resolved exceptions without resolution dates
SELECT
    'QA14 - Resolved Without Date',
    COUNT(*)
FROM dbo.Exceptions
WHERE RemediationStatus = 'Resolved'
  AND ResolvedDate IS NULL

UNION ALL

-- QA15: Open exceptions with resolution dates
SELECT
    'QA15 - Open With Resolution Date',
    COUNT(*)
FROM dbo.Exceptions
WHERE RemediationStatus = 'Open'
  AND ResolvedDate IS NOT NULL

UNION ALL

-- QA16: Exception student differs from enrolment student
SELECT
    'QA16 - Student ID Mismatch',
    COUNT(*)
FROM dbo.Exceptions x
INNER JOIN dbo.Enrolments e
    ON x.EnrolmentID = e.EnrolmentID
WHERE x.StudentID <> e.StudentID
   OR x.StudentID IS NULL
   OR e.StudentID IS NULL;
