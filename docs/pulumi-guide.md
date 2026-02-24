# Pulumi Infrastructure Guide

## Overview

The `infra/` directory contains the Pulumi TypeScript project that can deploy Verily's backend to either **AWS** or **GCP**. The cloud provider is selected per-stack via configuration, and both providers share the same project and entry point.

## Quick Start

```bash
# 1. Install all dependencies (includes pnpm install for infra/)
install:all

# 2. Log in to Pulumi (uses PULUMI_TOKEN from ~/.env.dotfiles)
pulumi login

# 3. Initialize a stack
cd infra
pulumi stack init staging

# 4. Set secrets in ESC (see infra/README.md for the full list)
pulumi env set ifiokjr/verily-infra/staging dbPassword '<password>' --secret

# 5. Preview changes
infra:preview staging

# 6. Deploy
infra:up staging
```

## Secrets Management (Pulumi ESC)

All secrets and configuration are managed via Pulumi ESC environments — not in the stack YAML files. The stack files only reference an ESC environment:

```yaml
# Pulumi.staging.yaml
environment:
  - verily-infra/staging
```

Three layered environments:

| Environment               | Imports | Contains                    |
| ------------------------- | ------- | --------------------------- |
| `verily-infra/base`       | —       | Shared config (domain)      |
| `verily-infra/staging`    | base    | Staging secrets + sizing    |
| `verily-infra/production` | base    | Production secrets + sizing |

See [`infra/README.md`](../infra/README.md) for step-by-step instructions on setting every required secret.

## Project Structure

```
infra/
  Pulumi.yaml               # Project definition
  Pulumi.staging.yaml        # Staging stack config
  Pulumi.production.yaml     # Production stack config
  package.json               # pnpm dependencies
  tsconfig.json              # TypeScript configuration
  src/
    index.ts                 # Entry point — routes to aws/ or gcp/
    config.ts                # Shared configuration reader
    types.ts                 # DeploymentOutputs interface
    aws/
      index.ts               # AWS orchestrator
      network.ts             # VPC, subnets, NAT
      database.ts            # RDS PostgreSQL 16 + PostGIS
      cache.ts               # ElastiCache Redis
      compute.ts             # ECS Fargate + ECR + auto-scaling
      storage.ts             # S3 + CloudFront
      dns.ts                 # Route 53 + ACM certificates
    gcp/
      index.ts               # GCP orchestrator
      network.ts             # VPC, Cloud NAT, firewall
      database.ts            # Cloud SQL PostgreSQL 16
      cache.ts               # Memorystore Redis
      compute.ts             # Cloud Run + Artifact Registry
      storage.ts             # Cloud Storage
      dns.ts                 # Cloud DNS + managed SSL
```

## Configuration Reference

All config below is set via ESC environments, not stack YAML files. Edit with `pulumi env edit ifiokjr/verily-infra/<env>` or `pulumi env set`.

### Pulumi config keys (under `pulumiConfig` in ESC)

| Key                               | Description                         | Required                        |
| --------------------------------- | ----------------------------------- | ------------------------------- |
| `verily-infra:cloud`              | `"aws"` or `"gcp"`                  | Yes                             |
| `verily-infra:environment`        | `"staging"` or `"production"`       | Yes                             |
| `verily-infra:domain`             | Base domain (e.g. `verily.fun`)     | Yes (in base)                   |
| `verily-infra:dbPassword`         | Database password (from ESC secret) | Yes                             |
| `verily-infra:redisPassword`      | Redis auth token (from ESC secret)  | No                              |
| `verily-infra:dbInstanceClass`    | AWS RDS instance class              | No (default: `db.t4g.medium`)   |
| `verily-infra:dbAllocatedStorage` | Database storage in GB              | No (default: `20`)              |
| `verily-infra:redisNodeType`      | AWS ElastiCache node type           | No (default: `cache.t4g.micro`) |
| `verily-infra:serverCpu`          | CPU units (256, 512, 1024, etc.)    | No (default: `512`)             |
| `verily-infra:serverMemory`       | Memory in MB                        | No (default: `1024`)            |
| `verily-infra:minCapacity`        | Minimum server instances            | No (default: `1`)               |
| `verily-infra:maxCapacity`        | Maximum server instances            | No (default: `4`)               |
| `aws:region`                      | AWS region                          | No (default: `us-west-2`)       |
| `gcp:project`                     | GCP project ID                      | Yes (if cloud=gcp)              |
| `gcp:region`                      | GCP region                          | No (default: `us-central1`)     |

### ESC secret keys (top-level in ESC environment)

| Key                         | Description                           |
| --------------------------- | ------------------------------------- |
| `dbPassword`                | PostgreSQL password                   |
| `redisPassword`             | Redis auth token                      |
| `serviceSecret`             | Serverpod service-to-service auth key |
| `emailSecretHashPepper`     | Email hashing pepper                  |
| `jwtHmacSha512PrivateKey`   | JWT signing key (min 32 chars)        |
| `jwtRefreshTokenHashPepper` | Refresh token hashing pepper          |

## Devenv Scripts

| Script                  | Description                  |
| ----------------------- | ---------------------------- |
| `pulumi`                | Run the Pulumi CLI           |
| `esc`                   | Run the Pulumi ESC CLI       |
| `pnpm`                  | Run the pnpm package manager |
| `install:infra`         | Install infra dependencies   |
| `infra:preview <stack>` | Preview changes for a stack  |
| `infra:up <stack>`      | Deploy changes to a stack    |

## Deploying the Server Image

The root `Dockerfile` builds the Serverpod server as a native executable. Both AWS (ECR + ECS Fargate) and GCP (Artifact Registry + Cloud Run) deployments use this image.

```bash
# Build locally
docker build -t verily-server .

# Tag and push to ECR (AWS)
aws ecr get-login-password | docker login --username AWS --password-stdin <ecr-url>
docker tag verily-server:latest <ecr-url>:latest
docker push <ecr-url>:latest

# Tag and push to Artifact Registry (GCP)
gcloud auth configure-docker <region>-docker.pkg.dev
docker tag verily-server:latest <artifact-registry-url>:latest
docker push <artifact-registry-url>:latest
```

After pushing a new image, update the ECS service or Cloud Run service to pick it up.

## Pulumi ESC Details

ESC environments are already created and linked to stacks. The stack YAML files contain only an `environment:` reference — all config and secrets live in ESC.

```bash
# View environment (secrets masked)
pulumi env get ifiokjr/verily-infra/staging

# Edit environment YAML interactively
pulumi env edit ifiokjr/verily-infra/staging

# Run a command with ESC env vars injected
pulumi env run ifiokjr/verily-infra/staging -- env | grep SERVERPOD
```

See [`infra/README.md`](../infra/README.md) for the full secrets setup guide.

## CI/CD Integration

Add a GitHub Actions workflow for preview on PRs and deploy on merge:

```yaml
# .github/workflows/infra.yml
name: Infrastructure
on:
  pull_request:
    paths: ["infra/**", "Dockerfile"]
  push:
    branches: [main]
    paths: ["infra/**", "Dockerfile"]

jobs:
  preview:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 10
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: pnpm
          cache-dependency-path: infra/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: infra
      - uses: pulumi/actions@v5
        with:
          command: preview
          stack-name: staging
          work-dir: infra
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}

  deploy:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 10
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: pnpm
          cache-dependency-path: infra/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
        working-directory: infra
      - uses: pulumi/actions@v5
        with:
          command: up
          stack-name: production
          work-dir: infra
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
```

---

## Scaling Guide — Areas to Improve as the Application Grows

### 1. Database Scaling

**Current state**: Single RDS/Cloud SQL instance with vertical scaling via instance class config.

**When to act**: Query latency increases, CPU > 80% sustained, or connection count approaches limits.

**Improvements**:

- **Read replicas**: Add RDS read replicas or Cloud SQL read replicas for read-heavy workloads (action browsing, leaderboards). Route read queries via Serverpod's read-replica support.
- **Connection pooling**: Add PgBouncer or Cloud SQL Auth Proxy as a sidecar to the ECS/Cloud Run service. Serverpod connection limits can saturate quickly under auto-scaling.
- **PostGIS query optimization**: As location-based action data grows, add spatial indexes and consider partitioning the actions table by region. Monitor `pg_stat_user_tables` for sequential scans on spatial queries.
- **Vertical → horizontal**: Eventually move to Aurora PostgreSQL (AWS) or AlloyDB (GCP) for automatic horizontal read scaling.

### 2. Compute & Auto-Scaling

**Current state**: ECS Fargate (AWS) or Cloud Run (GCP) with CPU-based scaling.

**Improvements**:

- **Multi-metric scaling**: Add scaling policies based on request count, memory utilization, and custom CloudWatch/Cloud Monitoring metrics (e.g., video verification queue depth).
- **Scheduled scaling**: If traffic patterns are predictable (e.g., more action submissions on weekends), add time-based scaling rules.
- **Separate services per role**: Serverpod supports `--role` flags (`monolith`, `api`, `insights`, `web`). Split into dedicated services so API servers scale independently of the web/insights servers. This is especially important when video verification causes CPU spikes.
- **Task placement constraints**: For AWS, use Fargate Spot for staging and a mix of Spot + On-Demand for production to reduce costs.

### 3. Video Processing Pipeline

**Current state**: Gemini 2.0 Flash is called synchronously during verification.

**Improvements**:

- **Async queue**: Add an SQS queue (AWS) or Cloud Tasks (GCP) for video verification. The API receives the upload, returns immediately, and a worker processes the verification asynchronously.
- **Dedicated workers**: Separate video-processing workers from API servers, with their own scaling policies optimized for GPU/CPU-intensive work.
- **CDN for video uploads**: Use pre-signed S3/GCS URLs for direct client upload, bypassing the API server entirely. This removes the file-upload bottleneck from the server.
- **Caching verification results**: Cache Gemini responses in Redis to avoid re-processing re-submitted videos.

### 4. Redis & Caching

**Current state**: Single Redis node (staging) or replicated (production).

**Improvements**:

- **Cluster mode**: When key space grows beyond single-node memory, switch to ElastiCache cluster mode (AWS) or a larger Memorystore tier (GCP).
- **Application-level caching**: Add cache-aside patterns for hot data: popular actions, user profiles, leaderboard rankings.
- **Session affinity**: If using Redis for Serverpod sessions, ensure sticky sessions or a shared session store to avoid session loss during rolling deploys.

### 5. Storage & CDN

**Current state**: S3/GCS bucket with CloudFront (AWS only).

**Improvements**:

- **GCP CDN**: Add Cloud CDN in front of GCS for the GCP deployment (not yet included in the GCP stack).
- **Lifecycle policies**: Auto-transition old video submissions to cheaper storage tiers (S3 Glacier / GCS Nearline) after 90 days.
- **Multi-region replication**: For global users, enable cross-region replication on the storage bucket.
- **Signed URLs with short TTL**: Serve all user-uploaded content via signed URLs with 15-minute TTL to prevent hotlinking.

### 6. Networking & Security

**Current state**: VPC with public/private subnets, security groups/firewall rules.

**Improvements**:

- **WAF**: Add AWS WAF or Google Cloud Armor in front of the load balancer to protect against DDoS, SQL injection, and common web attacks.
- **VPC endpoints / Private Service Connect**: Reduce NAT costs and improve latency by using VPC endpoints (AWS) or Private Service Connect (GCP) for AWS/GCP service calls (S3, ECR, Cloud SQL).
- **Network policies**: As more services are added, implement fine-grained security group rules or GCP firewall policies per-service instead of allowing all VPC-internal traffic.
- **Bastion / IAP tunnel**: Add a bastion host or IAP tunnel for secure database administration without exposing the database publicly.

### 7. Observability

**Current state**: CloudWatch log groups (AWS) / Cloud Run built-in logs (GCP).

**Improvements**:

- **Structured logging**: Configure Serverpod to emit structured JSON logs. Add log-based metrics for error rates, latency percentiles, and verification success rates.
- **Distributed tracing**: Add AWS X-Ray or Google Cloud Trace for end-to-end request tracing, especially important for the video verification pipeline.
- **Dashboards & alerts**: Create Pulumi-managed CloudWatch/Cloud Monitoring dashboards and alert policies for key SLIs (API latency p99 < 500ms, error rate < 1%, database CPU < 80%).
- **Uptime checks**: Add synthetic monitoring / uptime checks hitting the `/health` endpoint from multiple regions.

### 8. Multi-Environment & Multi-Region

**Current state**: Single-region deployment with staging/production stacks.

**Improvements**:

- **Stack references**: Use Pulumi stack references to share outputs between stacks (e.g., a shared VPC stack referenced by application stacks).
- **Multi-region**: For global latency, deploy API servers to multiple regions with a global load balancer. Database can use read replicas in each region with writes routed to the primary.
- **Disaster recovery**: Add cross-region database backups and a documented failover procedure. Test recovery quarterly.
- **Feature environments**: Use Pulumi's dynamic stack creation to spin up per-PR preview environments that auto-destroy on PR close.

### 9. Cost Optimization

**Improvements**:

- **Right-sizing**: After 2 weeks of production data, review CloudWatch/Cloud Monitoring CPU and memory metrics. Downsize instances that are consistently under 40% utilization.
- **Reserved capacity**: For production databases and Redis, purchase reserved instances (AWS) or committed use discounts (GCP) for 30-50% savings.
- **Spot/preemptible**: Use Fargate Spot (AWS) or preemptible Cloud Run (GCP) for staging environments and non-critical workloads.
- **Storage tiering**: Implement S3 Intelligent-Tiering or GCS autoclass for automatic cost optimization on uploaded files.

### 10. Pulumi Project Organization

**Current state**: Single project, single entry point, stacks differentiate environments.

**When to split**:

- **Separate long-lived infra from app infra**: Network/database resources change rarely; compute resources change on every deploy. Split into `infra-foundation` (VPC, DB, Redis) and `infra-app` (ECS/Cloud Run, ALB). Use stack references to connect them.
- **Per-service stacks**: As you add more services (notification workers, video processors, cron jobs), give each its own stack so they can deploy independently.
- **Policy as Code**: Add Pulumi CrossGuard policy packs to enforce organizational standards (e.g., "all S3 buckets must have encryption", "no public database access").
