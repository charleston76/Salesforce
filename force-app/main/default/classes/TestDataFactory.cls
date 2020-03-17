@isTest
public class TestDataFactory {
    public static List<Treinamento__c> LoadTreinamento(){
        List<sObject> objList = Test.loadData(Treinamento__c.sObjectType, 'Treinamento');
        return objList;
    }

    public static List<Modulo__c> LoadModulo(){
        List<sObject> objList = Test.loadData(Modulo__c.sObjectType, 'Modulo');
        return objList;
    }    
}
