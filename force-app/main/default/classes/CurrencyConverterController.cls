/**
 * CurrencyConverterController
 * @description This class is used to convert currency.
 * 
 */

public with sharing class CurrencyConverterController {
    

    public class RequestWrapper
    {
        @InvocableVariable(required=true description='Amount to convert')
        public Decimal amount;

        @InvocableVariable(required=true description='Source currency code (e.g., USD)')
        public String fromCurrency;

        @InvocableVariable(required=true description='Target currency code (e.g., EUR)')
        public String toCurrency;
    }

    public class ResponseWrapper
    {
        @InvocableVariable(description='Converted amount')
        public Decimal convertedAmount;

        @InvocableVariable(description='Exchange rate used for conversion')
        public Decimal exchangeRate;

        @InvocableVariable(description='Indicates if the conversion was successful or not')
        public Boolean isSuccess;

        @InvocableVariable(description='Error message if conversion failed')
        public String errorMessage;
    }

    @InvocableMethod(callout=true label='Convert Currency' description='Convert an amount from one currency to another using the exchange rate API')
    public static List<ResponseWrapper> doConversion(List<RequestWrapper> input)
    {
        ResponseWrapper output = new ResponseWrapper();

        if(input == null || input.size() == 0)
        {
            output.isSuccess = false;
            output.errorMessage = 'No inputuest data provided.';
            return new List<ResponseWrapper>{output};
        }

        if(input[0].amount == null || input[0].amount == 0 || String.isBlank(input[0].fromCurrency) || String.isBlank(input[0].toCurrency))
        {
            output.isSuccess = false;
            output.errorMessage = 'Invalid input data. Please provide a valid amount and currency codes.';
            return new List<ResponseWrapper>{output};
        }

        String fromCurrency = input[0].fromCurrency;
        String toCurrency = input[0].toCurrency;
        Decimal amount = input[0].amount;


        try
        {
            HttpRequest req = new HttpRequest();
            String API_KEY = '2b33d2741242dbf3b938997b';
            req.setEndpoint('callout:CurrencyConverterNamedCredential/v6/'+API_KEY+'/pair/'+fromCurrency+'/'+toCurrency+'/'+amount);
            req.setMethod('GET');

            Http h = new Http();

            HttpResponse res = h.send(req);

            system.debug(res.getBody());
            system.debug(res.getStatusCode());

            if(res.getBody() == null || res.getStatusCode() != 200)
            {
                output.isSuccess = false;
                output.errorMessage = 'Error during currency conversion: ' + res.getBody();
                return new List<ResponseWrapper>{output};
            }

            Map<String, object> mappedResponse = (Map<String, object>) JSON.deserializeUntyped(res.getBody());
            
            output.isSuccess = true;
            output.convertedAmount = (Decimal) mappedResponse.get('conversion_result');
            output.exchangeRate = (Decimal) mappedResponse.get('conversion_result');
            
            return new List<ResponseWrapper>{output};
        } 
        catch (Exception e)
        {
            output.isSuccess = false;
            output.errorMessage = 'Error during currency conversion: ' + e.getMessage();
            return new List<ResponseWrapper>{output};
        }
        
    }
}