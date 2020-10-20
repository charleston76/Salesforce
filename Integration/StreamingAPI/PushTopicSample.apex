// Um "PushTopic" é um mecanismo de gatilho que "dispara" mensagens de notificação quando algum evento (CRUD + Undelete) ocorre.
// Este método de notificação é baseado nos critérios que você determina com SOQL, e apenas os campos que você determinar 
// serão incluídos na mensagem de notificação.
// Este sObject permite que "subscribers" se inscrevam em um "channel" (streaming de eventos) criado, para receber as notificações
PushTopic objPushRest = new PushTopic();
// Este será o "channel" desta notificação
objPushRest.Name = 'TreinamentoRestUpdate';
objPushRest.Description='Example de criação de push topic';
// É obrigatório incluir o Id, e você só pode usar um objeto por query
objPushRest.Query='SELECT Id, Name FROM Treinamento__c WHERE Name =\'Treinamento REST\'';
// Se você não definir uma clausula WHERE, todo os registros do objetos serão verificados, sempre
objPushRest.ApiVersion = 49.0;
// Você pode especificar para quais eventos a notificação deve ser disparada ou não
// mas o default é true
objPushRest.NotifyForOperationCreate = true;
objPushRest.NotifyForOperationDelete = true;
objPushRest.NotifyForOperationUndelete = true;
objPushRest.NotifyForOperationUpdate = true;
// Você pode determinar para quais campos deve ser a notificação, entre:
// All - Todos os campos do objeto.  Notificações são geradas apenas se os registros combinam com o critério especificado no WHERE
// Referenced (Defaul) - Alterações nos campos referenciados no SELECT e no WHERE. Notificações são geradas apenas se os registros combinam com o critério especificado no WHERE
// Select - Alterações nos campos referenciados no SELECT. Notificações são geradas apenas se os registros combinam com o critério especificado no WHERE
// Where - Alterações nos campos referenciados no WHERE. Notificações são geradas apenas se os registros combinam com o critério especificado no WHERE
objPushRest.NotifyForFields='Referenced';

insert objPushRest;


PushTopic objPushAll = new PushTopic();
objPushAll.Name = 'TreinamentoUpdate';
// Se você não definir uma clausula WHERE, todo os registros do objetos serão verificados, sempre
objPushAll.Query='SELECT Id, Name FROM Treinamento__c ';
objPushAll.ApiVersion = 49.0;
objPushAll.NotifyForOperationCreate = true;
objPushAll.NotifyForOperationDelete = true;
objPushRest.NotifyForOperationUndelete = false;
objPushRest.NotifyForOperationUpdate = false;
objPushAll.NotifyForFields='All';
insert objPushAll;

// Para utilização deste modo de Streaming API, temos a seguinte sequencia:
// 1 - Você cria o push topic baseado em uma query, e isto define o "Channel"
// 2 - Clients se escrevem (substribe) no "Channel" 
// 3 - Quando ocorre um evento (CRUD + Undelete), esta alteração é avaliada
// 4 - Se a alteração (evento) "combina" (match) com o critério da query
// uma notificação é gerada pelo servidor e recebida pelos inscritos
// Da mesma forma que se faz no Youtube.

// Você poderá selecionar as informações de sObject normalmente:
SELECT Id, 
    Name,
    Query,
    ApiVersion,
    NotifyForOperationCreate,
    NotifyForOperationDelete,
    NotifyForOperationUndelete,
    NotifyForOperationUpdate,
    NotifyForFields
FROM PushTopic


