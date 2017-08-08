#!/bin/bash

#Find old checkpoints
java -Dtar.memoryMapped=true -Xms1g -Xmx1g -jar /opt/aem/oak-run.jar checkpoints /opt/aem/crx-quickstart/repository/segmentstore

#Find unreferenced checkpoints and delete them
java -Dtar.memoryMapped=true -Xms1g -Xmx1g -jar /opt/aem/oak-run.jar checkpoints /opt/aem/crx-quickstart/repository/segmentstore rm-unreferenced
java -Dtar.memoryMapped=true -Xms1g -Xmx1g -jar /opt/aem/oak-run.jar compact /opt/aem/crx-quickstart/repository/segmentstore

#Start AEM
sh -c 'cd /opt/aem/crx-quickstart/bin/ && ./quickstart'