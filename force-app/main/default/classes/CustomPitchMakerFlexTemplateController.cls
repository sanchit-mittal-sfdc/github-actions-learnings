/**
 * CustomPitchMakerFlexTemplateController
 * @description This class is used to generate a custom pitch for a contact based on the products they are interested in.
 * 
 * CustomPitchMakerFlexTemplateController.generateCustomPitch
 * @param contactId
 * @param product1Id
 * @param product2Id
 * @return String - Generated pitch text
 */

public with sharing class CustomPitchMakerFlexTemplateController
{
    @AuraEnabled
    public static String generateCustomPitch(Id contactId, Id product1Id, Id product2Id)
    {
        // Create inputs
        Map<String, String> contactMap = new Map<String, String>();
        contactMap.put('id', contactId);

        Map<String, String> product1Map = new Map<String, String>();
        product1Map.put('id', product1Id);

        Map<String, String> product2Map = new Map<String, String>();
        product2Map.put('id', product2Id);


        ConnectApi.WrappedValue contactInstance = new ConnectApi.WrappedValue();
        contactInstance.value = contactMap;

        ConnectApi.WrappedValue product1Instance = new ConnectApi.WrappedValue();
        product1Instance.value = product1Map;

        ConnectApi.WrappedValue product2Instance = new ConnectApi.WrappedValue();
        product2Instance.value = product2Map;

        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        inputParams.put('Input:Contact', contactInstance);
        inputParams.put('Input:Product1', product1Instance);
        inputParams.put('Input:Product2', product2Instance);

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
                'Product_Pitch_Flex_Template',
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