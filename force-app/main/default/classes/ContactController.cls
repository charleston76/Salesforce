public with sharing class ContactController {
    // When cacheable=true is enabled, DML is not allowed
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        /*return [
            SELECT FirstName, LastName, Email
            FROM Contact
            WITH SECURITY_ENFORCED
            ORDER BY FirstName
        ];*/
        throw new AuraHandledException('Forced error');
    }
}