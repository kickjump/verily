import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { isProduction } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");

export interface CacheArgs {
  networkSelfLink: pulumi.Input<string>;
}

export interface CacheOutputs {
  host: pulumi.Output<string>;
  port: pulumi.Output<number>;
}

export class Cache extends pulumi.ComponentResource implements CacheOutputs {
  public readonly host: pulumi.Output<string>;
  public readonly port: pulumi.Output<number>;

  constructor(
    name: string,
    args: CacheArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Cache", name, {}, opts);

    const redis = new gcp.redis.Instance(
      `${name}-redis`,
      {
        region,
        memorySizeGb: isProduction ? 5 : 1,
        tier: isProduction ? "STANDARD_HA" : "BASIC",
        redisVersion: "REDIS_7_0",
        authEnabled: true,
        transitEncryptionMode: "SERVER_AUTHENTICATION",
        authorizedNetwork: args.networkSelfLink,
        labels: {
          project: "verily",
          managed_by: "pulumi",
        },
      },
      { parent: this },
    );

    this.host = redis.host;
    this.port = redis.port;

    this.registerOutputs({
      host: this.host,
      port: this.port,
    });
  }
}
