FROM openjdk:8u162-jdk-slim
MAINTAINER info@hortonworks.com

ENV VERSION 2.8.0-dev.23

WORKDIR /

# Install zip
RUN apt-get update --no-install-recommends && apt-get install -y zip procps && apt-get clean && rm -rf /var/lib/apt/lists/*

# install the cloudbreak app
ADD https://cloudbreak-maven.s3.amazonaws.com/releases/com/sequenceiq/cloudbreak/$VERSION/cloudbreak-$VERSION.jar /cloudbreak.jar

# add jmx exporter
ADD jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar

# extract schema files
RUN ( unzip cloudbreak.jar schema/* -d / ) || \
    ( unzip cloudbreak.jar BOOT-INF/classes/schema/* -d /tmp/ && mv /tmp/BOOT-INF/classes/schema/ /schema/ )

# Install starter script for the Cloudbreak application
COPY bootstrap/start_cloudbreak_app.sh /
COPY bootstrap/wait_for_cloudbreak_api.sh /

ENTRYPOINT ["/start_cloudbreak_app.sh"]