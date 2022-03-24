ARG NGINX_TAG
FROM nginx:${NGINX_TAG}

ARG GWT_DOWNLOAD
ENV GWT_DOWNLOAD ${GWT_DOWNLOAD}

ARG GWT_VERSION


# Download latest GWT (in the future we could change this to only download the samples)
ADD ${GWT_DOWNLOAD} /gwt.zip
#
RUN set -eux; \
    apt-get update; \
    apt-get install -y unzip;

RUN unzip /gwt.zip -d /gwt; \
    mkdir -p /usr/share/nginx/html/samples/{Showcase,Mail};

RUN mv gwt/gwt-${GWT_VERSION}/samples/Showcase/war /usr/share/nginx/html/samples/Showcase/; \
    mv gwt/gwt-${GWT_VERSION}/samples/Mail/war /usr/share/nginx/html/samples/Mail/;

# Add an HTML file to redirect to the most commonly used samples, the showcase, until we \
# decide to have a proper landing/list page
ADD index.html /usr/share/nginx/html/
ADD index.html /usr/share/nginx/html/samples/