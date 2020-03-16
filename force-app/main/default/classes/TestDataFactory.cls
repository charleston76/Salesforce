@isTest
public class TestDataFactory {
    public static List<Inscricao__c> LoadInscricao(){
        List<sObject> objList = Test.loadData(Inscricao__c.sObjectType, 'Inscricao');
        
        return objList;
    }
}
