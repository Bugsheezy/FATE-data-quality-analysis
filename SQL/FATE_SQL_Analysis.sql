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