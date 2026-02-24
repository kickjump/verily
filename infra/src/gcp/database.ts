import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { dbName, dbPassword, dbUser, environment, isProduction } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");

export interface DatabaseArgs {
  networkSelfLink: pulumi.Input<string>;
}

export interface DatabaseOutputs {
  connectionName: pulumi.Output<string>;
  privateIpAddress: pulumi.Output<string>;
  dbName: string;
  dbUser: string;
}

export class Database extends pulumi.ComponentResource implements DatabaseOutputs {
  public readonly connectionName: pulumi.Output<string>;
  public readonly privateIpAddress: pulumi.Output<string>;
  public readonly dbName: string;
  public readonly dbUser: string;

  constructor(
    name: string,
    args: DatabaseArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Database", name, {}, opts);

    const instance = new gcp.sql.DatabaseInstance(
      `${name}-instance`,
      {
        databaseVersion: "POSTGRES_16",
        region,
        deletionProtection: isProduction,
        settings: {
          tier: isProduction ? "db-custom-4-15360" : "db-custom-2-7680",
          availabilityType: isProduction ? "REGIONAL" : "ZONAL",
          ipConfiguration: {
            ipv4Enabled: false,
            privateNetwork: args.networkSelfLink,
          },
          backupConfiguration: {
            enabled: true,
            startTime: "03:00",
            pointInTimeRecoveryEnabled: true,
          },
          databaseFlags: [
            { name: "cloudsql.enable_pgaudit", value: "on" },
          ],
          userLabels: {
            project: "verily",
            environment,
            managed_by: "pulumi",
          },
        },
      },
      { parent: this },
    );

    new gcp.sql.Database(
      `${name}-db`,
      {
        instance: instance.name,
        name: dbName,
      },
      { parent: this },
    );

    new gcp.sql.User(
      `${name}-user`,
      {
        instance: instance.name,
        name: dbUser,
        password: dbPassword,
      },
      { parent: this },
    );

    this.connectionName = instance.connectionName;
    this.privateIpAddress = instance.privateIpAddress;
    this.dbName = dbName;
    this.dbUser = dbUser;

    this.registerOutputs({
      connectionName: this.connectionName,
      privateIpAddress: this.privateIpAddress,
      dbName: this.dbName,
      dbUser: this.dbUser,
    });
  }
}
