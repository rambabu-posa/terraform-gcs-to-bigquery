# terraform-gcs-to-bigquery
Its a terraform pyhon-based repository to copy data from GCS to Google BigQuery

## Pre-requisites:
1. Create "terraform_dataset" data set
2. Create "trail" table
```
 name: String
 age: String
```

## Steps:
1.  clone this project
2.  cd terraform-gcs-to-bigquery
3.  terraform init
4.  terraform plan
5.  terraform play
6.  Verify GCP resources created and execute below query to check data in Google BigQuery

```
 SELECT name, age FROM `ram-pde-project.terraform_dataset.trail`
```
