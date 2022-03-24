ARG NGINX_TAG
FROM nginx:${NGINX_TAG}

# Build the markdown and styles to HTML, note that this section in the future
# will probably just download pre-compiled static content
ADD https://github.com/gwtproject/gwt-site/archive/refs/heads/master.zip /

RUN set -eux; \
    apt-get update; \
    apt-get install -y maven unzip;

RUN set -eux; \
    unzip master.zip; \
    cd gwt-site-master; \
    mvn install -Pgrunt;

# Build the GWT-based JS that enhances the page. Likewise, in the future this
# will be downloaded from pre-compiled content
RUN set -eux; \
    apt-get install -y git

RUN set -eux; \
    git clone https://gwt.googlesource.com/gwt-site-webapp

ADD https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u322b06.tar.gz /openjdk.tar.gz

RUN set -eux; \
    tar xf openjdk.tar.gz; \
    export JAVA_HOME=/jdk8u322-b06; \
    cd gwt-site-webapp; \
    mvn package;

RUN mv /gwt-site-master/target/generated-site/* /usr/share/nginx/html/

RUN mv /gwt-site-webapp/target/gwt-site-webapp-2.0-SNAPSHOT/gwtproject /gwt-site-webapp/target/gwt-site-webapp-2.0-SNAPSHOT/src /usr/share/nginx/html/
