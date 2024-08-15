# See the following on glibc
# https://stackoverflow.com/a/66974607 
# https://wiki.alpinelinux.org/wiki/Running_glibc_programs

FROM alpine:3.18



# Setup build environment
WORKDIR /tmp/build
RUN apk add build-base cmake make git
RUN git clone https://github.com/4rknova/xtracer.git

# Build xtracer
WORKDIR /tmp/build/xtracer
RUN git checkout develop
RUN apk add libgomp libstdc++ libgcc openlibm alsa-lib-dev 
RUN cmake .
RUN make

# Setup image
WORKDIR /app
RUN apk add alsa-lib
RUN cp /tmp/build/xtracer/bin/xtracer_cli ./xtracer

# Cleanup
RUN apk del build-base cmake make git alsa-lib-dev
RUN rm -rf /tmp/build/

# Set entry point
ENTRYPOINT ["/app/xtracer"]
