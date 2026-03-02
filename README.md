# 🏥 CMS 2025 STAR Ratings — CAHPS Analysis
**By Melvin Issaei | Healthcare Data Analyst**

---

## 👋 The Problem I'm Solving

Medicare Advantage health plans live and die by their **STAR ratings**.

A plan that hits **4+ stars earns bonus payments from CMS worth millions of dollars**. The hardest domain to improve is always **CAHPS** — which measures how members *feel* about their experience with the plan.

I worked alongside health plans at mPulse trying to move these scores. I wanted to understand using **real CMS data** — which CAHPS measures are actually separating the 4-star plans from the 3.5-star plans that are just missing the bonus threshold?

---

## 📂 What's in This Project?

| File | What it does |
|---|---|
| `cms_stars_schema.sql` | Creates the database and 3 tables |
| `cms_stars_queries.sql` | All SQL queries analyzing CAHPS performance |
| `plan_summary.csv` | 580 real MA plans with overall STAR ratings |
| `domain_stars.csv` | Domain-level scores including HD3 (CAHPS) |
| `cahps_measures.csv` | Individual CAHPS measure scores (C19–C24) |

---

## 🗄️ Where Does the Data Come From?

**Source:** CMS (Centers for Medicare & Medicaid Services) — publicly available

🔗 [CMS Part C & D Performance Data](https://www.cms.gov/medicare/health-drug-plans/part-c-d-performance-data)

This is the same data that health plans like Humana, UnitedHealthcare, Centene, and Kaiser use to track their own performance. It covers **580 real Medicare Advantage contracts** across the US for the 2025 measurement year.

---

## 🗂️ How Are the Tables Connected?

```
PlanSummary_T         DomainStars_T         CAHPSMeasures_T
─────────────         ─────────────         ───────────────
ContractID ◄────────── ContractID ◄───────── ContractID
Plan Name              HD1 Preventive        C19 Getting Needed Care
Parent Org             HD2 Chronic Care      C20 Getting Care Quickly
Plan Type              HD3 CAHPS ⭐           C21 Customer Service
Overall Stars          HD4 Complaints        C22 Rating Health Quality
                       HD5 Customer Svc      C23 Rating Health Plan
                                             C24 Care Coordination
```

All 3 tables connect through **ContractID** — the unique ID CMS assigns to every health plan contract.

---

## 💡 What SQL Skills Does This Show?

**🔗 JOINs** — connecting all 3 tables to build a complete picture of each plan's CAHPS performance

**↔️ CASE WHEN** — flagging plans where CAHPS is dragging their overall rating, and categorizing plans by bonus eligibility

**🔢 Aggregate Functions** — calculating average CAHPS scores by star tier to prove that member experience directly correlates with overall ratings

---

## 🔍 What Did I Find?

- **171 plans are stuck at 3.5 stars** — just below the bonus threshold
- For those plans, **Rating of Health Plan (C23)** and **Getting Needed Care (C19)** are consistently the lowest scoring CAHPS measures
- Plans with strong CAHPS scores (HD3 = 4+) almost always have 4+ overall stars
- **Kaiser and Highmark** consistently outperform larger national plans on CAHPS

---

## ⚠️ Limitations

- This is **contract-level data only** — no member-level detail is publicly available
- Star ratings are a lagging indicator — scores reflect prior year performance
- Some contracts show "Not enough data available" and were excluded from analysis

---

## 📊 Tableau Dashboard

Interactive dashboard showing CAHPS performance by plan, star tier, and measure — with filters to explore any individual plan or parent organization.

> 🔗 *[Tableau Public link coming soon]*

---

## ⚙️ How to Run This Project

1. Install MySQL
2. Create the database and tables:
```sql
source /your/path/cms_stars_schema.sql
```
3. Import the 3 CSV files into their tables using TablePlus or MySQL Workbench
4. Run the queries:
```sql
source /your/path/cms_stars_queries.sql
```

---

*Data source: CMS 2025 Star Ratings Data Tables (December 2, 2024). All data is publicly available from CMS.*
