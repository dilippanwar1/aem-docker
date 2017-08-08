#!/bin/bash
#####################################################################################
# Installer to help clone environments for testing
#
####################################################################################
# for entry in $(cat ./publish.txt); do
# 	./aem-pkmgr.sh upload-install -h "http://localhost:4503" -pk "$entry"
# done
#
# for entry in $(cat ./author.txt); do
# 	./aem-pkmgr.sh upload-install -h "http://localhost:4502" -pk "$entry"
# done

curl -u admin:admin -X POST 'http://localhost:4502' --data '_charset_=utf-8&edit=%2Fetc%2Fworkflow%2Flauncher%2Fconfig%2Fupdate_asset_create&%3Astatus=browser&eventType=1&nodetype=nt%3Afile&glob=%2Fcontent%2Fdam(%2F.*%2F)renditions%2Foriginal&condition=&workflow=%2Fetc%2Fworkflow%2Fmodels%2Fdam%2Fupdate_asset%2Fjcr%3Acontent%2Fmodel&description=&enabled=false&excludeList=&runModes=author'
# curl -u admin:admin -Fjcr:primaryType=sling:Folder http://localhost:4502/content/clubcar
# curl -u admin:admin -Fjcr:primaryType=sling:Folder http://localhost:4502/content/dam/cc-corp
# curl -u admin:admin -Fjcr:primaryType=sling:Folder http://localhost:4503/content/clubcar
# curl -u admin:admin -Fjcr:primaryType=sling:Folder http://localhost:4503/content/dam/cc-corp

/Users/mgschwind/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4502/crx/-/jcr:root/content/clubcar http://admin:admin@localhost:4502/crx/-/jcr:root/content/clubcar 2> author-pages.log&
/Users/mgschwind/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4503/crx/-/jcr:root/content/clubcar http://admin:admin@localhost:4503/crx/-/jcr:root/content/clubcar 2> publish-pages.log&
/Users/mgschwind/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4502/crx/-/jcr:root/content/dam/cc-corp http://admin:admin@localhost:4502/crx/-/jcr:root/content/dam/cc-corp 2> author-dam.log&
/Users/mgschwind/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4503/crx/-/jcr:root/content/dam/cc-corp http://admin:admin@localhost:4503/crx/-/jcr:root/content/dam/cc-corp 2> publish-dam.log&

#curl -u admin:admin -X POST 'http://localhost:4502' --data '_charset_=utf-8&edit=%2Fetc%2Fworkflow%2Flauncher%2Fconfig%2Fupdate_asset_create&%3Astatus=browser&eventType=1&nodetype=nt%3Afile&glob=%2Fcontent%2Fdam(%2F.*%2F)renditions%2Foriginal&condition=&workflow=%2Fetc%2Fworkflow%2Fmodels%2Fdam%2Fupdate_asset%2Fjcr%3Acontent%2Fmodel&description=&enabled=true&excludeList=&runModes=author'
