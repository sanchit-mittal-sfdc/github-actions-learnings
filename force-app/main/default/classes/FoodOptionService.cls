/**
 * Invocable Apex class to query Food_Option__c records
 * Used by AgentForce agents to retrieve food options data
 */
public without sharing class FoodOptionService {
    
    /**
     * Invocable method to get all Food_Option__c records with specified fields
     * @return List of FoodOptionResponse containing wrapped food options data
     */
    @InvocableMethod(label='Get Food Options' description='Retrieves all Food Options with their details')
    public static List<FoodOptionResponse> getFoodOptions(List<String> foodPreferences) {
        List<FoodOptionResponse> responses = new List<FoodOptionResponse>();
        
        // Query all food options
        List<Food_Option__c> foodOptions = [
            SELECT Name, Price__c, Size__c, Part_of_Buffet__c, Type__c
            FROM Food_Option__c 
        ];
        
        // Create wrapper response
        FoodOptionResponse response = new FoodOptionResponse();
        response.foodOptions = new FoodOptions();
        response.foodOptions.foodOptions = new List<FoodOption>();
        
        // Convert Food_Option__c records to wrapper objects
        for(Food_Option__c food : foodOptions) {
            FoodOption foodOption = new FoodOption(
                food.Name,
                String.valueOf(food.Price__c),
                food.Size__c,
                food.Part_of_Buffet__c,
                food.Type__c
            );
            response.foodOptions.foodOptions.add(foodOption);
        }
        
        responses.add(response);
        return responses;
    }
    
    
    /**
     * Wrapper class for the response containing list of food options
     */
    public class FoodOptionResponse {
        @InvocableVariable
        public FoodOptions foodOptions;
    }

    /**
     * Wrapper class for the food options list
     */
    public class FoodOptions {
        @InvocableVariable
        public List<FoodOption> foodOptions;
    }
    
    /**
     * Wrapper class for individual food option details
     */
    public class FoodOption {
        @InvocableVariable
        public String name;
        
        @InvocableVariable
        public String price;
        
        @InvocableVariable
        public String size;
        
        @InvocableVariable
        public Boolean partOfBuffet;
        
        @InvocableVariable
        public String type;
        
        public FoodOption(String name, String price, String size, Boolean partOfBuffet, String type) {
            this.name = name;
            this.price = price;
            this.size = size;
            this.partOfBuffet = partOfBuffet;
            this.type = type;
        }
    }
}