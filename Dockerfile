# =============================================================================
# Arquivo: Dockerfile
# Descrição: APISIX standalone (data_plane + yaml) — sem etcd, 1 container.
#
# Portas:
#   9080 → tráfego HTTP (data plane / rotas)
#   7085 → Status API (healthcheck)
#          GET /status        → {"status":"ok"}
#          GET /status/ready  → {"status":"ok"} quando todos workers prontos
# =============================================================================

FROM apache/apisix:latest

LABEL maintainer="devops@meu-projeto.com" \
      description="Apache APISIX standalone — sem etcd, deploy gratuito no Render" \
      version="3.0.1"

COPY apisix_conf/config.yaml /usr/local/apisix/conf/config.yaml
COPY apisix_conf/apisix.yaml /usr/local/apisix/conf/apisix.yaml

EXPOSE 9080 7085 9443

