# import orthanc
# import requests
# import json
# import pprint

# def on_stored_instance(dicom, instance_id):
#     print(f'Received instance {instance_id} of size {dicom.GetInstanceSize()} '
#           f'(transfer syntax {dicom.GetInstanceMetadata("TransferSyntax")}, '
#           f'SOP class UID {dicom.GetInstanceMetadata("SopClassUid")})')

#     # Print the origin information
#     if dicom.GetInstanceOrigin() == orthanc.InstanceOrigin.DICOM_PROTOCOL:
#         print('This instance was received through the DICOM protocol')
#     elif dicom.GetInstanceOrigin() == orthanc.InstanceOrigin.REST_API:
#         print('This instance was received through the REST API')

#     # Print the DICOM tags
#     pprint.pprint(json.loads(dicom.GetInstanceSimplifiedJson()))

#     # Extract ID and Type
#     instance_info = requests.get(f'http://localhost:8042/instances/{instance_id}').json()
#     id_ = instance_info['ID']
#     type_ = instance_info['Type']
#     print(id_)
#     print(type_)

#     # Trigger AI analysis
#     trigger_ai_analysis(instance_id)

# def trigger_ai_analysis(instance_id):
#     ai_url = 'http://localhost:5001/prediction/'
    
#     # Get the DICOM file
#     dicom_file = requests.get(f'http://localhost:8042/instances/{instance_id}/file').content
    
#     # Create a multipart form data body
#     files = {'file': (f'{instance_id}.dcm', dicom_file, 'application/dicom')}
    
#     # Send the DICOM file to the AI service
#     response = requests.post(ai_url, files=files)

#     if response.status_code != 200:
#         print(f'Error triggering AI analysis for instance: {instance_id}')
#     else:
#         print(f'AI analysis triggered for instance: {instance_id}')

# orthanc.RegisterOnStoredInstanceCallback(on_stored_instance)


print("HI")