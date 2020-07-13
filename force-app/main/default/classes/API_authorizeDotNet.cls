// Esta classe foi baseada na seguinte classe:
// https://github.com/deepikakhanna/SalesforceRealTimeProjectPart1/blob/master/API_AuthorizeDotNet

public with sharing class API_authorizeDotNet {
    // Variáveis com as credenciais
    public static string API_LOGIN;
    public static string API_TRANSKEY;
    public static string API_ENDPOINT;

    // Verifica as credenciais
    public static void getAuthNetCredenciais(){
        Authorize_Net_Setting__c apiLogin = Authorize_Net_Setting__c.getInstance('API Login');
        Authorize_Net_Setting__c apiTransKey = Authorize_Net_Setting__c.getInstance('Transaction Key');
        Authorize_Net_Setting__c apiEndPoint = Authorize_Net_Setting__c.getInstance('Endpoint URL');

        API_LOGIN = apiLogin.Value__c;
        API_TRANSKEY = apiTransKey.Value__c;
        API_ENDPOINT = apiEndPoint.Value__c;

        //system.System.debug('apiLogin: ' + API_LOGIN);
        //system.System.debug('apiTransKey: ' + API_TRANSKEY);
        //system.System.debug('apiEndPoint: ' + API_ENDPOINT);
    }

    // Realiza a chamada
    public static ResponseWrapper getCalloutAuthDotNet (RequestWrapper objImput) {
        //Primeiro pega as credenciais
        getAuthNetCredenciais();
    
        //Instancia a request
        HttpRequest objRequest = new HttpRequest();

        // Este endpoint precisa estar configurado no remote site settings
        // Se não dá erro
        objRequest.setEndpoint(API_ENDPOINT); 
        objRequest.setMethod('POST');
        
        //Cria um map para a mensagem
        Map<string,string> strMapMessage = new map<String,String>();
        
        //Campos do padrão definido na documentação do authorize.net documentation
        strMapMessage.put('x_login',API_LOGIN);
        strMapMessage.put('x_tran_key',API_TRANSKEY);  
        strMapMessage.put('x_version', '3.1');
        strMapMessage.put('x_delim_data', 'TRUE');
        //Delimitar do response
        strMapMessage.put('x_delim_char', ';');
        strMapMessage.put('x_relay_response', 'FALSE');  
        //Tipo de transação
        strMapMessage.put('x_type', 'AUTH_CAPTURE');
        //Processing credit card
        strMapMessage.put('x_method', 'CC');
          
        //Transaction Specific Information
        //card numbers, expiration, security codes
        strMapMessage.put('x_card_num', objImput.ccnum);
        strMapMessage.put('x_exp_date', objImput.ccexp);
        strMapMessage.put('x_card_code', objImput.ccsec);
        
        //transaction amount
        strMapMessage.put('x_amount', objImput.amt);
        //description of transaction
        strMapMessage.put('x_description', 'Your Transaction: '+objImput.ordername);
        
        //billing information
        strMapMessage.put('x_first_name', objImput.firstname);
        strMapMessage.put('x_last_name', objImput.lastname);
        strMapMessage.put('x_address', objImput.billstreet);
        strMapMessage.put('x_city', objImput.billcity);
        strMapMessage.put('x_state', objImput.billstate);
        strMapMessage.put('x_zip', objImput.billzip);
        
        //encode the message components
        String strEncoded = '';
        for (string s : strMapMessage.keySet()){
            string v = strMapMessage.get(s);
            //fix null values
            if (string.isblank(v)){
                v='';
            }else{
                strEncoded += s+'='+EncodingUtil.urlEncode(v, 'UTF-8')+'&';
            }
        } 
        //add message termination
        strEncoded += 'endofdata';
        system.debug('TRACE: Encoded Message: \n\n' + strEncoded);
    
        //Define o body da request
        objRequest.setBody(strEncoded);
        
        //Envia e já pega a resposta
        Http objHttp = new Http();
        string objResponse = objHttp.send(objRequest).getbody();
        //debug
        system.debug(objResponse);
        
        //Split pelo delimitador definido
        list<string> responses = objResponse.split(';');
        
        //Faz o parse no objeto criado
        ResponseWrapper objWrapper = parseIntoResponseWrapper(responses);
    
        //debug response wrapper
        system.debug(objWrapper);
        return objWrapper;
      } 
        
      
    
      /**
      * Method to parse split response into wrapper
      **/
      public static ResponseWrapper parseIntoResponseWrapper(list<string> objImput){
        ResponseWrapper objTemp = new ResponseWrapper();
        objTemp.responseCode = objImput[0];
        objTemp.ResponseSubcode = objImput[1];
        objTemp.ResponseReasonCode =objImput[2];
        objTemp.ResponseReasonText=objImput[3];
        objTemp.AuthorizationCode=objImput[4];
        objTemp.AVSResponse= objImput[5];
        objTemp.TransactionID=objImput[6];
        objTemp.InvoiceNumber= objImput[7];
        objTemp.Description= objImput[8];
        objTemp.Amount= objImput[9];
        objTemp.Method= objImput[10];
        objTemp.TransactionType= objImput[11];
        objTemp.CustomerID= objImput[12];
        objTemp.FirstName= objImput[13];
        objTemp.LastName= objImput[14];
        objTemp.Company= objImput[15];
        objTemp.Address= objImput[16];
        objTemp.City= objImput[17];
        objTemp.State= objImput[18];
        objTemp.ZIPCode= objImput[19];
        objTemp.Country= objImput[20];
        objTemp.Phone= objImput[21];
        objTemp.Fax= objImput[22];
        objTemp.EmailAddress= objImput[23];
        objTemp.ShipToFirstName= objImput[24];
        objTemp.ShipToLastName= objImput[25];
        objTemp.ShipToCompany= objImput[26];
        objTemp.ShipToAddress= objImput[27];
        objTemp.ShipToCity= objImput[28];
        objTemp.ShipToState= objImput[29];
        objTemp.ShipToZIPCode= objImput[30];
        objTemp.ShipToCountry= objImput[31];
        objTemp.Tax= objImput[32];
        objTemp.Duty= objImput[33];
        objTemp.Freight= objImput[34];
        objTemp.TaxExempt= objImput[35];
        objTemp.PurchaseOrderNumber= objImput[36];
        objTemp.MD5Hash= objImput[37];
        objTemp.CardCodeResponse= objImput[38];
        objTemp.CardholderAuthenticationVerificationResponse= objImput[39];
        objTemp.AccountNumber= objImput[40];
        objTemp.CardType= objImput[41];
        objTemp.SplitTenderID= objImput[42];
        objTemp.RequestedAmount= objImput[43];
        objTemp.BalanceOnCard= objImput[44];
        return objTemp;
      }
      
      public class RequestWrapper {
        public string ordername {get;set;}
        public string ccnum {get;set;}  
        public string ccexp {get;set;}
        public string ccsec {get;set;}
        public string amt {get;set;}
        public string firstname {get;set;}
        public string lastname {get;set;}
        public string billstreet {get;set;}
        public string billcity {get;set;}
        public string billstate {get;set;}
        public string billzip {get;set;}
        public string transid {get; set;}
        public string routingnumber {get; set;}
        public string accountnumber {get; set;}
        public string bankaccounttype {get; set;}
        public string bankname {get; set;}
        public string bankaccountname {get; set;}
        
        public RequestWrapper(){}
      }
      
      public class ResponseWrapper{
        // value, index in split string list
        public string responseCode {get;set;} //0
        public string ResponseSubcode{get;set;} //1
        public string ResponseReasonCode{get;set;} //2
        public string ResponseReasonText{get;set;} //3
        public string AuthorizationCode{get;set;} //4
        public string AVSResponse{get;set;} //5
        public string TransactionID{get;set;} //6
        public string InvoiceNumber{get;set;} //7
        public string Description{get;set;} //8
        public string Amount{get;set;} //9
        public string Method{get;set;} //10
        public string TransactionType{get;set;} //11
        public string CustomerID{get;set;} //12
        public string FirstName{get;set;} //13
        public string LastName{get;set;} //14
        public string Company{get;set;} //15
        public string Address{get;set;} //16
        public string City{get;set;} //17
        public string State{get;set;} //18
        public string ZIPCode{get;set;} //19
        public string Country{get;set;} //20
        public string Phone{get;set;} //21
        public string Fax{get;set;} //22
        public string EmailAddress{get;set;} //23
        public string ShipToFirstName{get;set;} //24
        public string ShipToLastName{get;set;} //25
        public string ShipToCompany{get;set;} //26
        public string ShipToAddress{get;set;} //27
        public string ShipToCity{get;set;} //28
        public string ShipToState{get;set;} //29
        public string ShipToZIPCode{get;set;} //30
        public string ShipToCountry{get;set;} //31
        public string Tax{get;set;} //32
        public string Duty{get;set;} //33
        public string Freight{get;set;} //34
        public string TaxExempt{get;set;} //35
        public string PurchaseOrderNumber{get;set;} //36
        public string MD5Hash{get;set;} //37
        public string CardCodeResponse{get;set;} //38
        public string CardholderAuthenticationVerificationResponse{get;set;} //39
        public string AccountNumber{get;set;} //40
        public string CardType{get;set;} //41
        public string SplitTenderID{get;set;} //42
        public string RequestedAmount{get;set;} //43
        public string BalanceOnCard{get;set;} //44
        public ResponseWrapper(){}
      }

}
