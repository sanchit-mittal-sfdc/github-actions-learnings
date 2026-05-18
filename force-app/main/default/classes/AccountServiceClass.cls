public without sharing class AccountServiceClass {
    
    @InvocableMethod(Label='Get All Accounts by matching name and show Details' Description='Get Account Details')
    public static List<AccountResponse> getAccountByName(List<AccountRequest> req)
    {
        AccountResponse ar = new AccountResponse();
        ar.matchingAccounts = new Accounts();
        ar.matchingAccounts.matchingAccountsList = new List<AccountObj>();

        for(Account a : [SELECT Id, Name, Website, Phone, Industry, Type, Owner.Name, Rating FROM Account WHERE Type = :req[0].filters.typeVal and Rating = :req[0].filters.ratingVal])
        {
            ar.matchingAccounts.matchingAccountsList.add( new AccountObj(a.Id, a.name, a.website, a.phone, a.industry, a.type, a.rating, a.Owner.Name ) );
        }

        return new List<AccountResponse>{ar};

    }

    public class AccountResponse 
    {
        @InvocableVariable
        public Accounts matchingAccounts;
    } 

    public class Accounts
    {
        @InvocableVariable
        public List<AccountObj> matchingAccountsList;
    }

    public class AccountObj
    {
        @InvocableVariable
        public String accId;

        @InvocableVariable
        public String name;

        @InvocableVariable
        public String website;

        @InvocableVariable
        public String phone;

        @InvocableVariable
        public String industry;

        @InvocableVariable
        public String type;

        @InvocableVariable
        public String rating;

        @InvocableVariable
        public String ownerName;

        public AccountObj(String accId, String name, String website, String phone, String industry, String type, String rating, String ownerName)
        {
            this.accId = accId;
            this.name = name;
            this.website = 'dummy';
            this.phone = phone;
            this.industry = industry;
            this.type = type;
            this.rating = rating;
            this.ownerName = ownerName;
        }
    } 


    public class AccountRequest
    {
        @InvocableVariable
        public AccountFilters filters;
    }

    public class AccountFilters
    {
        @InvocableVariable
        public String typeVal;

        @InvocableVariable
        public String ratingVal;
    }
}