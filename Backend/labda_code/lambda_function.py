import json
import boto3
import os

s3 = boto3.client("s3")
bedrock = boto3.client("bedrock-runtime")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = os.environ["DYNAMODB_TABLE"]
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    print("Event:", json.dumps(event))
    
    # Extract bucket name and object key from event
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    object_key = event["Records"][0]["s3"]["object"]["key"]

     # Extract user ID from file path (private/user_id/filename)
    user_id = object_key.split("/")[1]
    
    # Retrieve document from S3
    response = s3.get_object(Bucket=bucket_name, Key=object_key)
    document_text = response["Body"].read().decode("utf-8")

    # Send text to Bedrock for analysis
    bedrock_response = bedrock.invoke_model(
        modelId=os.environ["BEDROCK_MODEL"],
        contentType="application/json",
        accept="application/json",
        body=json.dumps({"inputText": document_text}),
    )

    # Parse Bedrock response
    analysis_result = json.loads(bedrock_response["body"].read())

     # Store result in DynamoDB
    document_id = str(uuid.uuid4())
    table.put_item(
        Item={
            "document_id": document_id,
            "user_id": user_id,
            "document_name": object_key.split("/")[-1],
            "analysis_result": analysis_result
        }
    )

    print("Analysis Result:", analysis_result)

     return {
        "statusCode": 200,
        "body": json.dumps({"document_id": document_id, "analysis_result": analysis_result}),
    }

    