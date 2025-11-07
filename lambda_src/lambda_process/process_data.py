import boto3
import json
import pandas as pd
import io

S3_CLIENT = boto3.client("s3")
BUCKET_NAME = "forecasting-app-s3"

def lambda_handler(event, context):
    """
    Simula procesamiento de datos:
    - Descarga un CSV desde S3 (raw/data.csv)
    - Realiza una limpieza básica (por ejemplo: elimina nulos)
    - Guarda el archivo procesado en processed/train.csv
    """
    try:
        # --- 1. Descargar archivo desde S3 ---
        raw_key = "raw/data.csv"
        obj = S3_CLIENT.get_object(Bucket=BUCKET_NAME, Key=raw_key)
        df = pd.read_csv(io.BytesIO(obj["Body"].read()))

        # --- 2. Procesar datos ---
        df = df.dropna()  # Ejemplo simple
        df.to_csv("/tmp/train.csv", index=False)

        # --- 3. Subir archivo procesado ---
        processed_key = "processed/train.csv"
        S3_CLIENT.upload_file("/tmp/train.csv", BUCKET_NAME, processed_key)

        print(f"Archivo procesado y guardado en s3://{BUCKET_NAME}/{processed_key}")

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Data processed successfully", "output_key": processed_key})
        }

    except Exception as e:
        print(f"Error en procesamiento: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }