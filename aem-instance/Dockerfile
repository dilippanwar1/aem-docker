FROM aem-base:latest
MAINTAINER mgschwind

ENV AEM_VERSION 6.1
ENV AEM_QUICKSTART_FILE cq-quickstart-6.1.jar
ENV AEM_USER aem
ENV AEM_WORKING_DIR /opt/aem
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/bin/java
ENV PATH $PATH:/usr/lib/jvm/java-8-oracle/jre/bin/java

# Download, install JAVA and remove it after installation
RUN apt-get install -y software-properties-common && \
    apt-get -y install ipython ipython3 python-psutil python-pycurl && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get -y upgrade && \
    echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y install oracle-java8-installer && \
    apt-get clean && \
    apt-get purge && \
    update-alternatives --display java
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Install utility for AEM
ADD ./resources/aemInstaller.py $AEM_WORKING_DIR/aemInstaller.py

# Add quick-start file and license properties
ADD ./resources/$AEM_QUICKSTART_FILE $AEM_WORKING_DIR/$AEM_QUICKSTART_FILE
ADD ./resources/license.properties $AEM_WORKING_DIR/license.properties

#  Add the oak-run jar and compaction.sh for compaction
ADD ./resources/oak-run-1.2.16.jar $AEM_WORKING_DIR/oak-run.jar
ADD ./resources/compaction.sh $AEM_WORKING_DIR/compaction.sh

# Create user and unpack AEM quick-start
RUN groupadd -r $AEM_USER && useradd -r -g $AEM_USER $AEM_USER -d $AEM_WORKING_DIR && \
    java -jar $AEM_WORKING_DIR/$AEM_QUICKSTART_FILE -unpack && \
    chown -R $AEM_USER:$AEM_USER $AEM_WORKING_DIR

USER $AEM_USER
WORKDIR $AEM_WORKING_DIR