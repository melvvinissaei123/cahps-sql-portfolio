-- ============================================================
--  HOSPITAL DATABASE SQL PORTFOLIO
--  Author: Portfolio Project
--  Database: MySQL
--  Techniques Demonstrated: JOINs, Subqueries
-- ============================================================


-- ============================================================
-- SECTION 1: JOINs
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 INNER JOIN
-- List all appointments with full patient and doctor names
-- Use case: Scheduling front desk view
-- ------------------------------------------------------------
SELECT
    a.AppointmentID,
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName)   AS PatientName,
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS DoctorName,
    d.Specialty,
    a.AppointmentTime,
    a.VisitReason
FROM Appointment_T a
INNER JOIN Patient_T p
    ON a.PatientID = p.PatientID
INNER JOIN Doctor_T d
    ON a.DoctorID = d.EmployeeID
INNER JOIN Employee_T e
    ON d.EmployeeID = e.EmployeeID
ORDER BY a.AppointmentTime;


-- ------------------------------------------------------------
-- 1.2 MULTI-TABLE INNER JOIN
-- Full treatment record: patient, doctor, and nurse involved
-- Use case: Clinical audit trail
-- ------------------------------------------------------------
SELECT
    t.TreatmentID,
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName)    AS PatientName,
    t.TreatmentDate,
    t.TreatmentDescription,
    CONCAT(ed.EmployeeFirstName, ' ', ed.EmployeeLastName) AS AttendingDoctor,
    doc.Specialty,
    CONCAT(en.EmployeeFirstName, ' ', en.EmployeeLastName) AS AssignedNurse,
    n.Certification                                        AS NurseCertified
FROM Treatment_T t
INNER JOIN Patient_T p   ON t.PatientID = p.PatientID
INNER JOIN Doctor_T doc  ON t.DoctorID  = doc.EmployeeID
INNER JOIN Employee_T ed ON doc.EmployeeID = ed.EmployeeID
INNER JOIN Nurse_T n     ON t.NurseID   = n.EmployeeID
INNER JOIN Employee_T en ON n.EmployeeID = en.EmployeeID
ORDER BY t.TreatmentDate DESC;


-- ------------------------------------------------------------
-- 1.3 LEFT JOIN
-- All doctors and their appointment counts (including doctors
-- with zero appointments — important for workload analysis)
-- Use case: Identifying underutilized or overloaded doctors
-- ------------------------------------------------------------
SELECT
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS DoctorName,
    d.Specialty,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctor_T d
INNER JOIN Employee_T e ON d.EmployeeID = e.EmployeeID
LEFT JOIN Appointment_T a ON d.EmployeeID = a.DoctorID
GROUP BY d.EmployeeID, e.EmployeeFirstName, e.EmployeeLastName, d.Specialty
ORDER BY TotalAppointments DESC;


-- ------------------------------------------------------------
-- 1.4 LEFT JOIN WITH FILTER
-- Receptionist staffing view: who supports which doctor,
-- and whether they are bilingual
-- Use case: Ensuring language-appropriate care coordination
-- ------------------------------------------------------------
SELECT
    CONCAT(er.EmployeeFirstName, ' ', er.EmployeeLastName) AS ReceptionistName,
    r.Bilingual,
    CONCAT(ed.EmployeeFirstName, ' ', ed.EmployeeLastName) AS SupportedDoctor,
    d.Specialty
FROM Receptionist_T r
INNER JOIN Employee_T er ON r.EmployeeID = er.EmployeeID
LEFT JOIN Doctor_T d     ON r.DoctorID   = d.EmployeeID
LEFT JOIN Employee_T ed  ON d.EmployeeID = ed.EmployeeID
ORDER BY SupportedDoctor;


-- ------------------------------------------------------------
-- 1.5 JOIN WITH DATE FILTERING
-- All appointments scheduled in Q1 2020 with patient
-- and receptionist details
-- Use case: Quarterly scheduling report
-- ------------------------------------------------------------
SELECT
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName)   AS PatientName,
    a.VisitReason,
    a.AppointmentTime,
    CONCAT(ed.EmployeeFirstName, ' ', ed.EmployeeLastName) AS DoctorName,
    CONCAT(er.EmployeeFirstName, ' ', er.EmployeeLastName) AS ReceptionistName,
    r.Bilingual                                           AS ReceptionistLanguage
FROM Appointment_T a
INNER JOIN Patient_T p       ON a.PatientID      = p.PatientID
INNER JOIN Doctor_T d        ON a.DoctorID       = d.EmployeeID
INNER JOIN Employee_T ed     ON d.EmployeeID     = ed.EmployeeID
INNER JOIN Receptionist_T r  ON a.ReceptionistID = r.EmployeeID
INNER JOIN Employee_T er     ON r.EmployeeID     = er.EmployeeID
WHERE a.AppointmentTime BETWEEN '2020-01-01' AND '2020-03-31 23:59:59'
ORDER BY a.AppointmentTime;


-- ============================================================
-- SECTION 2: SUBQUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 SUBQUERY IN WHERE CLAUSE
-- Find all patients who have had at least one treatment
-- Use case: Distinguish active treatment patients from
--           appointment-only patients
-- ------------------------------------------------------------
SELECT
    PatientID,
    CONCAT(PatientFirstName, ' ', PatientLastName) AS PatientName,
    PatientCity,
    PatientState
FROM Patient_T
WHERE PatientID IN (
    SELECT DISTINCT PatientID
    FROM Treatment_T
);


-- ------------------------------------------------------------
-- 2.2 NOT IN SUBQUERY
-- Patients who have appointments but have NEVER received
-- a formal treatment
-- Use case: Follow-up outreach — patients who may need care
-- ------------------------------------------------------------
SELECT
    PatientID,
    CONCAT(PatientFirstName, ' ', PatientLastName) AS PatientName,
    PatientCity
FROM Patient_T
WHERE PatientID NOT IN (
    SELECT DISTINCT PatientID
    FROM Treatment_T
);


-- ------------------------------------------------------------
-- 2.3 CORRELATED SUBQUERY
-- For each patient, show how many total appointments they
-- have had — using a correlated subquery per row
-- Use case: Patient engagement frequency analysis
-- ------------------------------------------------------------
SELECT
    p.PatientID,
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName) AS PatientName,
    (
        SELECT COUNT(*)
        FROM Appointment_T a
        WHERE a.PatientID = p.PatientID
    ) AS TotalAppointments,
    (
        SELECT COUNT(*)
        FROM Treatment_T t
        WHERE t.PatientID = p.PatientID
    ) AS TotalTreatments
FROM Patient_T p
ORDER BY TotalAppointments DESC;


-- ------------------------------------------------------------
-- 2.4 SUBQUERY IN FROM CLAUSE (Derived Table)
-- Find doctors whose appointment count is above the
-- average across all doctors
-- Use case: Identifying high-demand providers
-- ------------------------------------------------------------
SELECT
    DoctorName,
    Specialty,
    AppointmentCount
FROM (
    SELECT
        CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS DoctorName,
        d.Specialty,
        COUNT(a.AppointmentID) AS AppointmentCount
    FROM Doctor_T d
    INNER JOIN Employee_T e ON d.EmployeeID = e.EmployeeID
    LEFT JOIN Appointment_T a ON d.EmployeeID = a.DoctorID
    GROUP BY d.EmployeeID, e.EmployeeFirstName, e.EmployeeLastName, d.Specialty
) AS DoctorStats
WHERE AppointmentCount > (
    SELECT AVG(AppointmentCount)
    FROM (
        SELECT COUNT(AppointmentID) AS AppointmentCount
        FROM Appointment_T
        GROUP BY DoctorID
    ) AS AvgCalc
);


-- ------------------------------------------------------------
-- 2.5 SUBQUERY FOR CHRONIC CONDITION TRACKING
-- Find patients who have appeared in appointments with
-- the same VisitReason more than once — potential indicator
-- of recurring/chronic conditions
-- Use case: Chronic condition management dashboard feed
-- ------------------------------------------------------------
SELECT
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName) AS PatientName,
    a.VisitReason,
    COUNT(*) AS VisitCount
FROM Appointment_T a
INNER JOIN Patient_T p ON a.PatientID = p.PatientID
WHERE a.PatientID IN (
    SELECT PatientID
    FROM Appointment_T
    GROUP BY PatientID, VisitReason
    HAVING COUNT(*) > 1
)
GROUP BY a.PatientID, p.PatientFirstName, p.PatientLastName, a.VisitReason
HAVING COUNT(*) > 1
ORDER BY VisitCount DESC;


-- ------------------------------------------------------------
-- 2.6 SUBQUERY WITH EXISTS
-- List nurses who have been assigned to at least one treatment
-- Use case: Active vs. inactive nurse roster reporting
-- ------------------------------------------------------------
SELECT
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS NurseName,
    n.Certification
FROM Nurse_T n
INNER JOIN Employee_T e ON n.EmployeeID = e.EmployeeID
WHERE EXISTS (
    SELECT 1
    FROM Treatment_T t
    WHERE t.NurseID = n.EmployeeID
);


-- ============================================================
-- SECTION 3: COMBINED JOINs + SUBQUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 Patient Visit Timeline
-- Full chronological view of every patient touchpoint:
-- appointments AND treatments in one unified timeline
-- Use case: Patient history feed for Tableau dashboard
-- ------------------------------------------------------------
SELECT
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName) AS PatientName,
    'Appointment'           AS EventType,
    a.AppointmentTime       AS EventDate,
    a.VisitReason           AS Description,
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS ProviderName
FROM Appointment_T a
INNER JOIN Patient_T p  ON a.PatientID = p.PatientID
INNER JOIN Doctor_T d   ON a.DoctorID  = d.EmployeeID
INNER JOIN Employee_T e ON d.EmployeeID = e.EmployeeID

UNION ALL

SELECT
    CONCAT(p.PatientFirstName, ' ', p.PatientLastName) AS PatientName,
    'Treatment'             AS EventType,
    t.TreatmentDate         AS EventDate,
    t.TreatmentDescription  AS Description,
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS ProviderName
FROM Treatment_T t
INNER JOIN Patient_T p  ON t.PatientID = p.PatientID
INNER JOIN Doctor_T d   ON t.DoctorID  = d.EmployeeID
INNER JOIN Employee_T e ON d.EmployeeID = e.EmployeeID
ORDER BY PatientName, EventDate;


-- ------------------------------------------------------------
-- 3.2 Operational Scheduling KPI Export
-- Per-doctor summary: appointments, treatments, unique patients,
-- and bilingual receptionist support
-- Use case: Operational KPI dashboard in Tableau
-- ------------------------------------------------------------
SELECT
    CONCAT(e.EmployeeFirstName, ' ', e.EmployeeLastName) AS DoctorName,
    d.Specialty,
    COUNT(DISTINCT a.AppointmentID)  AS TotalAppointments,
    COUNT(DISTINCT t.TreatmentID)    AS TotalTreatments,
    COUNT(DISTINCT a.PatientID)      AS UniquePatients,
    (
        SELECT COUNT(*)
        FROM Receptionist_T r2
        WHERE r2.DoctorID = d.EmployeeID
          AND r2.Bilingual IS NOT NULL
    ) AS BilingualReceptionistCount
FROM Doctor_T d
INNER JOIN Employee_T e    ON d.EmployeeID = e.EmployeeID
LEFT JOIN Appointment_T a  ON d.EmployeeID = a.DoctorID
LEFT JOIN Treatment_T t    ON d.EmployeeID = t.DoctorID
GROUP BY d.EmployeeID, e.EmployeeFirstName, e.EmployeeLastName, d.Specialty
ORDER BY TotalAppointments DESC;
