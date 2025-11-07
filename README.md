# Forecasting Tool

## Introduction and Architecture

### Purpose and Scope

### Architecture Diagram

### Tools Used

## Configuration

### S3 Bucket

The Amazon S3 Bucket resource will be used to store the Streamlit application files, machine learning models, and input/output data. It also initializes the five required folder paths:

* */input* : Contains the raw data coming from NetSuite, uploaded either automatically or manually, plus the mapping files that will be uploaded and updated manually.
* */processed* : Contains a .csv file with the processed data after aggregation, cleansing and mapping, ready to use as a train dataset for the model.
* */model* : Contains a .tar.gz file for each trained model. It is automatically updated every month when the model is trained.
* */output* : Contains the files with the predictions of the model for the following months. It is automatically updated every month when the model is trained or if any of the files in the input folder is updated.
* */python_files* : Contains all the necessary .py and .zip files to process the data, train the model, get the predictions and run the Streamlit app.

### EC2 Instance

The Amazon EC2 (Elastic Compute Cloud) Instance will serve as the host for the Python Streamlit application.

### Lambda Functions

#### Lambda 1: Process

The goal of the first Lambda function is to process all the input files into one .csv file that summarizes all the necessary data for training the model. 


#### Lambda 2: Train

#### Lambda 3: Predict


## Operations and Management

### Maintenance and Operations

### Estimated Costs