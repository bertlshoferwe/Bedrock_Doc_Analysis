import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ["DYNAMODB_TABLE"]
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    user_id = event["queryStringParameters"]["user_id"]

    response = table.query(
        IndexName="UserIndex",
        KeyConditionExpression="user_id = :uid",
        ExpressionAttributeValues={":uid": user_id}
    )

    return {
        "statusCode": 200,
        "body": json.dumps(response["Items"]),
        "headers": {"Content-Type": "application/json"}
    }