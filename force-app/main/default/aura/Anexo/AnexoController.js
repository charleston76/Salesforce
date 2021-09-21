({
    doInit: function(component, event, helper) {
        helper.carregarInfoComponente(component, event, helper);
    },

    handleTipoAnexoChange : function(component, event, helper) {
        helper.desbloquearInputArquivo(component, event);
        helper.definirExtensoesSuportadas(component, event, helper);
        helper.limparArquivo(component);
    },

    handleFilesChange : function(component, event, helper) {
        let fileInput = event.getSource().get('v.files');
        let nomeArquivo = helper.exibirNomeArquivo(component, fileInput);
        if (helper.validarTamanho(component, event, helper, fileInput)) {
            helper.validarPorFormato(component, event, helper, nomeArquivo);    
        }
    },

    handleUploadFinished : function(component, event, helper) {
        console.log('handleUploadFinished');
        helper.atualizarTipoArquivo(component, event, helper);
    },

    saveAction : function(component, event, helper) {
        helper.salvarArquivo(component, event, helper);
    }
})