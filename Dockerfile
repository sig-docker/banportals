FROM sigcorp/tomcat:8.5.61-5

COPY webapps/*.war /usr/local/tomcat/webapps/

ENV ojdbc_ver=19.3.0.0 \
    ojdbc_url=https://repo1.maven.org/maven2/com/oracle/database \
    tomcat_lib=/usr/local/tomcat/lib \
    JDBC_INITIAL_POOL_SIZE=10 \
    JDBC_MIN_POOL_SIZE=5 \
    JDBC_MAX_POOL_SIZE=100 \
    PROVIDER_SERVLET_DEFAULT_SOURCE_INFO=GN_PERSINFO \
    PROVIDER_SERVLET_DEFAULT_EXTERNAL_SYSTEM_ID=tcams4 \
    PROVIDER_SERVLET_DEFAULT_USER_NAME=tcams4 \
    PROVIDER_SERVLET_DEFAULT_IMMUTABLE_ID=tcams4 \
    PROVIDER_SERVLET_DEFAULT_MODE=DEFAULT \
    PROVIDER_SERVLET_DEFAULT_FOCUSED=false \
    PROVIDER_SERVLET_DEFAULT_SUBSCRIBER_ID=1234

ADD ${ojdbc_url}/jdbc/ojdbc8/${ojdbc_ver}/ojdbc8-${ojdbc_ver}.jar ${tomcat_lib}/ojdbc8.jar
ADD ${ojdbc_url}/xml/xdb/${ojdbc_ver}/xdb-${ojdbc_ver}.jar ${tomcat_lib}/xdb.jar
ADD ${ojdbc_url}/jdbc/ucp/${ojdbc_ver}/ucp-${ojdbc_ver}.jar ${tomcat_lib}/ucp.jar

SHELL ["/bin/bash", "-c"]
RUN cd /usr/local/tomcat/webapps && \
    for F in *.war; do N=$(basename $F .war); echo "Expanding $N ..."; mkdir $N; pushd $N; unzip ../$F; popd; rm -f $F; done

COPY overlay/ /

EXPOSE 8080
CMD /run.sh
