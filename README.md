# Salesforce
Salesforce technical help

Este repositório tem o intuito de auxiliar e alavancar os primeiros passos para os novos desenvolvedores na plataforma.

Após clonar o repositório e fazer push na sua scratch, atribua o permission set abaixo:</br>
    <b>sfdx force:user:permset:assign -n Treinamento_App_Permission_Set </b>


Mais detalhes no <a href="https://github.com/charleston76/Salesforce/wiki">Wiki</a> deste repositório.

## Login an environment 
    Setting as defualt user name
        Sandbox
            sfdx force:auth:web:login -a [Alias] --setdefaultusername  -r https://test.salesforce.com
        Productive
            sfdx force:auth:web:login -a [Alias] --setdefaultusername 

    If you don't wanna set the default user name, you can do that later:
        sfdx force:config:set defaultusername=user@test.com.br.sdrdev
        sfdx force:config:set defaultdevhubusername=user@name.com

## Retrieve from TMP package
    sfdx force:source:retrieve --manifest manifest/package-retrieveTmp.xml -u [Alias]

## Deployment
## clear the deployment folder, convert the files, and update de environment
    rmdir /s/q Deploy
    sfdx force:source:convert -r force-app/ -d Deploy -x manifest/package-Deploy.xml
    --sfdx force:mdapi:deploy -u [ALIAS] -d Deploy/ -w 10
    --sfdx force:mdapi:deploy -u [ALIAS] -w10 -d ./Deploy --checkonly  -l RunSpecifiedTests -r ClasseName1,ClasseName2,ClasseNameN
    
    sfdx force:mdapi:deploy -u myTrain -w15 -d ./Deploy

# Destructive 
    # The package need to be in the destructive folder
    --sfdx force:mdapi:deploy -d destructive -g -w 10

# For the SOAP API integration
1 - Authentication 
    Endpoint:   https://login.salesforce.com/services/Soap/c/49.0.

    Set the headers:
    1 - SOAPAction : -  (a dash)
        Content-Type : text/xml
    2 - Body:   Integration\SOAP\SOAPAuthenticationAPI.txt

2 - Query objects
    Endpoint (sobjects): https://iteristesting-dev-ed.my.salesforce.com/services/Soap/c/7.0
    Set the headers:
    1 - SOAPAction : -  (a dash)
        Content-Type : text/xml
    2 - Body:   Integration\SOAP\SOAPQueryAccount.txt

3 - For custom webservices the endpoint is:
    Endpoint:   https://iteristesting-dev-ed.my.salesforce.com/services/Soap/class/ClassName

    Example:    https://iteristesting-dev-ed.my.salesforce.com/services/Soap/class/SOAP_IntegrationAccount

    2 - Body:   Integration\SOAP\SOAPCustomWebService.txt