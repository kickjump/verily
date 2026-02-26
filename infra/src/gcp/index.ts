import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { apiHost, appHost, dbPassword, environment, insightsHost, serverImageUri } from "../config.js";
import type { DeploymentOutputs } from "../types.js";
import { Cache } from "./cache.js";
import { Compute } from "./compute.js";
import { Database } from "./database.js";
import { Dns } from "./dns.js";
import { Network } from "./network.js";
import { Storage } from "./storage.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");
const prefix = `verily-${environment}`;

export function deployGcp(): DeploymentOutputs {
  const network = new Network(`${prefix}-network`);

  const database = new Database(`${prefix}-database`, {
    networkSelfLink: network.networkSelfLink,
  });

  const cache = new Cache(`${prefix}-cache`, {
    networkSelfLink: network.networkSelfLink,
  });

  const storage = new Storage(`${prefix}-storage`);

  const compute = new Compute(`${prefix}-compute`, {
    networkSelfLink: network.networkSelfLink,
    subnetSelfLink: network.subnetSelfLink,
    dbConnectionName: database.connectionName,
    dbHost: database.privateIpAddress,
    dbName: database.dbName,
    dbUser: database.dbUser,
    dbPassword,
    redisHost: cache.host,
    redisPort: cache.port,
    imageUri: serverImageUri ?? undefined,
  });

  // ---------------------------------------------------------------------------
  // Global HTTPS Load Balancer
  // ---------------------------------------------------------------------------

  const globalIp = new gcp.compute.GlobalAddress(`${prefix}-lb-ip`, {
    description: `Global IP for Verily ${environment} load balancer`,
  });

  const dns = new Dns(`${prefix}-dns`, {
    loadBalancerIp: globalIp.address,
  });

  const neg = new gcp.compute.RegionNetworkEndpointGroup(`${prefix}-neg`, {
    region,
    networkEndpointType: "SERVERLESS",
    cloudRun: {
      service: `verily-${environment}`,
    },
  });

  const backendService = new gcp.compute.BackendService(
    `${prefix}-backend`,
    {
      protocol: "HTTP",
      portName: "http",
      backends: [{ group: neg.id }],
      logConfig: {
        enable: true,
        sampleRate: 1.0,
      },
    },
  );

  const urlMap = new gcp.compute.URLMap(`${prefix}-url-map`, {
    defaultService: backendService.id,
  });

  const httpsProxy = new gcp.compute.TargetHttpsProxy(
    `${prefix}-https-proxy`,
    {
      urlMap: urlMap.id,
      sslCertificates: [dns.sslCertificateId],
    },
  );

  new gcp.compute.GlobalForwardingRule(`${prefix}-https-rule`, {
    target: httpsProxy.id,
    portRange: "443",
    ipAddress: globalIp.address,
    loadBalancingScheme: "EXTERNAL",
  });

  // HTTP-to-HTTPS redirect
  const redirectUrlMap = new gcp.compute.URLMap(
    `${prefix}-redirect-url-map`,
    {
      defaultUrlRedirect: {
        httpsRedirect: true,
        stripQuery: false,
        redirectResponseCode: "MOVED_PERMANENTLY_DEFAULT",
      },
    },
  );

  const httpProxy = new gcp.compute.TargetHttpProxy(`${prefix}-http-proxy`, {
    urlMap: redirectUrlMap.id,
  });

  new gcp.compute.GlobalForwardingRule(`${prefix}-http-rule`, {
    target: httpProxy.id,
    portRange: "80",
    ipAddress: globalIp.address,
    loadBalancingScheme: "EXTERNAL",
  });

  return {
    apiUrl: pulumi.interpolate`https://${apiHost}`,
    appUrl: pulumi.interpolate`https://${appHost}`,
    insightsUrl: pulumi.interpolate`https://${insightsHost}`,
    databaseHost: database.privateIpAddress,
    redisHost: cache.host,
    imageRepositoryUrl: compute.artifactRegistryUrl,
    storageBucket: storage.bucketName,
  };
}
