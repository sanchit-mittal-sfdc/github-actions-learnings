public with sharing class CreateCaseFromSlack {

    @InvocableMethod(label='Create Case From Slack' description='Creates a single Salesforce Case from Slack or chat-based agents and returns the created Case.'
    )
    public static List<Case> createCase(List<Request> requests) {

        try {

            if (requests == null || requests.isEmpty()) {
                throw new CaseCreationException('No case details were provided.');
            }

            Request req = requests[0];

            if (String.isBlank(req.subject)) {
                throw new CaseCreationException('Case subject is required.');
            }
            if (String.isBlank(req.description)) {
                throw new CaseCreationException('Case description is required.');
            }
            if (String.isBlank(req.caseReason)) {
                throw new CaseCreationException('Case reason could not be determined.');
            }

            // Id supportRecordTypeId = [
            //     SELECT Id
            //     FROM RecordType
            //     WHERE SObjectType = 'Case'
            //     AND Name = 'Salesforce Support'
            //     LIMIT 1
            // ].Id;

            Case c = new Case();
            c.Subject = req.subject;
            c.Description = req.description;
            c.Reason = req.caseReason;
            //c.Status = 'New';
            //c.Origin = 'Slack';
            //c.RecordTypeId = supportRecordTypeId;

            insert c;

            return new List<Case>{ c };

        } catch (Exception e) {

            // Re-throw as Exception for agent-friendly handling
            throw new CaseCreationException(
                'Unable to create the case. Please ensure all required details are provided and try again. Technical Details: '+e.getMessage()
            );
        }
    }

    // ---------- INPUT ----------
    public class Request {

        @InvocableVariable(
            required=true
            description='The subject of the case provided by the user. This is mandatory.'
        )
        public String subject;

        @InvocableVariable(
            required=true
            description='Detailed description of the issue or request.'
        )
        public String description;

        @InvocableVariable(
            required=true
            description='Case Reason automatically derived by the agent.'
        )
        public String caseReason;
    }

    //Custom Exception
    public class CaseCreationException extends Exception{}
}