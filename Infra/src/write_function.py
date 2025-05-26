import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ.get('DYNAMODB_TABLE', 'HighAvailabilityTable'))

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        item_id = body['ItemId']
        data = body['Data']

        table.put_item(Item={'ItemId': item_id, 'Data': data})
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item saved successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }