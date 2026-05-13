public with sharing class AccountSummaryController 
{
    @InvocableMethod(
        label='Get Contacts' 
        description='Generate a prompt with all child contacts of the account'
        CapabilityType='PromptTemplateType://einstein_gpt__fieldCompletion')
    public static List<ResponseWrapper> getContacts(List<RequestWrapper> input)
    {
        List<ResponseWrapper> output = new List<ResponseWrapper>();
        Account a = input[0].RelatedEntity;
        String promptText = '';
        Integer i = 1;
        
        for(Contact c : [SELECT Id, Name, Email FROM Contact WHERE AccountId = :a.Id])
        {
            
            promptText += 'Contact ' + i + ': ' + c.Name + ' (' + c.Email + ')\n';
            i++;
        }
        ResponseWrapper rw = new ResponseWrapper();
        rw.Prompt = promptText;
        output.add(rw);

        return output;
    }

    public class RequestWrapper
    {
        @InvocableVariable(required=true)
        public Account RelatedEntity;
    }

    public class ResponseWrapper
    {
        @InvocableVariable
        public String Prompt;
    }
}