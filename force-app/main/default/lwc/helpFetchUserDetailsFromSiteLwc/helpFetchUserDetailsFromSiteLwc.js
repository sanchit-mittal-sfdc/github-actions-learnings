import { LightningElement, wire } from 'lwc';
import loggedInUserId from '@salesforce/user/Id';
import EmailField from '@salesforce/schema/User.Email';
import NameField from '@salesforce/schema/User.Name';
import FirstNameField from '@salesforce/schema/User.FirstName';
import LastNameField from '@salesforce/schema/User.LastName';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


const fields = [
    EmailField,
    NameField,
    FirstNameField,
    LastNameField
];
export default class HelpFetchUserDetailsFromSiteLwc extends LightningElement {

    loggedInUserDetails = {
        "id": loggedInUserId,
        "email": "",
        "name": "",
        "firstName": "",
        "lastName": ""
    };

    @wire(getRecord, {recordId: loggedInUserId, fields})
    fetchedUserDetails({data, error}) {
        if(error)
        {
            console.log('Error: ' + JSON.stringify(error));
        }
        if(data)
        {
            this.loggedInUserDetails.email = getFieldValue(data, EmailField);
            this.loggedInUserDetails.name = getFieldValue(data, NameField);
            this.loggedInUserDetails.firstName = getFieldValue(data, FirstNameField);
            this.loggedInUserDetails.lastName = getFieldValue(data, LastNameField);
            console.log('User Details: ' + JSON.stringify(this.loggedInUserDetails));

            const userDetailsEvt = new CustomEvent('communitypageload', {
                detail: {
                    ...this.loggedInUserDetails
                },
                bubbles: true, // this is required for the event to be picked up by the parent component
                composed: true //
            });
    
            if(userDetailsEvt)
            {
                console.log('User Details Event: ' + JSON.stringify(userDetailsEvt));
                window.dispatchEvent(userDetailsEvt); 
            }
        }
    }
}