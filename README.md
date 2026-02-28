# 🏥 CAHPS & STAR Ratings SQL Portfolio

A healthcare data analytics portfolio project analyzing **member experience (CAHPS) survey data** and **CMS STAR ratings** across simulated health plans. Built to demonstrate entry-level SQL skills relevant to **Healthcare Data Analyst** roles.

---

## 📂 Repository Structure

```
cahps-sql-portfolio/
│
├── cahps_schema.sql            ← Database schema + simulated seed data
├── cahps_portfolio_queries.sql ← Portfolio SQL queries
└── README.md                   ← You are here
```

---

## 🗄️ Database Schema Overview

A simulated managed care database with **5 related tables** modeled after real-world health plan data structures:

```
HealthPlan_T ──┬──► Member_T ──────► CAHPSSurvey_T
               ├──► STARMeasure_T
               └──► Member_T ───────► Outreach_T
```

| Table | Description |
|---|---|
| `HealthPlan_T` | Health plans with CMS Star Ratings and plan type |
| `Member_T` | Enrolled members with demographics and plan assignment |
| `CAHPSSurvey_T` | CAHPS survey responses by member and measurement year |
| `STARMeasure_T` | CMS STAR measure scores per plan per year |
| `Outreach_T` | Quality improvement outreach activities per member |

---

## 🔍 SQL Skills Demonstrated

### 1. JOINs with Aliases (AS)

| Query | Description | Business Use Case |
|---|---|---|
| 1.1 Member Survey Overview | INNER JOIN across 3 tables with aliases | Member-level CAHPS reporting |
| 1.2 Plan-Level Score Summary | JOIN + GROUP BY + AVG | Comparing plan CAHPS performance |
| 1.3 Outreach Activity Report | Multi-table JOIN | Tracking QI outreach efforts |
| 1.4 STAR Measure Performance | JOIN + filter by measure type | Identifying low-scoring CAHPS measures |

### 2. CASE WHEN (IF/THEN Logic)

| Query | Description | Business Use Case |
|---|---|---|
| 2.1 Member Satisfaction Tier | CASE WHEN on rating score | Segmenting members for outreach |
| 2.2 STAR Rating Performance Flag | CASE WHEN on star value | QI prioritization reporting |
| 2.3 Outreach Effectiveness | CASE WHEN on result + method | Measuring outreach campaign ROI |

### 3. Aggregate Functions (COUNT, AVG, SUM)

| Query | Description | Business Use Case |
|---|---|---|
| 3.1 Plan Scorecard | COUNT + AVG + SUM + CASE | Executive CAHPS KPI dashboard |
| 3.2 Year-Over-Year Trend | Conditional aggregation across years | Tracking score improvement over time |
| 3.3 Outreach Success Rate | SUM + calculated percentage | Quality team performance reporting |

---

## 📊 Linked Tableau Public Dashboards

| Dashboard | Key Metrics |
|---|---|
| **Member Experience Overview** | Plan ratings by member, satisfaction tiers, survey volume |
| **STAR Ratings & CAHPS Performance** | Measure scores vs. star targets, plan comparisons |
| **Outreach & Quality Improvement** | Outreach success rates, year-over-year CAHPS trends |

> 🔗 (https://public.tableau.com/views/CAHPSStarsTrends/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## 💡 Key Findings

- **PremierCare PPO (HP003)** consistently scored highest across all CAHPS domains, averaging above 9/10 on member satisfaction
- **ValleyHealth Medicare (HP004)** showed the lowest scores and highest outreach activity — a candidate for targeted quality improvement initiatives
- Year-over-year analysis shows **all plans improved** their Health Plan Rating scores from 2022 to 2023, with PremierCare leading at +3 points
- **Phone outreach** had the highest reach rate compared to mail and email channels

---

## ⚙️ How to Run

1. Ensure you have **MySQL 8.0+** installed
2. Create and select your database:
   ```sql
   CREATE DATABASE cahps_db;
   USE cahps_db;
   ```
3. Load the schema and seed data:
   ```sql
   source /path/to/cahps_schema.sql
   ```
4. Run the portfolio queries:
   ```sql
   source /path/to/cahps_portfolio_queries.sql
   ```

---

## 🛠️ Tech Stack

- **MySQL** — Query execution
- **Tableau Public** — Data visualization
- **GitHub** — Version control and portfolio hosting

---

*Simulated dataset designed to reflect real-world CAHPS survey and CMS STAR rating structures. All member and plan names are fictional.*
