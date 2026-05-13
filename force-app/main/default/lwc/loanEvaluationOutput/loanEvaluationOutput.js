import { LightningElement, api } from 'lwc';

export default class LoanEvaluationOutput extends LightningElement {
    
    _value;
    recommendation;
    reasoning;
    confidence;
    sourceDocuments;
    
    @api get value(){
        return _value;
    }

    set value(value){
        this._value = value;
    }

    get recommendationClass() {
        if (!this.recommendation) return '';
    
        if (this.recommendation === 'Approve') {
            return 'slds-badge slds-theme_success';
        }
        if (this.recommendation === 'Approve with Exception') {
            return 'slds-badge slds-theme_warning';
        }
        if (this.recommendation === 'Reject') {
            return 'slds-badge slds-theme_error';
        }
        return 'slds-badge';
    }
    
    get sourceDocumentsList() {
        if (!this.sourceDocuments) return [];
        return this.sourceDocuments.split(';').map(doc => doc.trim());
    }
    

    connectedCallback() {
        console.log('value: ' + this._value);


        if(this._value){

            const { recommendation, reasoning, confidence, sourceDocuments } = this._value;

            this.recommendation = recommendation;
            this.reasoning = reasoning;
            this.confidence = confidence;
            this.sourceDocuments = sourceDocuments;
        }

    }
}