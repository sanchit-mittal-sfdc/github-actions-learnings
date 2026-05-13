import { LightningElement } from 'lwc';
import makeCustomPitch from '@salesforce/apex/CustomPitchMakerFlexTemplateController.generateCustomPitch';

export default class CustomPitchMakerUsingFlexTemplate extends LightningElement {
    contactId;
    product1Id;
    product2Id;
    pitch;

    // Handle change event for record picker
    handleChange(event) {
        debugger;
        console.log("handleChange called for " + event.target.dataset.fieldname + " with value " + event.target.value);
        const fieldName = event.target.dataset.fieldname;
        this[fieldName] = event.detail.recordId;
    }

    // Handle click event for generating custom pitch
    async generatePitch() {
        this.pitch = "Generating custom pitch...";
        try
        {
            const resp = await makeCustomPitch({contactId: this.contactId, product1Id: this.product1Id, product2Id: this.product2Id});
            this.pitch = resp;
        }
        catch(err)
        {
            console.error("Error generating custom pitch: " + err);
            this.pitch = "Error generating custom pitch: " + err;
        }
    }
    

}