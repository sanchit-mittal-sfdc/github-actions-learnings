public with sharing class AccountSummaryRSPTController {
    
    @InvocableMethod(label='Get child contacts' 
    description='Generate a prompt with all child contacts of the account' 
    CapabilityType='PromptTemplateType://einstein_gpt__recordSummary')
    public static List<ResponseWrapper> getChildContacts(List<RequestWrapper> input)
    {
        List<ResponseWrapper> output = new List<ResponseWrapper>();
        Account acc = input[0].objectToSummarize;
        String promptText = '';

        for(Contact c : [SELECT Id, Name, Email FROM Contact WHERE AccountId = :acc.Id])
        {
            promptText += 'Contact: ' + c.Name + ' (' + c.Email + ')\n';
        }
        ResponseWrapper rw = new ResponseWrapper();
        rw.Prompt = promptText;
        output.add(rw);
        return output;
    }

    public class RequestWrapper
    {
        @InvocableVariable(required=true)
        public Account objectToSummarize;
    }

    public class ResponseWrapper
    {
        @InvocableVariable
        public String Prompt;
    }
}