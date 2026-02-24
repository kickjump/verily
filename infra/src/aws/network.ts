import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags } from "../config.js";

export interface NetworkOutputs {
  vpcId: pulumi.Output<string>;
  publicSubnetIds: pulumi.Output<string>[];
  privateSubnetIds: pulumi.Output<string>[];
  vpcCidrBlock: pulumi.Output<string>;
}

export class Network extends pulumi.ComponentResource implements NetworkOutputs {
  public readonly vpcId: pulumi.Output<string>;
  public readonly publicSubnetIds: pulumi.Output<string>[];
  public readonly privateSubnetIds: pulumi.Output<string>[];
  public readonly vpcCidrBlock: pulumi.Output<string>;

  constructor(
    name: string,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Network", name, {}, opts);

    const azs = aws.getAvailabilityZonesOutput({
      state: "available",
    });

    const vpc = new aws.ec2.Vpc(
      `${name}-vpc`,
      {
        cidrBlock: "10.0.0.0/16",
        enableDnsSupport: true,
        enableDnsHostnames: true,
        tags: { ...baseTags, Name: `${name}-vpc` },
      },
      { parent: this },
    );

    const publicSubnet0 = new aws.ec2.Subnet(
      `${name}-public-0`,
      {
        vpcId: vpc.id,
        cidrBlock: "10.0.1.0/24",
        availabilityZone: azs.names[0],
        mapPublicIpOnLaunch: true,
        tags: { ...baseTags, Name: `${name}-public-0` },
      },
      { parent: this },
    );

    const publicSubnet1 = new aws.ec2.Subnet(
      `${name}-public-1`,
      {
        vpcId: vpc.id,
        cidrBlock: "10.0.2.0/24",
        availabilityZone: azs.names[1],
        mapPublicIpOnLaunch: true,
        tags: { ...baseTags, Name: `${name}-public-1` },
      },
      { parent: this },
    );

    const privateSubnet0 = new aws.ec2.Subnet(
      `${name}-private-0`,
      {
        vpcId: vpc.id,
        cidrBlock: "10.0.10.0/24",
        availabilityZone: azs.names[0],
        tags: { ...baseTags, Name: `${name}-private-0` },
      },
      { parent: this },
    );

    const privateSubnet1 = new aws.ec2.Subnet(
      `${name}-private-1`,
      {
        vpcId: vpc.id,
        cidrBlock: "10.0.11.0/24",
        availabilityZone: azs.names[1],
        tags: { ...baseTags, Name: `${name}-private-1` },
      },
      { parent: this },
    );

    const igw = new aws.ec2.InternetGateway(
      `${name}-igw`,
      {
        vpcId: vpc.id,
        tags: { ...baseTags, Name: `${name}-igw` },
      },
      { parent: this },
    );

    const eip = new aws.ec2.Eip(
      `${name}-nat-eip`,
      {
        domain: "vpc",
        tags: { ...baseTags, Name: `${name}-nat-eip` },
      },
      { parent: this },
    );

    const natGw = new aws.ec2.NatGateway(
      `${name}-nat`,
      {
        subnetId: publicSubnet0.id,
        allocationId: eip.id,
        tags: { ...baseTags, Name: `${name}-nat` },
      },
      { parent: this },
    );

    const publicRt = new aws.ec2.RouteTable(
      `${name}-public-rt`,
      {
        vpcId: vpc.id,
        routes: [{ cidrBlock: "0.0.0.0/0", gatewayId: igw.id }],
        tags: { ...baseTags, Name: `${name}-public-rt` },
      },
      { parent: this },
    );

    const privateRt = new aws.ec2.RouteTable(
      `${name}-private-rt`,
      {
        vpcId: vpc.id,
        routes: [{ cidrBlock: "0.0.0.0/0", natGatewayId: natGw.id }],
        tags: { ...baseTags, Name: `${name}-private-rt` },
      },
      { parent: this },
    );

    new aws.ec2.RouteTableAssociation(
      `${name}-public-rta-0`,
      { subnetId: publicSubnet0.id, routeTableId: publicRt.id },
      { parent: this },
    );

    new aws.ec2.RouteTableAssociation(
      `${name}-public-rta-1`,
      { subnetId: publicSubnet1.id, routeTableId: publicRt.id },
      { parent: this },
    );

    new aws.ec2.RouteTableAssociation(
      `${name}-private-rta-0`,
      { subnetId: privateSubnet0.id, routeTableId: privateRt.id },
      { parent: this },
    );

    new aws.ec2.RouteTableAssociation(
      `${name}-private-rta-1`,
      { subnetId: privateSubnet1.id, routeTableId: privateRt.id },
      { parent: this },
    );

    this.vpcId = vpc.id;
    this.publicSubnetIds = [publicSubnet0.id, publicSubnet1.id];
    this.privateSubnetIds = [privateSubnet0.id, privateSubnet1.id];
    this.vpcCidrBlock = vpc.cidrBlock;

    this.registerOutputs({
      vpcId: this.vpcId,
      publicSubnetIds: this.publicSubnetIds,
      privateSubnetIds: this.privateSubnetIds,
      vpcCidrBlock: this.vpcCidrBlock,
    });
  }
}
