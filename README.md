# rcm_project_final_report

{
	"name": "onPremToCloud",
	"properties": {
		"activities": [
			{
				"name": "Accounts",
				"type": "Copy",
				"dependsOn": [],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"source": {
						"type": "DelimitedTextSource",
						"storeSettings": {
							"type": "FileServerReadSettings",
							"recursive": true,
							"enablePartitionDiscovery": false
						},
						"formatSettings": {
							"type": "DelimitedTextReadSettings"
						}
					},
					"sink": {
						"type": "DelimitedTextSink",
						"storeSettings": {
							"type": "AzureBlobFSWriteSettings"
						},
						"formatSettings": {
							"type": "DelimitedTextWriteSettings",
							"quoteAllText": true,
							"fileExtension": ".txt"
						}
					},
					"enableStaging": false,
					"translator": {
						"type": "TabularTranslator",
						"typeConversion": true,
						"typeConversionSettings": {
							"allowDataTruncation": true,
							"treatBooleanAsNumber": false
						}
					}
				},
				"inputs": [
					{
						"referenceName": "ds_accountsSource",
						"type": "DatasetReference"
					}
				],
				"outputs": [
					{
						"referenceName": "ds_sink",
						"type": "DatasetReference"
					}
				]
			},
			{
				"name": "Data Dictionary",
				"type": "Copy",
				"dependsOn": [
					{
						"activity": "Accounts",
						"dependencyConditions": [
							"Succeeded"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"source": {
						"type": "DelimitedTextSource",
						"storeSettings": {
							"type": "FileServerReadSettings",
							"recursive": true,
							"enablePartitionDiscovery": false
						},
						"formatSettings": {
							"type": "DelimitedTextReadSettings"
						}
					},
					"sink": {
						"type": "DelimitedTextSink",
						"storeSettings": {
							"type": "AzureBlobFSWriteSettings"
						},
						"formatSettings": {
							"type": "DelimitedTextWriteSettings",
							"quoteAllText": true,
							"fileExtension": ".txt"
						}
					},
					"enableStaging": false,
					"translator": {
						"type": "TabularTranslator",
						"typeConversion": true,
						"typeConversionSettings": {
							"allowDataTruncation": true,
							"treatBooleanAsNumber": false
						}
					}
				},
				"inputs": [
					{
						"referenceName": "ds_datadictionarySource",
						"type": "DatasetReference"
					}
				],
				"outputs": [
					{
						"referenceName": "ds_sink",
						"type": "DatasetReference"
					}
				]
			},
			{
				"name": "Products",
				"type": "Copy",
				"dependsOn": [
					{
						"activity": "Data Dictionary",
						"dependencyConditions": [
							"Succeeded"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"source": {
						"type": "DelimitedTextSource",
						"storeSettings": {
							"type": "FileServerReadSettings",
							"recursive": true,
							"enablePartitionDiscovery": false
						},
						"formatSettings": {
							"type": "DelimitedTextReadSettings"
						}
					},
					"sink": {
						"type": "DelimitedTextSink",
						"storeSettings": {
							"type": "AzureBlobFSWriteSettings"
						},
						"formatSettings": {
							"type": "DelimitedTextWriteSettings",
							"quoteAllText": true,
							"fileExtension": ".txt"
						}
					},
					"enableStaging": false,
					"translator": {
						"type": "TabularTranslator",
						"typeConversion": true,
						"typeConversionSettings": {
							"allowDataTruncation": true,
							"treatBooleanAsNumber": false
						}
					}
				},
				"inputs": [
					{
						"referenceName": "ds_productsSource",
						"type": "DatasetReference"
					}
				],
				"outputs": [
					{
						"referenceName": "ds_sink",
						"type": "DatasetReference"
					}
				]
			},
			{
				"name": "Sales Pipeline",
				"type": "Copy",
				"dependsOn": [
					{
						"activity": "Products",
						"dependencyConditions": [
							"Succeeded"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"source": {
						"type": "DelimitedTextSource",
						"storeSettings": {
							"type": "FileServerReadSettings",
							"recursive": true,
							"enablePartitionDiscovery": false
						},
						"formatSettings": {
							"type": "DelimitedTextReadSettings"
						}
					},
					"sink": {
						"type": "DelimitedTextSink",
						"storeSettings": {
							"type": "AzureBlobFSWriteSettings"
						},
						"formatSettings": {
							"type": "DelimitedTextWriteSettings",
							"quoteAllText": true,
							"fileExtension": ".txt"
						}
					},
					"enableStaging": false,
					"translator": {
						"type": "TabularTranslator",
						"typeConversion": true,
						"typeConversionSettings": {
							"allowDataTruncation": true,
							"treatBooleanAsNumber": false
						}
					}
				},
				"inputs": [
					{
						"referenceName": "ds_salespipelineSource",
						"type": "DatasetReference"
					}
				],
				"outputs": [
					{
						"referenceName": "ds_sink",
						"type": "DatasetReference"
					}
				]
			},
			{
				"name": "Sales Teams",
				"type": "Copy",
				"dependsOn": [
					{
						"activity": "Sales Pipeline",
						"dependencyConditions": [
							"Succeeded"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"source": {
						"type": "DelimitedTextSource",
						"storeSettings": {
							"type": "FileServerReadSettings",
							"recursive": true,
							"enablePartitionDiscovery": false
						},
						"formatSettings": {
							"type": "DelimitedTextReadSettings"
						}
					},
					"sink": {
						"type": "DelimitedTextSink",
						"storeSettings": {
							"type": "AzureBlobFSWriteSettings"
						},
						"formatSettings": {
							"type": "DelimitedTextWriteSettings",
							"quoteAllText": true,
							"fileExtension": ".txt"
						}
					},
					"enableStaging": false,
					"translator": {
						"type": "TabularTranslator",
						"typeConversion": true,
						"typeConversionSettings": {
							"allowDataTruncation": true,
							"treatBooleanAsNumber": false
						}
					}
				},
				"inputs": [
					{
						"referenceName": "ds_salesteamSource",
						"type": "DatasetReference"
					}
				],
				"outputs": [
					{
						"referenceName": "ds_sink",
						"type": "DatasetReference"
					}
				]
			},
			{
				"name": "Success",
				"type": "WebActivity",
				"dependsOn": [
					{
						"activity": "Sales Teams",
						"dependencyConditions": [
							"Succeeded"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"method": "POST",
					"url": "https://prod-38.uksouth.logic.azure.com:443/workflows/bac96fff64cf4deba27c44f687345f05/triggers/When_an_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_an_HTTP_request_is_received%2Frun&sv=1.0&sig=8cvqriX8p9nh8NWDRrhKjBxyQVfV9y5srbm0ot8Hos4",
					"body": {
						"value": "{\n    \"pipelineName\" : \"@{pipeline().Pipeline}\",\n    \"status\" : \"Succeeded\",\n    \"runId\" : \"@{pipeline().RunId}\",\n    \"time\" : \"@{utcNow()}\"\n}",
						"type": "Expression"
					}
				}
			},
			{
				"name": "Fail",
				"type": "WebActivity",
				"dependsOn": [
					{
						"activity": "Sales Teams",
						"dependencyConditions": [
							"Failed"
						]
					}
				],
				"policy": {
					"timeout": "0.12:00:00",
					"retry": 0,
					"retryIntervalInSeconds": 30,
					"secureOutput": false,
					"secureInput": false
				},
				"userProperties": [],
				"typeProperties": {
					"method": "POST",
					"url": "https://prod-38.uksouth.logic.azure.com:443/workflows/bac96fff64cf4deba27c44f687345f05/triggers/When_an_HTTP_request_is_received/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2FWhen_an_HTTP_request_is_received%2Frun&sv=1.0&sig=8cvqriX8p9nh8NWDRrhKjBxyQVfV9y5srbm0ot8Hos4",
					"body": {
						"value": "{\n    \"pipelineName\" : \"@{pipeline().Pipeline}\",\n    \"status\" : \"Failed\",\n    \"runId\" : \"@{pipeline().RunId}\",\n    \"time\" : \"@{utcNow()}\"\n}",
						"type": "Expression"
					}
				}
			}
		],
		"annotations": []
	}
}
