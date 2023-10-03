# dashlane-audit-logs-v2

The solution we offer in this article allows you to run a instance that will pull your Dashlane businnes logs and send them on the destination of you choice using the Fluentbit service. At the moment, we provide configurations for the following solutions:
* Azure logs analytics workspace
* Azure blob storage
* AWS S3
* Elasticsearch 

## Prerequisites

In order to manage the Dashlane audit logs of your business account, you need to generate the credentials that will be used to pull the logs. The procedure can be found here: https://dashlane.github.io/dashlane-cli/business



## Running an instance

### Azure container instance

```
az container create -g resource-group --name dashlane-audit-logs --image sgravis/dcli-log-catcher:0.2 -e DASHLANE_TEAM_UUID=XXX  DASHLANE_TEAM_ACCESS_KEY=XXX DASHLANE_TEAM_SECRET_KEY=XXX
```
Specify your resource groupe name and replace the "XXX" by your credentials information.

Running this command will create a simple  Azure container instance that pull the logs and print them on the stdout steam of the instance.

To specify a custom destination, you need to update the fluentbit configuration file as indicated in the following sections.


### Kubernetes

Work in progress

## Sending logs to Azure
### Log analytics workspace

If you want to send your logs to an Azure log analytics workspace, you need to retrieve its workspace ID and shared access key. If you are using an Azure container instance, you need to pass those values as an environment variables like this: 
```
az container create -g resource-group --name dashlane-audit-logs --image sgravis/dcli-log-catcher:0.2 -e DASHLANE_TEAM_UUID=XXX  DASHLANE_TEAM_ACCESS_KEY=XXX DASHLANE_TEAM_SECRET_KEY=XXX LAW_ID=XXX LAW_KEY=XXX
```

Then you need to update your Fluentbit configuration file by adding the following output configuration

```
[OUTPUT]
    Name        azure
    Match       *
    Customer_ID ${LAW_ID}
    Shared_Key  ${LAW_KEY}
```

Todo: indicate how to overwrite the config file


### Azure blob storage

If you want to send your logs to an Azure storage account, you need to retrieve its access key. If you are using an Azure container instance, you need to pass this value as an environment variables like this: 

```
az container create -g resource-group --name dashlane-audit-logs --image sgravis/dcli-log-catcher:0.2 -e DASHLANE_TEAM_UUID=XXX  DASHLANE_TEAM_ACCESS_KEY=XXX DASHLANE_TEAM_SECRET_KEY=XXX STORAGE_ACCOUNT_KEY=XXX
```


Then you need to update your Fluentbit configuration file by adding the following output configuration
```
[OUTPUT]
    name                  azure_blob
    match                 *
    account_name          dashlaneauditlogs
    shared_key            ${STORAGE_ACCOUNT_KEY}
    container_name        fluentbit
    auto_create_container on
    tls                   on
    blob_type             blockblob
```
In this configuration, we are telling Fluentbit to send the logs on a storage account named "dashlaneauditlogs" in the container "fluentbit". Be sure to validate that your Azure configuration matches the Fluentbit output configuration.

Note: the "blob_type" configuration specifies to create an entry for every log entry on the storage account, which facilitates the log their manipulation for eventual post-processing treatment.


Todo: indicate how to overwrite the config file


## Sending logs to AWS
If you want to send your logs to an AWS S3, you need to pass your credentials as environment variables;

```
export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=XXX
```

Then you need to update your Fluentbit configuration file by adding the following output configuration:

```
[OUTPUT]
     Name s3
     Match *
     bucket techweek-secu-audit-logs
     region eu-west-1
     store_dir /tmp/
     use_put_object On
     total_file_size 1M
     upload_timeout 10m
```
// aws conf still in progress

## Sending logs to Elasticsearch
Work in progress



## Notes:
All configuration are provided as is and designed to work out of the box. If you want customize them, you can consult the Fluentbit documentation: https://docs.fluentbit.io/manual/pipeline/outputs