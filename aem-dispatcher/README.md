# Dockerfile(s) for Adobe AEM 

### Dockerfiles for a complete environment for AEM

## Abstract

4. **Prep the systems for data migration**

      2. Disable workflow launchers for DAM by going to the launcher tab under workflow console url: http://host:port/libs/cq/workflow/content/console.html
         * Disable all launchers that use "DAM Update Asset" and "DAM Metadata Writeback” workflow models.
      3. Disable OSGi components to reduce overhead.
         * Install ACS Commons (on the newly installed environment): http://adobe-consulting-services.github.io/acs-aem-commons/features/osgi-disabler.html
         * Disable these OSGi components using the osgi-disabler:
         ```
         com.day.cq.dam.core.impl.event.DamEventAuditListener
         com.day.cq.replication.audit.ReplicationEventListener
         com.day.cq.wcm.core.impl.event.PageEventAuditListener
         com.day.cq.tagging.impl.TagValidatingEventListener
         com.day.cq.dam.core.impl.DamChangeEventListener
         ```
   3. (6.x to 6.x migration only) On the old/source instance, package out-of-the-box indexes that were disabled or modified and install those.  Do not install custom indexes as it is faster to install them after.  The objective here is to get any disabled indexes disabled.
   4. Go to CRXDE on the destination instance, browse to /oak:index/lucene and add a String[] property excludedPaths
      ```
      excludedPaths=[/var, /jcr:system, /etc/workflow/instances]
      ```
   5. Perform repository maintenance
      * Tar (only) - Backup the segmentstore and run offline compaction
        * 6.0 - https://docs.adobe.com/docs/en/aem/6-0/deploy/upgrade/microkernels-in-aem-6-0.html#par_title_8
        * 6.1 - https://docs.adobe.com/docs/en/aem/6-1/deploy/platform/storage-elements-in-aem-6.html#par_title_8
    6. Monitor the logs to validate when Revision GC completes successfully.
    ```
    grep VersionGarbage error*
    ```
5. **Migrate the data from the old AEM cluster node to the new one** 
   * if there is not a lot of content in the system then use packages (10GB worth or less).  Make sure to set the AC Handling mode on the package to Merge.  That way when ACLs are migrated to the new system it won't remove out-of-the-box ACLs.
   * Or use VLT service with instructions below (if you have greater than 5GB worth of content)
     1. If the destination instance is AEM6.1 or later then do the following extra preparation:
        1. Make sure ACS Commons is installed (it should have been installed)
        2. Create a new ACL packager page using the ACS Commons ACL Packager: https://adobe-consulting-services.github.io/acs-aem-commons/features/acl-packager.html
        3. Have it package all ACLs under /content, /etc, and /apps
        4. Go to the package manager and edit the package definition.  On the Advanced tab, set AC Handling mode to Merge.
     2. Install the latest vlt-rcp bundle in the destination server
      http://repo1.maven.org/maven2/org/apache/jackrabbit/vault/org.apache.jackrabbit.vault.rcp/3.1.24/
        * Instructions for vlt-rcp service here:
        https://github.com/apache/jackrabbit-filevault/blob/trunk/vault-doc/src/site/markdown/rcp.md
        
        https://github.com/apache/jackrabbit-filevault/tree/trunk/vault-rcp
        Npte: If you are using CQ5.6.1 then install 5.6.1 Service Pack 2 first as it includes all the dependency bundles required to support vlt rcp.  Download SP2 from here: https://helpx.adobe.com/experience-manager/kb/cq561-available-hotfixes.html
        * Some automated scripts to start with:
        https://github.com/apache/jackrabbit-filevault/tree/trunk/vault-rcp/src/test/resources
        * Alternatively, use VLT RCP UI here: http://adobe-consulting-services.github.io/acs-aem-tools/vlt-rcp.html
     3. Use vlt-rcp to copy everything from /etc/tags
     4. Use vlt-rcp to copy everything from /content/dam
     5. Use vlt-rcp to copy each site under /content individually as well
      * If possible run concurrent vlt copy tasks to make it faster
     6. Use vlt-rcp to copy any large content under other paths like /etc or /var that is required
     7. Install the ACL package created in the first step
     8. In CRXDe, go to the paths where the ACL package installed the ACLs.  Use the "Access Control" tab to re-order the ACLs so any that override your custom ones are at the top of the list. 
   * Or leverage the Oak migration tool, this might be faster and supports version history migration while VLT does not: http://dev.day.com/content/ddc/en/gems/deep-dive-into-aem-upgrade-process.html
  Note: Alternatively it might be possible to use grabbit: https://github.com/TWCable/grabbit to perform the data migration instead.
6. **Migrate users and groups** _(If users were not impored automatically via LDAP)_
   Package users and groups (2 separate packages) on the old system (excluding admin and anonymous OOTB users)
   1. Go to CRXDE lite app /crx/de/index.jsp and log in as admin user (on the old system)
   2. Go to "Tools" => "Query"
   3. In the bottom "Query" box enter this query to find the admin user:
     _/jcr:root/home/users//element(*,rep:User)[@rep:principalName="admin"]_
   4. Click "Execute" and copy the path of the admin user node in the results to a text file
   5. Repeat step 3 with a query for anonymous user:
     _/jcr:root/home/users//element(*,rep:User)[@rep:principalName="anonymous"]_
   6. Click "Execute" and copy the path of the anonymous user node in the results to a text file (so now you should have two paths, one for "admin" and one for "anonymous")
  

   7. Go to the "Package Manager", _http://host:port/crx/packmgr/index.jsp_, and log in as admin
   8. Create a package "users"
   9. Add a filter to the package config for /home/users
     with these exclude rules (on the /home/users filter):
   10. Build the package
   11. Download the package
   14. Add mode="merge" to the \<filter ...> tag, for example:
    
    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <workspaceFilter version="1.0">
      <filter root="/home/users" mode="merge">
        <exclude pattern="/home/users/.*/.tokens"/>
        <exclude pattern="/home/users/Q/QY5FIMXeQIbGpwZtQ3Dv"/>
        <exclude pattern="/home/users/K/Kj1406Qo9IDODc_nk5Ib"/>
        <exclude pattern="/home/users/a/admin"/>
        <exclude pattern="/home/users/a/anonymous"/>
        <exclude pattern="/home/users/system"/>
        <exclude pattern="/home/users/geometrixx"/>
        <exclude pattern="/home/users/media"/>
        <exclude pattern="/home/users/projects"/>
        <exclude pattern="/home/users/mac"/>
      </filter>
    </workspaceFilter>
    ```
   15. Re-zip the modified package contents so it includes the change
   16. Create a "groups" package that contains a filter rule /home/groups
   17. Repeat steps 11-14 for the groups package
  
   18. Install the users package on the new system
   19. Install the groups package on the new system
7. **Install the application and other required files**
   1. Install the application including all configurations
   2. Package the replication agents from production, install the package on the new instance and disable the agents
8. **Install custom lucene property indexes**, make sure all indexes have been applied and fully indexed
9. **Do testing (functional and load testing)** to validate that the application works perfectly
10. **Create package using a search for pages that changed since the copy was done**
    1. Install either one of these tools for packaging the changed content:     
       * http://adobe-consulting-services.github.io/acs-aem-commons/features/query-packager.html
       * http://www.wemblog.com/2011/11/how-to-create-package-based-on-xpath-in.html
    2. Create package using a search for tags that changed since the copy was done.
     Use this query for tags (but change the date):
     ```
     //element(*, cq:Tag)[@jcr:created > xs:dateTime('2015-09-16T00:00:00.000-05:00')]
     ```
    3. Create package using a search for assets that changed since the copy was done.
     Use this query for assets (but change the date):
     ```
     //element(*, dam:AssetContent)[@jcr:lastModified > xs:dateTime('2015-09-16T00:00:00.000-05:00')]
     ```
    4. Create package using a search for pages that changed since the copy was done.
     Use this query for pages (but change the date):
     ```
     //element(*,cq:PageContent)[@cq:lastModified >= xs:dateTime('2015-09-16T00:00:00.000-05:00')]
     ```
    5. Install all the packages to the AEM instance (install the tags first, then the assets then pages)
    6. Account for any other data that might of changed (for example, new users added to the system or other content)
11. **Remove the disabling of OSGi component** config that we did in step 3 above to re-allow audit trails and tag validation.
12. **_(Mongo to Mongo only)_ Remove another replica from the original mongo cluster**, wipe out the database there and instead add it to the new replica from step A.
    1. Remove the replica node from the set: http://docs.mongodb.org/master/tutorial/remove-replica-set-member
    2. Validate that no other nodes in the set consider that node to be part of the set anymore
    3. Drop the aem database on that node http://docs.mongodb.org/manual/reference/command/dropDatabase/
    4. Add the node as a replica http://docs.mongodb.org/master/tutorial/expand-replica-set/

15. **Perform repository maintenance**
    * Tar (only) - Backup the segmentstore and run offline compaction
      * 6.0 - https://docs.adobe.com/docs/en/aem/6-0/deploy/upgrade/microkernels-in-aem-6-0.html#par_title_8
      * 6.1 - https://docs.adobe.com/docs/en/aem/6-1/deploy/platform/storage-elements-in-aem-6.html#par_title_8
16. **Take a short outage window and do the cut over to the environment** by simply clearing the dispatcher cache and pointing it to the new environment.  If no dispatcher is used, then point the load balancer to the new AEM environment instead of the old.

