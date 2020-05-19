public with sharing class InscricaoController {
    @AuraEnabled(cacheable=true)
    public static List<Inscricao__c> getInscricao(String strFiltro){
        List<Inscricao__c> objReturn = new List<Inscricao__c>();
        string strWhere = '';        
        string strQuery = getRegularQuery();

        // Remove possiveis injections e converte em objeto
        FiltroInscricao objFilter = removeInjectionAndConvert(strFiltro);
        // Atribui os filtros recebidos
        strWhere = getFiltroInscricao(objFilter);
        system.debug('strWhere >>>> ' + strWhere) ;

        // Verifica se tem alguma condição no where
        strQuery +=  (strWhere !='') ? strWhere : '';
        strQuery +=' ORDER BY TreinamentoModuloId__r.TreinamentoId__r.Name, TreinamentoModuloId__r.ModuloId__r.Name, TreinamentoModuloId__r.TreinamentoId__r.Name ';
        System.debug('strQuery >>>>> ' + strQuery);

        // Executa o método na base
        objReturn = Database.query(strQuery);
        // Retorna o resultado
        return objReturn;
    }

    private static FiltroInscricao removeInjectionAndConvert (String objFilter){
        String jsonString = String.escapeSingleQuotes(objFilter);
        return (FiltroInscricao)JSON.deserializeStrict(jsonString, FiltroInscricao.class);
    }   

    private static string getFiltroInscricao(FiltroInscricao objFilter){
        string strRetorno ='';
        // Verifica se os campos estão preenchidos
        if (objFilter.Id != null && objFilter.Id !=''){
            strRetorno += 'ID = \'' + objFilter.Id + '\' ';
        }

        if (objFilter.UserId != null && objFilter.UserId !=''){
            strRetorno += (strRetorno=='') ? 'UserId__r.Id = \'' + objFilter.UserId + '\' ' : 'AND UserId__r.Id = \'' + objFilter.UserId + '\' ' ; 
        }

        if (objFilter.UserName != null && objFilter.UserName !=''){
            strRetorno += (strRetorno=='') ? 'UserId__r.Name LIKE \'%' + objFilter.UserName + '%\' ' : 'AND UserId__r.Name LIKE \'%' + objFilter.UserName + '%\' ' ; 
        }

        if (objFilter.TreinamentoId != null && objFilter.TreinamentoId !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.TreinamentoId__r.Id = \'' + objFilter.TreinamentoId + '\' ' : 'AND TreinamentoModuloId__r.TreinamentoId__r.Id = \'' + objFilter.TreinamentoId + '\' ' ; 
        }

        if (objFilter.TreinamentoName != null && objFilter.TreinamentoName !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.TreinamentoId__r.Name LIKE \'%' + objFilter.TreinamentoName + '%\' ' : 'AND TreinamentoModuloId__r.TreinamentoId__r.Name LIKE \'%' + objFilter.TreinamentoName + '%\' ' ; 
        }

        if (objFilter.TreinamentoAtivo != null && objFilter.TreinamentoAtivo !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.ModuloId__r.Ativo__c = ' + objFilter.TreinamentoAtivo + ' ' : 'AND TreinamentoModuloId__r.ModuloId__r.Ativo__c = ' + objFilter.TreinamentoAtivo  + ' ' ; 
        }


        if (objFilter.ModuloId != null && objFilter.ModuloId !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.ModuloId__r.Id = \'' + objFilter.ModuloId + '\' ' : 'AND TreinamentoModuloId__r.ModuloId__r.Id = \'' + objFilter.ModuloId + '\' ' ; 
        }

        if (objFilter.ModuloName != null && objFilter.ModuloName !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.ModuloId__r.Name LIKE \'%' + objFilter.ModuloName + '%\' ' : 'AND TreinamentoModuloId__r.ModuloId__r.Name LIKE \'%' + objFilter.ModuloName + '%\' ' ; 
        }


        if (objFilter.ModuloAtivo != null && objFilter.ModuloAtivo !=''){
            strRetorno += (strRetorno=='') ? 'TreinamentoModuloId__r.ModuloId__r.Ativo__c = ' + objFilter.ModuloAtivo + ' ' : 'AND TreinamentoModuloId__r.ModuloId__r.Ativo__c = ' + objFilter.ModuloAtivo  + ' ' ; 
        }

        strRetorno = (strRetorno != '') ? 'WHERE ' + strRetorno : '';

        return strRetorno ;
    }

    private static string getRegularQuery(){
        string strQuery = 'SELECT ID, UserId__r.Id, UserId__r.Name, TreinamentoModuloId__r.TreinamentoId__r.Id, ' ;
        strQuery += 'TreinamentoModuloId__r.TreinamentoId__r.Name, TreinamentoModuloId__r.TreinamentoId__r.Ativo__c, ';
        strQuery += 'TreinamentoModuloId__r.ModuloId__r.Id, TreinamentoModuloId__r.ModuloId__r.Name, ';
        strQuery += 'TreinamentoModuloId__r.ModuloId__r.Ativo__c , TreinamentoModuloId__r.ModuloId__r.Carga_Horaria__c ';
        strQuery += 'FROM Inscricao__c ';
        return strQuery;
    }

    public static List<Inscricao__c> getInscricaoPorUsuario(String srtUsername){
        List<Inscricao__c> objReturn;

        objReturn = [SELECT
                        ID, 
                        UserId__r.Id,
                        UserId__r.Name, 
                        TreinamentoModuloId__r.TreinamentoId__r.Id,
                        TreinamentoModuloId__r.TreinamentoId__r.Name ,
                        TreinamentoModuloId__r.TreinamentoId__r.Ativo__c,
                        TreinamentoModuloId__r.ModuloId__r.Id,
                        TreinamentoModuloId__r.ModuloId__r.Name,
                        TreinamentoModuloId__r.ModuloId__r.Ativo__c ,
                        TreinamentoModuloId__r.ModuloId__r.Carga_Horaria__c
                    FROM Inscricao__c
                    WHERE Ativo__c = true
                    AND   TreinamentoModuloId__r.TreinamentoId__r.Ativo__c = true
                    AND   TreinamentoModuloId__r.ModuloId__r.Ativo__c = true
                    AND   UserId__r.Name =: srtUsername ];

        return objReturn;
    }
}


