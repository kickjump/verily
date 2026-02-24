import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags, isProduction, redisNodeType, redisPassword } from "../config.js";

export interface CacheNetworkArgs {
  vpcId: pulumi.Output<string>;
  privateSubnetIds: pulumi.Output<string>[];
  vpcCidrBlock: pulumi.Output<string>;
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
    args: { networkArgs: CacheNetworkArgs },
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Cache", name, {}, opts);

    const { networkArgs } = args;

    const sg = new aws.ec2.SecurityGroup(
      `${name}-sg`,
      {
        vpcId: networkArgs.vpcId,
        description: "Allow Redis access from within the VPC",
        ingress: [
          {
            protocol: "tcp",
            fromPort: 6379,
            toPort: 6379,
            cidrBlocks: [networkArgs.vpcCidrBlock],
          },
        ],
        egress: [
          {
            protocol: "-1",
            fromPort: 0,
            toPort: 0,
            cidrBlocks: ["0.0.0.0/0"],
          },
        ],
        tags: { ...baseTags, Name: `${name}-sg` },
      },
      { parent: this },
    );

    const subnetGroup = new aws.elasticache.SubnetGroup(
      `${name}-subnet-group`,
      {
        subnetIds: networkArgs.privateSubnetIds,
        tags: { ...baseTags, Name: `${name}-subnet-group` },
      },
      { parent: this },
    );

    const replicationGroup = new aws.elasticache.ReplicationGroup(
      `${name}-redis`,
      {
        description: "Redis cluster for Serverpod",
        engine: "redis",
        engineVersion: "7.1",
        nodeType: redisNodeType,
        numCacheClusters: isProduction ? 3 : 1,
        subnetGroupName: subnetGroup.name,
        securityGroupIds: [sg.id],
        transitEncryptionEnabled: true,
        atRestEncryptionEnabled: true,
        authToken: redisPassword,
        automaticFailoverEnabled: isProduction,
        tags: { ...baseTags, Name: `${name}-redis` },
      },
      { parent: this },
    );

    this.host = replicationGroup.primaryEndpointAddress;
    this.port = pulumi.output(6379);

    this.registerOutputs({
      host: this.host,
      port: this.port,
    });
  }
}
