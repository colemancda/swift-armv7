# Should only run on Armv7 platform
FROM debian:bullseye

# Install runtime libraries and development headers
COPY ./runtime/install-dependencies.sh /tmp/
RUN /bin/bash /tmp/install-dependencies.sh

# Install Swift runtime
COPY ./build/swift-armv7.tar.gz /tmp/swift-armv7.tar.gz
RUN cd /tmp/ \
    && tar -xf /tmp/swift-armv7.tar.gz \
    && cp -rf /tmp/usr/* /usr/ \
    && rm -rf /tmp/usr
