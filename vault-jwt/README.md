## Hashicorp Vault JWT example

### Подготовка БД

- установим postgresql из чарта

```
helm install postgresql charts/postgresql --set global.postgresql.auth.username="todoapp_user" --set global.postgresql.auth.password="todoapp_password" --set global.postgresql.auth.database="todoapp_db" --set primary.persistence.size="2Gi" --namespace todoapp --wait --timeout 300s --atomic --debug
```

### Подготовка Vault

- добавим секреты в Vault

```
vault kv put secret/todoapp/production/db db_name='todoapp_db' db_user='todoapp_user' db_password='todoapp_password'
```

- добавим метод в Vault

```
vault auth enable jwt
Success! Enabled jwt auth method at: jwt/
```

- создадим политику в Vault

```
vault policy write todoapp-production - <<EOF
# Policy name: todoapp-production
#
# Read-only permission on 'secret/todoapp/production/*' path
path "secret/data/todoapp/production/*" {
  capabilities = [ "read" ]
}
EOF
```

- создадим правила в Vault
```
vault write auth/jwt/role/todoapp-production - <<EOF
{
  "role_type": "jwt",
  "policies": ["todoapp-production"],
  "token_explicit_max_ttl": 60,
  "user_claim": "user_email",
  "bound_claims_type": "glob",
  "bound_claims": {
    "project_id": "55261475",
    "ref_protected": "true",
    "ref_type": "branch",
    "ref": "main"
  }
}
EOF
```

где project_id идентификатор нашего проекта в gitlab

- добавим конфиг Vault

```
vault write auth/jwt/config \
  oidc_discovery_url="https://gitlab.com" \
  bound_issuer="https://gitlab.com"
```

### Подготовка кластера

- создадим неймспейс для приложения

```
kubectl create ns todoapp
```

- добавим deploy token с gitlab (Settings - Repository - Deploy tokens - Add token)

```
kubectl create secret docker-registry regcred -n todoapp --docker-server registry.gitlab.com --docker-email 'user@domain.ru' --docker-username 'gitlab+deploy-token-XXXXXXXX' --docker-password 'gldt-XXXXXXXX-XXXXXXXXX'
```

- добавим в кластер gitlab-agent (Operate - Kubernetes clusters - Agent - Connect a cluster)

```
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install primary-agent gitlab/gitlab-agent \
    --namespace todoapp \
    --set image.tag=v17.0.0-rc1 \
    --set config.token=glagent-XXXXXXXXXXXXXXXXXXXXXXXXXX \
    --set config.kasAddress=wss://kas.gitlab.com
```