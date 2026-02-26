import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { environment, maxCapacity, minCapacity, serverCpu, serverMemory } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");
const project = gcpConfig.require("project");

export interface ComputeArgs {
  networkSelfLink: pulumi.Input<string>;
  subnetSelfLink: pulumi.Input<string>;
  dbConnectionName: pulumi.Input<string>;
  dbHost: pulumi.Input<string>;
  dbName: string;
  dbUser: string;
  dbPassword: pulumi.Input<string>;
  redisHost: pulumi.Input<string>;
  redisPort: pulumi.Input<number>;
  imageUri?: pulumi.Input<string>;
}

export interface ComputeOutputs {
  serviceUrl: pulumi.Output<string>;
  artifactRegistryUrl: pulumi.Output<string>;
}

export class Compute extends pulumi.ComponentResource implements ComputeOutputs {
  public readonly serviceUrl: pulumi.Output<string>;
  public readonly artifactRegistryUrl: pulumi.Output<string>;

  constructor(
    name: string,
    args: ComputeArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Compute", name, {}, opts);

    const repository = new gcp.artifactregistry.Repository(
      `${name}-repo`,
      {
        repositoryId: `verily-${environment}`,
        format: "DOCKER",
        location: region,
        description: `Verily ${environment} container images`,
        labels: {
          project: "verily",
          environment,
          managed_by: "pulumi",
        },
      },
      { parent: this },
    );

    this.artifactRegistryUrl = pulumi.interpolate`${region}-docker.pkg.dev/${project}/${repository.repositoryId}`;

    const vpcConnector = new gcp.vpcaccess.Connector(
      `${name}-connector`,
      {
        name: `verily-${environment}`,
        region,
        network: args.networkSelfLink,
        ipCidrRange: "10.8.0.0/28",
        minInstances: 2,
        maxInstances: 3,
      },
      { parent: this },
    );

    const containerImage = args.imageUri ?? pulumi.interpolate`${this.artifactRegistryUrl}/serverpod:latest`;

    const service = new gcp.cloudrunv2.Service(
      `${name}-service`,
      {
        name: `verily-${environment}`,
        location: region,
        ingress: "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER",
        template: {
          scaling: {
            minInstanceCount: minCapacity,
            maxInstanceCount: maxCapacity,
          },
          vpcAccess: {
            connector: vpcConnector.id,
            egress: "PRIVATE_RANGES_ONLY",
          },
          containers: [
            {
              image: containerImage,
              ports: { containerPort: 8080 },
              resources: {
                limits: {
                  cpu: `${serverCpu}m`,
                  memory: `${serverMemory}Mi`,
                },
              },
              envs: [
                {
                  name: "SERVERPOD_DATABASE_HOST",
                  value: pulumi.interpolate`${args.dbHost}`,
                },
                { name: "SERVERPOD_DATABASE_PORT", value: "5432" },
                { name: "SERVERPOD_DATABASE_NAME", value: args.dbName },
                { name: "SERVERPOD_DATABASE_USER", value: args.dbUser },
                {
                  name: "SERVERPOD_DATABASE_PASSWORD",
                  value: pulumi.interpolate`${args.dbPassword}`,
                },
                {
                  name: "SERVERPOD_REDIS_HOST",
                  value: pulumi.interpolate`${args.redisHost}`,
                },
                {
                  name: "SERVERPOD_REDIS_PORT",
                  value: pulumi.interpolate`${args.redisPort}`,
                },
                { name: "RUNNING_IN_CLOUD", value: "true" },
              ],
              volumeMounts: [
                { name: "cloudsql", mountPath: "/cloudsql" },
              ],
            },
          ],
          volumes: [
            {
              name: "cloudsql",
              cloudSqlInstance: {
                instances: [pulumi.interpolate`${args.dbConnectionName}`],
              },
            },
          ],
          labels: {
            project: "verily",
            environment,
            managed_by: "pulumi",
          },
        },
      },
      { parent: this },
    );

    new gcp.cloudrunv2.ServiceIamMember(
      `${name}-invoker`,
      {
        name: service.name,
        location: region,
        role: "roles/run.invoker",
        member: "allUsers",
      },
      { parent: this },
    );

    this.serviceUrl = service.uri;

    this.registerOutputs({
      serviceUrl: this.serviceUrl,
      artifactRegistryUrl: this.artifactRegistryUrl,
    });
  }
}
