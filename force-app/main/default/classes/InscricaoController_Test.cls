@isTest
public class InscricaoController_Test {
    @testSetup
    private static void setLoadTestData(){
        List<Treinamento__c> mockupTreinamento = new List<Treinamento__c>();
        List<Modulo__c> mockupModulo = new List<Modulo__c>();
        List<Treinamento_Modulo__c> mockupTreinaModulo = new List<Treinamento_Modulo__c>();
        List<Inscricao__c> mockupInsc = new List<Inscricao__c>();
        Id IdUsuario = UserInfo.getUserId();
        List<Treinamento__c> MocupData1 = TestDataFactory.LoadTreinamento();
        List<Modulo__c> MocupData2 = TestDataFactory.LoadModulo();

        for(Treinamento__c objRow : MocupData1){

            mockupTreinamento.add(
                new Treinamento__c(Name = objRow.Descricao__c,Descricao__c = objRow.Descricao__c + ' Mockup',Instrutor__c = IdUsuario, Ativo__c = true)
            );
        }

        for(Modulo__c objRow : MocupData2){
            // Modulo
            mockupModulo.add(new Modulo__c(Name = objRow.Descricao__c, Descricao__c = objRow.Descricao__c + ' Mockup', Carga_Horaria__c = 4, Ativo__c = true)
            );
        }
        insert mockupTreinamento;
        insert mockupModulo;
        // Treinamento Modulo
        mockupTreinaModulo.add ( new Treinamento_Modulo__c(Ativo__c = true, TreinamentoId__c = mockupTreinamento[0].id, ModuloId__c = mockupModulo[0].id));
        insert mockupTreinaModulo;
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
