public without sharing class UpdateCaseOwnerUsingIssueTypeClass
{
    @InvocableMethod(
        label='Update Case Owner and Priority'
        description='This is used to update the case owner and Priority using the Case Id, Priority and QUeue Developer NAme received in the input'
        )
    public static List<OutputWrapper> updateCaseOwnerUsingIssueType(List<InputWrapper> input)
    {

        if(input == null || input.isEmpty() || input.size() == 0 || input[0].caseId == null || input[0].queueDeveloperName == null || input[0].priority == null)
        {
            OutputWrapper ow = new OutputWrapper();
            ow.success = false;
            ow.message = 'Invalid input';

            return new List<OutputWrapper>{ow};
        }

        OutputWrapper ow = new OutputWrapper();

        

        try
        {
            Id queueId = [Select Id 
                      FROM Group
                      WHERE 
                      Type = 'Queue' AND
                      DeveloperName = :input[0].queueDeveloperName
                      LIMIT 1].Id;

            Case caseToBeUpdated = new Case(Id = input[0].caseId, ownerId = queueId, Priority = input[0].priority);

            update caseToBeUpdated;

            ow.success = true;
            ow.message = 'Case owner updated successfully';
        }
        catch(Exception e)
        {
            ow.success = false;
            ow.message = e.getMessage();
        }
        return new List<OutputWrapper>{ow};
    }


    public class InputWrapper
    {
        @InvocableVariable(
            label='Case Id' 
            description='Id of the case record whose owner needs to be updated.' 
            required=true
        )
        public String caseId;

        @InvocableVariable(
            label='Queue Developer Name' 
            description='Developer Name of the the queue to  which the case needs to be assigned.' 
            required=true
        )
        public String queueDeveloperName;


        @InvocableVariable(
            label='Case Priority' 
            description='Prioirty of the case that needs to be updated.' 
            required=true
        )
        public String priority;
    }


    public class OutputWrapper
    {
        @InvocableVariable(
            label='Success' 
            description='Indicates if the operation was successful or not.' 
        )
        public Boolean success;


        @InvocableVariable(
            label='Message' 
            description='Contains the success/error message' 
        )
        public String message;
    }
}