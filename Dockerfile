FROM ivonet/alpine-dev:3.11.3 as builder

ENV FFMPEG_VERSION=4.2.2

RUN DIR=$(mktemp -d) \
 && cd ${DIR} \
 && curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxf - -C . \
 && cd ffmpeg-${FFMPEG_VERSION} \
 && ./configure \
        --disable-doc \
        --disable-debug \
        --disable-shared \
        --enable-avfilter \
        --enable-avresample \
        --enable-gnutls \
        --enable-gpl \
        --enable-libass \
        --enable-libfdk-aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-librtmp \
        --enable-libtheora \
        --enable-libv4l2 \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libwebp \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libxcb \
        --enable-libxvid \
        --enable-nonfree \
        --enable-pic \
        --enable-pthreads \
        --enable-postproc \
        --enable-static \
        --enable-version3 \
        --enable-vaapi \
        --prefix=/usr \
 && make -j4 \
 && make install \
 && gcc -o tools/qt-faststart $CFLAGS tools/qt-faststart.c \
 && install -D -m755 tools/qt-faststart /usr/bin/qt-faststart \
 && make distclean \
 && cd ${DIR} \
 && wget http://www.dechifro.org/dcraw/dcraw.c \
 && gcc -o dcraw -O4 dcraw.c -lm -ljasper -ljpeg -llcms2 \
 && cp dcraw /usr/bin/dcraw \
 && chmod +x /usr/bin/dcraw

FROM alpine:3.11.3
LABEL maintainer="Ivo Woltring - @ivonet"

ARG VERSION=1.0

LABEL org.label-schema.name="ffmpeg tools" \
    org.label-schema.description="DLNA Serviio 2.0" \
    org.label-schema.url="https://ivonet.nl/" \
    org.label-schema.vcs-url="https://github.com/ivonet/docker-ffmpeg" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    maintainer="Ivonet - @ivonet"

ENV JAVA_HOME="/usr"

COPY --from=builder /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=builder /usr/bin/ffprobe /usr/bin/ffprobe
COPY --from=builder /usr/bin/dcraw /usr/bin/dcraw
COPY --from=builder /usr/bin/qt-faststart /usr/bin/qt-faststart
COPY --from=builder /usr/lib/lib* /usr/lib/
COPY --from=builder /lib/libuuid* /lib/

CMD ["/usr/bin/ffmpeg"]

