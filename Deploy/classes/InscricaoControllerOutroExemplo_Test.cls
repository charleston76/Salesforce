@isTest
public class InscricaoControllerOutroExemplo_Test {
    @testSetup
    private static void setLoadTestData(){

        List<Inscricao__c> mockupInsc = new List<Inscricao__c>();
        Id IdUsuario = UserInfo.getUserId();

        List<Treinamento__c> mockupTreinamento  = TestDataFactory.loadTreinamentoComId();
        List<Modulo__c> mockupModulo = TestDataFactory.loadModuloComId();
        List<Treinamento_Modulo__c> mockupTreinaModulo = TestDataFactory.loadTreinamentoModulo();

        // Inscrição
        mockupInsc.add(new Inscricao__c(Ativo__c = true,UserId__c = IdUsuario,TreinamentoModuloId__c = mockupTreinaModulo[0].id));
        insert mockupInsc;
    }

    @isTest static void queryWithoutParameters() {
        string userName = '';
        List <sObject> objTest = InscricaoController.getInscricaoPorUsuario(userName);
        System.assertEquals(0,objTest.size());
    }

    static testmethod void queryWithParameters(){
        string userName = UserInfo.getName();
        List <sObject> objTest = InscricaoController.getInscricaoPorUsuario(userName);
        System.assertEquals(1,objTest.size());
    }

    @isTest static void TestTreinamentoModuloTrigger() {
        List<Treinamento_Modulo__c> objInsert = new List<Treinamento_Modulo__c>();
        
        List<Treinamento_Modulo__c> objCadastrado = [   SELECT Ativo__c , TreinamentoId__c , ModuloId__c
                                                        FROM Treinamento_Modulo__c LIMIT 1];
        
        for(Treinamento_Modulo__c objRow : objCadastrado){
            objInsert.add(
                new Treinamento_Modulo__c(
                    Ativo__c = objRow.Ativo__c, TreinamentoId__c = objRow.TreinamentoId__c, ModuloId__c= objRow.ModuloId__c
                )
            );
        }

        Test.startTest();
        // Como o registro já está na base deverá ocorrer o erro
        Database.SaveResult[] objResult = Database.insert(objInsert, false);
        Test.stopTest();

        // E verificamos os resultados
        System.assert(!objResult[0].isSuccess());
        System.assert(objResult[0].getErrors().size() > 0);
        System.assertEquals('Informação já cadastrada', objResult[0].getErrors()[0].getMessage());
    }    
}
