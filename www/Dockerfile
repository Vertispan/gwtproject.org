ARG NGINX_TAG
FROM nginx:${NGINX_TAG}

RUN set -eux; \
    apt-get update; \
    apt-get install -y unzip rsync;

# Redirect "gwtproject.org/..." requests to "www.gwtproject.org/...". This will consume the
# BASE_DOMAIN env var automatically, a feature added in nginx 1.19. The file starts in the
# /etc/nginx/templates directory, and is copied to /etc/nginx/conf.d/ after env vars are
# applied.
ARG BASE_DOMAIN
ENV BASE_DOMAIN ${BASE_DOMAIN}
COPY www-redirect.conf.template /etc/nginx/templates/

# Replace default.conf with our own copy, which will allow for files to not end in .html,
# and redirect the client to the expected url.
COPY default.conf /etc/nginx/conf.d/
