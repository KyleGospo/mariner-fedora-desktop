FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-silverblue:43@sha256:168d862aab89b5011cffff9efe7f3ed48d798dc33bb359d5b3469c23bf6d9f04

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    /ctx/build.sh && \
    ostree container commit

RUN bootc container lint
