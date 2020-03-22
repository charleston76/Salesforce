import { LightningElement, track } from 'lwc';
import getTreinamento from '@salesforce/apex/TreinamentoController.getTreinamento';

export default class TreinamentoImperativo extends LightningElement {
    @track filtroNome;
    @track filtroDescr;
    objLista;
    chkError;

    handleNomeChange(event) {
        this.filtroNome = event.target.value;
    }
    handleDescrChange(event) {
        this.filtroDescr = event.target.value;
    }
    handleSearch() {
        let objFiltro = {
            Id: '',
            Name: this.filtroNome,
            Descricao: this.filtroDescr
        };
        getTreinamento({ strFiltro: JSON.stringify(objFiltro)})
            .then(result => {
                this.objLista = result;
                this.chkError = undefined;
                console.log('sucesso');
                console.log(JSON.stringify(objFiltro));
            })
            .catch(error => {
                this.objLista = undefined;
                this.chkError = error;
                console.log('Erro relacionando ',error.body.message);
                console.log(JSON.stringify(objFiltro));
            });
    }    
}