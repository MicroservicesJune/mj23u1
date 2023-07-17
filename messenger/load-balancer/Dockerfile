FROM nginx:1.23.1

ARG CONSUL_TEMPLATE_VERSION=0.30.0

# 为 Consul 集群的位置设置一个环境
# 变量。 默认情况下，它尝试解析到 consul-client:8500
# 如果 Consul 在同一主机内 
# 作为容器运行，并链接到该 NGINX 容器（又名 
# consul），就会发生这种情况。但如果我们想要解析到另一个地址，
# 也可以在容器启动时
# 覆盖这个环境变量。

ENV CONSUL_URL consul-client:8500

# 下载指定版本的 Consul 模板
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp

RUN apt-get update \
  && apt-get install -y --no-install-recommends dumb-init unzip \
  && unzip /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && rm -rf /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

COPY consul-template-config.hcl ./consul-template-config.hcl
COPY nginx.ctmpl /usr/templates/nginx.ctmpl

EXPOSE 8085

STOPSIGNAL SIGQUIT

CMD ["dumb-init", "consul-template", "-config=consul-template-config.hcl"]