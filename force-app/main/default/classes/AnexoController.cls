public without sharing class AnexoController {
    
    @AuraEnabled
    public static TelaAnexosWrapper obterInfoComponente() {
        String[] colunasXlsxBaseDados = obterColunasModelo();
        List<ComboboxWrapper> opcoesTipoAnexo = obterOpcoesTipoAnexo();
        TelaAnexosWrapper taw = new TelaAnexosWrapper();
        taw.colunasXlsxBaseDados = colunasXlsxBaseDados;
        taw.opcoesTipoAnexo = opcoesTipoAnexo;
        return taw;
    }
    
    @AuraEnabled
    public static String[] obterColunasModelo() {
       // Validacao_Planilha__mdt vp = [
	   //SELECT Id, Label, Colunas__c FROM Validacao_Planilha__mdt WHERE DeveloperName = 'XLSX_Padrao' LIMIT 1
       //];
       String strClunas = 'Data de NascimentoGêneroCidadeUFGrau de DependênciaSituaçãoCIDAbrangênciaEquivalência de PlanoOperadora AtualEquivalência de Plano Fesp';
       //System.debug(vp.Colunas__c?.split('\n'));
       //System.debug(JSON.serialize( vp.Colunas__c?.split('\n')));
       return strClunas.split('\n');
    }

    private static List<ComboboxWrapper> obterOpcoesTipoAnexo() {
        //List<Schema.PicklistEntry> picklist = Schema.SObjectType.Anexos__c.fields.getMap().get('tipoanexo__c').getDescribe().getPicklistValues();
        //List<ComboboxWrapper> opcoesTipoAnexo = new List<ComboboxWrapper>{
            //new ComboboxWrapper('-- Selecionar --', '')
        //};
        //for (Schema.PicklistEntry pickValue :picklist) {
            //if (pickValue.isActive()) {
                //String label = pickValue.getLabel();
                //String value = pickValue.getValue();
                //opcoesTipoAnexo.add(new ComboboxWrapper(label, value));
            //}
        //}
        //
        List<ComboboxWrapper> opcoesTipoAnexo = new List<ComboboxWrapper>{
            new ComboboxWrapper('-- Selecionar --', ' '),
            new ComboboxWrapper('Excel', 'Excel')
        };
            return opcoesTipoAnexo;
    }

    public static void atribuirTipoArquivo(Id contentVersionId, Id recordId, String tipoAnexo) {
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
        cv.Title = tipoAnexo;
        //cv.Tipo_Arquivo__c = tipoAnexo;
        Database.update(cv);
    }

    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String tipoAnexo, String base64Data, String contentType, String fileId) {
        if ( String.isBlank(fileId) ) {
            fileId = salvarArquivo(parentId, fileName, tipoAnexo, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }

    private static void appendToFile(Id fileId, String base64Data) {
        ContentVersion cv = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :fileId LIMIT 1];
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(cv.VersionData) + base64Data);
        Database.update(cv);
    }

    public static Id salvarArquivo(Id idRegistro, String nomeArquivo, String tipoAnexo, String base64Data, String contentType) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = tipoAnexo;
        cv.PathOnClient = nomeArquivo;
        cv.Description = tipoAnexo;
        cv.FirstPublishLocationId = idRegistro;
        //cv.Tipo_Arquivo__c = tipoAnexo;
        Database.insert(cv);
        return cv.Id;
    }

}