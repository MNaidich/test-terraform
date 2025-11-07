import boto3
import json
import pandas as pd
import io

S3_CLIENT = boto3.client("s3")
SAGEMAKER_RUNTIME = boto3.client("sagemaker-runtime")

BUCKET_NAME = "forecasting-app-s3"
MODEL_ENDPOINT = "xgboost-endpoint"  # ← Debe coincidir con tu endpoint desplegado

def lambda_handler(event, context):
    """
    Simula la inferencia sobre datos nuevos:
    - Descarga un CSV de entrada
    - Invoca el endpoint de SageMaker
    - Guarda resultados en S3
    """
    try:
        input_key = "inference/new_data.csv"
        obj = S3_CLIENT.get_object(Bucket=BUCKET_NAME, Key=input_key)
        df = pd.read_csv(io.BytesIO(obj["Body"].read()))

        # Convertimos a CSV sin header para enviar al endpoint
        csv_buffer = io.StringIO()
        df.to_csv(csv_buffer, header=False, index=False)

        # --- 1. Invocar el endpoint ---
        response = SAGEMAKER_RUNTIME.invoke_endpoint(
            EndpointName=MODEL_ENDPOINT,
            ContentType="text/csv",
            Body=csv_buffer.getvalue()
        )

        # --- 2. Procesar resultado ---
        result = response["Body"].read().decode("utf-8").strip().split("\n")
        df["prediction"] = result

        # --- 3. Guardar salida en S3 ---
        output_key = "predictions/predicted_data.csv"
        df.to_csv("/tmp/predicted_data.csv", index=False)
        S3_CLIENT.upload_file("/tmp/predicted_data.csv", BUCKET_NAME, output_key)

        print(f"Predicciones guardadas en s3://{BUCKET_NAME}/{output_key}")

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Predictions generated successfully", "output_key": output_key})
        }

    except Exception as e:
        print(f"Error en predicción: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }