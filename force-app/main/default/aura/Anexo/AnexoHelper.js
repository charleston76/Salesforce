({
    MAX_FILE_SIZE: 6000000, //Max file size 6.0 MB
    CHUNK_SIZE: 6000000,      //Chunk Max size 750Kb

    carregarInfoComponente : function(component, event, helper) {
        let action = component.get('c.obterInfoComponente');
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                component.set('v.telaAnexosWrapper', response.getReturnValue());
            }
            else {
                alert('Ocorreu um erro inesperado no módulo do servidor');
            }
        });
        $A.enqueueAction(action);
    },

    definirExtensoesSuportadas : function(component, event, helper) {
        let METHOD = 'definirExtensoesSuportadas';
        
        let valorSelecionado = event.getSource().get('v.value');
        let extensoesSuportadas = '';
        console.log(METHOD + ' valorSelecionado ' + valorSelecionado);        

        if (valorSelecionado == 'Excel') {
            extensoesSuportadas = '.xlsx';
        }
        else {
            extensoesSuportadas = undefined;
        }
        console.log(METHOD + ' extensoesSuportadas ' + extensoesSuportadas);        
        component.set('v.accept', extensoesSuportadas);
    },

    limparArquivo : function(component) {
        component.set('v.arquivo', null);
        component.set('v.nomeArquivo', null);
        component.set('v.msgValidacao', null);
        component.set('v.ok', false);
    },

    desbloquearInputArquivo : function(component, event) {
        let valorInput = event.getSource().get('v.value');
        if (valorInput) {
            component.set('v.bloqueado', false);
        }
        else {
            component.set('v.bloqueado', true);
        }
    },

    exibirNomeArquivo : function(component, fileInput) {
        let METHOD = 'exibirNomeArquivo';
        
        let nomeArquivo = fileInput[0].name;
        console.log(METHOD + ' nomeArquivo ' + nomeArquivo);
        component.set('v.nomeArquivo', nomeArquivo);
        return nomeArquivo;
    },

    validarTamanho : function(component, event, helper, fileInput) {
        let METHOD = 'validarTamanho';
        let arquivo = fileInput[0];
        let self = this;
        console.log(METHOD + ' arquivo.size ' + arquivo.size);
        console.log(METHOD + ' self.MAX_FILE_SIZE ' + self.MAX_FILE_SIZE);
        
        if (arquivo.size > self.MAX_FILE_SIZE) {
            component.set('v.ok', false);
            component.set('v.msgValidacao', 'Tamanho limite do arquivo excedido: ' + (self.MAX_FILE_SIZE / 1000000) + ' MB');
            return false;
        }
        return true;
    },

    validarPorFormato : function(component, event, helper, nomeArquivo) {
        let METHOD = 'validarPorFormato';
        let tipoSelecionado = component.get('v.tipoSelecionado');
        console.log(METHOD + ' tipoSelecionado ' + tipoSelecionado);        
        console.log(METHOD + ' nomeArquivo ' + nomeArquivo);        
        if (nomeArquivo.includes('.xlsx') && tipoSelecionado == 'Excel') {
            helper.validarXlsx(component, event, helper);
        }
        else {
            component.set('v.ok', true);
        }
    },

    validarXlsx : function(component, event, helper) {

        let METHOD = 'validarXlsx';
        let files = component.find('fileInput').get('v.files');
        console.log(METHOD + ' files ' + files);

        let reader = new FileReader();
        reader.onload = function() {
            component.set('v.arquivo', reader.result);
            if (files.length > 0) {
                console.log(METHOD + ' Convertendo para JSON...');
                var workbook;
                var msgValidacao;
                var ok = false;
                try {
                    workbook = XLSX.read(reader.result, {type: 'binary'});
                    console.log(METHOD + ' workbook: ', workbook);
                    let primeiroSheet = Object.keys(workbook.Sheets)[0];
                    console.log(METHOD + ' First key: ', primeiroSheet);
                    var xl_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[primeiroSheet], {defval: ''}, {blankrows: true});
                    console.log(METHOD + ' xl_row_object: ', xl_row_object);
                    //============================================================================
                    //= Com este objeto vc consegue definir as linhas onde se inicia a leitura
                    //============================================================================
                    xl_row_object[0]
                    var validacao = helper.validarColunas(component, event, helper, xl_row_object[0]);
                    if (validacao.ok) {
                        console.log(METHOD + ' Validação ok!');
                    }
                    else {
                        console.log(METHOD + ' Validação não ok!');
                        msgValidacao = 'Ops! As seguintes colunas não foram correspondidas: '
                        + validacao.colunasNaoCorrespondidas;
                    }
                    ok = validacao.ok;
                }
                catch (err) {
                    ok = false;
                    msgValidacao = 'Ocorreu um erro inesperado! Por favor verifique seu arquivo ou contate sua equipe de suporte';
                    console.error(' err.message ' + err.message);
                    console.error(' Stack Trace: ' + err.stackTrace);
                    alert(msgValidacao);
                }
                component.set('v.ok', ok);
                component.set('v.msgValidacao', msgValidacao);
            }
        }
        reader.readAsBinaryString(files[0]);
    },

    validarColunas : function(component, event, helper, colunas) {
        let METHOD = 'validarTamanho';

        let attrColunasModeloProxy = component.get('v.telaAnexosWrapper').colunasXlsxBaseDados;
        let attrColunasModelo = new Array();
        let attrColunasModeloLower = new Array();

        console.log(METHOD + ' attrColunasModeloProxy ' + attrColunasModeloProxy);        
        console.log(METHOD + ' attrColunasModelo ' + attrColunasModelo);        
        console.log(METHOD + ' attrColunasModeloLower ' + attrColunasModeloLower);        

        attrColunasModeloProxy.forEach(function(item, index) {
            let itemBruto = item.trim();
            let itemLower = item.toLowerCase().trim();
            console.log(METHOD + ' itemBruto ' + itemBruto);        
            console.log(METHOD + ' itemLower ' + itemLower);        
            attrColunasModelo.push(itemBruto);
            attrColunasModeloLower.push(itemLower);
        });

        console.log(METHOD + ' attrColunasModelo.length inicial: ' + attrColunasModelo.length);
        console.log(METHOD + ' attrColunasModelo: ', attrColunasModelo);
        //var colunasModeloArray = helper.colunasModelo2Array(colunasModelo);
        //console.log('colunasModeloArray:', colunasModeloArray);
        let keys = Object.keys(colunas);
        console.log(METHOD + ' Keys: ', keys);
        let spliced = 0;
        keys.forEach(function(item, index) {
            let itemBruto = item.trim();
            let itemLower = item.toLowerCase().trim();
            console.log(METHOD + ' item ' + item + ' is included: ', attrColunasModeloLower.includes(itemLower));
            if (attrColunasModeloLower.includes(itemLower)) {
                //console.log(item.trim() + ' is being spliced');
                //console.log(item.toLowerCase().trim() + ' is being spliced');
                const indexToSplice = attrColunasModeloLower.indexOf(itemLower);
                console.log('Spliced item (modelo): ', attrColunasModelo.splice(indexToSplice, 1));
                console.log('Actual spliced item (modelo lower): ', attrColunasModeloLower.splice( indexToSplice, 1));
                spliced++;
                //attrColunasModelo.splice(item.trim(), 1);
                //attrColunasModeloLower.splice(item.toLowerCase().trim(), 1);
            }
        });
        console.log('attrColunasModelo.length: ' + attrColunasModelo.length);
        let validacaoOk = (attrColunasModelo.length == 0) ? true : false;
        console.log('Colunas Modelo resultante: ', attrColunasModelo);
        console.log('Colunas Modelo Lower resultante: ', attrColunasModeloLower);

        // Para fins de exibição
        for (let i = 1; i < attrColunasModelo.length; i++) {
            attrColunasModelo[i] = ' ' + attrColunasModelo[i];
        }

        return {
            colunasNaoCorrespondidas : attrColunasModelo,
            ok : validacaoOk
        };
        
    },

    atualizarTipoArquivo : function(component, event, helper) {
        let action = component.get('c.atribuirTipoArquivo');
        console.log('ContentVersionID: ', event.getParam('files')[0].contentVersionId);
        
        action.setParams({
            'contentVersionId': event.getParam('files')[0].contentVersionId,
            'recordId': component.get('v.recordId'),
            'tipoAnexo': component.get('v.tipoSelecionado')
        });
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                helper.showToast('success', 'dismissible', 'Sucesso!', 'Anexo salvo com sucesso!');
            }
            else {
                helper.showToast('error', 'sticky', 'Erro!', 'Ocorreu um erro inesperado ao salvar o anexo! :( Por favor contate sua equipe de suporte');
            }
        });
        $A.enqueueAction(action);
        
    },

    salvarArquivo : function(component, event, helper) {
        component.set('v.loading', true);
        console.log('salvarArquivo: início');
        var fileInput = component.find('fileInput').get('v.files');
        let arquivo = fileInput[0];
        console.log('Arquivo: ', arquivo);
        var self = this;

        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var conteudoArquivo = objFileReader.result;
            var base64Mark = 'base64,';
            var dataStart = conteudoArquivo.indexOf(base64Mark) + base64Mark.length;
            conteudoArquivo = conteudoArquivo.substring(dataStart);
            self.uploadProcess(component, helper, arquivo, conteudoArquivo);
        });
        objFileReader.readAsDataURL(arquivo);

    },

    uploadProcess : function(component, helper, arquivo, conteudoArquivo) {
        console.log('uploadProcess - início');
        let startPosition = 0;
        let endPosition = Math.min(conteudoArquivo.length, startPosition + this.CHUNK_SIZE);
        helper.uploadInChunks(component, arquivo, conteudoArquivo, startPosition, endPosition, helper, '');
    },

    uploadInChunks : function(component, arquivo, conteudoArquivo, startPosition, endPosition, helper, attachId) {
        console.log('uploadInChunks - início');
        console.log('attachId: ', attachId);
        console.log('startPosition: ', startPosition);
        console.log('endPosition: ', endPosition);
        let getChunk = conteudoArquivo.substring(startPosition, endPosition);
        let action = component.get('c.saveChunk');
        action.setParams({
            'parentId': component.get('v.recordId'),
            'fileName': component.get('v.nomeArquivo'),
            'tipoAnexo': component.get('v.tipoSelecionado'),
            'base64Data' : getChunk,
            'contentType': arquivo.type,
            'fileId': attachId
        });
        action.setCallback(this, function(response) {
            console.log('Callback - início');
            console.log('State: ', response.getState());
            console.log('Response: ' , response);
            if (response.getError()) {
                console.error('Errors: ', response.getError());
                console.error('Errors length: ', response.getError().length);
                console.error('Error: ', response.getError()[0]);
            }
            if (response.getState() === 'SUCCESS') {
                attachId = response.getReturnValue();
                startPosition = endPosition;
                endPosition = Math.min(conteudoArquivo.length, startPosition + this.CHUNK_SIZE);
                console.log('startPosition in callback: ', startPosition);
                console.log('endPosition in callback: ', endPosition);
                if (startPosition < endPosition) {
                    helper.uploadInChunks(component, arquivo, conteudoArquivo, startPosition, endPosition, helper, attachId);
                }
                else {
                    component.set('v.loading', false);
                    component.set('v.arquivo', null);
                    component.set('v.nomeArquivo', null);
                    helper.showToast('success', 'dismissible', 'Sucesso!', 'Anexo salvo com sucesso!');
                }
            }
            else if (state === 'INCOMPLETE') {
                component.set('v.loading', false);
                alert('From server: ' + response.getReturnValue());
            }
            else if (state == 'ERROR') {
                let errors = response.getError();
                errors.forEach(function(item, index) {
                    console.error(item);
                });
                component.set('v.loading', false);
                helper.showToast('error', 'sticky', 'Erro!', 'Ocorreu um erro inesperado ao salvar o anexo! :( Por favor contate sua equipe de suporte');
            }
            console.log('Return value: ', response.getReturnValue());
            console.log('State: ', response.getState());
        });
        $A.enqueueAction(action);
    },

    showToast : function(type, mode, title, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "mode": mode,
            "title": title,
            "message": msg
        });
        toastEvent.fire();
    }
        
})