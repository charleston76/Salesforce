import { LightningElement, api } from 'lwc';

export default class ModuloFlowScreen extends LightningElement {
    @api selectedAccs = [];
    @api selectedAccsString;
    @api Accs = [];
    @api value = '';
    @api objOption = [];


    handleCheck(event) {
        if(!this.selectedAccs.includes(event.currentTarget.name))
            this.selectedAccs.push(event.currentTarget.name);
        else {
            for(let i = 0; i < this.selectedAccs.length; i++) {
                if(event.currentTarget.name === this.selectedAccs[i])
                this.selectedAccs.splice(i, 1);
            }
        }
        
        this.selectedAccsString = JSON.stringify(this.selectedAccs);
        
    }

        get options() {
            if(!this.selectedAccs.includes(event.currentTarget.name))
                this.selectedAccs.push(event.currentTarget.name);
            else {
                for(let i = 0; i < this.selectedAccs.length; i++) {
                    if(event.currentTarget.name === this.selectedAccs[i])
                    this.selectedAccs.splice(i, 1);
                }
            }

            
            return [
                { label: 'Sales', value: 'option1' },
                { label: 'Force', value: 'option2' },
        ];
    }    

}
