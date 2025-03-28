FROM ghcr.io/ublue-os/silverblue-main:latest

COPY build.sh /tmp/build.sh

RUN git submodule init
RUN git submodule update

COPY rootcopy /
COPY onboarding/rootcopy /
COPY wallpaper-cycler/rootcopy /

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit

