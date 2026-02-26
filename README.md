# hospital-sql-portfolio
SQL portfolio project demonstrating JOINs and Subqueries using a hospital database
# 🏥 Hospital Database SQL Portfolio

A SQL portfolio project using a relational hospital management database. Demonstrates real-world query writing skills using **JOINs** and **Subqueries** across a normalized, multi-table schema.

---

## 📂 Repository Structure

```
hospital-sql-portfolio/
│
├── hospital_portfolio_queries.sql   ← All queries (this file)
├── hospital_schema.sql              ← Original schema + seed data
└── README.md                        ← You are here
```

---

## 🗄️ Database Schema Overview

The database models a small hospital and contains **6 related tables**:

```
Employee_T ──┬──► Doctor_T ──────────────────────► Appointment_T ◄── Patient_T
             ├──► Nurse_T  ──────────────────────► Treatment_T   ◄── Patient_T
             └──► Receptionist_T (→ Doctor_T) ───► Appointment_T
```

| Table | Description |
|---|---|
| `Employee_T` | All hospital staff (doctors, nurses, receptionists) |
| `Doctor_T` | Doctor specialties — subtype of Employee |
| `Nurse_T` | Nurse certifications — subtype of Employee |
| `Receptionist_T` | Receptionist language skills and assigned doctor |
| `Patient_T` | Patient demographics |
| `Appointment_T` | Scheduled visits linking patients, doctors, and receptionists |
| `Treatment_T` | Clinical treatments linking patients, doctors, and nurses |

---

## 🔍 SQL Skills Demonstrated

### 1. JOINs

| Query | Technique | Business Use Case |
|---|---|---|
| 1.1 Appointment Schedule | `INNER JOIN` (3 tables) | Front desk scheduling view |
| 1.2 Full Treatment Record | `INNER JOIN` (5 tables) | Clinical audit trail |
| 1.3 Doctor Workload | `LEFT JOIN` + `GROUP BY` | Appointment load per doctor |
| 1.4 Receptionist Staffing | `LEFT JOIN` chain | Language-appropriate care coordination |
| 1.5 Q1 Appointment Report | `JOIN` + date filter `BETWEEN` | Quarterly scheduling report |

### 2. Subqueries

| Query | Technique | Business Use Case |
|---|---|---|
| 2.1 Patients with Treatments | `WHERE IN (subquery)` | Active treatment patient list |
| 2.2 Appointment-Only Patients | `WHERE NOT IN (subquery)` | Follow-up outreach candidates |
| 2.3 Patient Engagement Counts | Correlated subquery | Visit frequency per patient |
| 2.4 High-Demand Doctors | Derived table + `AVG()` | Above-average appointment load |
| 2.5 Chronic Condition Signals | `HAVING COUNT > 1` + subquery | Recurring visit reason detection |
| 2.6 Active Nurses | `WHERE EXISTS` | Nurse assignment roster |

### 3. Combined: JOINs + Subqueries

| Query | Technique | Business Use Case |
|---|---|---|
| 3.1 Patient Visit Timeline | `UNION ALL` + multi-JOIN | Unified patient history feed |
| 3.2 Operational KPI Export | Correlated subquery in `SELECT` + `LEFT JOIN` | Tableau dashboard data source |

---

## 📊 Linked Tableau Dashboards

This SQL project is paired with a **Tableau Public portfolio** containing 3 dashboards built from query outputs:

| Dashboard | Key Metrics |
|---|---|
| **Patient & Appointment Overview** | Appointment volume by doctor, patient demographics, visit reason breakdown |
| **Operational / Scheduling KPIs** | Doctor workload, bilingual support coverage, appointment-to-treatment conversion |
| **Chronic Condition Trends** | Recurring visit reasons per patient, treatment frequency over time |

> 🔗 *[Insert your Tableau Public profile link here]*

---

## ⚙️ How to Run

1. Ensure you have **MySQL 8.0+** installed
2. Create and select your database:
   ```sql
   CREATE DATABASE hospital_db;
   USE hospital_db;
   ```
3. Load the schema and seed data:
   ```bash
   mysql -u root -p hospital_db < hospital_schema.sql
   ```
4. Run the portfolio queries:
   ```bash
   mysql -u root -p hospital_db < hospital_portfolio_queries.sql
   ```

---

## 🛠️ Tech Stack

- **MySQL** — Query execution
- **Tableau Public** — Data visualization
- **GitHub** — Version control and portfolio hosting

---

*Built as a data analytics portfolio project. Database schema provided by a peer collaborator.*
