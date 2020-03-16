public with sharing class InscricaoController {
    public static List<Inscricao__c> getInscricaoPorUsuario(String srtUsername){
        List<Inscricao__c> objReturn;

        objReturn = [SELECT
                        ID, 
                        UserId__r.Name, 
                        TreinamentoModuloId__r.TreinamentoId__r.Name ,
                        TreinamentoModuloId__r.ModuloId__r.Name,
                    TreinamentoModuloId__r.ModuloId__r.Carga_Horaria__c
                    FROM Inscricao__c
                    WHERE Ativo__c = true
                    AND   TreinamentoModuloId__r.TreinamentoId__r.Ativo__c = true
                    AND   TreinamentoModuloId__r.ModuloId__r.Ativo__c = true
                    AND   UserId__r.Name =: srtUsername ];

        return objReturn;
    }
}


