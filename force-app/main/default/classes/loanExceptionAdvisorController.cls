/**
 * loanExceptionAdvisorController
 * @description This class is used to generate a custom pitch for a contact based on the products they are interested in.
 * loanExceptionAdvisorController.evaluateLoanApplication();
 */

public with sharing class loanExceptionAdvisorController
{
    public class RequestWrapper
    {
        @InvocableVariable
        public Filters filters;
    }

    public class Filters
    {
        @InvocableVariable
        public String applicantName;

        @InvocableVariable
        public Decimal loanAmount;

        @InvocableVariable
        public String loanType;

        @InvocableVariable
        public Integer cibilScore;

        @InvocableVariable
        public Decimal monthlyIncome;

        @InvocableVariable
        public String employmentType;

        @InvocableVariable
        public String miscellaneousDetails;
    }


    public class ResponseWrapper
    {
        @InvocableVariable
        public Evaluation evalutation;
    }


    public class Evaluation
    {
        @InvocableVariable
        public String recommendation;

        @InvocableVariable
        public Integer confidence;

        @InvocableVariable
        public String reasoning;

        @InvocableVariable
        public String sourceDocuments;
    }


    
    @InvocableMethod(label = 'Evaluate Loan Application (JSON Response)' description='Evaluate loan application specially for exceptional cases and return JSON response')
    public static List<ResponseWrapper> evaluateLoanApplication(List<RequestWrapper> req)
    {
        RequestWrapper request = req[0];

        String applicantName = request.filters.applicantName;
        Decimal loanAmount = request.filters.loanAmount;
        String loanType = request.filters.loanType;
        Integer cibilScore = request.filters.cibilScore;
        Decimal monthlyIncome = request.filters.monthlyIncome;
        String employmentType = request.filters.employmentType;
        String miscellaneousDetails = request.filters.miscellaneousDetails;


        // First insert custom obj Loan_Applicant__c record
        Loan_Applicant__c applicant = new Loan_Applicant__c();
        applicant.Name = applicantName;
        applicant.Monthly_Income__c = monthlyIncome;
        applicant.Employment_Type__c = employmentType;
        applicant.CIBIL_Score__c = cibilScore;
        applicant.Applicant_Remarks__c = miscellaneousDetails;

        insert applicant;

        // Next insert custom obj Loan_Application__c record
        Loan_Application__c loanApplication = new Loan_Application__c();
        loanApplication.Loan_Amount__c = loanAmount;
        loanApplication.Loan_Type__c = loanType;
        loanApplication.Loan_Applicant__c = applicant.Id;
        loanApplication.Loan_Status__c = 'Under Review';
        loanApplication.Application_Date__c = Date.today();
        loanApplication.Loan_Type__c = loanType;
        loanApplication.Loan_Amount__c = loanAmount;
        loanApplication.Evaluate_Loan_using_AI__c = false; // To prevent re-evaluation loop


        insert loanApplication;

        ResponseWrapper res = new ResponseWrapper();

        String resultJsonStr = '';

        resultJsonStr = InvokeLoanExceptionAdvFieldGenTemplate.evaluateLoanApplication(loanApplication.Id);
        // String escapedResultJsonStr = String.escapeSingleQuotes(resultJsonStr);

        // System.debug('JSON Result String: ' + resultJsonStr);
        // System.debug('escapedResultJsonStr: ' + escapedResultJsonStr);

        String cleanJson = resultJsonStr;

        // Remove non-breaking spaces
        cleanJson = cleanJson.replace('\u00A0', ' ');

        // Remove zero-width unicode chars (AI / PDF junk)
        cleanJson = cleanJson.replace('\u200B', '');
        cleanJson = cleanJson.replace('\u200C', '');
        cleanJson = cleanJson.replace('\u200D', '');
        cleanJson = cleanJson.replace('\uFEFF', '');

        // Safety trim
        cleanJson = cleanJson.trim();

        System.debug('CLEAN JSON >>> ' + cleanJson);

        Map<String, Object> mapFromJsonStr = (Map<String, Object>) JSON.deserializeUntyped(cleanJson);

        res.evalutation = new Evaluation();

        res.evalutation.recommendation = mapFromJsonStr.get('recommendation') != null ? String.valueOf(mapFromJsonStr.get('recommendation')) : 'No Recommendation';
        res.evalutation.confidence = mapFromJsonStr.get('confidence') != null ? Integer.valueOf(mapFromJsonStr.get('confidence')) : 0;
        res.evalutation.reasoning = mapFromJsonStr.get('reasoning') != null ? String.valueOf(mapFromJsonStr.get('reasoning')) : 'No Reasoning';
        res.evalutation.sourceDocuments = mapFromJsonStr.get('sourceDocuments') != null ? String.valueOf(mapFromJsonStr.get('sourceDocuments')) : 'No Source Documents';

        return new List<ResponseWrapper>{res};

    }

}