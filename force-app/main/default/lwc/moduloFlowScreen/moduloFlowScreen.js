import { LightningElement, api,wire, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getModuloAtivoRelacionado from '@salesforce/apex/ModuloController.getModuloAtivoRelacionado';

export default class ModuloFlowScreen extends LightningElement {
    @api varIdTreinamentoLwc;
    @api varIdModuloLwc;
    @api varOptionModuloLwc;
    objResults = [];

    @wire(getModuloAtivoRelacionado, { Id: '',  TreinamentoId: '$varIdTreinamentoLwc', Name: '',  Descricao: '' , Ativo:'' } ) 
    wiredResult(data,error) { 
        if(data){
            console.log('{Id:"",TreinamentoId:' + (this.varIdTreinamentoLwc == 'undefined' ? '' : this.varIdTreinamentoLwc ) +',Name:"",Descricao:""}');
            this.objResults= data;
        } else if(error){
            console.log('error -->'+error);   
        }
    } 

    get radioOption()  {
        let vlrReturn=[];
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
// VERIFICAR SE OS IDS DOS MODULOS E TREINAMENTOS ESTÃO CORRETOS, APESAR DO TEXTO...
    handleChange(event) {
        this.varIdModuloLwc = event.detail.value;
        var rdoList = this.radioOption;
        var rdoSelected  = this.varIdModuloLwc;
        //this.varOptionModuloLwc = event.detail[event.detail.value].label;
        var optIndex = rdoList.map(function (e) {
            if (e.value == rdoSelected) {
                return e.label;
            }
        }).indexOf(rdoList.label);

        this.varOptionModuloLwc = rdoList[optIndex].label;
        console.log('optIndex ' + optIndex);
        console.log('varIdModuloLwc ' + this.varIdModuloLwc);
        console.log('varOptionModuloLwc ' + this.varOptionModuloLwc);
    }

    @api
    validate() {
        if(this.varIdModuloLwc != null) { 
            return { isValid: true }; 
        } 
        else { 
            // If the component is invalid, return the isValid parameter 
            // as false and return an error message. 
            return { 
                isValid: false, 
                errorMessage: 'Selecione um modulo na lista!' 
             }; 
         }
    }

}
