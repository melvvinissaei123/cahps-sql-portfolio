# 🏥 CAHPS & STAR Ratings SQL Portfolio
**By Melvin Issaei | Healthcare Data Analyst**

---

## 👋 What is this project?

This project analyzes **member experience data** for health insurance plans using SQL and Tableau. I built a database that tracks how members rate their health plans (called CAHPS scores) and the overall quality ratings plans receive from Medicare (called STAR ratings).

---

## 📂 What's in this project?

| File | What it does |
|---|---|
| `cahps_schema.sql` | Creates the database and loads all the data |
| `cahps_portfolio_queries.sql` | All the SQL queries I wrote to analyze the data |

---

## 🗄️ What data am I working with?

I created a simulated database with 5 fictional health plans and their members. The database tracks:

- 🏢 **Health Plans** — plan names, types, and their STAR ratings
- 👥 **Members** — who is enrolled in each plan
- 📋 **CAHPS Surveys** — how members rated their experience (0-10 scale)
- ⭐ **STAR Measures** — CMS quality scores per plan
- 📞 **Outreach Activities** — follow-up efforts to improve member satisfaction

---

## 💡 What SQL skills does this show?

**🔗 JOINs** — connecting multiple tables together to answer questions like *"which members gave low ratings and which plan are they on?"*

**↔️ CASE WHEN** — writing IF/THEN logic in SQL, like categorizing members into satisfaction groups: Promoter, Neutral, At Risk, or Detractor

**🔢 Aggregate Functions** — using COUNT, AVG, and SUM to calculate things like average plan ratings and outreach success rates

---

## 🔍 What did I find?

- ⭐ **PremierCare PPO** had the highest member satisfaction — all members were Promoters
- ⚠️ **ValleyHealth Medicare** had the lowest scores and needed the most outreach
- 📈 Every health plan improved their CAHPS scores from 2022 to 2023
- 📞 Phone outreach had the highest success rate compared to email and mail

---

## 📊 Tableau Dashboard

I built an interactive dashboard where you can select any health plan and see its star rating, member satisfaction, and year-over-year improvement.

> 🔗 (https://public.tableau.com/views/CAHPSStarsTrends/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## ⚙️ How to run this project

1. Install MySQL
2. Create a database:
```sql
CREATE DATABASE cahps_db;
USE cahps_db;
```
3. Load the data:
```sql
source /your/path/cahps_schema.sql
```
4. Run the queries:
```sql
source /your/path/cahps_portfolio_queries.sql
```

---

*💡 All data in this project is simulated and fictional. Built as a healthcare data analytics portfolio project.*
