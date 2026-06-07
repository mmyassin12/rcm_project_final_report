# rcm_project_final_report



##1. Overall pipeline design
I built an Azure Data Factory pipeline called onPremToCloud to move multiple on-premises datasets into Azure storage in a strict sequential order.
I structured the pipeline in Azure Data Factory as a chain of activities where each step runs only after the previous one succeeds. I did this to ensure controlled and ordered movement of data from on-prem file sources into Azure storage.

2. Accounts dataset (first activity)

I started with the Accounts copy activity, which reads delimited files from an on-prem file server and loads them into an Azure storage sink dataset (ds_sink).

I kept this as the first step because it has no dependencies and initiates the pipeline flow.

3. Data Dictionary dataset

Next, I configured the Data Dictionary copy activity to run only after the Accounts activity succeeds.

I enforced this dependency so that Data Dictionary processing happens only after Accounts data is successfully moved.

4. Products dataset

After that, I added the Products copy activity, which loads product data into Azure storage.

I set it to run only after the Data Dictionary completes successfully so that the pipeline maintains a consistent processing sequence.

I also enabled type conversion during this step to ensure data values are correctly interpreted during ingestion.

5. Sales Pipeline dataset

I then added the Sales Pipeline copy activity, which processes sales pipeline data.

I configured it to run only after the Products activity succeeds so that the data flow remains strictly sequential.

6. Sales Teams dataset

After Sales Pipeline, I configured the Sales Teams copy activity.

I set it to run only after the Sales Pipeline activity succeeds, continuing the same dependency-based execution flow.

7. Success notification (Web Activity)

Once the final activity (Sales Teams) completes successfully, I trigger a Web Activity that sends a POST request to an Azure Logic App endpoint.

I send:

Pipeline name
Run ID
Timestamp
Status = Succeeded

I added this so I can automatically track successful pipeline runs without manual monitoring.

8. Failure notification (Web Activity)

I also configured a separate Web Activity for failure, which triggers if the Sales Teams activity fails.

It sends the same structure to the Logic App, but with status = Failed.

I included this so I get immediate visibility into any pipeline execution failure.
