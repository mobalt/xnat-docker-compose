FROM tomcat:7-jre8-alpine
MAINTAINER Matt Kelsey <kelseym@wustl.edu>

ARG XNAT_VER=1.7.6
ARG XNAT_ROOT=/data/xnat
ARG XNAT_HOME=/data/xnat/home
ARG XNAT_DATASOURCE_DRIVER=org.postgresql.Driver
ARG XNAT_DATASOURCE_URL=jdbc:postgresql://xnat-db/xnat
ARG XNAT_DATASOURCE_USERNAME=xnat
ARG XNAT_DATASOURCE_PASSWORD=xnat
ARG XNAT_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQL9Dialect
ARG TOMCAT_XNAT_FOLDER=ROOT
ARG TOMCAT_XNAT_FOLDER_PATH=${CATALINA_HOME}/webapps/${TOMCAT_XNAT_FOLDER}

RUN apk add --no-cache postgresql-client wget
RUN rm -rf ${CATALINA_HOME}/webapps/*
RUN mkdir -p \
        ${TOMCAT_XNAT_FOLDER_PATH} \
        ${XNAT_HOME}/config \
        ${XNAT_HOME}/logs \
        ${XNAT_HOME}/plugins \
        ${XNAT_HOME}/work \
        ${XNAT_ROOT}/archive \
        ${XNAT_ROOT}/build \
        ${XNAT_ROOT}/cache \
        ${XNAT_ROOT}/ftp \
        ${XNAT_ROOT}/pipeline \
        ${XNAT_ROOT}/prearchive
RUN wget --no-verbose --output-document=/tmp/xnat-web-${XNAT_VER}.war https://api.bitbucket.org/2.0/repositories/xnatdev/xnat-web/downloads/xnat-web-${XNAT_VER}.war
RUN unzip -o -d ${TOMCAT_XNAT_FOLDER_PATH} /tmp/xnat-web-${XNAT_VER}.war
RUN rm -f /tmp/xnat-web-${XNAT_VER}.war
RUN apk del wget

RUN echo "\n" \
    "datasource.driver=$XNAT_DATASOURCE_DRIVER\n" \
    "datasource.url=$XNAT_DATASOURCE_URL\n" \
    "datasource.username=$XNAT_DATASOURCE_USERNAME\n" \
    "datasource.password=$XNAT_DATASOURCE_PASSWORD\n" \
    "hibernate.dialect=$XNAT_HIBERNATE_DIALECT\n" \
    "hibernate.hbm2ddl.auto=update\n" \
    "hibernate.show_sql=false\n" \
    "hibernate.cache.use_second_level_cache=true\n" \
    "hibernate.cache.use_query_cache=true\n" \
    > $XNAT_HOME/config/xnat-conf.properties


EXPOSE 8080

ENV XNAT_HOME=${XNAT_HOME} XNAT_DATASOURCE_USERNAME=${XNAT_DATASOURCE_USERNAME} PGPASSWORD=${XNAT_DATASOURCE_PASSWORD}

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

