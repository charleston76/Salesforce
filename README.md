# Salesforce
Salesforce technical help

Este repositório tem o intuito de auxiliar e alavancar os primeiros passos para os novos desenvolvedores na plataforma.

Após clonar o repositório e fazer push na sua scratch, atribua o permission set abaixo:
    sfdx force:user:permset:assign -n Treinamento_App_Permission_Set 


Mais detalhes no <a href="https://github.com/charleston76/Salesforce/wiki">Wiki</a> deste repositório.

## Login an environment 
    Setting as defualt user name
        Sandbox
            sfdx force:auth:web:login -a [Alias] --setdefaultusername  -r https://test.salesforce.com
        Productive
            sfdx force:auth:web:login -a [Alias] --setdefaultusername 

    If you don't wanna set the default user name, you can do that later:
        sfdx force:config:set defaultdevhubusername=user@name.com


## Retrieve from TMP package
    sfdx force:source:retrieve --manifest manifest/package-retrieveTmp.xml -u [Alias]

## Deployment
## clear the deployment folder, convert the files, and update de environment
    rmdir /s/q Deploy
    sfdx force:source:convert -r force-app/ -d Deploy -x manifest/package-Deploy.xml
    --sfdx force:mdapi:deploy -u [ALIAS] -d Deploy/ -w 10
    --sfdx force:mdapi:deploy -u [ALIAS] -w10 -d ./Deploy --checkonly  -l RunSpecifiedTests -r Sistema_de_Reservas_APITest.cls
    sfdx force:config:set defaultusername=user@test.com.br.sdrdev
sfdx force:mdapi:deploy -u [ALIAS] -w15 -d ./Deploy

# Destructive 
    # The package need to be in the destructive folder
    --sfdx force:mdapi:deploy -d destructive -g -w 10

# For the SOAP API integration
1 - Authentication endpoint: 
    http://login.salesforce.com/Soap/c/49.0

    Set the headers:
    1 - SOAPAction : -  (a dash)
        Content-Type : text/xml
    2 - Use the body example SOAPAuthenticationAPI.txt
        
2 - Query objects
    Set the headers:
    1 - SOAPAction : -  (a dash)
        Content-Type : text/xml
    2 - Use the body example SOAPQueryAccount.txt