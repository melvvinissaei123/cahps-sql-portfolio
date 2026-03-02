-- ============================================================
--  CMS 2025 STAR RATINGS DATABASE SCHEMA
--  Source: CMS Part C & D Performance Data (public)
--  https://www.cms.gov/medicare/health-drug-plans/part-c-d-performance-data
--  Designed for: Healthcare Data Analyst Portfolio
-- ============================================================

CREATE DATABASE IF NOT EXISTS cms_stars_2025;
USE cms_stars_2025;

-- ------------------------------------------------------------
-- TABLE 1: Plan Summary
-- Overall STAR ratings per Medicare Advantage contract
-- ------------------------------------------------------------
CREATE TABLE PlanSummary_T (
    ContractID          VARCHAR(10)  NOT NULL,
    MarketingName       VARCHAR(100),
    ParentOrg           VARCHAR(100),
    OrgType             VARCHAR(50),
    OverallStarRating   VARCHAR(10),   -- 2, 2.5, 3, 3.5, 4, 4.5, 5
    PartCSummary        VARCHAR(10),
    CONSTRAINT PlanSummary_PK PRIMARY KEY (ContractID)
);

-- ------------------------------------------------------------
-- TABLE 2: Domain Star Ratings
-- CMS rates plans across 5 Part C domains
-- HD3 = Member Experience (CAHPS) — our focus
-- ------------------------------------------------------------
CREATE TABLE DomainStars_T (
    ContractID              VARCHAR(10)  NOT NULL,
    HD1_StayingHealthy      VARCHAR(10),
    HD2_ChronicConditions   VARCHAR(10),
    HD3_MemberExperience    VARCHAR(10),  -- CAHPS domain
    HD4_Complaints          VARCHAR(10),
    HD5_CustomerService     VARCHAR(10),
    CONSTRAINT DomainStars_PK PRIMARY KEY (ContractID),
    CONSTRAINT DomainStars_FK FOREIGN KEY (ContractID) REFERENCES PlanSummary_T(ContractID)
);

-- ------------------------------------------------------------
-- TABLE 3: CAHPS Measure Star Ratings
-- Individual CAHPS measure scores (1-5 stars each)
-- These are the 6 measures that make up HD3
-- ------------------------------------------------------------
CREATE TABLE CAHPSMeasures_T (
    ContractID              VARCHAR(10)  NOT NULL,
    C19_GettingNeededCare   VARCHAR(10),
    C20_GettingCareQuickly  VARCHAR(10),
    C21_CustomerService     VARCHAR(10),
    C22_RatingHealthQuality VARCHAR(10),
    C23_RatingHealthPlan    VARCHAR(10),
    C24_CareCoordination    VARCHAR(10),
    CONSTRAINT CAHPSMeasures_PK PRIMARY KEY (ContractID),
    CONSTRAINT CAHPSMeasures_FK FOREIGN KEY (ContractID) REFERENCES PlanSummary_T(ContractID)
);
