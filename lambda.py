import json
import os
import urllib.request

def lambda_handler(event, context):
    print("Hello from Lambda!")
    #Implement code here - Mahesh
    #Security Headers here 
    headers = {
        'X-Siemens-Auth': 'test',
        'Accept': 'application/json',
        'Content-Type': 'application/json' # necessary to make understand python intrepretor to AWS via Lambda 
        
    }

    # Payload here 
    payload = {
        "subnet_id": os.environ['Mahesh_Subnet'],
        "name": "Mahesh Chaudhari",
        "email": "mahesh.chaudhari@siemens.com"
    }
    data = json.dumps(payload).encode('utf-8')
    url = 'https://ij92qpvpma.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data'
    req = urllib.request.Request(url, data, headers)
    response = urllib.request.urlopen(req)

    return {
        'statusCode': response.getcode(),
        'body': json.read(response).decode('utf-8')
    }
