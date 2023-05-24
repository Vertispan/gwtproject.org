# Simple webhook image with no nearly no tools in it
FROM almir/webhook

# Add curl to our image
RUN set -eux; \
    apk add curl; \
    rm -rf /var/cache/apk/*
