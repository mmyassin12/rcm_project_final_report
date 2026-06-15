☁️ Azure End-to-End Data Engineering Project
<p align="center"> <img src="https://img.shields.io/badge/Azure-Cloud-blue?logo=microsoftazure" alt="Azure Badge"> <img src="https://img.shields.io/badge/Azure%20Data%20Factory-ETL%20Pipelines-0078D4?logo=microsoftazure" alt="ADF Badge"> <img src="https://img.shields.io/badge/Azure%20Databricks-Data%20Engineering-FF3621?logo=databricks" alt="Databricks Badge"> <img src="https://img.shields.io/badge/Azure%20Synapse-Analytics-008AD7?logo=microsoftazure" alt="Synapse Badge"> <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi" alt="Power BI Badge"> <img src="https://img.shields.io/badge/ETL-Pipeline-green" alt="ETL Badge"> <img src="https://img.shields.io/badge/License-MIT-green" alt="License Badge"> </p>
📑 Table of Contents
Project Goal & Problem Statement
Project Architecture
Resource Group
Storage Account
Pipeline Design
Data Transformation (Databricks)
Enriched Data Review (Synapse)
Data Analysis (Power BI)
Summary of Key Actions Performed
License
Author
🧠 Project Goal & Problem Statement

This project aims to design and implement a complete Azure-based data engineering solution that moves data from on-premises systems into the cloud, processes it, and makes it available for analysis. The core problem it solves is the fragmentation and inefficiency of working with raw, unstructured data stored locally, which makes it difficult to manage, monitor, and derive meaningful insights.

By building an automated pipeline using Azure services, the project centralizes data storage, ensures consistent and reliable data ingestion, and transforms raw data into a clean, structured format suitable for analytics. It also introduces monitoring, security, and scalability, which are typically lacking in manual systems.

1. Project Architecture

First, I have started with creating the project layout, as it helps outline the steps involved in a clear and visual way at a conceptual level.

<p align="center"> <img width="1042" height="559" src="https://github.com/user-attachments/assets/66f92e22-95b4-4582-b7e8-6b62f6e56fa2" /> </p>
2. Resource Group

For this project, I created a Resource Group named “rg-rcm”. This resource group is used to store and manage all the components involved in the solution, such as Azure Data Factory, storage accounts, and any supporting services.

<p align="center"> <img width="940" height="365" src="https://github.com/user-attachments/assets/d54489ee-0375-49e7-b1e6-0827767ea8f4" /> </p>
3. Storage Account

I created a storage account with two containers: one to store the raw data ingested from on-premises, and another to hold the transformed data after it has been cleaned and processed in Databricks.

<p align="center"> <img width="940" height="452" src="https://github.com/user-attachments/assets/b5b35d54-ca21-4f5b-8f7b-6f546ee6da2e" /> </p>
4. Pipeline Design

I built an Azure Data Factory pipeline called onPremToCloud to move multiple on-premises datasets into Azure storage in a strict sequential order.

I structured the pipeline in Azure Data Factory as a chain of activities where each step runs only after the previous one succeeds. I did this to ensure controlled and ordered movement of data from on-prem file sources into Azure storage.

Creating Connections

To connect ADF to the local files on my machine, I installed a Self-Hosted Integration Runtime called “OnPremToAzureIntegrationRunTime” and configured it successfully.

I then created two linked services:

One connecting local drive via Self-Hosted Integration Runtime
One connecting to ADLS using AutoResolve

For the source, I created a separate dataset for each file. For the sink, I created a single dataset pointing to the container file path level in ADLS.

<p align="center"> <img width="1000" height="431" src="https://github.com/user-attachments/assets/4b590bbd-8ed7-4148-b762-9a1adbba56ce" /> </p>
Activities
A. Accounts Dataset (First Activity)

I started with the Accounts copy activity, which reads delimited files from an on-prem file and loads them into Azure storage.

This was kept as the first step because it has no dependencies and initiates the pipeline flow.

B. Data Dictionary Dataset

Runs only after Accounts activity succeeds to ensure sequential execution.

C. Products Dataset

Runs after Data Dictionary completes successfully.

D. Sales Pipeline Dataset

Runs after Products activity succeeds.

E. Sales Teams Dataset

Runs after Sales Pipeline activity succeeds.

<p align="center"> <img width="940" height="403" src="https://github.com/user-attachments/assets/32c7dab8-9b5f-481d-9f85-4afe04f8a9b7" /> </p>
Success/Failure Notification (Azure Logic App)

I created an Azure Logic Apps workflow to enable web activity notifications via email, providing alerts on pipeline success or failure.

Once the final activity (Sales Teams) completes successfully, a Web Activity triggers a POST request to an Azure Logic App endpoint.

I send:

Pipeline name
Run ID
Timestamp
Status (Succeeded/Failure)

This allows automated monitoring without manual tracking.

<p align="center"> <img width="940" height="377" src="https://github.com/user-attachments/assets/d1c4ee2b-9acd-420d-a216-c922c969ca1a" /> </p> <p align="center"> <img width="812" height="283" src="https://github.com/user-attachments/assets/333ac282-a9b2-4ce2-a182-36d95d73ca1a" /> </p>
Ingestion Raw Data

After successful execution, source files are ingested into the raw-data container in ADLS, ensuring secure storage for downstream processing.

<p align="center"> <img width="940" height="456" src="https://github.com/user-attachments/assets/4cd73f7a-9fd5-4b32-84cd-10a97b1057da" /> </p>
Azure Monitor

Pipeline performance and execution are tracked using Azure Monitor for reliability and issue detection.

<p align="center"> <img width="940" height="461" src="https://github.com/user-attachments/assets/6bac92dd-d4af-4de4-84fa-6fec15ab5e4e" /> </p>
5. Data Transformation with Azure Databricks

After raw data lands in ADLS, it is transformed into clean structured format using Databricks for analytics.

<p align="center"> <img width="940" height="432" src="https://github.com/user-attachments/assets/0781f220-86d1-4803-9ab1-acb5130ef4b9" /> <img width="940" height="429" src="https://github.com/user-attachments/assets/c0b76ee1-a592-473f-9a37-0a61c598e4af" /> </p>
Storing Processed Data

The enriched data is stored back into ADLS under a separate container called transformed-data, following medallion architecture principles.

<p align="center"> <img width="940" height="347" src="https://github.com/user-attachments/assets/63f53c42-5472-401d-be4e-21353929a9e5" /> </p>
Azure Key Vault – Securing Keys

Storage access keys are stored securely in Azure Key Vault instead of hardcoding them.

Databricks retrieves secrets via Secret Scope integrated with Key Vault, improving security and governance.

<p align="center"> <img width="940" height="439" src="https://github.com/user-attachments/assets/e0be35fe-0042-4abf-a753-d6127c96da48" /> </p>
6. Enriched Data Review with Azure Synapse

Transformed data is queried using Azure Synapse Analytics by creating views inside a sales database for analytics readiness.

<p align="center"> <img width="940" height="438" src="https://github.com/user-attachments/assets/aa2f1ffb-661e-4b72-bf2e-96d919824f3f" /> </p>
7. Data Analysis with Power BI

Power BI is connected to Synapse views to build dashboards for business insights.

<p align="center"> <img width="963" height="548" src="https://github.com/user-attachments/assets/84ef199a-30bf-4b5b-b362-2f1372db36a0" /> </p>
Dashboard Summary
Total Deals / Win Metrics
Total Deals: 6,711
Won: 4,238
Lost: 2,473
Win Rate: 63.15%
Revenue by Account
Kan-code leads with 11.70K
Revenue concentrated in top accounts
Sales by Month
Highly fluctuating trend
Peaks mid-year and Q4
Revenue by Office Location
North America dominates
Africa minimal
Sales by Agent
Darcel Schlecht highest activity
Deals by Product
GTX Basic best performing
GTK 500 weakest
Revenue by Sector
Software leads (~26%)
8. Summary of Key Actions Performed
Designed end-to-end Azure architecture
Created resource group (rg-rcm)
Provisioned ADLS with raw and transformed containers
Built ADF pipeline for ingestion
Configured Self-hosted Integration Runtime
Implemented sequential pipeline orchestration
Added Logic App + Azure Monitor integration
Built Databricks transformation layer (medallion architecture)
Secured credentials using Key Vault
Created Synapse views for analytics
Built Power BI dashboards
🪪 License

This project is open-source and available under the MIT License.

🌐 Author

Mohamud Yassin
💼 Data Engineer | ☁️ Azure Enthusiast
📫 Reach me at: mmyassin12@gmail.com
