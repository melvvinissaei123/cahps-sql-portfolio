# CMS 2025 Medicare Advantage — CAHPS & STAR Ratings Analysis
**By Melvin Issaei**

---

## The Problem

Medicare Advantage health plans earn **Quality Bonus Payments from CMS worth millions of dollars** when they hit 4+ stars. Most plans don't realize how close they are — or that their **CAHPS scores** (member experience surveys) are what's holding them back.

I used real CMS data to answer: **which health plans are near the bonus threshold and could get there by improving member experience?**

---

## Workflow

1. Downloaded CMS 2025 Star Ratings data as CSVs
2. Used Terminal to load SQL schema and create empty tables
3. Imported CMS data into MySQL database
4. Used TablePlus to run SQL queries using `CASE WHEN`, `JOIN`, and aggregate functions
5. Exported results as CSVs and loaded into Tableau

---

## What's in This Repo

| File | Description |
|---|---|
| `cms_stars_schema.sql` | Creates the database and 3 tables |
| `cms_stars_queries.sql` | SQL queries analyzing CAHPS performance |
| `full_cahps_profile.csv` | All 530 MA plans with CAHPS measure scores |
| `performance_tiers.csv` | Plans grouped by star tier and bonus eligibility |

---

## Key Findings

- **171 plans are stuck at 3.5 stars** — just below the Quality Bonus Payment threshold
- Plans with higher CAHPS scores consistently have higher overall star ratings
- Improving member experience measures is the clearest path to reaching 4 stars

---

## Tableau Dashboard

🔗 https://public.tableau.com/shared/XGFCBTFGD?:display_count=n&:origin=viz_share_link

---

## Data Source

CMS 2025 Star Ratings Data Tables (December 2, 2024) — publicly available at [cms.gov](https://www.cms.gov/medicare/health-drug-plans/part-c-d-performance-data)
