public class TreinamentoFlowController {
    @InvocableMethod(label='Consulta modulos ativos' description='Retorna uma lista de modulos')
    public static List<Treinamento__c> getTreinamentoFlow(List<String> strFiltro){

        // Passa apenas o primeiro valor
        return TreinamentoController.getTreinamento(strFiltro[0]);

    }
}