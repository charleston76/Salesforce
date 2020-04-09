import { LightningElement, api,wire, track } from 'lwc';
import getTreinamento from '@salesforce/apex/TreinamentoController.getTreinamento';

export default class ModuloFlowScreen extends LightningElement {
    @api varIdTreinamentoLwc;
    @api selectedAccs = [];
    @api selectedAccsString;
    @api Accs = [];
    objResults = [];

    @track objFiltro = {
        Id: '',
        Name: '',
        Descricao: ''
    };

    @track strSearch = JSON.stringify(this.objFiltro);

    @wire(getTreinamento, { strFiltro: '$strSearch' } ) // 
    wiredResult(data,error) { 
        if(data){
            this.objResults= data;
        } else if(error){
            console.log('error -->'+error);   
        }
    } 

    get radioOption()  {
        let vlrReturn=[];
        // Tenho que fazer a tela entender esse cara para carregar os mudolos
        // criar uma nova classe de modulos e mostrar tudo na tela no lugar dos treinamentos
        console.log('varIdTreinamentoLwc - ' + this.varIdTreinamentoLwc);

        if (this.objResults.data != undefined){
             for( var i = 0; i < this.objResults.data.length; i++) {
                 vlrReturn.push({
                    label: this.objResults.data[i].Name,
                    value: this.objResults.data[i].Id
                })
            }
        } 
        return vlrReturn;
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
