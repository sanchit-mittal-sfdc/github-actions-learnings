import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendMessageToAgent from '@salesforce/apex/AgentChatController.sendMessageToAgent';

export default class AgentChat extends LightningElement {
    @track messages = [];
    currentMessage = '';
    isLoading = false;
    errorMessage = '';
    sessionId = '';
    @api agentDeveloperName;
    
   
    
    // Message ID counter
    messageIdCounter = 0;
    
    // Getter for send button disabled state
    get isSendDisabled() {
        return this.isLoading || !this.currentMessage || this.currentMessage.trim() === '';
    }
    
    // Getter to check if there are messages
    get hasMessages() {
        return this.messages && this.messages.length > 0;
    }
    
    // Handle message input change
    handleMessageChange(event) {
        this.currentMessage = event.target.value;
        this.errorMessage = '';
    }
    
    // Handle key up event for Enter key
    handleKeyUp(event) {
        if (event.keyCode === 13) { // Enter key
            this.sendMessage();
        }
    }
    
    // Send message to agent
    async sendMessage() {
        if (this.isSendDisabled) {
            return;
        }
        
        const userMessage = this.currentMessage.trim();
        this.currentMessage = '';
        this.isLoading = true;
        this.errorMessage = '';
        
        // Add user message to conversation
        this.addMessage(userMessage, 'User');
        
        try {
            // Call Apex method
            const result = await sendMessageToAgent({
                agentDeveloperName: this.agentDeveloperName,
                userMessage: userMessage,
                sessionId: this.sessionId || null
            });
            
            if (result.isSuccess) {
                // Store session ID for future messages
                this.sessionId = result.sessionId;
                
                // Add agent response to conversation
                this.addMessage(result.agentResponse, 'Agentforce');
                
            } else {
                this.errorMessage = result.errorMessage || 'Failed to get response from agent';
                this.showErrorToast(this.errorMessage);
            }
            
        } catch (error) {
            console.error('Error sending message:', error);
            this.errorMessage = 'An unexpected error occurred. Please try again.';
            this.showErrorToast(this.errorMessage);
        } finally {
            this.isLoading = false;
        }
    }
    
    // Add message to conversation
    addMessage(text, sender) {
        const message = {
            id: this.messageIdCounter++,
            text: text,
            sender: sender,
            class: sender === 'User' ? 'chat-bubble user' : 'chat-bubble agent'
        };
        
        this.messages = [...this.messages, message];
    }
    
    // Show error toast
    showErrorToast(message) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    
    // Clear chat (optional utility method)
    @api
    clearChat() {
        this.messages = [];
        this.sessionId = '';
        this.currentMessage = '';
        this.errorMessage = '';
    }
    
    // Get session ID (optional utility method)
    @api
    getSessionId() {
        return this.sessionId;
    }
    
    // Connected callback - initialize component
    connectedCallback() {
        // Add welcome message
        this.addMessage(
            'Hi, I am Agentforce. How can I help you?', 
            'Agentforce'
        );
    }


    renderedCallback() {
        const chatWindow = this.template.querySelector('.chat-window');
        if (chatWindow) {
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }
    }
    
}