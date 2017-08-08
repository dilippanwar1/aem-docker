# DOCKER-VERSION 17.06.0
FROM ubuntu:16.04
MAINTAINER mgschwind

ENV AEM_WORKING_DIR /opt/aem

# Update packages and install required packages
RUN apt-get update && \
    apt-get install -y curl unzip wget tar && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get clean && \
    apt-get purge

# Prepare aem directory
RUN mkdir -p $AEM_WORKING_DIR
