FROM aem-instance:latest
MAINTAINER mgschwind

ENV CQ_RUNMODE author
ENV CQ_PORT 4502
ENV CQ_SSL_PORT 5502
ENV DEBUG_PORT 30303
ENV PUBLISH_HOST publish
ENV JMX_PORT 4602
ENV DOCKER_IP 10.7.5.90

ADD resources/postInstallHook.py $AEM_WORKING_DIR/postInstallHook.py
ADD resources/packagelist.txt $AEM_WORKING_DIR/packagelist.txt
ADD resources/packages/*.zip $AEM_WORKING_DIR/packages/

# Add customised log file, to print the logging to standard out.
RUN mv ./$AEM_QUICKSTART_FILE $AEM_WORKING_DIR/cq-author-4502.jar
ADD resources/org.apache.sling.commons.log.LogManager.config $AEM_WORKING_DIR/org.apache.sling.commons.log.LogManager.config
ADD resources/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.cfg $AEM_WORKING_DIR/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.cfg

# Installs AEM
WORKDIR $AEM_WORKING_DIR
RUN ["python","aemInstaller.py","-i","cq-author-4502.jar","-r","author","-p","4502"]

WORKDIR $AEM_WORKING_DIR/crx-quickstart/bin
RUN mv quickstart quickstart.original
ADD ./resources/quickstart $AEM_WORKING_DIR/crx-quickstart/bin/quickstart
USER $AEM_USER
WORKDIR $AEM_WORKING_DIR
RUN chmod +x $AEM_WORKING_DIR/compaction.sh

EXPOSE $CQ_PORT
EXPOSE $CQ_SSL_PORT
EXPOSE $DEBUG_PORT
EXPOSE $JMX_PORT

ENTRYPOINT ["/opt/aem/compaction.sh"]
