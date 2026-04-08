FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/silverblue:45@sha256:db517880c700089946219a180fa7224b3169f2ce3353954700d742a1e9274dfb

RUN rpm-ostree install dnf5 dnf5-plugins

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    /ctx/build.sh && \
    ostree container commit
