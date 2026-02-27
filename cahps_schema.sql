-- ============================================================
--  CAHPS / STAR RATINGS DATABASE SCHEMA & SEED DATA
--  Simulated health plan member experience dataset
--  Designed for: Healthcare Data Analyst Portfolio
-- ============================================================

-- ------------------------------------------------------------
-- TABLE 1: Health Plans
-- ------------------------------------------------------------
CREATE TABLE HealthPlan_T (
    PlanID          VARCHAR(10)  NOT NULL,
    PlanName        VARCHAR(60)  NOT NULL,
    PlanType        VARCHAR(20)  NOT NULL,  -- e.g. HMO, PPO, Medicare Advantage
    Region          VARCHAR(30)  NOT NULL,
    StarRating      DECIMAL(2,1),           -- Overall CMS Star Rating (1.0 - 5.0)
    ContractYear    INT          NOT NULL,
    CONSTRAINT HealthPlan_PK PRIMARY KEY (PlanID)
);

-- ------------------------------------------------------------
-- TABLE 2: Members
-- ------------------------------------------------------------
CREATE TABLE Member_T (
    MemberID        VARCHAR(10)  NOT NULL,
    PlanID          VARCHAR(10)  NOT NULL,
    MemberFirstName VARCHAR(25)  NOT NULL,
    MemberLastName  VARCHAR(25)  NOT NULL,
    DateOfBirth     DATE         NOT NULL,
    Gender          CHAR(1),                -- M / F / O
    County          VARCHAR(30),
    State           CHAR(2),
    EnrollmentDate  DATE         NOT NULL,
    CONSTRAINT Member_PK PRIMARY KEY (MemberID),
    CONSTRAINT Member_FK1 FOREIGN KEY (PlanID) REFERENCES HealthPlan_T(PlanID)
);

-- ------------------------------------------------------------
-- TABLE 3: CAHPS Survey Responses
-- Each row = one member's survey response for a measurement year
-- ------------------------------------------------------------
CREATE TABLE CAHPSSurvey_T (
    SurveyID            VARCHAR(10)  NOT NULL,
    MemberID            VARCHAR(10)  NOT NULL,
    PlanID              VARCHAR(10)  NOT NULL,
    MeasurementYear     INT          NOT NULL,
    SurveyDate          DATE         NOT NULL,

    -- Core CAHPS Composite Measures (0-10 scale)
    GettingCare         INT,   -- Getting Needed Care
    CareQuickly         INT,   -- Getting Care Quickly
    DoctorCommunication INT,   -- How Well Doctors Communicate
    HealthPlanRating    INT,   -- Rating of Health Plan (0-10)
    PCP_Rating          INT,   -- Rating of Personal Doctor (0-10)
    SpecialistRating    INT,   -- Rating of Specialist (0-10)

    -- Customer Service
    CustomerService     INT,   -- Rating of Customer Service (0-10)

    -- Response flag
    Completed           CHAR(1) DEFAULT 'Y',  -- Y/N

    CONSTRAINT CAHPSSurvey_PK PRIMARY KEY (SurveyID),
    CONSTRAINT CAHPSSurvey_FK1 FOREIGN KEY (MemberID) REFERENCES Member_T(MemberID),
    CONSTRAINT CAHPSSurvey_FK2 FOREIGN KEY (PlanID) REFERENCES HealthPlan_T(PlanID)
);

-- ------------------------------------------------------------
-- TABLE 4: STAR Measure Scores
-- One row per plan per measure per year
-- ------------------------------------------------------------
CREATE TABLE STARMeasure_T (
    MeasureID       VARCHAR(10)  NOT NULL,
    PlanID          VARCHAR(10)  NOT NULL,
    MeasurementYear INT          NOT NULL,
    MeasureName     VARCHAR(80)  NOT NULL,
    MeasureType     VARCHAR(30)  NOT NULL,  -- CAHPS, HEDIS, Administrative
    Score           DECIMAL(5,2),           -- Percentage or raw score
    StarValue       INT,                    -- 1-5 stars for this measure
    CONSTRAINT STARMeasure_PK PRIMARY KEY (MeasureID),
    CONSTRAINT STARMeasure_FK1 FOREIGN KEY (PlanID) REFERENCES HealthPlan_T(PlanID)
);

-- ------------------------------------------------------------
-- TABLE 5: Outreach Activities
-- Tracks member outreach attempts to improve CAHPS scores
-- ------------------------------------------------------------
CREATE TABLE Outreach_T (
    OutreachID      VARCHAR(10)  NOT NULL,
    MemberID        VARCHAR(10)  NOT NULL,
    OutreachDate    DATE         NOT NULL,
    OutreachType    VARCHAR(30)  NOT NULL,  -- Phone, Mail, Email, Portal
    OutreachReason  VARCHAR(60)  NOT NULL,  -- e.g. Survey follow-up, Care gap
    OutreachResult  VARCHAR(20)  NOT NULL,  -- Reached, Voicemail, No Answer
    CONSTRAINT Outreach_PK PRIMARY KEY (OutreachID),
    CONSTRAINT Outreach_FK1 FOREIGN KEY (MemberID) REFERENCES Member_T(MemberID)
);

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO HealthPlan_T (PlanID, PlanName, PlanType, Region, StarRating, ContractYear) VALUES
('HP001', 'ClearPath Medicare Advantage', 'Medicare Advantage', 'Southwest', 4.0, 2023),
('HP002', 'BlueStar Health HMO',          'HMO',                'Midwest',   3.5, 2023),
('HP003', 'PremierCare PPO',              'PPO',                'Northeast', 4.5, 2023),
('HP004', 'ValleyHealth Medicare',        'Medicare Advantage', 'West',      3.0, 2023),
('HP005', 'SunBridge HMO',               'HMO',                'Southeast', 3.5, 2023);

INSERT INTO Member_T (MemberID, PlanID, MemberFirstName, MemberLastName, DateOfBirth, Gender, County, State, EnrollmentDate) VALUES
('M001', 'HP001', 'Rosa',    'Delgado',   '1948-03-12', 'F', 'Maricopa',    'AZ', '2020-01-01'),
('M002', 'HP001', 'James',   'Whitfield', '1952-07-24', 'M', 'Pima',        'AZ', '2019-06-15'),
('M003', 'HP002', 'Linda',   'Nguyen',    '1955-11-30', 'F', 'Cook',        'IL', '2021-03-01'),
('M004', 'HP002', 'Carlos',  'Reyes',     '1943-05-08', 'M', 'DuPage',      'IL', '2018-09-01'),
('M005', 'HP003', 'Patricia','Okafor',    '1950-01-19', 'F', 'Suffolk',     'NY', '2020-07-01'),
('M006', 'HP003', 'David',   'Chen',      '1947-09-03', 'M', 'Nassau',      'NY', '2019-01-01'),
('M007', 'HP004', 'Angela',  'Morales',   '1960-04-22', 'F', 'Los Angeles', 'CA', '2022-01-01'),
('M008', 'HP004', 'Robert',  'Kim',       '1953-12-15', 'M', 'Orange',      'CA', '2021-11-01'),
('M009', 'HP005', 'Sandra',  'Williams',  '1958-08-07', 'F', 'Fulton',      'GA', '2020-04-01'),
('M010', 'HP005', 'Thomas',  'Jackson',   '1945-02-28', 'M', 'Gwinnett',    'GA', '2019-08-01'),
('M011', 'HP001', 'Maria',   'Hernandez', '1949-06-14', 'F', 'Maricopa',    'AZ', '2021-01-01'),
('M012', 'HP002', 'William', 'Thompson',  '1956-10-05', 'M', 'Cook',        'IL', '2020-02-01'),
('M013', 'HP003', 'Helen',   'Park',      '1951-03-27', 'F', 'Suffolk',     'NY', '2022-06-01'),
('M014', 'HP004', 'George',  'Martinez',  '1944-07-11', 'M', 'San Diego',   'CA', '2019-03-01'),
('M015', 'HP005', 'Dorothy', 'Robinson',  '1962-09-19', 'F', 'Fulton',      'GA', '2021-07-01');

INSERT INTO CAHPSSurvey_T (SurveyID, MemberID, PlanID, MeasurementYear, SurveyDate, GettingCare, CareQuickly, DoctorCommunication, HealthPlanRating, PCP_Rating, SpecialistRating, CustomerService, Completed) VALUES
('S001', 'M001', 'HP001', 2023, '2023-03-15', 9, 8, 9, 9, 10, 8, 9, 'Y'),
('S002', 'M002', 'HP001', 2023, '2023-03-20', 7, 6, 8, 7,  8, 7, 6, 'Y'),
('S003', 'M003', 'HP002', 2023, '2023-04-10', 6, 7, 7, 6,  7, 6, 7, 'Y'),
('S004', 'M004', 'HP002', 2023, '2023-04-15', 8, 8, 9, 8,  9, 8, 8, 'Y'),
('S005', 'M005', 'HP003', 2023, '2023-02-28', 10,9,10, 10, 10, 9,10, 'Y'),
('S006', 'M006', 'HP003', 2023, '2023-03-05', 9, 9, 9, 9,  9, 10, 9, 'Y'),
('S007', 'M007', 'HP004', 2023, '2023-05-12', 5, 5, 6, 5,  6,  5, 5, 'Y'),
('S008', 'M008', 'HP004', 2023, '2023-05-18', 6, 6, 7, 6,  7,  6, 6, 'Y'),
('S009', 'M009', 'HP005', 2023, '2023-06-01', 7, 8, 8, 8,  8,  7, 8, 'Y'),
('S010', 'M010', 'HP005', 2023, '2023-06-10', 8, 7, 9, 7,  9,  8, 7, 'Y'),
('S011', 'M011', 'HP001', 2023, '2023-03-25', 8, 9, 8, 8,  9,  8, 9, 'Y'),
('S012', 'M012', 'HP002', 2023, '2023-04-20', 5, 6, 6, 5,  6,  5, 6, 'Y'),
('S013', 'M013', 'HP003', 2023, '2023-03-10', 9, 8, 9, 9,  8,  9, 8, 'Y'),
('S014', 'M014', 'HP004', 2023, '2023-05-25', 4, 5, 5, 4,  5,  4, 5, 'Y'),
('S015', 'M015', 'HP005', 2023, '2023-06-15', 9, 8, 9, 8,  9,  8, 9, 'Y'),
-- 2022 data for trend analysis
('S016', 'M001', 'HP001', 2022, '2022-03-10', 8, 7, 8, 8,  9,  7, 8, 'Y'),
('S017', 'M003', 'HP002', 2022, '2022-04-05', 5, 6, 6, 5,  6,  5, 6, 'Y'),
('S018', 'M005', 'HP003', 2022, '2022-02-20', 9, 9,10, 9, 10,  9, 9, 'Y'),
('S019', 'M007', 'HP004', 2022, '2022-05-08', 4, 4, 5, 4,  5,  4, 4, 'Y'),
('S020', 'M009', 'HP005', 2022, '2022-06-05', 6, 7, 7, 7,  7,  6, 7, 'Y');

INSERT INTO STARMeasure_T (MeasureID, PlanID, MeasurementYear, MeasureName, MeasureType, Score, StarValue) VALUES
('SM001', 'HP001', 2023, 'Getting Needed Care',           'CAHPS', 87.50, 4),
('SM002', 'HP001', 2023, 'Getting Care Quickly',          'CAHPS', 82.30, 4),
('SM003', 'HP001', 2023, 'How Well Doctors Communicate',  'CAHPS', 91.20, 5),
('SM004', 'HP001', 2023, 'Rating of Health Plan',         'CAHPS', 80.00, 4),
('SM005', 'HP001', 2023, 'Customer Service',              'CAHPS', 83.40, 4),
('SM006', 'HP002', 2023, 'Getting Needed Care',           'CAHPS', 72.10, 3),
('SM007', 'HP002', 2023, 'Getting Care Quickly',          'CAHPS', 74.50, 3),
('SM008', 'HP002', 2023, 'How Well Doctors Communicate',  'CAHPS', 78.90, 3),
('SM009', 'HP002', 2023, 'Rating of Health Plan',         'CAHPS', 68.00, 3),
('SM010', 'HP002', 2023, 'Customer Service',              'CAHPS', 71.20, 3),
('SM011', 'HP003', 2023, 'Getting Needed Care',           'CAHPS', 95.30, 5),
('SM012', 'HP003', 2023, 'Getting Care Quickly',          'CAHPS', 93.10, 5),
('SM013', 'HP003', 2023, 'How Well Doctors Communicate',  'CAHPS', 97.40, 5),
('SM014', 'HP003', 2023, 'Rating of Health Plan',         'CAHPS', 94.00, 5),
('SM015', 'HP003', 2023, 'Customer Service',              'CAHPS', 96.20, 5),
('SM016', 'HP004', 2023, 'Getting Needed Care',           'CAHPS', 61.40, 2),
('SM017', 'HP004', 2023, 'Getting Care Quickly',          'CAHPS', 63.20, 2),
('SM018', 'HP004', 2023, 'How Well Doctors Communicate',  'CAHPS', 67.80, 3),
('SM019', 'HP004', 2023, 'Rating of Health Plan',         'CAHPS', 58.00, 2),
('SM020', 'HP004', 2023, 'Customer Service',              'CAHPS', 60.50, 2),
('SM021', 'HP005', 2023, 'Getting Needed Care',           'CAHPS', 80.20, 4),
('SM022', 'HP005', 2023, 'Getting Care Quickly',          'CAHPS', 78.90, 3),
('SM023', 'HP005', 2023, 'How Well Doctors Communicate',  'CAHPS', 85.60, 4),
('SM024', 'HP005', 2023, 'Rating of Health Plan',         'CAHPS', 77.50, 3),
('SM025', 'HP005', 2023, 'Customer Service',              'CAHPS', 81.30, 4),
-- 2022 scores for trend analysis
('SM026', 'HP001', 2022, 'Rating of Health Plan',         'CAHPS', 76.00, 3),
('SM027', 'HP002', 2022, 'Rating of Health Plan',         'CAHPS', 65.00, 2),
('SM028', 'HP003', 2022, 'Rating of Health Plan',         'CAHPS', 91.00, 5),
('SM029', 'HP004', 2022, 'Rating of Health Plan',         'CAHPS', 54.00, 2),
('SM030', 'HP005', 2022, 'Rating of Health Plan',         'CAHPS', 72.00, 3);

INSERT INTO Outreach_T (OutreachID, MemberID, OutreachDate, OutreachType, OutreachReason, OutreachResult) VALUES
('O001', 'M007', '2023-06-01', 'Phone', 'Low CAHPS score follow-up',    'Reached'),
('O002', 'M007', '2023-06-15', 'Mail',  'Care satisfaction survey',     'No Answer'),
('O003', 'M014', '2023-06-03', 'Phone', 'Low CAHPS score follow-up',    'Voicemail'),
('O004', 'M014', '2023-06-20', 'Email', 'Care satisfaction survey',     'Reached'),
('O005', 'M012', '2023-05-10', 'Phone', 'Survey non-responder outreach','Reached'),
('O006', 'M004', '2023-05-15', 'Phone', 'Care gap closure',             'Reached'),
('O007', 'M002', '2023-04-01', 'Email', 'Survey follow-up',             'Reached'),
('O008', 'M008', '2023-06-25', 'Phone', 'Low CAHPS score follow-up',    'Voicemail'),
('O009', 'M008', '2023-07-05', 'Phone', 'Low CAHPS score follow-up',    'Reached'),
('O010', 'M001', '2023-04-10', 'Portal','Member satisfaction check-in', 'Reached');
