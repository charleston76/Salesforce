public with sharing class AccountController {
    // When cacheable=true is enabled, DML is not allowed
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        /*
        return [
            SELECT Name, AnnualRevenue, Industry
            FROM Account
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];*/
        throw new AuraHandledException('Forced error');
    }
}