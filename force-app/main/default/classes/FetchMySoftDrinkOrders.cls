public without sharing class FetchMySoftDrinkOrders {
    

    @InvocableMethod(label = 'Fetch Soft Drink Order' description='Fetch all soft drink orders of user using email')
    public static List<OutputWrapper> getAllSoftDrinkOrders(List<InputWrapper> inputList)
    {
        List<OutputWrapper> outputList = new List<OutputWrapper>();
        string emailOfUser = inputList[0].email;
        List<Soft_Drink_Order__c> softDrinkOrders = [SELECT Id, Name, Order_Number__c, Status__c, Soft_Drink__r.Name 
                                                        FROM Soft_Drink_Order__c 
                                                        WHERE Customer_Email__c = :emailOfUser];

        OutputWrapper ow = new OutputWrapper();
        ow.orderCount=0;
        ow.softDrinkOrders=null;
        if(softDrinkOrders != null && softDrinkOrders.size() > 0)
        {
            ow.softDrinkOrders = softDrinkOrders;
            ow.orderCount = softDrinkOrders.size();
            outputList.add(ow);
        }

        return new List<OutputWrapper>{ow};
    }




    public class OutputWrapper
    {
        @InvocableVariable(label='SOft Drink Orders' description='List of soft drink orders')
        public List<Soft_Drink_Order__c> softDrinkOrders;

        @InvocableVariable(label='Order Count' description='Number of orders')
        public Integer orderCount;
    }


    public class InputWrapper
    {
        @InvocableVariable(label='Email' description='Email of the user' required=true)
        public String email;
    }
}