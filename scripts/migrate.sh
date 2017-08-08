#!/bin/bash
####################################################################################
# Steps to clone or migrate environment for testing
#
####################################################################################

## Step 1 Install
step-one () {
  echo "DEBUG-SCRIPT: Starting Step 1"
  echo "-------------------------------------"
	echo ""
	# Script calls
	${INSTALL} install-package-dir ${ACS_INSTALL}
  echo "DEBUG-SCRIPT: Ending Step 1"
	echo "-------------------------------------"
	echo ""
}

## Step 2 Install
step-six () {
  echo "DEBUG-SCRIPT: Starting Step 6 ${CC_DAM_INSTALL}"
  echo "-------------------------------------"
	echo ""
	# Script calls
  ~/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -n -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4502/crx/-/jcr:root/content/clubcar/us/en  http://admin:admin@localhost:4502/crx/-/jcr:root/content/clubcar/us/en 2> author-pages.log &
  ~/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4503/crx/-/jcr:root/content/clubcar/us/en  http://admin:admin@localhost:4503/crx/-/jcr:root/content/clubcar/us/en 2> publish-pages.log &
  ~/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -n -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4502/crx/-/jcr:root/content/dam/cc-corp http://admin:admin@localhost:4502/crx/-/jcr:root/content/dam/cc-corp 2> author-dam.log &
  ~/AEM/vault-cli-3.1.16/bin/vlt rcp -r -u -b 1000 http://admin:Culbur50@ir-dev-2.3sharecorp.com:4503/crx/-/jcr:root/content/dam/cc-corp http://admin:admin@localhost:4503/crx/-/jcr:root/content/dam/cc-corp 2> publish-dam.log &
  echo "DEBUG: Ending Step 6"
	echo "-------------------------------------"
	echo ""
}

## Step 6 Install
step-six () {
  echo "DEBUG-SCRIPT: Starting Step 6 ${CC_DAM_INSTALL}"
  echo "-------------------------------------"
	echo ""
	# Script calls
  ./aem-pkmgr.sh upload -h http://localhost:4502 -pk ${CC_DAM_INSTALL}/clubcar.content.dam.limited.ir-dev-2.zip
  echo "DEBUG-SCRIPT: Ending Step 6"
	echo "-------------------------------------"
	echo ""
}

### Workflow Management
###

# Disabled Dam Workflow
```bash
  curl -u admin:admin -X POST 'http://127.0.0.1:4502/libs/cq/workflow/launcher' --data '_charset_=utf-8&edit=%2Fetc%2Fworkflow%2Flauncher%2Fconfig%2Fupdate_asset_create&%3Astatus=browser&eventType=1&nodetype=nt%3Afile&glob=%2Fcontent%2Fdam(%2F.*%2F)renditions%2Foriginal&condition=&workflow=%2Fetc%2Fworkflow%2Fmodels%2Fdam%2Fupdate_asset%2Fjcr%3Acontent%2Fmodel&description=&enabled=false&excludeList=&runModes=author'
```
# Enable Dam workflow
```bash
  curl -u admin:admin -X POST 'http://127.0.0.1:4502/libs/cq/workflow/launcher' --data '_charset_=utf-8&edit=%2Fetc%2Fworkflow%2Flauncher%2Fconfig%2Fupdate_asset_create&%3Astatus=browser&eventType=1&nodetype=nt%3Afile&glob=%2Fcontent%2Fdam(%2F.*%2F)renditions%2Foriginal&condition=&workflow=%2Fetc%2Fworkflow%2Fmodels%2Fdam%2Fupdate_asset%2Fjcr%3Acontent%2Fmodel&description=&enabled=true&excludeList=&runModes=author'
```

### Content Management
###

# Create a folder in /apps called myFolder:
```bash
  curl -u admin:admin -Fjcr:primaryType=sling:Folder http://localhost:4502/content/dam/myFolder
```

# Copy the folder /content/dam/geometrixx/icons/ (and its contents) to /content/dam/myFolder
```bash
  curl -u admin:admin -F:operation=copy -F:dest=/content/dam/myFolder/ http://localhost:4502/content/dam/geometrixx/icons/
```

# Update Title Attribute
```bash
  curl -u admin:admin -Fjcr:title="Test" http://localhost:4502/content/geometrixx-outdoors/en/jcr%3Acontent | grep 'id="Message"' | sed 's/.*<div id="Message">\([^<]*\)<.*/\1/'
```

# Move Content
```bash
  curl -u admin:admin \
      --header "Referer:http://localhost:4502/" \
      -F":diff=>/apps/test1/test2 : /apps/test2/test2" http://localhost:4502/crx/server/crx.default/jcr%3aroot
```

# Activate Page
```bash
  curl -u admin:admin -X POST -F path="/content/path/to/page" -F cmd="activate" http://localhost:4502/bin/replicate.json
```

# Deactivate Page
```bash
  curl -u admin:admin -X POST -F path="/content/path/to/page" -F cmd="deactivate" http://localhost:4502/bin/replicate.json
```

# Tree Activation
```bash
  curl -u admin:admin -F cmd=activate -F ignoredeactivated=true -F onlymodified=true \
      -F path=/content/geometrixx http://localhost:4502/etc/replication/treeactivation.html
```

# Copy page
```bash
  curl -u admin:admin -F:operation=copy -F:dest=/path/to/destination http://localhost:4502/path/to/source
```

# Clear Audit
```bash
  curl -u admin:admin -F":operation=delete" http://localhost:4502/var/audit/com.day.cq.replication
  curl -u admin:admin -F":operation=delete" http://localhost:4502/var/audit/com.day.cq.wcm.core.page
```

# Copy page
```bash
  curl -u admin:admin -F:operation=copy -F:dest=/path/to/destination http://localhost:4502/path/to/source
```

### Bundle Management
###

# Uninstall a bundle
```bash
  curl -u admin:admin -daction=uninstall http://localhost:4502/system/console/bundles/name-of-bundle
```

# Install a bundle
```bash
  curl -u admin:admin -F action=install -F bundlestartlevel=20 -F bundlefile=@name-of-jar.jar http://localhost:4502/system/console/bundles
```

# Build a bundle
```bash
  curl -u admin:admin -F"bundleHome=/apps/centrica/bundles/name of bundle" \
      -F descriptor=/apps/centrica/bundles/com.centrica.cq.wcm.core-bundle/name_of_bundle.bnd http://localhost:4502/libs/crxde/build
```

# Stop a bundle
```bash
  curl -u admin:admin http://localhost:4502/system/console/bundles/org.apache.sling.scripting.jsp -F action=stop
```

# Start a bundle
```bash
  curl -u admin:admin http://localhost:4502/system/console/bundles/org.apache.sling.scripting.jsp -F action=start
```
# Delete a node (hierarchy) - (this will delete any directory / node / site)
```bash
  curl -u admin:admin -X DELETE http://localhost:4502/path/to/node/jcr:content/nodeName
```

# Get Bundle Config
```bash
  curl -u admin:admin http://localhost:4502/system/console/bundles/org.apache.jackrabbit.oak-core.json
```

### Package Management
###

# List Commands
```bash
  curl -u admin:admin  http://localhost:4502/crx/packmgr/service.jsp?cmd=help
```

# Check If Package Exist
```bash
  curl -u admin:admin -s -I -w %{http_code} http://localhost:4502/etc/packages/package/group/path/name_of_package.zip
```

# List Packages
```bash
  #XML
  curl -u admin:admin http://localhost:4502/crx/packmgr/service.jsp?cmd=ls
  #JSON
  curl -u admin:admin http://localhost:4502/crx/packmgr/list.jsp
```

# Upload a package AND install
```bash
  curl -u admin:admin -F file=@"name of zip file" -F name="name of package" \
      -F force=true -F install=true http://localhost:4502/crx/packmgr/service.jsp
```

# Upload a package DO NOT install
```bash
  curl -u admin:admin -F file=@"name of zip file" -F name="name of package" \
      -F force=true -F install=false http://localhost:4502/crx/packmgr/service.jsp
```

# Rebuild an existing package in CQ
```bash
  curl -u admin:admin -X POST http://localhost:4502/crx/packmgr/service/.json/etc/packages/name_of_package.zip?cmd=build
```

# Download (the package)
```bash
  curl -u admin:admin http://localhost:4502/etc/packages/export/name_of_package.zip > name_of_package.zip
```

# Upload a new package
```bash
  curl -u admin:admin -F package=@"name_of_package.zip" http://localhost:4502/crx/packmgr/service/.json/?cmd=upload
```

# Install an existing package
```bash
  curl -u admin:admin -X POST http://localhost:4502/crx/packmgr/service/.json/etc/packages/export/name-of-package?cmd=install
```

# Delete Package
```bash
  curl -u admin:admin -X POST -F cmd=delete http://localhost:4502/crx/packmgr/service/script.html/etc/packages/package-group/package-name.zip
```

##
# Parse the command line arguments from the parameters
#
#
while [ "$1" != "" ]; do
	case $1 in
		-s1 | --one ) ACTION="one"
		;;
		-s2 | --two ) ACTION="two"
		;;
		* ) exit 1
	esac
	shift
done


##
# Perform the actions
#
#
if [ "$ACTION" = "one" ]; then
	step-one
elif [ "$ACTION" = "two" ] ; then
	step-two
fi
