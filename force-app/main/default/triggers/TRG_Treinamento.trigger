/**************************************************************************
 * Método   : TRG_Treinamento
 * Objetivo : Trigger de inclusão de um evento no objeto EVT_DEMONSTRATION__e
 * Entradas : after insert/update/delete
 * Saídas   : N/A
 * Data     : 30/10/2020
 * Autor    : Charleston Santos
 *------------------------------------------------------------------------
 * Alteração: dd/mm/aaaa
 * Autor    : 
 * Motivo   :
**************************************************************************/
trigger TRG_Treinamento on Treinamento__c (after insert, after update,after delete ) {


    /*****************************************************************************
     * Embora neste exemplo o código esteja inserido diretamente na trigger,
     * se fosse um projeto real, as melhores praticas orientam para colocar o
     * trecho de códigodentro do "if" em uma helper/handler class.
     * Mas como o proposito deste repositório é apenas dar alguns exemplos...
     * Então vamos lá...
     *****************************************************************************/
    if (Trigger.isAfter
    &&  Trigger.isInsert
    &&  Trigger.isUpdate
    &&  Trigger.isDelete){
        // Instancia o evento
        List<EVT_DEMONSTRATION__e> objEve = new List<EVT_DEMONSTRATION__e>();
        // Define o tipo
        string strCrudType='';
        if (Trigger.isInsert) strCrudType = 'I';
        if (Trigger.isUpdate) strCrudType = 'U';
        if (Trigger.isDelete) strCrudType = 'D';
        // Adiciona os registros na instancia
        for (Treinamento__c objRow : Trigger.new){
            EVT_DEMONSTRATION__e newEve = new EVT_DEMONSTRATION__e();
            newEve.TXT_TREINAMENTO_NAME__c = objRow.Name;
            newEve.TXT_CRUD_TYPE__c = strCrudType;
            objEve.add(newEve);
        }

        // Publica o evento
        if(objEve.size()>0) Eventbus.publish(objEve);
    }

}