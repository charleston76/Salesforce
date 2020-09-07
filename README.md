# Salesforce
Salesforce technical help

Este repositório tem o intuito de auxiliar e alavancar os primeiros passos para os novos desenvolvedores na plataforma.

Após clonar o repositório e fazer push na sua scratch, atribua o permission set abaixo:</br>
    <b>sfdx force:user:permset:assign -n Treinamento_App_Permission_Set </b>


Mais detalhes no <a href="https://github.com/charleston76/Salesforce/wiki">Wiki</a> deste repositório.

## Retrieve from TMP package
    sfdx force:source:retrieve --manifest manifest/package-retrieveTmp.xml -u GjpQA

## Deployment
## clear the deployment folder, convert the files, and update de environment
    rmdir /s/q Deploy
    sfdx force:source:convert -r force-app/ -d Deploy -x manifest/package-Deploy.xml
    --sfdx force:mdapi:deploy -u [ALIAS] -d Deploy/ -w 10
    --sfdx force:mdapi:deploy -u [ALIAS] -w10 -d ./Deploy --checkonly  -l RunSpecifiedTests -r Sistema_de_Reservas_APITest.cls
    sfdx force:config:set defaultusername=charleston.santos@wingsit.com.br.sdrdevsfdx force:mdapi:deploy -u [ALIAS] -w15 -d ./Deploy

# Destructive 
    # The package need to be in the destructive folder
    --sfdx force:mdapi:deploy -d destructive -g -w 10