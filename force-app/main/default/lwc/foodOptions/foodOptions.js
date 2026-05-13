import { LightningElement, api } from 'lwc';

export default class FoodOptions extends LightningElement {
    foodData = [];

    @api
    get value() {
        return this._value;
    }
    
    set value(value) {
        this._value = value;
    }

    connectedCallback() {
        console.log('this.value', JSON.stringify(this.value));
        if (this.value) {
            this.updatedValue = [];
            this.value.foodOptions.map((food) => {
                this.updatedValue.push({
                    ...food,
                    buffetStatus: food.partOfBuffet ? 'Yes' : 'No'
                });
            });
            this.foodData = this.updatedValue;
        }
    }

    handleOrderFood(event) {
        const foodName = event.target.dataset.foodName;
        // Dispatch event to parent component
        const orderEvent = new CustomEvent('orderfood', {
            detail: {
                foodName: foodName
            }
        });
        this.dispatchEvent(orderEvent);
    }
}