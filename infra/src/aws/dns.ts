import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags, domain, storageHost } from "../config.js";

export interface DnsArgs {
  cdnDomainName: pulumi.Input<string>;
  cdnHostedZoneId: pulumi.Input<string>;
}

export interface DnsOutputs {
  zoneId: pulumi.Output<string>;
  certificateArn: pulumi.Output<string>;
}

export class Dns extends pulumi.ComponentResource implements DnsOutputs {
  public readonly zoneId: pulumi.Output<string>;
  public readonly certificateArn: pulumi.Output<string>;

  constructor(
    name: string,
    args: DnsArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Dns", name, {}, opts);

    const zone = new aws.route53.Zone(
      `${name}-zone`,
      {
        name: domain,
        tags: { ...baseTags, Name: `${name}-zone` },
      },
      { parent: this },
    );

    const certificate = new aws.acm.Certificate(
      `${name}-cert`,
      {
        domainName: domain,
        subjectAlternativeNames: [`*.${domain}`],
        validationMethod: "DNS",
        tags: { ...baseTags, Name: `${name}-cert` },
      },
      { parent: this },
    );

    const validationRecords = certificate.domainValidationOptions.apply(
      (options) =>
        options.map((opt, i) =>
          new aws.route53.Record(
            `${name}-cert-validation-${i}`,
            {
              zoneId: zone.zoneId,
              name: opt.resourceRecordName,
              type: opt.resourceRecordType,
              records: [opt.resourceRecordValue],
              ttl: 300,
            },
            { parent: this },
          )
        ),
    );

    const certValidation = new aws.acm.CertificateValidation(
      `${name}-cert-validation`,
      {
        certificateArn: certificate.arn,
        validationRecordFqdns: validationRecords.apply((records) => records.map((r) => r.fqdn)),
      },
      { parent: this },
    );

    new aws.route53.Record(
      `${name}-storage-record`,
      {
        zoneId: zone.zoneId,
        name: storageHost,
        type: "A",
        aliases: [
          {
            name: args.cdnDomainName,
            zoneId: args.cdnHostedZoneId,
            evaluateTargetHealth: false,
          },
        ],
      },
      { parent: this },
    );

    this.zoneId = zone.zoneId;
    this.certificateArn = certValidation.certificateArn;

    this.registerOutputs({
      zoneId: this.zoneId,
      certificateArn: this.certificateArn,
    });
  }
}
