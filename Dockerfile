ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Johannes Denninger"

COPY ./requirements.txt ./entrypoint.sh /tmp/

ARG W3AF_BRANCH=master
ENV PATH /opt/w3af:/app:$PATH

RUN set -euxo pipefail ;\
    sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories ;\
    apk add --no-cache --update python2 py2-pip ca-certificates dumb-init su-exec nodejs-current libxml2 libxslt openssl git sqlite-libs ;\
    apk add --no-cache --update --virtual .build-deps build-base python2-dev py-setuptools libffi-dev openssl-dev libxml2-dev py2-pillow libxslt-dev npm ;\
    pip install --no-cache --upgrade pip ;\
    pip install --no-cache -r /tmp/requirements.txt ;\
    npm install --only=prod --no-progress --quiet -g retire && npm cache clean --force ;\
    git clone -b ${W3AF_BRANCH} --depth 1 https://github.com/andresriancho/w3af.git /opt/w3af/ ;\
    git clone --depth 1 https://github.com/geekspeed/w3af_asm.git /tmp/w3af_asm/ ;\
    cp /tmp/w3af_asm/xml_f5asm.py /opt/w3af/w3af/plugins/output/ && rm -rf /tmp/w3af_asm/;\
    cd /opt/w3af/ && python -m compileall -q . ;\
    apk del --no-cache --purge .build-deps ;\
    rm -rf /var/cache/apk/* ;\
    rm -rf /root/.cache/ ;\
    rm -f /tmp/requirements.txt ;\
    mv /tmp/entrypoint.sh /usr/local/bin && chmod +x /usr/local/bin/entrypoint.sh ;\
    adduser -s /bin/ash -u 1000 -D -h /app usr-w3af ;\
    chmod -R 755 /opt/w3af

WORKDIR /app

ENTRYPOINT [ "/usr/bin/dumb-init","--","entrypoint.sh" ]

CMD [ "/bin/sh" ]