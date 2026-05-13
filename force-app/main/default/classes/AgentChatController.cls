/**
 * Apex controller for LWC Agent Chat component
 * Handles communication with Agentforce Service Agent
 * 
 * AgentChatController.sendMessageToAgent('WHats the status of my soft drink order 100','');
 */
public with sharing class AgentChatController {
    
    /**
     * Wrapper class for chat response
     */
    public class ChatResponse {
        @AuraEnabled
        public String agentResponse { get; set; }
        
        @AuraEnabled
        public String sessionId { get; set; }
        
        @AuraEnabled
        public Boolean isSuccess { get; set; }
        
        @AuraEnabled
        public String errorMessage { get; set; }
    }
    
    /**
     * Send message to Agentforce agent
     * @param userMessage The message from the user
     * @param sessionId Existing session ID (null for first message)
     * @return ChatResponse containing agent response and session info
     */
    @AuraEnabled
    public static ChatResponse sendMessageToAgent(String agentDeveloperName, String userMessage, String sessionId) {
        ChatResponse response = new ChatResponse();
        
        try {
            // Create an instance of the invocable action with type 'generateAiAgentResponse' and name 'Agentforce_Service_Agent_new'
            Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse', agentDeveloperName);
            
            // Set the user message
            action.setInvocationParameter('userMessage', userMessage);
            
            // Set session ID if provided (for continuing conversation)
            if (String.isNotBlank(sessionId)) {
                action.setInvocationParameter('sessionId', sessionId);
            }
            
           
            // Execute the action
            List<Invocable.Action.Result> results = action.invoke();
            Invocable.Action.Result result = results[0];
            
            // Handle the response
            if (result.isSuccess()) {
                String rawAgentResponse = (String) result.getOutputParameters().get('agentResponse');
                System.debug('Raw Agent Response: ' + result);
                
                // Parse the JSON response to extract the value
                try {
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(rawAgentResponse);
                    System.debug('Response Map: ' + responseMap);
                    response.agentResponse = (String) responseMap.get('value');
                } catch (Exception parseException) {
                    // If parsing fails, use the raw response as fallback
                    response.agentResponse = rawAgentResponse;
                    System.debug('Failed to parse agent response JSON: ' + parseException.getMessage());
                }
                
                response.sessionId = (String) result.getOutputParameters().get('sessionId');
                response.isSuccess = true;
                
                System.debug('Agent Response: ' + response.agentResponse);
                System.debug('Session ID: ' + response.sessionId);
                
            } else {
                response.isSuccess = false;
                response.errorMessage = 'Agent action execution failed: ' + result.getErrors();
                System.debug(response.errorMessage);
            }
            
        } catch (Exception e) {
            response.isSuccess = false;
            response.errorMessage = 'Error invoking agent: ' + e.getMessage();
            System.debug(response.errorMessage);
        }
        
        return response;
    }
}