# 🛒 SQL Data Warehouse Analytics Project (Retail)

> A robust, end-to-end Data Warehousing solution built from scratch using **MySQL**. This project demonstrates the extraction, transformation, and loading (ETL) of raw CRM and ERP data into a structured **Medallion Architecture** to support business intelligence and decision-making.

---

## 🏗️ Architecture & Data Flow

This project implements a **Medallion Architecture**, organizing data quality into three distinct layers.

![Data Flow Diagram](docs/Data_Flow_Diagram.drawio.png)

### The ETL Pipeline
The data flows from raw CSVs through a series of transformations to become analytics-ready.

| Layer | Name | Description |
| :--- | :--- | :--- |
| 🥉 | **Bronze Layer** | **Raw Ingestion.** Direct dump of source CSV files (CRM & ERP). Handles basic ingestion issues (e.g., converting empty CSV fields to `NULL`) but preserves the original data fidelity. |
| 🥈 | **Silver Layer** | **Cleansed & Conformed.** Applies data quality rules. Handles deduplication, standardizes text (e.g., Gender M/F -> Male/Female), cleans invalid dates (Zero-Dates), and ensures referential integrity. |
| 🥇 | **Gold Layer** | **Business Aggregates.** Optimized for reporting. This layer uses **Star Schemas** (Fact & Dimension tables) to answer specific business questions. |

---

## 📐 Data Modeling

### 1. Bronze Layer (Source Mapping)
The Bronze layer acts as a direct landing zone for the raw CSV files.
![Bronze Map](docs/dw_bronze_map.png)

### 2. Silver Layer (Integration Model)
In the Silver layer, data from the disparate CRM and ERP systems is merged, cleaned, and normalized.
![Integration Model](docs/integration_model.drawio.png)

### 3. Gold Layer (Dimensional Model / Star Schema)
The Gold layer is modeled as a **Star Schema** to enable fast querying for BI tools. It consists of Fact tables (Sales) surrounded by Dimension tables (Products, Customers).
![Data Mart Design](docs/DataMart.drawio.png)

---

## 🚀 Key Features Implemented

### 1. Robust Data Ingestion (ELT)
* Implemented **Bulk Data Loading** using `LOAD DATA LOCAL INFILE` for high-performance ingestion.
* Engineered a **"Capture & Convert"** pattern to safely handle CSV idiosyncrasies (e.g., handling missing values, empty strings, and type mismatches before they hit the database).

### 2. Advanced Data Cleaning (Stored Procedures)
* Developed modular **Stored Procedures** for the Silver Layer to automate data quality checks.
* **Logic Implemented:**
    * **Date Cleaning:** Handled legacy system errors like `'0000-00-00'` and integer-based dates (`20230101`).
    * **Standardization:** Normalized categorical fields (Marital Status, Gender, Country Codes).
    * **Deduplication:** Used Window Functions (`ROW_NUMBER()`) to identify and remove duplicate records based on the latest timestamp.

### 3. Business Intelligence (Gold Layer)
* Designed a **Fact-Dimension Model** to facilitate fast analytical queries.
* Created aggregated views for key metrics (Sales Velocity, Churn Rate, Product Performance).

---

## 📂 Project Structure

```text
/SQL_Data_Warehouse_Project
│
├── /dataset                # Raw source files (CRM & ERP CSVs)
├── /docs                   # Architecture diagrams and documentation
│
├── /scripts
│   ├── /dw_bronze          # DDL and Load Scripts for Raw Layer
│   ├── /dw_silver          # Stored Procedures for Transformation
│   └── /dw_gold            # Reporting Views and Dimensions
│
└── README.md
