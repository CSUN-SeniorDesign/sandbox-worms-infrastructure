FROM alpine:3.8
ENV HUGO_VERSION 0.49
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit 
ENV HUGO_BUILD_DIR /hugo/public
ENV HUGO_SRC /hugo

RUN apk add --no-cache apache2=2.4.34-r0  \
    git=2.18.0-r0 \
		bash \
		build-base \
		ca-certificates \
		curl \
		git \
		libcurl \
    #hugo=0.39-r0 \
    libc6-compat \
    libxml2-dev \
    libxslt-dev \
    openssh \
    rsync && \
    apk add --update ca-certificates bash curl wget && \
    apk upgrade
RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar xzf ${HUGO_BINARY}.tar.gz && \
    mv hugo /usr/bin/hugo && \
    rm ${HUGO_BINARY}.tar.gz LICENSE README.md && \
    rm -rf /tmp/* /var/cache/apk/*

RUN mkdir /hugo/ && \
    git clone https://github.com/CSUN-SeniorDesign/sandbox-worms-blog.git /hugo/

RUN hugo -F -v --config ${HUGO_SRC}/config.toml -s ${HUGO_SRC}/ --baseURL="https://www.sandboxworms.me" -d  ${HUGO_BUILD_DIR} --enableGitInfo --verbose --debug


#ENV HUGO_VERSION 0.25 
#ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit 
#ENV PATH=/usr/local/hugo:${PATH}

#RUN set -x \ so i doesnt get printed on the screen
#    && apk upgrade --update \
#    && apk add --update ca-certificates bash curl wget \
#    && rm -rf /var/cache/apk/* \
#    && mkdir /usr/local/hugo \
#    && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz -O /usr/local/hugo/${HUGO_BINARY}.tar.gz \
#    && tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
#  && rm /usr/local/hugo/${HUGO_BINARY}.tar.gz \
#    && rm -rf /tmp/* /var/cache/apk/* 
