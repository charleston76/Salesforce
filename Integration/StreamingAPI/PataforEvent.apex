Acter create a platform event (Setup > Plataform Event) anyone subscribed will receive the events inserted
    EVT_DEMONSTRATION__e

To insert an event through the Worbench: 
    Utilities > Rest
    Select a POST method
    set the end point:
        /services/data/v49.0/sobjects/EVT_DEMONSTRATION__e
    Enter the created fields in the body:
        {
            "TXT_TREINAMENTO_NAME__c":"Treinamento REST Event",
            "TXT_CRUD_TYPE__c":"I"
        }

Beyond this kinde of inclusion, in the real life, you can create a trigger in a object to insert a plataform event, accordling something
happened in the real object.

