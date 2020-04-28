public with sharing class TreinamentoModuloHelperClass {
   /**************************************************************************
    * Método   : getTreinamentoModuloCadastrado
    * Objetivo : Verificar se existe um item cadastrado antes da inclusão
    * Entradas : List<Treinamento_Modulo__c> objTreina
    * Saídas   : True/False
    * Data     : 04/03/2020
    * Autor    : Charleston Santos
    *------------------------------------------------------------------------
    * Alteração: dd/mm/aaaa
    * Autor    : 
    * Motivo   :
    **************************************************************************/
    public static Boolean getTreinamentoModuloCadastrado(List<Treinamento_Modulo__c> objTreina){
        Boolean blnReturn = false;
        Set<String> strTreinamento = new Set<String>();
        Set<String> strModulo= new Set<String>();

        // Verifica todos os Ids de treinamento e modulo
        for(Treinamento_Modulo__c objRow: objTreina){
            strTreinamento.add(objRow.TreinamentoId__c);
            strModulo.add(objRow.ModuloId__c);
        }

        // Verifica se na base já existe o treinnamento é o modulo
        List<Treinamento_Modulo__c> objCheck = [SELECT ID FROM Treinamento_Modulo__c
                                                WHERE TreinamentoId__c IN :strTreinamento
                                                AND   ModuloId__c IN :strModulo];
        // Se existir, retorna true
        if(objCheck.size()>0){
            blnReturn=true;
        }
        return blnReturn;
    }
}
