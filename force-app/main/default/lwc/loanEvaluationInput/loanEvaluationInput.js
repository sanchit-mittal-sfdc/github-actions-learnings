import { LightningElement, api } from 'lwc';

export default class LoanEvaluationInput extends LightningElement {

    @api readOnly;
    _value;
    applicantName;
    loanAmount;
    loanType;
    cibilScore;
    monthlyIncome;
    employmentType;
    miscellaneousDetails;

    @api get value() {
        return this._value;
    }

    set value(value) {
        this._value = value;
    }


     // 🔹 Loan Type options
     loanTypeOptions = [
        { label: 'Car Loan', value: 'Car' },
        { label: 'Home Loan', value: 'Home' },
        { label: 'Personal Loan', value: 'Personal' },
        { label: 'Business Loan', value: 'Business' }
    ];

    // 🔹 Employment Type options
    employmentOptions = [
        { label: 'Salaried', value: 'Salaried' },
        { label: 'Self-Employed', value: 'Self-Employed' },
        { label: 'Business Owner', value: 'Business Owner' },
        { label: 'Freelancer / Consultant', value: 'Freelancer / Consultant' },
        { label: 'Retired', value: 'Retired' },
        { label: 'Unemployed', value: 'Unemployed' }
    ];


    connectedCallback() {
        if(this._value)
        {
            const { applicantName, loanAmount, loanType, cibilScore, monthlyIncome, employmentType, miscellaneousDetails } = this._value;

            this.applicantName = applicantName || '';
            this.loanAmount = loanAmount || '';
            this.loanType = loanType || '';
            this.cibilScore = cibilScore || '';
            this.monthlyIncome = monthlyIncome || '';
            this.employmentType = employmentType || '';
            this.miscellaneousDetails = miscellaneousDetails || '';
        }
    }

    handleInputChange(event) {
        event.stopPropagation();
        const { name, value } = event.target;
        this[name] = value;


        const inputChangeEvt = new CustomEvent('valuechange', {
            detail: {
                value: {
                    applicantName: this.applicantName,
                    loanAmount: this.loanAmount,
                    loanType: this.loanType,
                    cibilScore: this.cibilScore,
                    monthlyIncome: this.monthlyIncome,
                    employmentType: this.employmentType,
                    miscellaneousDetails: this.miscellaneousDetails
                }
            }
        });

        if(inputChangeEvt)
        {
            this.dispatchEvent(inputChangeEvt);
        }
    }
}