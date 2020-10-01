global class SOAP_IntegrationAccount {
    Webservice static List<Account> getAccount(string strAccountId){
        List<Account> objReturn = new List<Account>();
        string strQuery = '';
        strQuery += 'SELECT Id, Name FROM Account ';
        strAccountId = removeInjection(strAccountId);
        strQuery += (strAccountId.trim()!='' ? 'WHERE Id =: strAccountId ' : '');

        objReturn = Database.query(strQuery);

        return objReturn;
    }

    private static String removeInjection (String strFilter){
        String jsonString = String.escapeSingleQuotes(strFilter);
        return jsonString;
    }   

}
