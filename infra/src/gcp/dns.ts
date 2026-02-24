import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { apiHost, appHost, domain, insightsHost, storageHost } from "../config.js";

export interface DnsArgs {
  loadBalancerIp: pulumi.Input<string>;
}

export interface DnsOutputs {
  zoneId: pulumi.Output<string>;
  nameServers: pulumi.Output<string[]>;
  sslCertificateId: pulumi.Output<string>;
}

export class Dns extends pulumi.ComponentResource implements DnsOutputs {
  public readonly zoneId: pulumi.Output<string>;
  public readonly nameServers: pulumi.Output<string[]>;
  public readonly sslCertificateId: pulumi.Output<string>;

  constructor(
    name: string,
    args: DnsArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Dns", name, {}, opts);

    const zoneName = domain.replace(/\./g, "-");

    const zone = new gcp.dns.ManagedZone(
      `${name}-zone`,
      {
        name: `${zoneName}-zone`,
        dnsName: `${domain}.`,
        description: `DNS zone for ${domain}`,
      },
      { parent: this },
    );

    const hosts = [
      { recordName: apiHost, label: "api" },
      { recordName: appHost, label: "app" },
      { recordName: insightsHost, label: "insights" },
      { recordName: storageHost, label: "storage" },
    ];

    for (const { recordName, label } of hosts) {
      new gcp.dns.RecordSet(
        `${name}-${label}-record`,
        {
          managedZone: zone.name,
          name: `${recordName}.`,
          type: "A",
          ttl: 300,
          rrdatas: [pulumi.interpolate`${args.loadBalancerIp}`],
        },
        { parent: this },
      );
    }

    const sslCert = new gcp.compute.ManagedSslCertificate(
      `${name}-ssl-cert`,
      {
        managed: {
          domains: [`*.${domain}`, domain],
        },
      },
      { parent: this },
    );

    this.zoneId = zone.id;
    this.nameServers = zone.nameServers;
    this.sslCertificateId = sslCert.id;

    this.registerOutputs({
      zoneId: this.zoneId,
      nameServers: this.nameServers,
      sslCertificateId: this.sslCertificateId,
    });
  }
}
