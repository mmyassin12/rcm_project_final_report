# rcm_project_final_report



## 1. Overall pipeline design
I built an Azure Data Factory pipeline called onPremToCloud to move multiple on-premises datasets into Azure storage in a strict sequential order.
I structured the pipeline in Azure Data Factory as a chain of activities where each step runs only after the previous one succeeds. I did this to ensure controlled and ordered movement of data from on-prem file sources into Azure storage.

#### Creating connections
To connect ADF to the local files on my machine, I installed a Self-Hosted Integration Runtime called “OnPremToAzureIntegrationRunTime” and configured it successfully.

I then created two linked services: one that connects directly to my local drive using the Self-Hosted Integration Runtime, and another that connects to ADLS using AutoResolve.

For the source, I created a separate dataset for each file. For the sink, I created a single dataset that points to the container file path level in ADLS.

<img width="1000" height="431" alt="image" src="https://github.com/user-attachments/assets/4b590bbd-8ed7-4148-b762-9a1adbba56ce" />

#### Activities

##### A.  Accounts dataset (first activity)

I started with the Accounts copy activity, which reads delimited files from an on-prem file server and loads them into an Azure storage sink dataset (ds_sink).

I kept this as the first step because it has no dependencies and initiates the pipeline flow.

#### Data Dictionary dataset

Next, I configured the Data Dictionary copy activity to run only after the Accounts activity succeeds.

I enforced this dependency so that Data Dictionary processing happens only after Accounts data is successfully moved.

#### Products dataset

After that, I added the Products copy activity, which loads product data into Azure storage.

I set it to run only after the Data Dictionary completes successfully so that the pipeline maintains a consistent processing sequence.

I also enabled type conversion during this step to ensure data values are correctly interpreted during ingestion.

#### Sales Pipeline dataset

I then added the Sales Pipeline copy activity, which processes sales pipeline data.

I configured it to run only after the Products activity succeeds so that the data flow remains strictly sequential.

#### Sales Teams dataset

After Sales Pipeline, I configured the Sales Teams copy activity.

I set it to run only after the Sales Pipeline activity succeeds, continuing the same dependency-based execution flow.

<img width="940" height="403" alt="image" src="https://github.com/user-attachments/assets/32c7dab8-9b5f-481d-9f85-4afe04f8a9b7" />


#### Success/Failure notification (Web Activity)

Once the final activity (Sales Teams) completes successfully, I trigger a Web Activity that sends a POST request to an Azure Logic App endpoint.

I send:

Pipeline name
Run ID
Timestamp
Status = Succeeded/Failure

I added this so I can automatically track successful or Failure pipeline runs without manual monitoring.

<img width="812" height="283" alt="image" src="https://github.com/user-attachments/assets/333ac282-a9b2-4ce2-a182-36d95d73ca1a" />


