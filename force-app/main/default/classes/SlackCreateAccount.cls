public without sharing class SlackCreateAccount {
    
    @InvocableMethod(label='Create Account' description='Create account if it does not exists else return the link of existing account')
    public static List<ResponseWrapper> createAccountIfNotExists(List<RequestWrapper> input)
    {
        List<ResponseWrapper> response = new List<ResponseWrapper>();

        RequestWrapper req = input[0];
        String accountName = req.accountName; // it can have leading ir trailing whitespaces
        String accountType = req.accountType;
        String accountRating = req.accountRating;

        if(String.isBlank(accountName) || accountName.trim() == '')
        {
            ResponseWrapper res = new ResponseWrapper();
            res.message = 'Account Name is required';
            res.isSuccess = false;
            response.add(res);
            return response;
        }

        accountName = accountName.trim();
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name = :accountName LIMIT 1];
        if(accList.size() > 0)
        {
            ResponseWrapper res = new ResponseWrapper();
            res.accountId = accList[0].Id;
            res.accountName = accList[0].Name;
            res.accountLink = URL.getOrgDomainUrl().toExternalForm() + '/' + accList[0].Id;
            res.isAccountAlreadyExists = true;
            res.isSuccess = true;
            res.message = 'Account already exists';
            response.add(res);
            return response;
        }
        else
        {
            Account acc = new Account();
            acc.Name = accountName;

            if(accountType != null)
            {
                acc.Type = accountType;
            }

            if(accountRating != null)
            {
                acc.Rating = accountRating;
            }

            insert acc;
            ResponseWrapper res = new ResponseWrapper();
            res.accountId = acc.Id;
            res.accountName = acc.Name;
            res.accountLink = URL.getOrgDomainUrl().toExternalForm() + '/' + acc.Id;
            res.isAccountAlreadyExists = false;
            res.isSuccess = true;
            res.message = 'Account created successfully';
            response.add(res);
        }

        return response;
    }

    public class RequestWrapper
    {
        @InvocableVariable(required = true label='Account Name' description='Name of the Account to be created')
        public String accountName;

        @InvocableVariable(label='Account Type' description='Type of the Account to be created. Some of the Valid values are like Customer - Direct, Customer - Channel, Prospect etc')
        public String accountType;

        @InvocableVariable(label='Account Rating' description='Rating of the Account to be created like Hot, Warm, Cold')
        public String accountRating;
    }

    public class ResponseWrapper
    {
        @InvocableVariable(label='Account Link' description='Link of the created or existing Account')
        public String accountLink;

        @InvocableVariable(label='Account Id' description='Id of the created or existing Account')
        public Id accountId;

        @InvocableVariable(label='Account Name' description='Name of the created or existing Account')
        public String accountName;

        @InvocableVariable(label='Success' description='Indicates if the operation was successful or not.')
        public Boolean isAccountAlreadyExists;

        @InvocableVariable(label='Success' description='Indicates if the operation was successful or not.')
        public Boolean isSuccess;

        @InvocableVariable(label='Message' description='Contains the success/error message')
        public String message;
    }
}