🎯 Project Goal & Problem Statement

This project aims to design and implement a complete Azure-based data engineering solution that moves data from on-premises systems into the cloud, processes it, and makes it available for analysis. The core problem it solves is the fragmentation and inefficiency of working with raw, unstructured data stored locally, which makes it difficult to manage, monitor, and derive meaningful insights.

By building an automated pipeline using Azure services, the project centralizes data storage, ensures consistent and reliable data ingestion, and transforms raw data into a clean, structured format suitable for analytics. It also introduces monitoring, security, and scalability, which are typically lacking in manual systems.

🏗️ 1. Project architecture

First, I have started with creating the project layout, as it helps outline the steps involved in a clear and visual way at a conceptual level.

<img width="1042" height="559" alt="image" src="https://github.com/user-attachments/assets/66f92e22-95b4-4582-b7e8-6b62f6e56fa2" />
🧱 2. Resource group

For this project, I created a Resource Group named “rg-rcm”. This resource group is used to store and manage all the components involved in the solution, such as Azure Data Factory, storage accounts, and any supporting services.

<img width="940" height="365" alt="image" src="https://github.com/user-attachments/assets/d54489ee-0375-49e7-b1e6-0827767ea8f4" />
🗄️ 3. Storage account

I created a storage account with two containers: one to store the raw data ingested from on-premises, and another to hold the transformed data after it has been cleaned and processed in Databricks.

<img width="940" height="452" alt="image" src="https://github.com/user-attachments/assets/b5b35d54-ca21-4f5b-8f7b-6f546ee6da2e" />
⚙️ 4. Pipeline design

I built an Azure Data Factory pipeline called onPremToCloud to move multiple on-premises datasets into Azure storage in a strict sequential order.
I structured the pipeline in Azure Data Factory as a chain of activities where each step runs only after the previous one succeeds.

🔌 Creating connections

To connect ADF to the local files on my machine, I installed a Self-Hosted Integration Runtime called “OnPremToAzureIntegrationRunTime” and configured it successfully.

I then created two linked services: one that connects directly to my local drive using the Self-Hosted Integration Runtime, and another that connects to ADLS using AutoResolve.

🔄 Activities
📌 Accounts dataset (first activity)

I started with the Accounts copy activity, which reads delimited files from an on-prem file and loads them into an Azure storage sink dataset (ds_sink).

📌 Data Dictionary dataset

Next, I configured the Data Dictionary copy activity to run only after the Accounts activity succeeds.

📌 Products dataset

After that, I added the Products copy activity, which loads product data into Azure storage.

📌 Sales Pipeline dataset

I then added the Sales Pipeline copy activity, which processes sales pipeline data.

📌 Sales Teams dataset

After Sales Pipeline, I configured the Sales Teams copy activity.

📩 Success/Failure notification using Azure Logic App (Web Activity)

Once the final activity completes successfully, a Web Activity triggers a POST request to an Azure Logic App endpoint.

📥 Ingestion Raw data

After successful pipeline execution, the source files are ingested into the ‘raw-data’ container in ADLS.

📊 Azure monitor

Pipeline execution is tracked using Azure Monitor for performance and reliability.

🔄 5. Data transformation with azure Databricks

After the raw data has landed in ADLS, the next step is transformation using Databricks.

💾 Storing processed data

The enriched data is written into the ‘transformed-data’ container following a medallion architecture approach.

🔐 Azure key vault – securing the keys

Databricks retrieves storage access keys securely from Azure Key Vault using Secret Scope.

🧠 6. Enriched data review with Azure Synapse

Now that the transformed data resides in ADLS, it can be easily queried and analyzed using Synapse Analytics. I created views for each enriched data file within a database called ‘sales’, making the data more accessible and ready for reporting and analytical use.

<img width="940" height="438" alt="image" src="https://github.com/user-attachments/assets/aa2f1ffb-661e-4b72-bf2e-96d919824f3f" />
📈 7. Data analysis with Power BI

The final step was to derive business insights from the cleaned data by using Synapse database views and visualizing them in Power BI. The curated views in Synapse acted as a structured layer that made the data easy to query and consume. I then connected Power BI to these views to build interactive dashboards and reports, enabling the business to explore trends, monitor performance, and make data-driven decisions effectively.

<img width="963" height="548" alt="image" src="https://github.com/user-attachments/assets/84ef199a-30bf-4b5b-b362-2f1372db36a0" />
Dashboard summary
1. Total Deals / Win Metrics

Total Deals: 6,711
Won: 4,238
Lost: 2,473
Win Rate: 63.15%

2. Sum of revenue by account

Kan-code leads with 11.70K

3. Total Sales by Month

Highly fluctuating monthly trend

4. Count of revenue by office location

North America dominates revenue

5. Total Sales won or lost by Agent

Darcel Schlecht shows highest activity

6. Number of deals won by product

GTX Basic is top-performing product

7. Revenue by sector

Software: highest share (~26%)

🧾 8. Summary of Key Actions Performed

Designed an end-to-end Azure data architecture to define data flow from on-premises to reporting.

Created and managed an Azure Resource Group (rg-rcm) to organize all project services.

Provisioned an Azure Data Lake Storage (ADLS) account with separate containers for raw and transformed data.

Built an Azure Data Factory (ADF) pipeline to ingest multiple on-prem datasets into ADLS.

Configured a Self-Hosted Integration Runtime to securely connect on-premises data sources to Azure.

Developed linked services and datasets in ADF to standardize data ingestion from source to sink.

Implemented sequential pipeline orchestration with dependencies to ensure controlled and reliable data flow.

Added automated monitoring and alerting using Azure Logic Apps and Azure Monitor for pipeline success/failure tracking.

Performed data transformation and enrichment using Azure Databricks, following a medallion architecture approach.

Secured sensitive credentials using Azure Key Vault with Databricks Secret Scope for safe access to storage.

Enabled data querying and modeling in Azure Synapse Analytics by creating structured views.

Built interactive Power BI dashboards connected to Synapse for business insights and reporting.
