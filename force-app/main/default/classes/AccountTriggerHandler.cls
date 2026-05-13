public with sharing class AccountTriggerHandler
{
    public static void handleAfterInsert(Map<Id, Account> newMap)
    {
        Map<Id, String> mapAccountIdToSummary = new Map<Id, String>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Account a : newMap.values())
        {
            String summary = PromptTemplateController.generateAccountSummary(a.Id);
            mapAccountIdToSummary.put(a.Id, summary);
        }

        for(Id accId: mapAccountIdToSummary.keySet())
        {
            accountsToUpdate.add( new Account(Id = accId, Account_Summary__c = mapAccountIdToSummary.get(accId)) );
        }

        if(accountsToUpdate.size() > 0)
            update accountsToUpdate;
    }


    public static void handleAfterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap)
    {
        Map<Id, String> mapAccountIdToSummary = new Map<Id, String>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Account a : newMap.values())
        {
            // Only regenerate summary if relevant fields have changed
            if(oldMap.get(a.Id).Account_Summary__c != a.Account_Summary__c)
                continue;

            String summary = PromptTemplateController.generateAccountSummary(a.Id);
            mapAccountIdToSummary.put(a.Id, summary);
        }

        for(Id accId: mapAccountIdToSummary.keySet())
        {
            accountsToUpdate.add( new Account(Id = accId, Account_Summary__c = mapAccountIdToSummary.get(accId)) );
        }

        if(accountsToUpdate.size() > 0)
            update accountsToUpdate;
    }
}