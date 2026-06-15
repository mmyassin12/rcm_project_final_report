
# 🏥 End-to-End Data Engineering project with CRM Sales Data

<p align="center">
  <img src="https://img.shields.io/badge/Azure-Cloud-blue?logo=microsoftazure" alt="Azure Badge">
  <img src="https://img.shields.io/badge/PySpark-Big%20Data-orange?logo=apachespark" alt="PySpark Badge">
  <img src="https://img.shields.io/badge/Azure%20Data%20Factory-ETL%20Pipelines-0078D4?logo=microsoftazure" alt="Azure Data Factory Badge">
  <img src="https://img.shields.io/badge/Azure%20Synapse-Analytics-008AD7?logo=microsoftazure" alt="Azure Synapse Badge">
  <img src="https://img.shields.io/badge/Azure%20Databricks-Data%20Engineering-FF3621?logo=databricks" alt="Azure Databricks Badge">
  <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi" alt="Power BI Badge">
  <img src="https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git" alt="Git Badge">
  <img src="https://img.shields.io/badge/Python-3.9%2B-3776AB?logo=python" alt="Python Badge">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License Badge">
</p>


## 📌 Table of Contents
1. [Project Goal & Problem Statement](#project-goal)
2. [Project architecture](#project-architecture)
3. [Resource group](#resource-group)
4. [Storage account](#storage-account)

5. [Pipeline design](#pipeline-design)
   - [Creating connections](#creating-connections)
   - [Activities](#activities)
     - 📌 Accounts dataset (first activity)
     - 📌 Data Dictionary dataset
     - 📌 Products dataset
     - 📌 Sales Pipeline dataset
     - 📌 Sales Teams dataset
   - [Success/Failure notification using Azure Logic App (Web Activity)](#successfailure-notification)
   - [Ingestion Raw data](#ingestion-raw-data)
   - [Azure monitor](#azure-monitor)

6. [Data transformation with azure Databricks](#databricks)
   - 💾 Storing processed data
   - 🔐 Azure key vault – securing the keys

7. [Enriched data review with Azure Synapse](#synapse)

8. [Data analysis with Power BI](#power-bi)
   - Dashboard summary
     - Total Deals / Win Metrics
     - Sum of revenue by account
     - Total Sales by Month
     - Count of revenue by office location
     - Total Sales won or lost by Agent
     - Number of deals won by product
     - Revenue by sector

9. [Summary of Key Actions Performed](#summary)
10. [License](#license)
11. [Author](#author)

---
<a id="project-goal"></a>
## 🎯  Project Goal & Problem Statement
This project aims to design and implement a complete Azure-based data engineering solution that moves data from on-premises systems into the cloud, processes it, and makes it available for analysis. The core problem it solves is the fragmentation and inefficiency of working with raw, unstructured data stored locally, which makes it difficult to manage, monitor, and derive meaningful insights.

By building an automated pipeline using Azure services, the project centralizes data storage, ensures consistent and reliable data ingestion, and transforms raw data into a clean, structured format suitable for analytics. It also introduces monitoring, security, and scalability, which are typically lacking in manual systems.

--- 
<a id="project-architecture"></a>
## 🏗️  Project architecture
First, I have started with creating the project layout, as it helps outline the steps involved in a clear and visual way at a conceptual level.

<img width="1042" height="559" alt="image" src="https://github.com/user-attachments/assets/66f92e22-95b4-4582-b7e8-6b62f6e56fa2" />

---
<a id="resource-group">
## 🧱  Resource Group
For this project, I created a Resource Group named “rg-rcm”. This resource group is used to store and manage all the components involved in the solution, such as Azure Data Factory, storage accounts, and any supporting services.

<img width="940" height="365" alt="image" src="https://github.com/user-attachments/assets/d54489ee-0375-49e7-b1e6-0827767ea8f4" />

---
<a id="storage-account"></a>
## 🗄️  Storage Account
I created an Azure Data Lake Storage (ADLS) account with two containers: one to store the raw data ingested from on-premises, and another to hold the transformed data after it has been cleaned and processed in Databricks.

<img width="940" height="452" alt="image" src="https://github.com/user-attachments/assets/b5b35d54-ca21-4f5b-8f7b-6f546ee6da2e" />

---
<a id="pipeline-design"></a>
## ⚙️  Pipeline Design

I built an Azure Data Factory (ADF) pipeline called onPremToCloud to move multiple on-premises datasets into Azure storage in a strict sequential order.
I structured the pipeline in Azure Data Factory as a chain of activities where each step runs only after the previous one succeeds. I did this to ensure controlled and ordered movement of data from on-prem file sources into Azure storage.

<a id="creating-connections"></a>
### Creating Connections
To connect ADF to the local files on my machine, I installed a Self-Hosted Integration Runtime called “OnPremToAzureIntegrationRunTime” and configured it successfully.

I then created two linked services: one that connects directly to my local drive using the Self-Hosted Integration Runtime, and another that connects to ADLS using AutoResolve.

For the source, I created a separate dataset for each file. For the sink, I created a single dataset that points to the container file path level in ADLS.

<img width="1000" height="431" alt="image" src="https://github.com/user-attachments/assets/4b590bbd-8ed7-4148-b762-9a1adbba56ce" />

<a id="activities"></a>
### 🔄 Activities
#### 📌 Accounts Dataset (first activity)
I started with the Accounts copy activity, which reads delimited files from an on-prem file and loads them into an Azure storage sink dataset (ds_sink).

I kept this as the first step because it has no dependencies and initiates the pipeline flow.


#### 📌 Data Dictionary Dataset
Next, I configured the Data Dictionary copy activity to run only after the Accounts activity succeeds.

I enforced this dependency so that Data Dictionary processing happens only after Accounts data is successfully moved.


#### 📌 Products Dataset
After that, I added the Products copy activity, which loads product data into Azure storage.

I set it to run only after the Data Dictionary completes successfully so that the pipeline maintains a consistent processing sequence.


#### 📌 Sales Pipeline Dataset
I then added the Sales Pipeline copy activity, which processes sales pipeline data.

I configured it to run only after the Products activity succeeds so that the data flow remains strictly sequential.

#### 📌 Sales Teams dataset
After Sales Pipeline, I configured the Sales Teams copy activity.

I set it to run only after the Sales Pipeline activity succeeds, continuing the same dependency-based execution flow.

<img width="940" height="403" alt="image" src="https://github.com/user-attachments/assets/32c7dab8-9b5f-481d-9f85-4afe04f8a9b7" />

<a id="successfailure-notification"></a>
### 📩 Success/Failure Notification Using Azure Logic App (Web Activity)
I have created an Azure Logic Apps workflow to enable web activity notifications via email, providing alerts on the success or failure of the pipeline.

<img width="940" height="377" alt="image" src="https://github.com/user-attachments/assets/d1c4ee2b-9acd-420d-a216-c922c969ba3d" />


Once the final activity completes successfully, a Web Activity triggers a POST request to an Azure Logic App endpoint.

I send:

Pipeline name:

Run ID:

Timestamp:

Status: Succeeded/Failure

I added this so I can automatically track successful or Failure pipeline runs without manual monitoring.

<img width="812" height="283" alt="image" src="https://github.com/user-attachments/assets/333ac282-a9b2-4ce2-a182-36d95d73ca1a" />

<a id="ingestion-raw-data"></a>
### 📥 Ingestion Raw Data
After a successful pipeline execution, the source files are ingested into the raw-data container in ADLS, ensuring the data is securely stored and ready for further processing.

<img width="940" height="456" alt="image" src="https://github.com/user-attachments/assets/4cd73f7a-9fd5-4b32-84cd-10a97b1057da" />

<a id="azure-monitor"></a>
### 📊 Azure Monitor
I have integrated the pipeline with the Azure Monitor dashboard to track its performance and execution. This helps monitor runs, identify issues quickly, and ensure the pipeline operates reliably.

<img width="940" height="461" alt="image" src="https://github.com/user-attachments/assets/6bac92dd-d4af-4de4-84fa-6fec15ab5e4e" />


---
<a id="databricks"></a>
## 🔄  Data transformation with Azure Databricks
After the raw data has landed in ADLS, the next step is to transform it into a clean and structured format that can be used by the business for reporting and analysis. To achieve this, I used Databricks to perform data cleaning, transformation, and enrichment.

<img width="940" height="432" alt="image" src="https://github.com/user-attachments/assets/0781f220-86d1-4803-9ab1-acb5130ef4b9" />
<img width="940" height="429" alt="image" src="https://github.com/user-attachments/assets/c0b76ee1-a592-473f-9a37-0a61c598e4af" />

### 💾 Storing Processed Data

The enriched data is written back to the same storage account, following the medallion architecture approach, but into a separate container named ‘transformed-data’. This separation helps maintain a clear distinction between raw and processed data, making the architecture more organized and easier to manage.

<img width="940" height="347" alt="image" src="https://github.com/user-attachments/assets/63f53c42-5472-401d-be4e-21353929a9e5" />



### 🔐 Azure Key Vault – securing the keys
For Databricks to read from and write to ADLS, it needs secure access to the storage account. This was configured using storage access keys, which are stored securely in Azure Key Vault rather than being hardcoded. 
Databricks retrieves these keys through a Databricks Secret Scope linked to Key Vault. This approach improves security by preventing sensitive credentials from being exposed in code.

<img width="940" height="439" alt="image" src="https://github.com/user-attachments/assets/e0be35fe-0042-4abf-a753-d6127c96da48" />


---
<a id="synapse"></a>
## 🧠  Enriched data review with Azure Synapse
Now that the transformed data resides in ADLS, it can be easily queried and analyzed using Synapse Analytics. I created views for each enriched data file within a database called ‘sales’, making the data more accessible and ready for reporting and analytical use.

<img width="940" height="438" alt="image" src="https://github.com/user-attachments/assets/aa2f1ffb-661e-4b72-bf2e-96d919824f3f" />

---
<a id="power-bi"></a>
## 📈  Data analysis with Power BI
The final step was to derive business insights from the cleaned data by using Synapse database views and visualizing them in Power BI. The curated views in Synapse acted as a structured layer that made the data easy to query and consume. I then connected Power BI to these views to build interactive dashboards and reports, enabling the business to explore trends, monitor performance, and make data-driven decisions effectively.

<img width="963" height="548" alt="image" src="https://github.com/user-attachments/assets/84ef199a-30bf-4b5b-b362-2f1372db36a0" />

### Dashboard summary
#### 1. Total Deals / Win Metrics
Total Deals: 6,711
Won: 4,238
Lost: 2,473
Win Rate: 63.15%

#### 2. Sum of revenue by account
Kan-code leads with 11.70K

#### 3. Total Sales by Month
Highly fluctuating monthly trend

#### 4. Count of revenue by office location
North America dominates revenue

#### 5. Total Sales won or lost by Agent
Darcel Schlecht shows highest activity

#### 6. Number of deals won by product
GTX Basic is top-performing product

#### 7. Revenue by sector
Software: highest share (~26%)

---
<a id="summary"></a>
## 🧾  Summary of Key Actions Performed
- Designed an end-to-end Azure data architecture to define data flow from on-premises to reporting.

- Created and managed an Azure Resource Group (rg-rcm) to organize all project services.

- Provisioned an Azure Data Lake Storage (ADLS) account with separate containers for raw and transformed data.

- Built an Azure Data Factory (ADF) pipeline to ingest multiple on-prem datasets into ADLS.

- Configured a Self-Hosted Integration Runtime to securely connect on-premises data sources to Azure.

- Developed linked services and datasets in ADF to standardize data ingestion from source to sink.

- Implemented sequential pipeline orchestration with dependencies to ensure controlled and reliable data flow.

- Added automated monitoring and alerting using Azure Logic Apps and Azure Monitor for pipeline success/failure tracking.

- Performed data transformation and enrichment using Azure Databricks, following a medallion architecture approach.

- Secured sensitive credentials using Azure Key Vault with Databricks Secret Scope for safe access to storage.

- Enabled data querying and modeling in Azure Synapse Analytics by creating structured views.

- Built interactive Power BI dashboards connected to Synapse for business insights and reporting.

---
<a id="license"></a>
## 🪪 License
This project is open-source and available under the **MIT License**.

---

<a id="author"></a>
## 🌐 Author
**Mohamud  Yassin**  
💼 Data Engineer | ☁️ Azure Enthusiast   
📫 Reach me at: mmyassin12@gmail.com

- Built interactive Power BI dashboards connected to Synapse for business insights and reporting.
