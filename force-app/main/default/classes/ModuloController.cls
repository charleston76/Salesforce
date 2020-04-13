public with sharing class ModuloController {
    @AuraEnabled(cacheable=true)
    public static List<Treinamento_Modulo__c> getModuloAtivoRelacionado(String strFiltro){
        List<Treinamento_Modulo__c> objReturn = new List<Treinamento_Modulo__c>();
        string strWhere = '';        
        string strQuery = getRegularQuery();

        // Remove possiveis injections e converte em objeto
        FiltroModulo objFilter = removeInjectionAndConvert(strFiltro);
        // Atribui os filtros recebidos
        strWhere = getFiltroModulo(objFilter,true);
        system.debug('strWhere >>>> ' + strWhere) ;

        // Verifica se tem alguma condição no where
        strQuery +=  (strWhere !='') ? strWhere : '';
        strQuery +=' ORDER BY ModuloId__r.Name ';
        System.debug('strQuery >>>>> ' + strQuery);

        // Executa o método na base
        objReturn = Database.query(strQuery);
        // Retorna o resultado
        return objReturn;
    }

    @AuraEnabled(cacheable=true)
    public static List<Treinamento_Modulo__c> getModuloRelacionado(String strFiltro){
        List<Treinamento_Modulo__c> objReturn = new List<Treinamento_Modulo__c>();
        string strWhere = '';        
        string strQuery = getRegularQuery();

        // Remove possiveis injections e converte em objeto
        FiltroModulo objFilter = removeInjectionAndConvert(strFiltro);
        // Atribui os filtros recebidos
        strWhere = getFiltroModulo(objFilter,false);
        system.debug('strWhere >>>> ' + strWhere) ;

        // Verifica se tem alguma condição no where
        strQuery +=  (strWhere !='') ? strWhere : '';
        strQuery +=' ORDER BY ModuloId__r.Name ';
        System.debug('strQuery >>>>> ' + strQuery);

        // Executa o método na base
        objReturn = Database.query(strQuery);
        // Retorna o resultado
        return objReturn;
    }

    private static FiltroModulo removeInjectionAndConvert (String objFilter){
        String jsonString = String.escapeSingleQuotes(objFilter);
        return (FiltroModulo)JSON.deserializeStrict(jsonString, FiltroModulo.class);
    }   

    private static string getFiltroModulo(FiltroModulo objFilter, Boolean blnAtivo){
        string strRetorno ='';
        // Verifica se os campos estão preenchidos
        if (objFilter.Id != null && objFilter.Id !=''){
            strRetorno += 'ModuloId__r.ID = \'' + objFilter.Id + '\' ';
        }
        if (objFilter.TreinamentoId != null && objFilter.TreinamentoId !=''){
            strRetorno += (strRetorno=='') ? 'ModuloId__r.Name LIKE \'%' + objFilter.TreinamentoId + '%\' ' : 'AND ModuloId__r.Name LIKE \'%' + objFilter.TreinamentoId + '%\' ' ; 
        }
        if (objFilter.Name != null && objFilter.Name !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoId__c = \'' + objFilter.Name + '\' ' : 'AND TreinamentoId__c = \'' + objFilter.Name + '\' ' ; 
        }
        if (objFilter.Descricao != null && objFilter.Descricao !=''){
            strRetorno += (strRetorno=='') ? 'ModuloId__r.Descricao__c LIKE \'%' + objFilter.Descricao + '%\' ' : 'AND ModuloId__r.Descricao__c LIKE \'%' + objFilter.Descricao + '%\' ' ; 
        }

        if (blnAtivo){
            strRetorno += (strRetorno=='') ? 'ModuloId__r.Ativo__c = ' +  String.valueof(blnAtivo)  + ' ' : 'AND ModuloId__r.Ativo__c = ' + String.valueof(blnAtivo) + ' ' ; 
        }else{
            if (objFilter.Name != null && objFilter.Name !=''){
                strRetorno += (strRetorno=='') ? 'ModuloId__r.Ativo__c = ' + objFilter.Ativo + ' ' : 'AND ModuloId__r.Ativo__c = ' + objFilter.Ativo  + ' ' ; 
            }
        }

        strRetorno = (strRetorno != '') ? 'WHERE ' + strRetorno : '';

        return strRetorno ;
    }

    private static string getRegularQuery(){
        string strQuery = 'SELECT ModuloId__r.ID, ModuloId__r.Name, TreinamentoId__c,  ';
        strQuery += 'ModuloId__r.Descricao__c, ModuloId__r.Ativo__c  ';
        strQuery += 'FROM Treinamento_Modulo__c ';
        return strQuery;
    }

}
