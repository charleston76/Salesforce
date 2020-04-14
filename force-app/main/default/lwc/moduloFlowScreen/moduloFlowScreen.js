import { LightningElement, api,wire, track } from 'lwc';
import getModuloAtivoRelacionado from '@salesforce/apex/ModuloController.getModuloAtivoRelacionado';

export default class ModuloFlowScreen extends LightningElement {
    @api varIdTreinamentoLwc;
    @api varIdModuloLwc;
    @api varOptionModuloLwc;
    objResults = [];

    @track objFiltro = {
        Id: '',
        TreinamentoId: varIdTreinamentoLwc,
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
        console.log('varIdModuloLwc ' + this.varIdModuloLwc);
        console.log('varOptionModuloLwc ' + this.varOptionModuloLwc);
    }
}
