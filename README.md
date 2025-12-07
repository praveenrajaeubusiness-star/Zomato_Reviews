#  Zomato Reviews – Big Data Analysis Project  

## 1.  Project Overview  

This project analyzes **Zomato restaurant reviews** using an end-to-end Big Data pipeline in **Databricks Free Edition**, powered by **PySpark**, **Spark SQL**, and **Lakeview Dashboards**.

The goal is to extract insights about:

- How customer ratings vary over time  
- Whether higher-rated reviews are considered more “helpful”  
- Whether unhappy customers write longer reviews  
- How review behavior changes by rating category  

This project contains:
- Data ingestion  
- Cleaning & feature engineering  
- Analytical exploration (PySpark & SQL)  
- Dashboard creation with 3 KPI-based tiles  
- Proper GitHub documentation including a SQL file and this README  


## 2.  Dataset Description  

**Source file:** `zomato_reviews.csv`

**Columns:**
- `review_id` – Original ID of the review  
- `rating` – Customer rating (typically 1–5)  
- `review_text` – Text content of the review  
- `review_date` – Date the review was posted  
- `helpful` – Number of helpful votes the review received  


## 3.  Tools & Technologies  

- Databricks (Free Edition)  
- PySpark for data cleaning & analysis  
- Spark SQL  
- Databricks Lakeview Dashboard  
- GitHub for version control  


## 4.  Data Pipeline  

### 4.1  Ingestion  

Notebook: `01_ingest_and_clean_zomato_reviews.ipynb`

Steps:
1. Uploaded `zomato_reviews.csv` into Databricks.
2. Created raw table:

table saved as: raw_zomato_reviews


### 4.2  Cleaning & Feature Engineering  

Performed inside `01_ingest_and_clean_zomato_reviews.ipynb`.

###  NEW review_id (IMPORTANT)  
The **original review_id column was replaced** with a **new numeric sequential ID** starting at **140601**.

Example:
140601
140602
140603


This was implemented using **Spark window functions**, and the column type is now **INT**, not string.


### Additional Cleaning Steps  

 Casted:
- `rating` → double  
- `helpful` → integer  

 Parsed:
- `review_date` → Spark `DateType`  

 Created new analytical columns:
- **`review_year`** (extracted year)
- **`review_month`** (`yyyy-MM`)
- **`rating_category`**:
  - Low (rating 1–2)
  - Medium (rating 3)
  - High (rating 4–5)
- **`helpful_group`**:
  - No votes  
  - Low (1–2)  
  - Medium (3–5)  
  - High (6+)  
- **`review_length_words`** — number of words in review_text  

Final cleaned table saved as: clean_zomato_reviews



## 5.  Exploratory Analysis  

Notebook: `02_analysis_notebook.ipynb`

### 5.1 PySpark Analysis Examples  

####  Average rating by month
```python
df.groupBy("review_month").agg(avg("rating")).orderBy("review_month").show()

#### Average helpful votes per rating

```python
df.groupBy("rating").agg(avg("helpful")).orderBy("rating").show()
```

####  Average review length per rating category

```python
df.groupBy("rating_category").agg(avg("review_length_words")).show()
```

---

### 5.2 SQL Analysis (Stored in `sql_queries.sql`)

####  Average rating per year

```sql
SELECT review_year, AVG(rating) AS avg_rating
FROM main.default.clean_zomato_reviews
GROUP BY review_year
ORDER BY review_year;
```

####  Helpful votes by rating

```sql
SELECT rating, AVG(helpful) AS avg_helpful
FROM main.default.clean_zomato_reviews
GROUP BY rating
ORDER BY rating;
```

---

## 6.  Dashboard (Lakeview)

Notebook: `03_dashboard_notebook.ipynb` prepares three dashboard data tables:

1. `dash_avg_rating_by_month`
2. `dash_helpful_by_rating`
3. `dash_length_by_rating_cat`

###  Dashboard Tiles (All KPI-Aligned)

#### 1 **Average Rating Over Time**

* Datasource: `dash_avg_rating_by_month`
* X-axis: `review_month`
* Y-axis: `avg_rating`
* Chart type: **Line**
* KPI: Satisfaction trend over time

---

#### 2️**Average Helpful Votes per Rating**

* Datasource: `dash_helpful_by_rating`
* X-axis: `rating`
* Y-axis: `avg_helpful`
* Chart type: **Bar**
* KPI: Which ratings are considered most helpful

---

#### 3️ **Average Review Length by Rating Category**

* Datasource: `dash_length_by_rating_cat`
* X-axis: `rating_category`
* Y-axis: `avg_review_length_words`
* Chart type: **Bar**
* KPI: Whether negative reviews are longer (they usually are!)

---

## 7.  Dashboard Filters (Correct & Compatible)

Because Databricks Lakeview cannot cross-filter unrelated datasources, each filter is tied to the **datasource of its tile**.

###  Filter 1 — Review Month

* Datasource: `dash_avg_rating_by_month`
* Field: `review_month`
* Applies to: **Tile 1 only**

---

###  Filter 2 — Rating

* Datasource: `dash_helpful_by_rating`
* Field: `rating`
* Applies to: **Tile 2 only**

---

###  Filter 3 — Rating Category

* Datasource: `dash_length_by_rating_cat`
* Field: `rating_category`
* Applies to: **Tile 3 only**

These filters ensure **zero data source mismatch errors** and allow meaningful slicing.

---

## 8.  How to Run the Project

1. Import all `.ipynb` notebooks into Databricks.
2. Attach to an active cluster.
3. Run:

   * `01_ingest_and_clean_zomato_reviews.ipynb`
   * `02_analysis_notebook.ipynb`
   * `03_dashboard_notebook.ipynb`
4. Create the Lakeview Dashboard:

   * Add all 3 tiles
   * Apply each filter to its tile

---

## 9.  Repository Structure

```
zomato-reviews-bigdata-final/
│
├── 01_ingest_and_clean_zomato_reviews.ipynb
├── 02_analysis_notebook.ipynb
├── 03_dashboard_notebook.ipynb
├── sql_queries.sql
└── README.md
```

---

## 10.  Conclusion

This project successfully demonstrates how to:

* Build a scalable Big Data pipeline
* Clean and engineer analytical features from text reviews
* Assign new sequential integer IDs using PySpark window functions
* Analyze customer satisfaction patterns
* Visualize KPIs using Lakeview dashboards
* Document the entire project professionally in GitHub

The insights offer a clear view of rating trends, review behavior, and helpfulness patterns across Zomato reviews.

