# See the following on glibc
# https://stackoverflow.com/a/66974607 
# https://wiki.alpinelinux.org/wiki/Running_glibc_programs

# Stage 1: Build Xtracer
FROM alpine:3.18 AS build

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

# Stage 2: Build Xtracer server (golang)
FROM golang:1.22 AS build_service
# Assumes the go service is in the same directory as the Dockerfile
ADD . /app 
WORKDIR /app
RUN make build


# Stage 3: Runtime
FROM alpine:3.18

WORKDIR /app
RUN apk add alsa-lib
COPY --from=build /tmp/build/xtracer/bin/xtracer_cli .
COPY --from=build_service /app/xtracer_service .

ENTRYPOINT ["./xtracer_service"]
