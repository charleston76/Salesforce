// This notation provide the mapping parameter value provide the access to this class
// and for any time you include this URL in the request "bingo", it will fall here
// Example: https://ORGANIZATION.my.salesforce.com/apexrest/services/TreinamentoService
@RestResource(urlMapping='/TreinamentoService/*')
// To be accessed out side of the SFDC, it needs to be global
global class REST_IntegrationTreinamentoService {
    global class TreinamentoService{
        string Name{get;set;}
        string Descricao {get;set;}
    }

    // To expose the methods, you need use the notations according the necessity
    @httpGet
    global static TreinamentoService getTreinamento(){
        RestRequest objRequest = RestContext.Request;
        // The ID will be in the URI after the /
        String strID = objRequest.requestURI.substring(objRequest.requestURI.lastIndexOf('/') +1);
        Treinamento__c objRecord = [SELECT Name, Descricao__c FROM Treinamento__c WHERE Id =:strID ];
        TreinamentoService objService = new TreinamentoService();

        objService.Name = objRecord.Name;
        objService.Descricao = objRecord.Descricao__c;

        return objService;

    }

}
