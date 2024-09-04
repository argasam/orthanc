function OnStoredInstance(instanceId)
    AnonymizeDicomInstance(instanceId)
    TriggerAiAnalysis(instanceId)
end

function TriggerAiAnalysis(instanceId)
    -- Implement the logic to call your AI service here
    -- You can use Orthanc's HTTP client to make requests to your FastAPI
    
    local aiUrl = 'http://172.18.0.4:80/prediction/'
    
    local headers_orthanc = {
        ["Authorization"] = "Basic ZGVtbzpkZW1v",
        ["Content-Type"] = "application/json"
    }
    -- Get the DICOM file
    local dicomFile = RestApiGet('/instances/' .. instanceId .. '/file', true, headers_orthanc)
    
    -- Create a multipart form data body
    local boundary = "--boundary"
    local body = boundary .. "\r\n" ..
                  'Content-Disposition: form-data; name="file"; filename="' .. instanceId .. '.dcm\"\r\n' ..
                  "Content-Type: application/dicom\r\n\r\n" ..
                  dicomFile .. "\r\n" ..
                  boundary .. "--\r\n"
 
    -- Headers for AI service API
    local headers_ai = {
        ["Content-Type"] = "multipart/form-data; boundary=boundary",
        ["accept"] = "application/json",
        ["Content-Length"] = body:len()
    }
    local headers_2 = {
        ["Content-Type"] = "application/json"
    }
 
    -- Send the DICOM file to the AI service
    local response = HttpPost(aiUrl, body, headers_ai)
    -- local response = HttpGet('http://localhost:5001/', headers_2)
    
    if response['status'] ~= 200 then
        print('Error triggering AI analysis for instance: ' .. instanceId)
    else
        print('AI analysis triggered for instance: ' .. instanceId)
    end
end

function AnonymizeDicomInstance(instanceId)
    
    local replace = {
        PatientName = 'Hello',
        ['0010-1001'] = 'World'
    }

    -- The tags to be kept
    local keep = {
        'StudyDescription',
        'SeriesDescription'
    }

    -- Create the command table
    local command = {
        Replace = replace,
        Keep = keep,
        KeepPrivateTags = true,
    }

    -- Serialize the command table to JSON
    local payload = DumpJson(command, true)

    -- Headers for Orthanc API request
    local headers_orthanc = {
        ["Authorization"] = "Basic ZGVtbzpkZW1v",
        ["Content-Type"] = "application/json"
    }

    -- Send the anonymization request to Orthanc
    -- Orthanc REST API URL for anonymization
    local anonym = RestApiPost('/instances/' .. instanceId .. '/anonymize', '{}')
    
    -- Check the response status
    if anonym['status'] ~= 200 then
        print('Error anonymizing instance: ' .. instanceId)
    else
        print('Instance anonymized: ' .. instanceId)
    end
end
