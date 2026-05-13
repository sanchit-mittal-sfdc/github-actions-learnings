import { LightningElement, api, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class AccountsResponseLwc extends NavigationMixin(LightningElement) {
    @api value;
    searchVal = '';
    accountRecords = [];
    @track filteredAccountRecords = [];
    scheduledFunctionCall;

    connectedCallback()
    {
        console.log('Inside connectedCallback of AccountsResponseLwc');

        console.log('value is ' + JSON.stringify(this.value));
        if(this.value?.matchingAccountsList)
        {
            this.accountRecords = this.value.matchingAccountsList;
            this.filteredAccountRecords = this.accountRecords;
        }
    }

    handleViewAccount(e)
    {
        const accountid = e.target.dataset.accId;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountid,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    filterAccountsUsingSearchVal()
    {
        if( !this.searchVal || this.searchVal == '')
        {
            this.filteredAccountRecords = this.accountRecords;
            return;
        }
        
        this.filteredAccountRecords = this.accountRecords.filter( acc => acc.name?.toLowerCase().includes(this.searchVal));
        
    }

    handleSearchValChange(e)
    {
        this.searchVal = e.target.value;

        console.log('searchVal is ' + this.searchVal);

        if(this.scheduledFunctionCall)
        {
            clearTimeout(this.scheduledFunctionCall);
        }
        this.scheduledFunctionCall = setTimeout( () => {
            this.filterAccountsUsingSearchVal(); 
            this.scheduledFunctionCall = null;
        }, 1000);
        
    }
}