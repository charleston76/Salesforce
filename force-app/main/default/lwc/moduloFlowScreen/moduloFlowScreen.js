import { LightningElement, api,wire } from 'lwc';
import getTreinamento from '@salesforce/apex/TreinamentoController.getTreinamento';

export default class ModuloFlowScreen extends LightningElement {
    @api selectedAccs = [];
    @api selectedAccsString;
    @api Accs = [];
    @api radioValue = '';

    @api objFiltro = {
        Id: '',
        Name: '',
        Descricao: ''
    };

   @wire(getTreinamento, { strFiltro: JSON.stringify(objFiltro)}  ) 
   ModulosAtivos;


    get radioOptionMock() {
        return [
            { label: 'Opção 1', value: 'option1' },
            { label: 'Opção 2', value: 'option2' },
        ];
    }

    get radioOption()  {
         let optionsValues = [ { label: 'Opção 1', value: 'option1' },
                             { label: 'Opção 2', value: 'option2' }];
        let test=[];
        // console.log('ModulosAtivos optionsValues'); 
        // //for( let i = 0; i < this.ModulosAtivos.length; i++) {
        console.log('Antes do for  ' + this.ModulosAtivos);
        console.log('length  ' + this.ModulosAtivos.length);
            
         for( let i = 0; i < optionsValues.length; i++) {
             console.log('optionsValues ' + i);
             test.push({
                 label: optionsValues[i].label,
                 value: optionsValues[i].value
             })
             console.log('test ' + test[i].label);
        }
        console.log('saiu ');
        return test;
      }

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

    selectRadio(event) {
        this.selectedAccsString = event.detail.value;
    }

}
