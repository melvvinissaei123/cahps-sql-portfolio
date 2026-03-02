-- ============================================================
--  CMS 2025 STAR RATINGS — SQL PORTFOLIO QUERIES
--  Author: Melvin Issaei
--  Data Source: CMS Part C & D Performance Data (public)
--  Target Role: Healthcare Data Analyst (Entry Level)
--
--  THE PROBLEM I'M SOLVING:
--  Medicare Advantage health plans live and die by their STAR
--  ratings. A plan that hits 4+ stars earns CMS quality bonus
--  payments worth millions. CAHPS (member experience) scores
--  are notoriously hard to move — and often the difference
--  between a 3.5 and 4-star plan.
--
--  This analysis uses real 2025 CMS data to identify which
--  CAHPS measures separate high performers from low performers,
--  and what patterns exist across plan types and parent orgs.
--
--  Skills: JOINs, Aliases (AS), CASE WHEN, Aggregate Functions
-- ============================================================

USE cms_stars_2025;

-- ============================================================
-- SECTION 1: JOINs WITH ALIASES (AS)
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Full Plan CAHPS Profile
-- Join all 3 tables to get a complete picture of each plan
-- Use case: Building a plan-level quality scorecard
-- ------------------------------------------------------------
SELECT
    p.ContractID                                    AS Contract_ID,
    p.MarketingName                                 AS Plan_Name,
    p.ParentOrg                                     AS Parent_Organization,
    p.OrgType                                       AS Plan_Type,
    p.OverallStarRating                             AS Overall_Stars,
    d.HD3_MemberExperience                          AS CAHPS_Domain_Stars,
    c.C19_GettingNeededCare                         AS Getting_Needed_Care,
    c.C20_GettingCareQuickly                        AS Getting_Care_Quickly,
    c.C21_CustomerService                           AS Customer_Service,
    c.C22_RatingHealthQuality                       AS Rating_Health_Quality,
    c.C23_RatingHealthPlan                          AS Rating_Health_Plan,
    c.C24_CareCoordination                          AS Care_Coordination
FROM PlanSummary_T    AS p
INNER JOIN DomainStars_T   AS d ON p.ContractID = d.ContractID
INNER JOIN CAHPSMeasures_T AS c ON p.ContractID = c.ContractID
WHERE p.OverallStarRating NOT IN ('Not enough data available', 'Plan not required to report measure')
  AND d.HD3_MemberExperience NOT IN ('Not enough data available', 'Plan not required to report measure')
ORDER BY p.OverallStarRating DESC;


-- ------------------------------------------------------------
-- 1.2 High vs Low Performing Plans — CAHPS Snapshot
-- Compare CAHPS domain scores for 4+ star vs 3 star plans
-- Use case: Identifying what separates top plans from average
-- ------------------------------------------------------------
SELECT
    p.MarketingName                 AS Plan_Name,
    p.ParentOrg                     AS Parent_Org,
    p.OverallStarRating             AS Overall_Stars,
    d.HD3_MemberExperience          AS CAHPS_Domain_Stars,
    d.HD1_StayingHealthy            AS Preventive_Care_Stars,
    d.HD2_ChronicConditions         AS Chronic_Care_Stars,
    d.HD4_Complaints                AS Complaints_Stars,
    d.HD5_CustomerService           AS Customer_Service_Stars
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE p.OverallStarRating IN ('4', '4.5', '5')
  AND d.HD3_MemberExperience NOT IN ('Not enough data available', 'Plan not required to report measure')
ORDER BY d.HD3_MemberExperience DESC, p.OverallStarRating DESC;


-- ------------------------------------------------------------
-- 1.3 Parent Organization CAHPS Performance
-- Which parent orgs (Humana, Centene, UHC etc.) perform best
-- Use case: Benchmarking competitors — real mPulse use case
-- ------------------------------------------------------------
SELECT
    p.ParentOrg                     AS Parent_Organization,
    COUNT(p.ContractID)             AS Total_Contracts,
    p.OverallStarRating             AS Overall_Stars,
    d.HD3_MemberExperience          AS CAHPS_Domain_Stars
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE p.ParentOrg IN ('Humana Inc. ', 'UnitedHealth Group, Inc. ', 'Centene Corporation ', 'CVS Health ', 'Kaiser Foundation Health Plan, Inc. ')
  AND d.HD3_MemberExperience NOT IN ('Not enough data available', 'Plan not required to report measure')
GROUP BY p.ParentOrg, p.OverallStarRating, d.HD3_MemberExperience
ORDER BY p.ParentOrg, p.OverallStarRating DESC;


-- ============================================================
-- SECTION 2: CASE WHEN (IF/THEN Logic)
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 Star Rating Performance Tier
-- Categorize every plan into a business-relevant tier
-- Use case: Segmenting plans for quality improvement outreach
-- This is exactly how mPulse targets health plan customers
-- ------------------------------------------------------------
SELECT
    p.MarketingName                 AS Plan_Name,
    p.ParentOrg                     AS Parent_Org,
    p.OverallStarRating             AS Overall_Stars,
    d.HD3_MemberExperience          AS CAHPS_Stars,
    CASE
        WHEN p.OverallStarRating = '5'   THEN '5-Star — Elite'
        WHEN p.OverallStarRating = '4.5' THEN '4.5-Star — High Performer'
        WHEN p.OverallStarRating = '4'   THEN '4-Star — Bonus Eligible'
        WHEN p.OverallStarRating = '3.5' THEN '3.5-Star — Near Threshold'
        WHEN p.OverallStarRating = '3'   THEN '3-Star — Below Threshold'
        ELSE                              '2.5 or Below — At Risk'
    END                             AS Performance_Tier,
    CASE
        WHEN p.OverallStarRating IN ('4','4.5','5') THEN 'Earns Quality Bonus Payment'
        ELSE 'Does NOT earn Quality Bonus Payment'
    END                             AS Bonus_Status
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE d.HD3_MemberExperience NOT IN ('Not enough data available','Plan not required to report measure')
ORDER BY p.OverallStarRating DESC;


-- ------------------------------------------------------------
-- 2.2 CAHPS Member Experience Gap Analysis
-- Flag plans where CAHPS score is LOWER than overall rating
-- These plans have strong clinical scores but weak member experience
-- Use case: Identifying which plans need CAHPS-specific outreach
-- ------------------------------------------------------------
SELECT
    p.MarketingName                 AS Plan_Name,
    p.ParentOrg                     AS Parent_Org,
    p.OverallStarRating             AS Overall_Stars,
    d.HD3_MemberExperience          AS CAHPS_Stars,
    CASE
        WHEN d.HD3_MemberExperience > p.OverallStarRating
            THEN 'CAHPS Strength — Member experience exceeds overall'
        WHEN d.HD3_MemberExperience = p.OverallStarRating
            THEN 'CAHPS Aligned — Member experience matches overall'
        WHEN d.HD3_MemberExperience < p.OverallStarRating
            THEN 'CAHPS Gap — Member experience is dragging overall rating'
        ELSE 'Insufficient data'
    END                             AS CAHPS_Assessment
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE p.OverallStarRating NOT IN ('Not enough data available','Plan not required to report measure')
  AND d.HD3_MemberExperience NOT IN ('Not enough data available','Plan not required to report measure')
ORDER BY CAHPS_Assessment, p.OverallStarRating DESC;


-- ------------------------------------------------------------
-- 2.3 Individual CAHPS Measure Weakness Flag
-- Flag which specific CAHPS measure is the weakest per plan
-- Use case: Telling a plan exactly where to focus improvement
-- ------------------------------------------------------------
SELECT
    p.MarketingName                 AS Plan_Name,
    p.OverallStarRating             AS Overall_Stars,
    c.C19_GettingNeededCare         AS Getting_Needed_Care,
    c.C20_GettingCareQuickly        AS Getting_Care_Quickly,
    c.C21_CustomerService           AS Customer_Service,
    c.C22_RatingHealthQuality       AS Rating_Health_Quality,
    c.C23_RatingHealthPlan          AS Rating_Health_Plan,
    c.C24_CareCoordination          AS Care_Coordination,
    CASE
        WHEN c.C23_RatingHealthPlan = '2' OR c.C23_RatingHealthPlan = '3'
            THEN 'Priority: Rating of Health Plan is low'
        WHEN c.C19_GettingNeededCare = '2' OR c.C19_GettingNeededCare = '3'
            THEN 'Priority: Getting Needed Care is low'
        WHEN c.C20_GettingCareQuickly = '2' OR c.C20_GettingCareQuickly = '3'
            THEN 'Priority: Getting Care Quickly is low'
        WHEN c.C24_CareCoordination = '2' OR c.C24_CareCoordination = '3'
            THEN 'Priority: Care Coordination is low'
        ELSE 'No critical CAHPS weakness identified'
    END                             AS Top_CAHPS_Priority
FROM PlanSummary_T    AS p
INNER JOIN CAHPSMeasures_T AS c ON p.ContractID = c.ContractID
WHERE p.OverallStarRating IN ('3', '3.5')
  AND c.C23_RatingHealthPlan NOT IN ('Not enough data available','Plan not required to report measure','No data available')
ORDER BY p.OverallStarRating DESC;


-- ============================================================
-- SECTION 3: AGGREGATE FUNCTIONS (COUNT, AVG, SUM)
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 CAHPS Performance Summary by Star Rating Group
-- Average CAHPS domain score for each star rating tier
-- Use case: Proving CAHPS scores correlate with overall rating
-- This is the core insight of the entire project
-- ------------------------------------------------------------
SELECT
    p.OverallStarRating                             AS Overall_Stars,
    COUNT(p.ContractID)                             AS Total_Plans,
    ROUND(AVG(CAST(d.HD3_MemberExperience AS DECIMAL(3,1))), 2)
                                                    AS Avg_CAHPS_Domain_Score,
    SUM(CASE WHEN d.HD3_MemberExperience >= '4' THEN 1 ELSE 0 END)
                                                    AS Plans_With_Strong_CAHPS,
    SUM(CASE WHEN d.HD3_MemberExperience <= '3' THEN 1 ELSE 0 END)
                                                    AS Plans_With_Weak_CAHPS
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE p.OverallStarRating IN ('2.5','3','3.5','4','4.5','5')
  AND d.HD3_MemberExperience NOT IN ('Not enough data available','Plan not required to report measure','No data available')
  AND d.HD3_MemberExperience REGEXP '^[0-9]'
GROUP BY p.OverallStarRating
ORDER BY p.OverallStarRating DESC;


-- ------------------------------------------------------------
-- 3.2 Top Parent Organizations by CAHPS Performance
-- Which health plan families consistently score well on CAHPS?
-- Use case: Competitive benchmarking across parent orgs
-- ------------------------------------------------------------
SELECT
    p.ParentOrg                                     AS Parent_Organization,
    COUNT(p.ContractID)                             AS Total_Contracts,
    ROUND(AVG(CAST(p.OverallStarRating AS DECIMAL(3,1))), 2)
                                                    AS Avg_Overall_Stars,
    ROUND(AVG(CAST(d.HD3_MemberExperience AS DECIMAL(3,1))), 2)
                                                    AS Avg_CAHPS_Stars,
    SUM(CASE WHEN p.OverallStarRating >= '4' THEN 1 ELSE 0 END)
                                                    AS Contracts_4_Stars_Or_Above
FROM PlanSummary_T  AS p
INNER JOIN DomainStars_T AS d ON p.ContractID = d.ContractID
WHERE p.OverallStarRating REGEXP '^[0-9]'
  AND d.HD3_MemberExperience REGEXP '^[0-9]'
GROUP BY p.ParentOrg
HAVING COUNT(p.ContractID) >= 3
ORDER BY Avg_CAHPS_Stars DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 3.3 CAHPS Measure Breakdown for 3.5-Star Plans
-- For plans just below the 4-star bonus threshold,
-- which CAHPS measures are holding them back?
-- Use case: Targeted quality improvement recommendations
-- ------------------------------------------------------------
SELECT
    COUNT(p.ContractID)                             AS Total_35_Star_Plans,
    ROUND(AVG(CASE WHEN c.C19_GettingNeededCare REGEXP '^[0-9]'
              THEN CAST(c.C19_GettingNeededCare AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Getting_Needed_Care,
    ROUND(AVG(CASE WHEN c.C20_GettingCareQuickly REGEXP '^[0-9]'
              THEN CAST(c.C20_GettingCareQuickly AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Getting_Care_Quickly,
    ROUND(AVG(CASE WHEN c.C21_CustomerService REGEXP '^[0-9]'
              THEN CAST(c.C21_CustomerService AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Customer_Service,
    ROUND(AVG(CASE WHEN c.C22_RatingHealthQuality REGEXP '^[0-9]'
              THEN CAST(c.C22_RatingHealthQuality AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Rating_Health_Quality,
    ROUND(AVG(CASE WHEN c.C23_RatingHealthPlan REGEXP '^[0-9]'
              THEN CAST(c.C23_RatingHealthPlan AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Rating_Health_Plan,
    ROUND(AVG(CASE WHEN c.C24_CareCoordination REGEXP '^[0-9]'
              THEN CAST(c.C24_CareCoordination AS DECIMAL(3,1)) END), 2)
                                                    AS Avg_Care_Coordination
FROM PlanSummary_T    AS p
INNER JOIN CAHPSMeasures_T AS c ON p.ContractID = c.ContractID
WHERE p.OverallStarRating = '3.5';
