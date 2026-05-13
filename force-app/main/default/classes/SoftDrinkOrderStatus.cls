public with sharing class SoftDrinkOrderStatus {
   
    /**
     * Invocable method for Service Agents and Flow usage.
     * Accepts a list of soft drink order numbers and returns corresponding order status
     * from Soft_Drink_Order__c records by Order_Number__c.
     *
     * Defaults used:
     * - Object: Soft_Drink_Order__c
     * - Order Number field: Order_Number__c (Text)
     * - Status field: Status__c (Text or Picklist)
     */
    @InvocableMethod(label='Get Soft Drink Order Status' description='Accepts a soft drink order number from customer which is mandatory and return the order status For eg- user can say whats the status of my order 100?')
    public static List<String> getStatus(List<Integer> orderNumber) {
        
        List<String> results = new List<String>();
        
        if (!orderNumber.isEmpty()) 
        {
            // Query matching records; assume Order_Number__c is unique or we'll take first foun
            
            // Attempt to find the Soft_Drink_Order__c record matching the given order number.
            // Since Order_Number__c should be unique, we only check the first element in the input list.
            try {
                Soft_Drink_Order__c o = [SELECT Order_Number__c, Status__c
                    FROM Soft_Drink_Order__c
                    WHERE Order_Number__c = :orderNumber[0]];

                // If a record is found, add its status to the results list.
                if(o != null)
                    results.add(o?.Status__c); 

            } catch (Exception e) {
                // If any error occurs, such as no record found or query error, return the current results (possibly empty).
                return results;
            }
               
        }
        return results;
    }
}