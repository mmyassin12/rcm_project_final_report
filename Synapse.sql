CREATE VIEW dbo.vAccounts AS
SELECT *
FROM OPENROWSET(
    BULK 'https://strcm.blob.core.windows.net/transformed-data/accounts.csv/part-00000-tid-4607185480912689135-34fe6e09-0507-4ec0-8a89-577f856bd3f4-38-1-c000.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;

SELECT * FROM vAccounts;



CREATE VIEW dbo.vData_dictionary AS
SELECT *
FROM OPENROWSET(
    BULK 'https://strcm.blob.core.windows.net/transformed-data/data_dictionary.csv/part-00000-tid-1034518262832365136-e6c88a69-d581-4fbc-bd4a-e583a956c738-39-1-c000.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
) AS ROWS;

SELECT * FROM vData_dictionary;


CREATE VIEW dbo.vProducts AS
SELECT *
FROM OPENROWSET(
    BULK 'https://strcm.blob.core.windows.net/transformed-data/products.csv/part-00000-tid-8414887521468399549-f8f1694a-351c-4015-9b79-c86ae91dcd1f-40-1-c000.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS ROWS;

SELECT * FROM vProducts;


CREATE VIEW dbo.vSales_pipeline AS
SELECT *
FROM OPENROWSET(
    BULK 'https://strcm.blob.core.windows.net/transformed-data/sales_pipeline.csv/part-00000-tid-2984818741392967795-b726a8fb-988c-4679-a765-b259dd1aa043-41-1-c000.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS ROWS;

SELECT * FROM vSales_pipeline;


CREATE VIEW dbo.vSales_teams AS
SELECT *
FROM OPENROWSET(
    BULK 'https://strcm.blob.core.windows.net/transformed-data/sales_teams.csv/part-00000-tid-8424850345118006065-e4b01561-b8b2-4613-ae2e-b76fbf86e0fe-42-1-c000.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS ROWS;

SELECT * FROM vSales_teams;



