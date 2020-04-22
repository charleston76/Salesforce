// Realiza as importações da plataforma
import { LightningElement, api,wire} from 'lwc';
import getModuloAtivoRelacionado from '@salesforce/apex/ModuloController.getModuloAtivoRelacionado';

export default class ModuloFlowScreen extends LightningElement {
    // Parâmetros explicitamente declarados no arquivo de meta.xml
    // nas tags de targetConfig
    @api varIdTreinamentoLwc; 
    @api varIdModuloLwc;
    @api varOptionModuloLwc;
    // objeto para carga dos resultados através do wire
    objResults = [];
    // Realiza a chamada do metodo da classe
    @wire(getModuloAtivoRelacionado, { Id: '',  TreinamentoId: '$varIdTreinamentoLwc', Name: '',  Descricao: '' , Ativo:'' } ) 
    wiredResult(data,error) { 
        if(data){
            this.objResults= data;
        } else if(error){
            console.log('error -->'+error);   
        }
    } 
    // Carrega o radio group
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
    // Valida a tela antes de ir para o proximo passo
    @api
    validate() {
        if(this.varIdModuloLwc != null) { 
            return { isValid: true }; 
        } else { 
            return { 
                isValid: false, 
                errorMessage: 'Selecione um modulo na lista!' 
             }; 
         }
    }
    // Altera o valor conforme seleção do usuário
    handleChange(event) {
        this.varIdModuloLwc = event.detail.value;
        var rdoList = this.radioOption;
        var rdoSelected  = this.varIdModuloLwc;
        var getLabel ='';
        rdoList.map(function (e) {
            if (e.value == rdoSelected) {
                getLabel = e.label;
                return e.label;
            }
        });
        this.varOptionModuloLwc =getLabel;
    }
}
