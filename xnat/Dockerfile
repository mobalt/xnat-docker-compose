FROM tomcat:7-jre8-alpine
MAINTAINER Matt Kelsey <kelseym@wustl.edu>

ARG XNAT_ROOT=/data/xnat
ENV XNAT_HOME=/data/xnat/home
ARG XNAT_DATASOURCE_DRIVER=org.postgresql.Driver
ARG XNAT_DATASOURCE_URL=jdbc:postgresql://xnat-db/xnat
ARG XNAT_DATASOURCE_USERNAME=xnat
ARG XNAT_DATASOURCE_PASSWORD=xnat
ARG XNAT_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQL9Dialect
ARG TOMCAT_XNAT_FOLDER=ROOT
ARG TOMCAT_XNAT_FOLDER_PATH=${CATALINA_HOME}/webapps/${TOMCAT_XNAT_FOLDER}

RUN apk add --no-cache postgresql-client
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

RUN echo -e \
    "datasource.driver=$XNAT_DATASOURCE_DRIVER\n" \
    "datasource.url=$XNAT_DATASOURCE_URL\n" \
    "datasource.username=$XNAT_DATASOURCE_USERNAME\n" \
    "datasource.password=$XNAT_DATASOURCE_PASSWORD\n" \
    "hibernate.dialect=$XNAT_HIBERNATE_DIALECT\n" \
    "hibernate.hbm2ddl.auto=update\n" \
    "hibernate.show_sql=false\n" \
    "hibernate.cache.use_second_level_cache=true\n" \
    "hibernate.cache.use_query_cache=true" \
    > $XNAT_HOME/config/xnat-conf.properties

COPY assets/xnat-web.war /tmp/xnat-web.war
RUN unzip -o -d ${TOMCAT_XNAT_FOLDER_PATH} /tmp/xnat-web.war && rm /tmp/xnat-web.war

EXPOSE 8080
# Give it a minute to load up, then check every 30s that the server responds within 5 seconds
# If fail, you get 3 chances then restart the server
HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 \
  CMD wget -nv -t1 --spider 'http://localhost:8080/' || exit 1
  #CMD curl -f http://localhost:8080/ || exit 1

CMD ["catalina.sh", "run"]
