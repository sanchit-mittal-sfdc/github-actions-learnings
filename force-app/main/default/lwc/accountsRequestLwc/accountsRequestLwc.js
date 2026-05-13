import { LightningElement, api } from 'lwc';

export default class AccountsRequestLwc extends LightningElement {

    @api readOnly;
    _value;
    ratingVal;
    typeVal;

    @api
    get value() {
        return this._value;
    }

    set value(val) {
        this._value = val ;
    }

    ratingOptions = [
        { label: 'Hot', value: 'Hot' },
        { label: 'Warm', value: 'Warm' },
        { label: 'Cold', value: 'Cold' }
    ];


    typeOptions = [
        { label: 'Prospect', value: 'Prospect' },
        { label: 'Customer - Direct', value: 'Customer - Direct' },
        { label: 'Customer - Channel', value: 'Customer - Channel' },
        { label: 'Channel Partner / Reseller', value: 'Channel Partner / Reseller' },
        { label: 'Installation Partner', value: 'Installation Partner' },
        { label: 'Technology Partner', value: 'Technology Partner' },
        { label: 'Other', value: 'Other' }
    ];


    connectedCallback()
    {
        console.log('Inside connectedCallback of AccountsRequestLwc with value ' + JSON.stringify(this.value));

        if(this.value)
        {
            this.ratingVal = this.value?.ratingVal || '';
            this.typeVal = this.value?.typeVal || '';
        }
    }


    handleInputChange(e)
    {
        const {name, value} = e.target;
        this[name] = value;

        // Firing a custom event to 
        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                value: {
                    typeVal: this.typeVal,
                    ratingVal: this.ratingVal
                }
            }
        }));
    }

}