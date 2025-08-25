FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/silverblue:43@sha256:d71d5fe2bc14aee20a385b04b6a944feb8c70d8f14f75679a00d57251efacec4

RUN rpm-ostree install dnf5 dnf5-plugins

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    /ctx/build.sh && \
    ostree container commit
