# Swiggy Food Delivery on Microsoft Fabric

> A production-style **end-to-end data engineering project** built on **Microsoft Fabric** using **Lakehouse, PySpark, Pipelines, Warehouse, Star Schema, Semantic Model, and Power BI**.

![Architecture](docs/images/architecture.png)

## Why this project
This project shows how raw operational order data can be transformed into a trusted analytics solution.

I designed the solution using a **Bronze → Silver → Gold** architecture, cleaned and standardized the data in **PySpark notebooks**, orchestrated movement with **Fabric Pipelines**, modeled the serving layer in a **Warehouse**, and delivered business insights through **Power BI**.

> **Scale note:** The architecture is designed as a **production-ready pattern** for high-volume food delivery data. The same design was executed on a smaller working sample for demo and portfolio purposes.

---

## What I built
- **Lakehouse** for raw, clean, and curated data layers
- **PySpark notebooks** for data cleaning and business-rule transformations
- **Fabric Data Pipelines** for orchestration and Warehouse loading
- **Warehouse SQL layer** for analytics and serving
- **Star Schema** with fact and dimension tables
- **Semantic Model** for reusable KPIs and relationships
- **Power BI report** for revenue, operations, and customer behavior insights

---

## Architecture at a glance
```text
Source Files / CSV
      ↓
Lakehouse Bronze (raw)
      ↓
PySpark Notebook
      ↓
Silver Delta Tables (clean + validated)
      ↓
Gold Delta Tables (analytics-ready)
      ↓
Fabric Pipeline
      ↓
Warehouse
      ↓
Semantic Model + Power BI
```

---

## Key engineering highlights
- Applied **Medallion architecture** for raw, clean, and curated data layers
- Used **Delta tables** for reliable and analytics-friendly storage
- Enforced **business rules** such as delivery logic for online/offline orders
- Built **Gold-layer fact and dimension tables** for reporting simplicity
- Designed the model using a **Star Schema** for better BI performance and usability
- Added **performance and model-quality thinking** using Power BI best practices

---

## Business questions answered
The Warehouse and report answer practical questions such as:
- What is the total revenue generated?
- Which cuisines and locations perform best?
- What is the average order value (AOV)?
- During which hours do most orders occur?
- Do customers who book a table spend more?
- What is the delivery success rate for online orders?
- Which areas show slower delivery performance?

---

## Project assets
### Fabric Items
- **Lakehouse:** `Swiggy_LH`
- **Warehouse:** `Swiggy_WH`
- **Pipelines:** `Copy_Silver_To_WH`, `Load_LH_Mart_to_WH`
- **Notebooks:** PySpark transformation notebooks
- **Semantic Model:** `Swiggy Food Delivery`
- **Report:** `Swiggy Delivery Summary`

### Main folders in this repo
```text
├─ docs/         # documentation, screenshots, showcase files
├─ sql/          # EDA SQL and star schema scripts
├─ notebooks/    # Fabric notebook exports
├─ pipeline/     # pipeline notes and screenshots
├─ report/       # report assets / PBIX (if shared)
└─ assets/       # architecture image / extra visuals
```

---

## Screenshots
### Workspace / Fabric items
![Workspace Items](docs/images/workspace_items.png)

### Pipeline
![Pipeline](docs/images/pipeline_foreach.png)

### Power BI Report
![Swiggy Delivery Summary](docs/images/report_summary.png)

---

## Tech Stack
- **Microsoft Fabric**
- **Lakehouse**
- **PySpark**
- **Fabric Data Pipeline**
- **Fabric Warehouse**
- **SQL**
- **Delta Lake**
- **Power BI**
- **DAX**

---

## Repo quick start
1. Upload raw files to the Lakehouse Bronze layer
2. Run the notebook to create **Silver** and **Gold** tables
3. Run the Fabric pipeline to load curated data into the Warehouse
4. Execute SQL scripts for EDA and dimensional modeling
5. Build or refresh the semantic model and Power BI report

---

## Why this repo matters
This is more than a demo dashboard.

It demonstrates how I think about:
- data quality
- scalable design patterns
- curated analytics layers
- BI-ready modeling
- production-style orchestration
- performance-aware reporting

---

## Author
**Sainatha Reddy**  
Microsoft Fabric / Data Engineering  
Power BI | SQL | PySpark | Data Modeling | Analytics Engineering
www.linkedin.com/in/sainathareddybi2017


---

## Connect
If you found this project useful, feel free to connect with me on LinkedIn and explore the rest of the repository.
