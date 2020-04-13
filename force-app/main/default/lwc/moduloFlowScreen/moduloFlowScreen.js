import { LightningElement, api,wire, track } from 'lwc';
import getModuloAtivoRelacionado from '@salesforce/apex/ModuloController.getModuloAtivoRelacionado';

export default class ModuloFlowScreen extends LightningElement {
    @api varIdTreinamentoLwc;
    @api varIdModuloLwc;
    @api varOptionModuloLwc;
    @api selectedAccs = [];
    @api selectedAccsString;
    @api Accs = [];
    objResults = [];

    @track objFiltro = {
        Id: '',
        TreinamentoId: '',
        Name: '',
        Descricao: ''
    };

    @track strSearch = JSON.stringify(this.objFiltro);

    @wire(getModuloAtivoRelacionado, { strFiltro: '$strSearch' } ) // 
    wiredResult(data,error) { 
        if(data){
            console.log('strSearch -->'+this.strSearch);   
            this.objResults= data;
        } else if(error){
            console.log('error -->'+error);   
        }
    } 

    get radioOption()  {
        let vlrReturn=[];
        // Tenho que fazer a tela entender esse cara para carregar os mudolos
        // criar uma nova classe de modulos e mostrar tudo na tela no lugar dos treinamentos
        //console.log('varIdTreinamentoLwc - ' + this.varIdTreinamentoLwc);
        //console.log('objResults.data ' + this.objResults.data);
        if (this.objResults.data != undefined){
             for( var i = 0; i < this.objResults.data.length; i++) {
                 vlrReturn.push({
                    label: this.objResults.data[i].ModuloId__r.Name,
                    value: this.objResults.data[i].ModuloId__r.Id
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

    handleChange(event) {
        this.varIdModuloLwc = event.detail.value;
        var Lista = this.radioOption;
        var optLWC = this.varIdModuloLwc;
        //this.varOptionModuloLwc = event.detail[event.detail.value].label;
        var optIndex = Lista.map(function (e) {
            if (e.value == optLWC) {
                return e.label;
            }
        }).indexOf(Lista.label);

        this.varOptionModuloLwc = Lista[optIndex].label;
        console.log('varIdModuloLwc ' + this.varIdModuloLwc);
        console.log('varOptionModuloLwc ' + this.varOptionModuloLwc);
    }

}
