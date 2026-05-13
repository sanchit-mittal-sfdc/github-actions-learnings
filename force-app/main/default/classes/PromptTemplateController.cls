public with sharing class PromptTemplateController {
    @AuraEnabled
    public static String generateAccountSummary(String accountId)
    {
        // Create inputs
        Map<String, String> recordMap = new Map<String, String>();
        recordMap.put('id', accountId);
        ConnectApi.WrappedValue accountInstance = new ConnectApi.WrappedValue();
        accountInstance.value = recordMap;
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        inputParams.put('Input:Account', accountInstance);

        // Configure invocation parameters
        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = inputParams;

        try
        {
            // Call the service
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                'Account_Summary_Prompt',
                executeTemplateInput
            );
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            return response.text;
        } 
        catch (Exception e)
        {
            System.debug(e.getMessage());
            throw e;
        }
    }
}