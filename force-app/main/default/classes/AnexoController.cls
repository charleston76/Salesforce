public without sharing class AnexoController {
    static string CLASS_NAME = 'AnexoController';

    @AuraEnabled
    public static TelaAnexosWrapper obterInfoComponente() {
        String METHOD_NAME = 'obterInfoComponente';
        String[] colunasXlsxBaseDados = obterColunasModelo();
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' colunasXlsxBaseDados ' + colunasXlsxBaseDados);
        List<ComboboxWrapper> opcoesTipoAnexo = obterOpcoesTipoAnexo();
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' opcoesTipoAnexo ' + opcoesTipoAnexo);
        TelaAnexosWrapper taw = new TelaAnexosWrapper();
        taw.colunasXlsxBaseDados = colunasXlsxBaseDados;
        taw.opcoesTipoAnexo = opcoesTipoAnexo;
        return taw;
    }
    
    @AuraEnabled
    public static String[] obterColunasModelo() {
        String METHOD_NAME = 'obterColunasModelo';
       // Validacao_Planilha__mdt vp = [
	   //SELECT Id, Label, Colunas__c FROM Validacao_Planilha__mdt WHERE DeveloperName = 'XLSX_Padrao' LIMIT 1
       //];
       String strClunas = '"Data de Nascimento","Gênero","Cidade","UF","Grau de Dependência","Situação","CID","Abrangência","Equivalência de Plano","Operadora Atual","Equivalência de Plano Fesp"';
       system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' strClunas.split(n) ' + strClunas.split('\n'));
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
        String METHOD_NAME = 'atribuirTipoArquivo';
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' contentVersionId ' + contentVersionId);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' recordId ' + recordId);        
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' tipoAnexo ' + tipoAnexo);        
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' cv ' + cv);        
        cv.Title = tipoAnexo;
        //cv.Tipo_Arquivo__c = tipoAnexo;
        Database.update(cv);
    }

    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String tipoAnexo, String base64Data, String contentType, String fileId) {
        String METHOD_NAME = 'saveChunk';
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' parentId ' + parentId);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' fileName ' + fileName);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' tipoAnexo ' + tipoAnexo);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' base64Data ' + base64Data);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' contentType ' + contentType);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' fileId ' + fileId);
        if ( String.isBlank(fileId) ) {
            fileId = salvarArquivo(parentId, fileName, tipoAnexo, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }

    private static void appendToFile(Id fileId, String base64Data) {
        String METHOD_NAME = 'appendToFile';
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' parefileIdntId ' + fileId);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' base64Data ' + base64Data);

        ContentVersion cv = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :fileId LIMIT 1];
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' cv ' + cv);        
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(cv.VersionData) + base64Data);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' cv.VersionData ' + cv.VersionData);        
        Database.update(cv);
    }

    public static Id salvarArquivo(Id idRegistro, String nomeArquivo, String tipoAnexo, String base64Data, String contentType) {
        String METHOD_NAME = 'salvarArquivo';
        ContentVersion cv = new ContentVersion();
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' idRegistro ' + idRegistro);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' nomeArquivo ' + nomeArquivo);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' tipoAnexo ' + tipoAnexo);
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' base64Data ' + base64Data);        
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' contentType ' + contentType);
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        //cv.Title = tipoAnexo;
        cv.Title = nomeArquivo;
        cv.PathOnClient = nomeArquivo;
        cv.Description = tipoAnexo;
        cv.FirstPublishLocationId = idRegistro;
        system.debug(CLASS_NAME + ' ' + METHOD_NAME + ' cv ' + cv);
        //cv.Tipo_Arquivo__c = tipoAnexo;
        Database.insert(cv);
        return cv.Id;
    }

}