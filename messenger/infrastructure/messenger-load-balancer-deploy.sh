#!/bin/bash
set -e

# 由于我们无法在一无所知的情况下查询 Consul，
# 因此每个主机都包含 Consul 主机和端口
CONSUL_HOST="${CONSUL_HOST}"
CONSUL_PORT="${CONSUL_PORT}"

docker run \
  --rm \
  -d \
  --name messenger-lb \
  -e CONSUL_URL="${CONSUL_HOST}:${CONSUL_PORT}"  \
  -p 8085:8085 \
  --network mm_2023 \
  messenger-lb