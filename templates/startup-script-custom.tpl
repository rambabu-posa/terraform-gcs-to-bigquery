#!/bin/bash

sudo apt-get update
sudo apt-get install git -y
sudo apt-get install python-pip -y
sudo apt-get install python3-venv -y
sudo apt-get install wget -y

python3 -m venv env
source env/bin/activate

pip install google-cloud-bigquery==1.28.0
git clone https://github.com/rambabu-posa/terraform-gcs-to-bigquery
cd terraform-gcs-to-bigquery

python3 startup_script.py
