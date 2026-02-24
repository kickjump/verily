import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { environment } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");

export interface NetworkOutputs {
  networkId: pulumi.Output<string>;
  networkSelfLink: pulumi.Output<string>;
  subnetId: pulumi.Output<string>;
  subnetSelfLink: pulumi.Output<string>;
}

export class Network extends pulumi.ComponentResource implements NetworkOutputs {
  public readonly networkId: pulumi.Output<string>;
  public readonly networkSelfLink: pulumi.Output<string>;
  public readonly subnetId: pulumi.Output<string>;
  public readonly subnetSelfLink: pulumi.Output<string>;

  constructor(
    name: string,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Network", name, {}, opts);

    const vpc = new gcp.compute.Network(
      `${name}-vpc`,
      {
        autoCreateSubnetworks: false,
        routingMode: "REGIONAL",
        description: `Verily ${environment} VPC`,
      },
      { parent: this },
    );

    const subnet = new gcp.compute.Subnetwork(
      `${name}-subnet`,
      {
        network: vpc.id,
        region,
        ipCidrRange: "10.0.0.0/20",
        privateIpGoogleAccess: true,
      },
      { parent: this },
    );

    const router = new gcp.compute.Router(
      `${name}-router`,
      {
        network: vpc.id,
        region,
      },
      { parent: this },
    );

    new gcp.compute.RouterNat(
      `${name}-nat`,
      {
        router: router.name,
        region,
        natIpAllocateOption: "AUTO_ONLY",
        sourceSubnetworkIpRangesToNat: "ALL_SUBNETWORKS_ALL_IP_RANGES",
      },
      { parent: this },
    );

    new gcp.compute.Firewall(
      `${name}-allow-internal`,
      {
        network: vpc.selfLink,
        allows: [
          { protocol: "tcp", ports: ["0-65535"] },
          { protocol: "udp", ports: ["0-65535"] },
          { protocol: "icmp" },
        ],
        sourceRanges: ["10.0.0.0/20"],
        description: "Allow internal VPC traffic",
      },
      { parent: this },
    );

    new gcp.compute.Firewall(
      `${name}-allow-health-checks`,
      {
        network: vpc.selfLink,
        allows: [{ protocol: "tcp" }],
        sourceRanges: ["130.211.0.0/22", "35.191.0.0/16"],
        description: "Allow Google health check ranges",
      },
      { parent: this },
    );

    new gcp.compute.Firewall(
      `${name}-allow-iap-ssh`,
      {
        network: vpc.selfLink,
        allows: [{ protocol: "tcp", ports: ["22"] }],
        sourceRanges: ["35.235.240.0/20"],
        description: "Allow SSH from IAP",
      },
      { parent: this },
    );

    const privateIpRange = new gcp.compute.GlobalAddress(
      `${name}-private-ip-range`,
      {
        purpose: "VPC_PEERING",
        addressType: "INTERNAL",
        prefixLength: 16,
        network: vpc.id,
      },
      { parent: this },
    );

    new gcp.servicenetworking.Connection(
      `${name}-private-services`,
      {
        network: vpc.id,
        service: "servicenetworking.googleapis.com",
        reservedPeeringRanges: [privateIpRange.name],
      },
      { parent: this },
    );

    this.networkId = vpc.id;
    this.networkSelfLink = vpc.selfLink;
    this.subnetId = subnet.id;
    this.subnetSelfLink = subnet.selfLink;

    this.registerOutputs({
      networkId: this.networkId,
      networkSelfLink: this.networkSelfLink,
      subnetId: this.subnetId,
      subnetSelfLink: this.subnetSelfLink,
    });
  }
}
