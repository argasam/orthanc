function OnStoredInstance(instanceId)
    -- This function is called whenever a new instance is received by Orthanc
    -- Get the study ID
    local tags = ParseJson(RestApiGet('/instances/' .. instanceId .. '/tags?short'))
    local studyInstanceUid = tags['0020,000d']
    
    -- Check if this is the last instance of the study
    local instances = ParseJson(RestApiGet('/studies/' .. studyInstanceUid))['Instances']
    if #instances == 1 then
        -- This is the first (and possibly only) instance of the study
        -- Trigger AI analysis
        TriggerAiAnalysis(studyInstanceUid)
    end
end

function TriggerAiAnalysis(studyInstanceUid)
    -- Implement the logic to call your AI service here
    -- You can use Orthanc's HTTP client to make requests to your FastAPI
    
    local url = 'http://localhost:8000/predict_study/'
    local headers = {}
    headers['Content-Type'] = 'application/json'
    
    local body = {}
    body['study_id'] = studyInstanceUid
    
    local response = HttpPost(url, DumpJson(body), headers)
    
    if response['status'] ~= 200 then
        print('Error triggering AI analysis for study: ' .. studyInstanceUid)
    else
        print('AI analysis triggered for study: ' .. studyInstanceUid)
    end
end