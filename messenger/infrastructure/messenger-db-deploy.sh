#!/bin/bash
set -e

PORT=5432
POSTGRES_USER=postgres
# 注：切勿在真实部署中这样做。 Store passwords
# 只能在加密的密钥存储中。
# 因为在本教程中我们关注其他概念，
# 因此在为了方便起见，此处这样设置密码。
POSTGRES_PASSWORD=postgres

# 迁移用户
POSTGRES_MIGRATOR_USER=messenger_migrator
# 注：同上，切勿在真实部署中这样做。
POSTGRES_MIGRATOR_PASSWORD=migrator_password

docker run \
  --rm \
  --name messenger-db-primary \
  -d \
  -v db-data:/var/lib/postgresql/data/pgdata \
  -e POSTGRES_USER="${POSTGRES_USER}" \
  -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
  -e PGPORT="${PORT}" \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  --network mm_2023 \
  postgres:15.1

echo "Register key messenger-db-port\n"
curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-port \
  -H "Content-Type: application/json" \
  -d "${PORT}"

echo "Register key messenger-db-host\n"
curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-host \
  -H "Content-Type: application/json" \
  -d 'messenger-db-primary' # 这与上面的“--name”标记相匹配
                            # 在我们的设置中，这代表主机名

echo "Register key messenger-db-application-user\n"
curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-application-user \
  -H "Content-Type: application/json" \
  -d "${POSTGRES_USER}"

curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-password-never-do-this \
  -H "Content-Type: application/json" \
  -d "${POSTGRES_PASSWORD}"

echo "Register key messenger-db-application-user\n"
curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-migrator-user \
  -H "Content-Type: application/json" \
  -d "${POSTGRES_MIGRATOR_USER}"

curl -X PUT --silent --output /dev/null --show-error --fail http://localhost:8500/v1/kv/messenger-db-migrator-password-never-do-this \
  -H "Content-Type: application/json" \
  -d "${POSTGRES_MIGRATOR_PASSWORD}"

printf "\nDone registering postgres details with Consul\n"
