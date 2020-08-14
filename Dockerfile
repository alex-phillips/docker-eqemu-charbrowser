FROM lsiobase/nginx:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CHARBROWSER_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	php7 \
    php7-gd \
    php7-mysqli && \
 echo "**** install charbrowser ****" && \
 mkdir -p /app/charbrowser && \
 if [ -z ${CHARBROWSER_RELEASE+x} ]; then \
	CHARBROWSER_RELEASE=$(curl -sX GET "https://api.github.com/repos/maudigan/charbrowser/commits/master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 	/tmp/charbrowser.tar.gz -L \
	"https://github.com/maudigan/charbrowser/archive/${CHARBROWSER_RELEASE}.tar.gz" && \
 tar xf \
 	/tmp/charbrowser.tar.gz -C \
	/app/charbrowser/ --strip-components=1 && \
 cd /app/charbrowser && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /
