public class FiltroModulo {
    @AuraEnabled
    public Integer pageSize {get; set;}
    @AuraEnabled
    public Integer pageNumber {get; set;}
    
    public string Id {get; set;}
    public string TreinamentoId {get; set;}
    public string Name {get; set;}
    public string Descricao {get; set;}
    public string Ativo {get; set;}
}

