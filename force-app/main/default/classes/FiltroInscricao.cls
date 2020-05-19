public class FiltroInscricao {
    @AuraEnabled
    public Integer pageSize {get; set;}
    @AuraEnabled
    public Integer pageNumber {get; set;}

    public string Id {get; set;}
    public string UserId {get; set;}
    public string UserName {get; set;}
    public string TreinamentoId {get; set;}
    public string TreinamentoName {get; set;}
    public string TreinamentoAtivo {get; set;}
    public string ModuloId {get; set;}
    public string ModuloName {get; set;}
    public string ModuloAtivo {get; set;}
    public string ModuloCargaHoraria {get; set;}
}
