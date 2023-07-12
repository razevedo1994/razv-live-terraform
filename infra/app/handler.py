import json
import boto3
import datetime

def lambda_handler(event, context):
    s3 = boto3.resource('s3')
    bucket_name = 'live-terraform'
    landing_zone_prefix = 'landing-zone/logs/'
    
    current_date = datetime.date.today().strftime('%Y-%m-%d')
    
    events = generate_fake_events()
    
    events_json = [json.dumps(event) for event in events]
    
    partition_path = f'{landing_zone_prefix}{current_date}/'
    s3_objects = list(s3.Bucket(bucket_name).objects.filter(Prefix=partition_path))
    
    if len(s3_objects) > 0:
        existing_data = [s3_object.get()['Body'].read().decode('utf-8') for s3_object in s3_objects]
        existing_events = [json.loads(data) for data in existing_data]
        all_events = existing_events + events
        all_events_json = [json.dumps(event) for event in all_events]
        
        s3_object = s3.Object(bucket_name, s3_objects[0].key)
        s3_object.put(Body='\n'.join(all_events_json))
        
        return {
            'statusCode': 200,
            'body': 'Eventos adicionados à partição existente.'
        }
    else:
        s3_object = s3.Object(bucket_name, f'{partition_path}events.json')
        s3_object.put(Body='\n'.join(events_json))
        
        return {
            'statusCode': 200,
            'body': 'Partição criada e eventos adicionados.'
        }

def generate_fake_events():
    return [
        {'timestamp': '2023-07-10T10:00:00', 'user': 'user1', 'page': 'home'},
        {'timestamp': '2023-07-10T10:05:00', 'user': 'user2', 'page': 'about'},
        {'timestamp': '2023-07-10T10:10:00', 'user': 'user1', 'page': 'products'},
        {'timestamp': '2023-07-10T10:15:00', 'user': 'user3', 'page': 'home'},
        {'timestamp': '2023-07-10T10:20:00', 'user': 'user2', 'page': 'contact'}
    ]
