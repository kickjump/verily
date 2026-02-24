import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags, dbAllocatedStorage, dbInstanceClass, dbName, dbPassword, dbUser, isProduction } from "../config.js";

export interface DatabaseNetworkArgs {
  vpcId: pulumi.Output<string>;
  privateSubnetIds: pulumi.Output<string>[];
  vpcCidrBlock: pulumi.Output<string>;
}

export interface DatabaseOutputs {
  host: pulumi.Output<string>;
  port: pulumi.Output<number>;
  dbName: string;
  dbUser: string;
  securityGroupId: pulumi.Output<string>;
}

export class Database extends pulumi.ComponentResource implements DatabaseOutputs {
  public readonly host: pulumi.Output<string>;
  public readonly port: pulumi.Output<number>;
  public readonly dbName: string;
  public readonly dbUser: string;
  public readonly securityGroupId: pulumi.Output<string>;

  constructor(
    name: string,
    args: { networkArgs: DatabaseNetworkArgs },
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Database", name, {}, opts);

    const { networkArgs } = args;

    const sg = new aws.ec2.SecurityGroup(
      `${name}-sg`,
      {
        vpcId: networkArgs.vpcId,
        description: "Allow PostgreSQL access from within the VPC",
        ingress: [
          {
            protocol: "tcp",
            fromPort: 5432,
            toPort: 5432,
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

    const subnetGroup = new aws.rds.SubnetGroup(
      `${name}-subnet-group`,
      {
        subnetIds: networkArgs.privateSubnetIds,
        tags: { ...baseTags, Name: `${name}-subnet-group` },
      },
      { parent: this },
    );

    const parameterGroup = new aws.rds.ParameterGroup(
      `${name}-pg16-params`,
      {
        family: "postgres16",
        description: "PostgreSQL 16 parameters for Serverpod",
        parameters: [
          {
            name: "shared_preload_libraries",
            value: "pg_stat_statements",
          },
          {
            name: "rds.force_ssl",
            value: "1",
          },
        ],
        tags: baseTags,
      },
      { parent: this },
    );

    const instance = new aws.rds.Instance(
      `${name}-instance`,
      {
        engine: "postgres",
        engineVersion: "16",
        instanceClass: dbInstanceClass,
        allocatedStorage: dbAllocatedStorage,
        dbName: dbName,
        username: dbUser,
        password: dbPassword,
        dbSubnetGroupName: subnetGroup.name,
        vpcSecurityGroupIds: [sg.id],
        parameterGroupName: parameterGroup.name,
        publiclyAccessible: false,
        multiAz: isProduction,
        skipFinalSnapshot: !isProduction,
        finalSnapshotIdentifier: isProduction
          ? pulumi.interpolate`${name}-final-snapshot`
          : undefined,
        storageEncrypted: true,
        tags: { ...baseTags, Name: `${name}-instance` },
      },
      { parent: this },
    );

    this.host = instance.address;
    this.port = instance.port;
    this.dbName = dbName;
    this.dbUser = dbUser;
    this.securityGroupId = sg.id;

    this.registerOutputs({
      host: this.host,
      port: this.port,
      dbName: this.dbName,
      dbUser: this.dbUser,
      securityGroupId: this.securityGroupId,
    });
  }
}
