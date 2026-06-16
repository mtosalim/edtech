# Overview

Data analytics project focused on marketing and commercial journey performance for an EdTech company, generating business insights from lead acquisition through enrollment. Data was provided as part of a technical selection process, processed using a **Medallion architecture (Bronze → Silver → Gold)** and visualized in Power BI.

<img width="1173" height="677" alt="Screenshot_3" src="https://github.com/user-attachments/assets/f66c8918-2dde-4611-aa71-181b244aeae7" />

## Tech Stack

- SQL Server (data modeling & transformation)
- Power BI (dashboard & visualization)
- DAX (measures & KPIs)
- CSV (data source)

---

## Data Architecture

### Bronze
- Raw data ingested via `BULK INSERT`
- No transformations
- All columns stored as `VARCHAR`

### Silver
- Data cleaning and standardization:
  - Type conversion (`TRY_CAST`, `TRY_CONVERT`)
  - Categorical field standardization (`COALESCE` + `CASE WHEN`)
  - Null handling (fallback to `'No data'`)
  - **Duplicate PK resolution via funnel stage ordering** — leads appear multiple times as they progress through the pipeline; only the most advanced stage record is kept per lead
- Analysis-ready dataset

### Gold
- Business-oriented analytical layer:
  - Lead journey KPIs
  - Engagement metrics
  - Event performance
  - Channel conversion analysis
  - Geographic and segment breakdown

---

## Data Model

```
leads_interested
      |
  ____|____
  |       |
journey  attendance
engagement  relationship

events (analyzed independently — no shared PK with other tables)
```

---

## Key Metrics

**Leads**
- Total leads, enrolled, lost
- Conversion rate (lead → enrolled)
- Avg. time to first contact
- Visit attendance rate

**Engagement**
- Email open rate
- Email click rate
- WhatsApp interaction rate
- Event participation
- Materials downloaded

**Events**
- Total events, subscribers, attendees
- Post-event conversion (lead → enrolled)
- Conversion by event location

---

## Key Insights

- Leads from referral, website, and WhatsApp showed the highest enrollment conversion rates, with referral and spontaneous visits standing out despite lower volume.
- Events generated strong lead volume but low post-event conversion — indicating an opportunity to improve follow-up strategy.
- Engagement correlates positively with conversion: enrolled leads consistently show higher email open rates, WhatsApp interactions, and event participation.
- Units with lower investment outperformed others in conversion efficiency, suggesting best practices can be replicated across locations.
- Income bracket of R$10–20k showed the highest conversion rate, with strong correlation to WhatsApp engagement and referral channels.
- Specific geographic regions showed consistently higher conversion, pointing to territory-level opportunities for targeted campaigns.

---

## Project Structure

```
/data       → .csv files (anonymized)
/sql        → .sql files (bronze, silver, gold layers)
/analytics  → .pbix file
```

---

## Notes

- Client data has been anonymized. Company name and identifying information have been removed from all files.
- Project developed as part of a technical data analytics assessment.
- AI tools (Claude, ChatGPT) were used as technical support for SQL/DAX syntax review, ETL logic validation, and documentation acceleration.
