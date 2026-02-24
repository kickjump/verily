import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags } from "../config.js";

export interface StorageOutputs {
  bucketName: pulumi.Output<string>;
  bucketArn: pulumi.Output<string>;
  cdnDomainName: pulumi.Output<string>;
  cdnDistributionId: pulumi.Output<string>;
}

export class Storage extends pulumi.ComponentResource implements StorageOutputs {
  public readonly bucketName: pulumi.Output<string>;
  public readonly bucketArn: pulumi.Output<string>;
  public readonly cdnDomainName: pulumi.Output<string>;
  public readonly cdnDistributionId: pulumi.Output<string>;

  constructor(
    name: string,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Storage", name, {}, opts);

    const bucket = new aws.s3.BucketV2(
      `${name}-bucket`,
      {
        forceDestroy: true,
        tags: { ...baseTags, Name: `${name}-bucket` },
      },
      { parent: this },
    );

    new aws.s3.BucketPublicAccessBlock(
      `${name}-public-access-block`,
      {
        bucket: bucket.id,
        blockPublicAcls: true,
        blockPublicPolicy: true,
        ignorePublicAcls: true,
        restrictPublicBuckets: true,
      },
      { parent: this },
    );

    new aws.s3.BucketVersioningV2(
      `${name}-versioning`,
      {
        bucket: bucket.id,
        versioningConfiguration: { status: "Enabled" },
      },
      { parent: this },
    );

    new aws.s3.BucketServerSideEncryptionConfigurationV2(
      `${name}-encryption`,
      {
        bucket: bucket.id,
        rules: [
          {
            applyServerSideEncryptionByDefault: {
              sseAlgorithm: "AES256",
            },
          },
        ],
      },
      { parent: this },
    );

    const oai = new aws.cloudfront.OriginAccessIdentity(
      `${name}-oai`,
      {
        comment: pulumi.interpolate`OAI for ${bucket.bucket}`,
      },
      { parent: this },
    );

    new aws.s3.BucketPolicy(
      `${name}-bucket-policy`,
      {
        bucket: bucket.id,
        policy: pulumi
          .all([bucket.arn, oai.iamArn])
          .apply(([bucketArn, oaiArn]) =>
            JSON.stringify({
              Version: "2012-10-17",
              Statement: [
                {
                  Effect: "Allow",
                  Principal: { AWS: oaiArn },
                  Action: "s3:GetObject",
                  Resource: `${bucketArn}/*`,
                },
              ],
            })
          ),
      },
      { parent: this },
    );

    const cdn = new aws.cloudfront.Distribution(
      `${name}-cdn`,
      {
        enabled: true,
        origins: [
          {
            domainName: bucket.bucketRegionalDomainName,
            originId: "s3",
            s3OriginConfig: {
              originAccessIdentity: oai.cloudfrontAccessIdentityPath,
            },
          },
        ],
        defaultCacheBehavior: {
          targetOriginId: "s3",
          viewerProtocolPolicy: "redirect-to-https",
          allowedMethods: ["GET", "HEAD"],
          cachedMethods: ["GET", "HEAD"],
          forwardedValues: {
            queryString: false,
            cookies: { forward: "none" },
          },
          minTtl: 0,
          defaultTtl: 86400,
          maxTtl: 31536000,
          compress: true,
        },
        restrictions: {
          geoRestriction: { restrictionType: "none" },
        },
        viewerCertificate: {
          cloudfrontDefaultCertificate: true,
          minimumProtocolVersion: "TLSv1.2_2021",
        },
        tags: { ...baseTags, Name: `${name}-cdn` },
      },
      { parent: this },
    );

    this.bucketName = bucket.bucket;
    this.bucketArn = bucket.arn;
    this.cdnDomainName = cdn.domainName;
    this.cdnDistributionId = cdn.id;

    this.registerOutputs({
      bucketName: this.bucketName,
      bucketArn: this.bucketArn,
      cdnDomainName: this.cdnDomainName,
      cdnDistributionId: this.cdnDistributionId,
    });
  }
}
