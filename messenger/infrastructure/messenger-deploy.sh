#!/bin/bash
set -e

# 此配置需要新的提交才能更改
NODE_ENV=production
PORT=4000
JSON_BODY_LIMIT=100kb

CONSUL_SERVICE_NAME="messenger"

# 由于我们无法在一无所知的情况下查询 Consul，
# 因此每个主机都包含 Consul 主机和端口
CONSUL_HOST="${CONSUL_HOST}"
CONSUL_PORT="${CONSUL_PORT}"

# 通过从 
# 系统中提取信息进行 Postgres 数据库配置
POSTGRES_USER=$(curl -X GET "http://localhost:8500/v1/kv/messenger-db-application-user?raw=true")
PGPORT=$(curl -X GET "http://localhost:8500/v1/kv/messenger-db-port?raw=true")
PGHOST=$(curl -X GET "http://localhost:8500/v1/kv/messenger-db-host?raw=true")
# 注：切勿在真实部署中这样做。 Store passwords
# 只能在加密的密钥存储中。
PGPASSWORD=$(curl -X GET "http://localhost:8500/v1/kv/messenger-db-password-never-do-this?raw=true")

# 通过从系统中提取信息进行 RabbitMQ 配置
AMQPHOST=$(curl -X GET "http://localhost:8500/v1/kv/amqp-host?raw=true")
AMQPPORT=$(curl -X GET "http://localhost:8500/v1/kv/amqp-port?raw=true")

docker run \
  --rm \
  -d \
  -e NODE_ENV="${NODE_ENV}" \
  -e PORT="${PORT}" \
  -e JSON_BODY_LIMIT="${JSON_BODY_LIMIT}" \
  -e PGUSER="${POSTGRES_USER}" \
  -e PGPORT="${PGPORT}" \
  -e PGHOST="${PGHOST}" \
  -e PGPASSWORD="${PGPASSWORD}" \
  -e AMQPPORT="${AMQPPORT}" \
  -e AMQPHOST="${AMQPHOST}" \
  -e CONSUL_HOST="${CONSUL_HOST}" \
  -e CONSUL_PORT="${CONSUL_PORT}" \
  -e CONSUL_SERVICE_NAME="${CONSUL_SERVICE_NAME}" \
  --network mm_2023 \
  messenger