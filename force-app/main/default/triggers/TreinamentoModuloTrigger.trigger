/**************************************************************************
 * Método   : TreinamentoModuloTrigger
 * Objetivo : Trigger de verificação e validação da inclusões no objeto
 * Entradas : before insert
 * Saídas   : N/A
 * Data     : 04/03/2020
 * Autor    : Charleston Santos
 *------------------------------------------------------------------------
 * Alteração: dd/mm/aaaa
 * Autor    : 
 * Motivo   :
**************************************************************************/
trigger TreinamentoModuloTrigger on Treinamento_Modulo__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        if (TreinamentoModuloHelperClass.getTreinamentoModuloCadastrado(Trigger.new)){
            Trigger.new[0].addError('Informação já cadastrada');
        }
    }
}