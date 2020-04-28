public with sharing class TreinamentoController {
    @AuraEnabled(cacheable=true)
    public static List<Treinamento__c> getTreinamento(String strFiltro){
        List<Treinamento__c> objReturn = new List<Treinamento__c>();
        string strQuery = 'SELECT Id, Name, Descricao__c FROM Treinamento__c ';
        string strWhere = '';
        // Remove possiveis injections e converte em objeto
        FiltroTreinamento objFilter = removeInjectionAndConvert(strFiltro);
        // Atribui os filtros recebidos
        strWhere = getFiltroTreinamento(objFilter);
        system.debug('strWhere >>>> ' + strWhere) ;

        // Verifica se tem alguma condição no where
        strQuery +=  (strWhere !='') ? strWhere : '';
        strQuery +=' ORDER BY Name ';
        System.debug('strQuery >>>>> ' + strQuery);

        // Executa o método na base
        objReturn = Database.query(strQuery);
        // Retorna o resultado
        return objReturn;
    }

    private static FiltroTreinamento removeInjectionAndConvert (String objFilter){
        String jsonString = String.escapeSingleQuotes(objFilter);
        return (FiltroTreinamento)JSON.deserializeStrict(jsonString, FiltroTreinamento.class);
    }   

    private static string getFiltroTreinamento(FiltroTreinamento objFilter){
        string strRetorno ='';
        // Verifica se os campos estão preenchidos
        if (objFilter.Id != null && objFilter.Id !=''){
            strRetorno += 'ID = \'' + objFilter.Id + '\' ';
        }
        if (objFilter.Name != null && objFilter.Name !=''){
            strRetorno += (strRetorno=='') ? 'Name LIKE \'%' + objFilter.Name + '%\' ' : 'AND Name LIKE \'%' + objFilter.Name + '%\' ' ; 
        }
        if (objFilter.Descricao != null && objFilter.Descricao !=''){
            strRetorno += (strRetorno=='') ? 'Descricao__c LIKE \'%' + objFilter.Descricao + '%\' ' : 'AND Descricao__c LIKE \'%' + objFilter.Descricao + '%\' ' ; 
        }
        strRetorno = (strRetorno != '') ? 'WHERE ' + strRetorno : '';

        return strRetorno ;
    }

}
