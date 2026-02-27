-- ============================================================
--  CAHPS / STAR RATINGS SQL PORTFOLIO
--  Author: Portfolio Project
--  Target Role: Healthcare Data Analyst (Entry Level)
--  Skills: JOINs, Aliases (AS), CASE WHEN, Aggregate Functions
-- ============================================================


-- ============================================================
-- SECTION 1: JOINs WITH ALIASES (AS)
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Member Survey Overview
-- Join members to their survey responses and health plan
-- Use case: Building a member-level CAHPS report
-- ------------------------------------------------------------
SELECT
    m.MemberID                                          AS Member_ID,
    CONCAT(m.MemberFirstName, ' ', m.MemberLastName)   AS Member_Name,
    m.State,
    hp.PlanName                                         AS Health_Plan,
    hp.PlanType                                         AS Plan_Type,
    hp.StarRating                                       AS Overall_Star_Rating,
    s.MeasurementYear                                   AS Survey_Year,
    s.HealthPlanRating                                  AS Plan_Rating_Score,
    s.DoctorCommunication                               AS Doctor_Communication_Score,
    s.CustomerService                                   AS Customer_Service_Score
FROM Member_T AS m
INNER JOIN CAHPSSurvey_T AS s  ON m.MemberID = s.MemberID
INNER JOIN HealthPlan_T  AS hp ON m.PlanID   = hp.PlanID
WHERE s.MeasurementYear = 2023
ORDER BY hp.StarRating DESC, m.MemberLastName;


-- ------------------------------------------------------------
-- 1.2 Plan-Level CAHPS Score Summary
-- Average scores per health plan for the measurement year
-- Use case: Comparing plan performance across CAHPS domains
-- ------------------------------------------------------------
SELECT
    hp.PlanName                         AS Health_Plan,
    hp.PlanType                         AS Plan_Type,
    hp.Region,
    hp.StarRating                       AS Overall_Star_Rating,
    COUNT(s.SurveyID)                   AS Total_Surveys,
    AVG(s.GettingCare)                  AS Avg_Getting_Care,
    AVG(s.CareQuickly)                  AS Avg_Care_Quickly,
    AVG(s.DoctorCommunication)          AS Avg_Doctor_Communication,
    AVG(s.HealthPlanRating)             AS Avg_Health_Plan_Rating,
    AVG(s.CustomerService)              AS Avg_Customer_Service
FROM HealthPlan_T AS hp
INNER JOIN CAHPSSurvey_T AS s ON hp.PlanID = s.PlanID
WHERE s.MeasurementYear = 2023
GROUP BY hp.PlanID, hp.PlanName, hp.PlanType, hp.Region, hp.StarRating
ORDER BY hp.StarRating DESC;


-- ------------------------------------------------------------
-- 1.3 Outreach Activity Report
-- Members who received outreach, joined with their plan info
-- Use case: Tracking quality improvement outreach efforts
-- ------------------------------------------------------------
SELECT
    CONCAT(m.MemberFirstName, ' ', m.MemberLastName) AS Member_Name,
    m.County,
    m.State,
    hp.PlanName                                       AS Health_Plan,
    o.OutreachDate                                    AS Date_of_Outreach,
    o.OutreachType                                    AS Contact_Method,
    o.OutreachReason                                  AS Reason,
    o.OutreachResult                                  AS Result
FROM Outreach_T AS o
INNER JOIN Member_T     AS m  ON o.MemberID = m.MemberID
INNER JOIN HealthPlan_T AS hp ON m.PlanID   = hp.PlanID
ORDER BY o.OutreachDate DESC;


-- ------------------------------------------------------------
-- 1.4 STAR Measure Performance by Plan
-- Join STAR measure scores to plan details
-- Use case: Identifying which CAHPS measures are dragging
--           down a plan's overall star rating
-- ------------------------------------------------------------
SELECT
    hp.PlanName                     AS Health_Plan,
    hp.StarRating                   AS Overall_Stars,
    sm.MeasureName                  AS CAHPS_Measure,
    sm.Score                        AS Measure_Score,
    sm.StarValue                    AS Measure_Stars
FROM STARMeasure_T  AS sm
INNER JOIN HealthPlan_T AS hp ON sm.PlanID = hp.PlanID
WHERE sm.MeasurementYear = 2023
  AND sm.MeasureType = 'CAHPS'
ORDER BY hp.StarRating DESC, sm.StarValue ASC;


-- ============================================================
-- SECTION 2: CASE WHEN (IF/THEN Logic)
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 Member Satisfaction Tier
-- Categorize each member's health plan rating into
-- satisfaction tiers using CASE WHEN
-- Use case: Segmenting members for targeted outreach
-- ------------------------------------------------------------
SELECT
    CONCAT(m.MemberFirstName, ' ', m.MemberLastName) AS Member_Name,
    hp.PlanName                                       AS Health_Plan,
    s.HealthPlanRating                                AS Plan_Rating,
    CASE
        WHEN s.HealthPlanRating >= 9 THEN 'Promoter'
        WHEN s.HealthPlanRating >= 7 THEN 'Neutral'
        WHEN s.HealthPlanRating >= 5 THEN 'At Risk'
        ELSE                              'Detractor'
    END                                               AS Satisfaction_Tier,
    s.MeasurementYear                                 AS Survey_Year
FROM CAHPSSurvey_T  AS s
INNER JOIN Member_T     AS m  ON s.MemberID = m.MemberID
INNER JOIN HealthPlan_T AS hp ON s.PlanID   = hp.PlanID
WHERE s.MeasurementYear = 2023
ORDER BY s.HealthPlanRating ASC;


-- ------------------------------------------------------------
-- 2.2 STAR Rating Performance Flag
-- Flag each plan's CAHPS measures as Above/At/Below target
-- Use case: Quality improvement prioritization
-- ------------------------------------------------------------
SELECT
    hp.PlanName                     AS Health_Plan,
    sm.MeasureName                  AS CAHPS_Measure,
    sm.Score                        AS Measure_Score,
    sm.StarValue                    AS Stars,
    CASE
        WHEN sm.StarValue >= 4 THEN 'Above Target'
        WHEN sm.StarValue =  3 THEN 'At Target'
        ELSE                        'Below Target — Needs Improvement'
    END                             AS Performance_Flag
FROM STARMeasure_T  AS sm
INNER JOIN HealthPlan_T AS hp ON sm.PlanID = hp.PlanID
WHERE sm.MeasurementYear = 2023
ORDER BY sm.StarValue ASC, sm.Score ASC;


-- ------------------------------------------------------------
-- 2.3 Outreach Effectiveness Classification
-- Classify outreach results and flag successful contacts
-- Use case: Measuring outreach campaign effectiveness
-- ------------------------------------------------------------
SELECT
    CONCAT(m.MemberFirstName, ' ', m.MemberLastName) AS Member_Name,
    hp.PlanName                                       AS Health_Plan,
    o.OutreachType                                    AS Contact_Method,
    o.OutreachResult                                  AS Result,
    CASE
        WHEN o.OutreachResult = 'Reached'   THEN 'Successful'
        WHEN o.OutreachResult = 'Voicemail' THEN 'Partial — Follow Up Needed'
        ELSE                                     'Unsuccessful — Re-attempt'
    END                                               AS Outreach_Status,
    CASE
        WHEN o.OutreachType = 'Phone' THEN 'High Touch'
        WHEN o.OutreachType = 'Mail'  THEN 'Low Touch'
        ELSE                               'Digital'
    END                                               AS Engagement_Level
FROM Outreach_T     AS o
INNER JOIN Member_T     AS m  ON o.MemberID = m.MemberID
INNER JOIN HealthPlan_T AS hp ON m.PlanID   = hp.PlanID
ORDER BY o.OutreachDate DESC;


-- ============================================================
-- SECTION 3: AGGREGATE FUNCTIONS (COUNT, AVG, SUM)
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 Plan Scorecard — Key CAHPS KPIs
-- Full aggregated scorecard per plan for reporting year
-- Use case: Executive summary / dashboard data feed
-- ------------------------------------------------------------
SELECT
    hp.PlanName                             AS Health_Plan,
    hp.Region,
    hp.StarRating                           AS Overall_Star_Rating,
    COUNT(s.SurveyID)                       AS Total_Surveys_Completed,
    ROUND(AVG(s.HealthPlanRating), 2)       AS Avg_Plan_Rating,
    ROUND(AVG(s.DoctorCommunication), 2)    AS Avg_Doctor_Communication,
    ROUND(AVG(s.CareQuickly), 2)            AS Avg_Care_Quickly,
    ROUND(AVG(s.CustomerService), 2)        AS Avg_Customer_Service,
    SUM(CASE WHEN s.HealthPlanRating >= 9
             THEN 1 ELSE 0 END)             AS Promoter_Count,
    SUM(CASE WHEN s.HealthPlanRating <= 6
             THEN 1 ELSE 0 END)             AS Detractor_Count
FROM HealthPlan_T   AS hp
INNER JOIN CAHPSSurvey_T AS s ON hp.PlanID = s.PlanID
WHERE s.MeasurementYear = 2023
GROUP BY hp.PlanID, hp.PlanName, hp.Region, hp.StarRating
ORDER BY hp.StarRating DESC;


-- ------------------------------------------------------------
-- 3.2 Year-Over-Year CAHPS Trend
-- Compare Health Plan Rating scores from 2022 to 2023
-- Use case: Tracking improvement or decline over time
-- ------------------------------------------------------------
SELECT
    hp.PlanName                                     AS Health_Plan,
    hp.StarRating                                   AS Current_Star_Rating,
    MAX(CASE WHEN sm.MeasurementYear = 2022
             THEN sm.Score END)                     AS Score_2022,
    MAX(CASE WHEN sm.MeasurementYear = 2023
             THEN sm.Score END)                     AS Score_2023,
    ROUND(
        MAX(CASE WHEN sm.MeasurementYear = 2023 THEN sm.Score END) -
        MAX(CASE WHEN sm.MeasurementYear = 2022 THEN sm.Score END)
    , 2)                                            AS Year_Over_Year_Change
FROM STARMeasure_T  AS sm
INNER JOIN HealthPlan_T AS hp ON sm.PlanID = hp.PlanID
WHERE sm.MeasureName = 'Rating of Health Plan'
GROUP BY hp.PlanID, hp.PlanName, hp.StarRating
ORDER BY Year_Over_Year_Change DESC;


-- ------------------------------------------------------------
-- 3.3 Outreach Summary by Plan
-- Count of outreach activities and success rate per plan
-- Use case: Quality team performance reporting
-- ------------------------------------------------------------
SELECT
    hp.PlanName                                     AS Health_Plan,
    COUNT(o.OutreachID)                             AS Total_Outreach_Attempts,
    SUM(CASE WHEN o.OutreachResult = 'Reached'
             THEN 1 ELSE 0 END)                     AS Successful_Contacts,
    ROUND(
        SUM(CASE WHEN o.OutreachResult = 'Reached'
                 THEN 1 ELSE 0 END) * 100.0
        / COUNT(o.OutreachID)
    , 1)                                            AS Success_Rate_Pct
FROM Outreach_T     AS o
INNER JOIN Member_T     AS m  ON o.MemberID = m.MemberID
INNER JOIN HealthPlan_T AS hp ON m.PlanID   = hp.PlanID
GROUP BY hp.PlanID, hp.PlanName
ORDER BY Success_Rate_Pct DESC;
