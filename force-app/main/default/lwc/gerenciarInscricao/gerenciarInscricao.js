import { LightningElement, track } from 'lwc';
import getInscricao from '@salesforce/apex/InscricaoController.getInscricao';

export default class GerenciarInscricao extends LightningElement {
    @track filtroInscricaoId;
    @track filtroNomeUsuario;
    @track filtroNomeTreinamento;
    @track filtroNomeModulo;

    @track filtroDescr;
    objLista;
    chkError;

    handleNomeUsuarioChange(event) {
        this.filtroNomeUsuario = event.target.value;
    }
    handleNomeTreinamentoChange(event) {
        this.filtroNomeTreinamento = event.target.value;
    }    
    handleNomeModuloChange(event) {
        this.filtroNomeModulo = event.target.value;
    }    

    handleSearch() {
        let objFiltro = {
            Id: this.filtroInscricaoId,
            UserName: this.filtroNomeUsuario,
            TreinamentoName: this.filtroNomeTreinamento,
            ModuloName: this.filtroNomeModulo
        };
        getInscricao({ strFiltro: JSON.stringify(objFiltro)})
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
