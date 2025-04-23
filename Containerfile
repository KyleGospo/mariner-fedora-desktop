FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/silverblue:40

RUN rpm-ostree install dnf5 && \
    dnf5 install dnf5-command(config-manager)

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    /ctx/build.sh && \
    ostree container commit
