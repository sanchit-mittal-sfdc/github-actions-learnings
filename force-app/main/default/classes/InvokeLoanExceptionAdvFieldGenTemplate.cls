/**
 * InvokeLoanExceptionAdvFieldGenTemplate
 * @description This class is used to call Loan Exception Advisor Field Generation Template
 * InvokeLoanExceptionAdvFieldGenTemplate.evaluateLoanApplication();
 * @param loanApplicationId - Id of the Loan Application record
 * 
 * InvokeLoanExceptionAdvFieldGenTemplate.evaluateLoanApplication('a03gL00000RIr37QAD');
 */

public with sharing class InvokeLoanExceptionAdvFieldGenTemplate
{
    public static String evaluateLoanApplication(String loanApplicationId)
    {
        // Create inputs
        Map<String, String> recordMap = new Map<String, String>();
        recordMap.put('id', loanApplicationId);
        ConnectApi.WrappedValue loanApplicationInstance = new ConnectApi.WrappedValue();
        loanApplicationInstance.value = recordMap;
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        inputParams.put('Input:Loan_Application__c', loanApplicationInstance);

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
                'Loan_Evaluation_in_JSON_Format_LWC',
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