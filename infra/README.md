# Verily Infrastructure

Pulumi TypeScript project for deploying the Verily backend to **AWS** or **GCP**. Secrets and configuration are managed centrally via [Pulumi ESC](https://www.pulumi.com/docs/esc/).

## Prerequisites

- Run `install:all` from the repo root (installs `pulumi`, `esc`, `pnpm`, and node dependencies)
- `PULUMI_TOKEN` set in `~/.env.dotfiles` (auto-mapped to `PULUMI_ACCESS_TOKEN` by devenv)
- AWS credentials configured (`aws configure`) or GCP credentials (`gcloud auth application-default login`)

## ESC Environments

Three ESC environments manage all configuration and secrets:

| Environment                       | Purpose                           |
| --------------------------------- | --------------------------------- |
| `ifiokjr/verily-infra/base`       | Shared non-secret config (domain) |
| `ifiokjr/verily-infra/staging`    | Staging secrets + infra sizing    |
| `ifiokjr/verily-infra/production` | Production secrets + infra sizing |

Staging and production both import `base`, so changes to `base` propagate automatically.

## Setting Up Secrets

Every secret is currently set to `CHANGE_ME`. You must replace them before deploying. Here's the full list:

### 1. Database password

Used by RDS / Cloud SQL and passed to the Serverpod container.

```bash
pulumi env set ifiokjr/verily-infra/staging dbPassword '<password>' --secret
pulumi env set ifiokjr/verily-infra/production dbPassword '<password>' --secret
```

Generate a strong password:

```bash
openssl rand -base64 32
```

### 2. Redis password

Auth token for ElastiCache / Memorystore.

```bash
pulumi env set ifiokjr/verily-infra/staging redisPassword '<password>' --secret
pulumi env set ifiokjr/verily-infra/production redisPassword '<password>' --secret
```

### 3. Serverpod service secret

Internal signing key used by Serverpod for service-to-service auth.

```bash
pulumi env set ifiokjr/verily-infra/staging serviceSecret '<secret>' --secret
pulumi env set ifiokjr/verily-infra/production serviceSecret '<secret>' --secret
```

### 4. Email hash pepper

Used by `serverpod_auth` to hash email addresses.

```bash
pulumi env set ifiokjr/verily-infra/staging emailSecretHashPepper '<pepper>' --secret
pulumi env set ifiokjr/verily-infra/production emailSecretHashPepper '<pepper>' --secret
```

### 5. JWT HMAC SHA-512 private key

Must be at least 32 characters. Used to sign authentication JWTs.

```bash
pulumi env set ifiokjr/verily-infra/staging jwtHmacSha512PrivateKey '<key-min-32-chars>' --secret
pulumi env set ifiokjr/verily-infra/production jwtHmacSha512PrivateKey '<key-min-32-chars>' --secret
```

Generate one:

```bash
openssl rand -base64 48
```

### 6. JWT refresh token hash pepper

Used to hash refresh tokens.

```bash
pulumi env set ifiokjr/verily-infra/staging jwtRefreshTokenHashPepper '<pepper>' --secret
pulumi env set ifiokjr/verily-infra/production jwtRefreshTokenHashPepper '<pepper>' --secret
```

### Quick setup script

Generate and set all secrets at once for a given environment:

```bash
ENV="staging"  # or "production"

pulumi env set ifiokjr/verily-infra/$ENV dbPassword "$(openssl rand -base64 32)" --secret
pulumi env set ifiokjr/verily-infra/$ENV redisPassword "$(openssl rand -base64 32)" --secret
pulumi env set ifiokjr/verily-infra/$ENV serviceSecret "$(openssl rand -base64 32)" --secret
pulumi env set ifiokjr/verily-infra/$ENV emailSecretHashPepper "$(openssl rand -base64 32)" --secret
pulumi env set ifiokjr/verily-infra/$ENV jwtHmacSha512PrivateKey "$(openssl rand -base64 48)" --secret
pulumi env set ifiokjr/verily-infra/$ENV jwtRefreshTokenHashPepper "$(openssl rand -base64 32)" --secret
```

### Verifying secrets

View the environment with secrets masked:

```bash
pulumi env get ifiokjr/verily-infra/staging
```

Reveal actual values (use with caution):

```bash
pulumi env open ifiokjr/verily-infra/staging
```

## Changing Non-Secret Configuration

Infrastructure sizing and cloud provider settings live in the ESC environments, not in the stack YAML files. To change them, edit the environment directly:

```bash
# Switch staging to GCP
pulumi env set ifiokjr/verily-infra/staging pulumiConfig.verily-infra:cloud gcp
pulumi env set ifiokjr/verily-infra/staging pulumiConfig.gcp:project your-project-id
pulumi env set ifiokjr/verily-infra/staging pulumiConfig.gcp:region us-central1

# Scale up production compute
pulumi env set ifiokjr/verily-infra/production pulumiConfig.verily-infra:serverCpu 2048
pulumi env set ifiokjr/verily-infra/production pulumiConfig.verily-infra:serverMemory 4096
pulumi env set ifiokjr/verily-infra/production pulumiConfig.verily-infra:maxCapacity 20
```

Or edit the full YAML definition interactively:

```bash
pulumi env edit ifiokjr/verily-infra/staging
```

## Deploying

```bash
# Preview changes (always do this first)
infra:preview staging

# Deploy
infra:up staging
```

## Generating `passwords.yaml` from ESC

For CI/CD or manual deployments where Serverpod reads `config/passwords.yaml`, you can generate it from ESC environment variables:

```bash
ENV="staging"  # or "production"

pulumi env run ifiokjr/verily-infra/$ENV -- bash -c '
cat > verily_server/config/passwords.yaml <<EOF
$ENV:
  database: "$SERVERPOD_DATABASE_PASSWORD"
  serviceSecret: "$SERVERPOD_SERVICE_SECRET"
  emailSecretHashPepper: "$SERVERPOD_EMAIL_PEPPER"
  jwtHmacSha512PrivateKey: "$SERVERPOD_JWT_KEY"
  jwtRefreshTokenHashPepper: "$SERVERPOD_JWT_REFRESH_PEPPER"
EOF
'
```

This eliminates manual secret management for deployed environments.

## Adding AWS OIDC (Optional, Recommended for CI)

Instead of storing static AWS keys in GitHub Actions, configure OIDC so Pulumi negotiates short-lived credentials automatically:

1. Create an IAM OIDC provider for Pulumi Cloud in AWS
2. Create an IAM role with the necessary deployment permissions
3. Add the provider to your ESC environment:

```bash
pulumi env edit ifiokjr/verily-infra/staging
```

Add under `values`:

```yaml
values:
  aws:
    login:
      fn::open::aws-login:
        oidc:
          roleArn: arn:aws:iam::123456789012:role/verily-pulumi-deploy
          sessionName: pulumi-deploy
          duration: 1h
  environmentVariables:
    AWS_ACCESS_KEY_ID: ${aws.login.accessKeyId}
    AWS_SECRET_ACCESS_KEY: ${aws.login.secretAccessKey}
    AWS_SESSION_TOKEN: ${aws.login.sessionToken}
```

See the [Pulumi AWS OIDC docs](https://www.pulumi.com/docs/esc/integrations/dynamic-login-credentials/aws-login/) for full setup instructions.

## Project Structure

```
infra/
  Pulumi.yaml               # Project definition
  Pulumi.staging.yaml        # Points to ESC staging environment
  Pulumi.production.yaml     # Points to ESC production environment
  package.json               # pnpm dependencies
  tsconfig.json              # TypeScript config
  src/
    index.ts                 # Entry point — routes to aws/ or gcp/
    config.ts                # Reads config (works with ESC transparently)
    types.ts                 # DeploymentOutputs interface
    aws/                     # AWS components (VPC, RDS, ECS, etc.)
    gcp/                     # GCP components (VPC, Cloud SQL, Cloud Run, etc.)
```
