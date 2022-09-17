FROM bitnami/minideb

ARG VERSION=0.43.0
ARG PKG_NAME=frp_${VERSION}_linux_amd64

WORKDIR /frp

ADD https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_amd64.tar.gz .

RUN tar -zxf ${PKG_NAME}.tar.gz --strip-components=1 && \
    rm -rf ${PKG_NAME}.tar.gz

COPY ./frpc.ini .

EXPOSE 7000 22

ENTRYPOINT ["/frp/frpc", "-c", "/frp/frpc.ini"]
