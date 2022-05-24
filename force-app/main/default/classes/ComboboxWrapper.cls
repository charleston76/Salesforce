public without sharing class ComboboxWrapper {
    @AuraEnabled public String label;
    @AuraEnabled public String value;
    public ComboboxWrapper(String label, String value) {
        this.label = label;
        this.value = value;
    }
}