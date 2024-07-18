function OnStoredInstance(instanceId)
    -- This function is called whenever a new instance is received by Orthanc
    -- Get the study ID
    print("hello")
    local headers_orthanc = {
        ["Authorization"] = "Basic ZGVtbzpkZW1v",
        ["Content-Type"] = "application/json"
    }
    local id = ParseJson(RestApiGet('/instances/' .. instanceId))['ID']
    print(id)
    local type = ParseJson(RestApiGet('/instances/' .. instanceId))['Type']
    print(type)
    TriggerAiAnalysis(instanceId)
end

function TriggerAiAnalysis(instanceId)
    -- Implement the logic to call your AI service here
    -- You can use Orthanc's HTTP client to make requests to your FastAPI
    
    local aiUrl = 'http://localhost:5001/prediction/'
    
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
    -- local response = HttpPost(aiUrl, body, headers_ai)
    local response = HttpGet('http://localhost:5001/', headers_2)
    
    if response['status'] ~= 200 then
        print('Error triggering AI analysis for instance: ' .. instanceId)
    else
        print('AI analysis triggered for instance: ' .. instanceId)
    end
end
