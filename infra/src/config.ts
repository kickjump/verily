import * as pulumi from "@pulumi/pulumi";

const config = new pulumi.Config("verily-infra");

/** Cloud provider: "aws" or "gcp". */
export const cloud = config.require("cloud") as "aws" | "gcp";

/** Deployment environment: "staging" or "production". */
export const environment = config.require("environment") as
  | "staging"
  | "production";

/** Base domain (e.g. "verily.fun"). */
export const domain = config.require("domain");

/** Whether this is a production deployment. */
export const isProduction = environment === "production";

// ---------------------------------------------------------------------------
// Subdomain helpers — mirrors verily_server config/*.yaml
// ---------------------------------------------------------------------------
const envPrefix = isProduction ? "" : `${environment}-`;
const privatePrefix = `private-${environment}`;

export const apiHost = `api${envPrefix ? `-${environment}` : ""}.${domain}`;
export const appHost = `app${envPrefix ? `-${environment}` : ""}.${domain}`;
export const insightsHost = `insights${envPrefix ? `-${environment}` : ""}.${domain}`;
export const storageHost = `storage${envPrefix ? `-${environment}` : ""}.${domain}`;
export const databasePrivateHost = `database.${privatePrefix}.${domain}`;
export const redisPrivateHost = `redis.${privatePrefix}.${domain}`;

// ---------------------------------------------------------------------------
// Database configuration
// ---------------------------------------------------------------------------
export const dbInstanceClass = config.get("dbInstanceClass") ?? "db.t4g.medium";
export const dbAllocatedStorage = config.getNumber("dbAllocatedStorage") ?? 20;
export const dbPassword = config.requireSecret("dbPassword");
export const dbName = "serverpod";
export const dbUser = "postgres";

// ---------------------------------------------------------------------------
// Cache configuration
// ---------------------------------------------------------------------------
export const redisNodeType = config.get("redisNodeType") ?? "cache.t4g.micro";
export const redisPassword = config.getSecret("redisPassword");

// ---------------------------------------------------------------------------
// Compute configuration
// ---------------------------------------------------------------------------
export const serverCpu = config.getNumber("serverCpu") ?? 512;
export const serverMemory = config.getNumber("serverMemory") ?? 1024;
export const minCapacity = config.getNumber("minCapacity") ?? 1;
export const maxCapacity = config.getNumber("maxCapacity") ?? 4;

// ---------------------------------------------------------------------------
// Tags applied to every resource
// ---------------------------------------------------------------------------
export const baseTags = {
  Project: "verily",
  Environment: environment,
  ManagedBy: "pulumi",
};
