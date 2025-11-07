import boto3
import json
from datetime import datetime

SAGEMAKER_CLIENT = boto3.client('sagemaker')
SAGEMAKER_ROLE = 'arn:aws:iam::599520171487:role/role-sage-maker-full'

def lambda_handler(event, context):
    timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    training_job_name = f"xgboost-train-{timestamp}"

    training_json = {
        "TrainingJobName": training_job_name,
        "RoleArn": SAGEMAKER_ROLE,
        "ResourceConfig": {
            "InstanceType": "ml.m5.large",
            "InstanceCount": 1,
            "VolumeSizeInGB": 10
        },
        "StoppingCondition": {
            "MaxRuntimeInSeconds": 3600
        },
        "AlgorithmSpecification": {
            "TrainingImage": "301217894520.dkr.ecr.us-east-2.amazonaws.com/sagemaker-xgboost:1.7-1",
            "TrainingInputMode": "File"
        },
        "OutputDataConfig": {
            "S3OutputPath": "s3://forecasting-app-s3/model/"
        },
        "HyperParameters": {
            "num_round": "100",
            "eta": "0.1",
            "objective": "reg:squarederror"
        },
        "InputDataConfig": [
            {
                "ChannelName": "train",
                "DataSource": {
                    "S3DataSource": {
                        "S3DataType": "S3Prefix",
                        "S3Uri": "s3://forecasting-app-s3/processed/train.csv",
                        "S3DataDistributionType": "FullyReplicated"
                    }
                },
                "ContentType": "text/csv"
            }
        ]
    }

    try:
        response = SAGEMAKER_CLIENT.create_training_job(**training_json)
        print(f"✅ Training Job iniciado: {training_job_name}")
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Training job started', 'job_name': training_job_name})
        }
    except Exception as e:
        print(f"❌ Error al iniciar Training Job: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
