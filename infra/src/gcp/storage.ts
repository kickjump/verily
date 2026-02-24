import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { environment } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");

export interface StorageOutputs {
  bucketName: pulumi.Output<string>;
  bucketUrl: pulumi.Output<string>;
}

export class Storage extends pulumi.ComponentResource implements StorageOutputs {
  public readonly bucketName: pulumi.Output<string>;
  public readonly bucketUrl: pulumi.Output<string>;

  constructor(
    name: string,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Storage", name, {}, opts);

    const bucket = new gcp.storage.Bucket(
      `${name}-bucket`,
      {
        location: region,
        uniformBucketLevelAccess: true,
        versioning: { enabled: true },
        labels: {
          project: "verily",
          environment,
          managed_by: "pulumi",
        },
      },
      { parent: this },
    );

    this.bucketName = bucket.name;
    this.bucketUrl = pulumi.interpolate`gs://${bucket.name}`;

    this.registerOutputs({
      bucketName: this.bucketName,
      bucketUrl: this.bucketUrl,
    });
  }
}
