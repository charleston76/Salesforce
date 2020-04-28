@isTest
public class TestDataFactory {
    // Realiza a carga dos objetos sem os IDs
    public static List<Treinamento__c> loadTreinamento(){
        List<sObject> objList = Test.loadData(Treinamento__c.sObjectType, 'Treinamento');
        return objList;
    }

    public static List<Modulo__c> loadModulo(){
        List<sObject> objList = Test.loadData(Modulo__c.sObjectType, 'Modulo');
        return objList;
    }    

    // Exemplo de carga dos objetos com os IDs para relacionamento
    public static List<Treinamento__c> loadTreinamentoComId(){
        List<Treinamento__c> objList = Test.loadData(Treinamento__c.sObjectType, 'TreinamentoComId');
        return objList;
    }

    public static List<Modulo__c> loadModuloComId(){
        List<Modulo__c> objList = Test.loadData(Modulo__c.sObjectType, 'ModuloComId');
        return objList;
    }    

    public static List<Treinamento_Modulo__c> loadTreinamentoModulo(){
        List<Treinamento_Modulo__c> objList = Test.loadData(Treinamento_Modulo__c.sObjectType, 'TreinamentoModulo');
        return objList;
    }
}
