import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";
import * as pulumi from "@pulumi/pulumi";

import {
  apiHost,
  appHost,
  baseTags,
  dbPassword,
  environment,
  insightsHost,
  redisPassword,
  serverImageUri,
} from "../config.js";
import type { DeploymentOutputs } from "../types.js";
import { Cache } from "./cache.js";
import { Compute } from "./compute.js";
import { Database } from "./database.js";
import { Dns } from "./dns.js";
import { Network } from "./network.js";
import { Recommendation } from "./recommendation.js";
import { Storage } from "./storage.js";

export function deployAws(): DeploymentOutputs {
  const prefix = `verily-${environment}`;

  const network = new Network(`${prefix}-network`);

  const database = new Database(`${prefix}-db`, {
    networkArgs: {
      vpcId: network.vpcId,
      privateSubnetIds: network.privateSubnetIds,
      vpcCidrBlock: network.vpcCidrBlock,
    },
  });

  const cache = new Cache(`${prefix}-cache`, {
    networkArgs: {
      vpcId: network.vpcId,
      privateSubnetIds: network.privateSubnetIds,
      vpcCidrBlock: network.vpcCidrBlock,
    },
  });

  const storage = new Storage(`${prefix}-storage`);

  // CloudFront uses a fixed hosted zone ID for alias records.
  const cloudfrontHostedZoneId = "Z2FDTNDATAQYW2";

  const dns = new Dns(`${prefix}-dns`, {
    cdnDomainName: storage.cdnDomainName,
    cdnHostedZoneId: cloudfrontHostedZoneId,
  });

  const albSg = new aws.ec2.SecurityGroup(`${prefix}-alb-sg`, {
    vpcId: network.vpcId,
    description: "Allow HTTP and HTTPS traffic to ALB",
    ingress: [
      {
        protocol: "tcp",
        fromPort: 80,
        toPort: 80,
        cidrBlocks: ["0.0.0.0/0"],
      },
      {
        protocol: "tcp",
        fromPort: 443,
        toPort: 443,
        cidrBlocks: ["0.0.0.0/0"],
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
    tags: { ...baseTags, Name: `${prefix}-alb-sg` },
  });

  const alb = new awsx.lb.ApplicationLoadBalancer(`${prefix}-alb`, {
    subnetIds: network.publicSubnetIds,
    securityGroups: [albSg.id],
    tags: { ...baseTags, Name: `${prefix}-alb` },
    defaultTargetGroup: {
      port: 8080,
      protocol: "HTTP",
      targetType: "ip",
      healthCheck: {
        path: "/readyz",
        protocol: "HTTP",
        healthyThreshold: 2,
        unhealthyThreshold: 3,
        timeout: 10,
        interval: 30,
      },
      tags: baseTags,
    },
    listener: {
      port: 443,
      protocol: "HTTPS",
      certificateArn: dns.certificateArn,
      tags: baseTags,
    },
  });

  new aws.lb.Listener(`${prefix}-http-redirect`, {
    loadBalancerArn: alb.loadBalancer.arn,
    port: 80,
    protocol: "HTTP",
    defaultActions: [
      {
        type: "redirect",
        redirect: {
          port: "443",
          protocol: "HTTPS",
          statusCode: "HTTP_301",
        },
      },
    ],
    tags: baseTags,
  });

  const compute = new Compute(`${prefix}-compute`, {
    networkArgs: {
      vpcId: network.vpcId,
      publicSubnetIds: network.publicSubnetIds,
      privateSubnetIds: network.privateSubnetIds,
    },
    dbHost: database.host,
    dbPort: database.port,
    dbName: database.dbName,
    dbUser: database.dbUser,
    dbPassword: dbPassword,
    redisHost: cache.host,
    redisPort: cache.port,
    redisPassword: redisPassword,
    imageUri: serverImageUri ?? undefined,
    targetGroupArn: alb.defaultTargetGroup.arn,
    albSecurityGroupId: albSg.id,
  });

  new aws.route53.Record(`${prefix}-api-record`, {
    zoneId: dns.zoneId,
    name: apiHost,
    type: "A",
    aliases: [
      {
        name: alb.loadBalancer.dnsName,
        zoneId: alb.loadBalancer.zoneId,
        evaluateTargetHealth: true,
      },
    ],
  });

  new aws.route53.Record(`${prefix}-app-record`, {
    zoneId: dns.zoneId,
    name: appHost,
    type: "A",
    aliases: [
      {
        name: alb.loadBalancer.dnsName,
        zoneId: alb.loadBalancer.zoneId,
        evaluateTargetHealth: true,
      },
    ],
  });

  new aws.route53.Record(`${prefix}-insights-record`, {
    zoneId: dns.zoneId,
    name: insightsHost,
    type: "A",
    aliases: [
      {
        name: alb.loadBalancer.dnsName,
        zoneId: alb.loadBalancer.zoneId,
        evaluateTargetHealth: true,
      },
    ],
  });

  const recommendation = new Recommendation(`${prefix}-rec`, {
    networkArgs: {
      vpcId: network.vpcId,
      privateSubnetIds: network.privateSubnetIds,
      vpcCidrBlock: network.vpcCidrBlock,
    },
    redisHost: cache.host,
    redisPort: cache.port,
    redisPassword: redisPassword,
    dbHost: database.host,
    dbPort: database.port,
    dbName: database.dbName,
    dbUser: database.dbUser,
    dbPassword: dbPassword,
  });

  return {
    apiUrl: pulumi.interpolate`https://${apiHost}`,
    appUrl: pulumi.interpolate`https://${appHost}`,
    insightsUrl: pulumi.interpolate`https://${insightsHost}`,
    databaseHost: database.host,
    redisHost: cache.host,
    imageRepositoryUrl: compute.ecrRepositoryUrl,
    storageBucket: storage.bucketName,
    recommendationEventQueue: recommendation.eventQueueUrl,
    recommendationScorerEndpoint: recommendation.scorerFunctionArn,
  };
}
