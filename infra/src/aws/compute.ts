import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags, environment, maxCapacity, minCapacity, serverCpu, serverMemory } from "../config.js";

export interface ComputeArgs {
  networkArgs: {
    vpcId: pulumi.Output<string>;
    publicSubnetIds: pulumi.Output<string>[];
    privateSubnetIds: pulumi.Output<string>[];
  };
  dbHost: pulumi.Output<string>;
  dbPort: pulumi.Output<number>;
  dbName: string;
  dbUser: string;
  dbPassword: pulumi.Output<string>;
  redisHost: pulumi.Output<string>;
  redisPort: pulumi.Output<number>;
  redisPassword?: pulumi.Output<string>;
  imageUri?: pulumi.Input<string>;
  targetGroupArn: pulumi.Output<string>;
  albSecurityGroupId: pulumi.Output<string>;
}

export interface ComputeOutputs {
  clusterId: pulumi.Output<string>;
  serviceId: pulumi.Output<string>;
  ecrRepositoryUrl: pulumi.Output<string>;
  securityGroupId: pulumi.Output<string>;
}

export class Compute extends pulumi.ComponentResource implements ComputeOutputs {
  public readonly clusterId: pulumi.Output<string>;
  public readonly serviceId: pulumi.Output<string>;
  public readonly ecrRepositoryUrl: pulumi.Output<string>;
  public readonly securityGroupId: pulumi.Output<string>;

  constructor(
    name: string,
    args: ComputeArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Compute", name, {}, opts);

    const ecr = new aws.ecr.Repository(
      `${name}-repo`,
      {
        imageScanningConfiguration: { scanOnPush: true },
        forceDelete: true,
        tags: { ...baseTags, Name: `${name}-repo` },
      },
      { parent: this },
    );

    new aws.ecr.LifecyclePolicy(
      `${name}-repo-lifecycle`,
      {
        repository: ecr.name,
        policy: JSON.stringify({
          rules: [
            {
              rulePriority: 1,
              description: "Keep last 10 images",
              selection: {
                tagStatus: "any",
                countType: "imageCountMoreThan",
                countNumber: 10,
              },
              action: { type: "expire" },
            },
          ],
        }),
      },
      { parent: this },
    );

    const cluster = new aws.ecs.Cluster(
      `${name}-cluster`,
      {
        settings: [
          { name: "containerInsights", value: "enabled" },
        ],
        tags: { ...baseTags, Name: `${name}-cluster` },
      },
      { parent: this },
    );

    const executionRole = new aws.iam.Role(
      `${name}-execution-role`,
      {
        assumeRolePolicy: JSON.stringify({
          Version: "2012-10-17",
          Statement: [
            {
              Effect: "Allow",
              Principal: { Service: "ecs-tasks.amazonaws.com" },
              Action: "sts:AssumeRole",
            },
          ],
        }),
        tags: { ...baseTags, Name: `${name}-execution-role` },
      },
      { parent: this },
    );

    new aws.iam.RolePolicyAttachment(
      `${name}-execution-role-policy`,
      {
        role: executionRole.name,
        policyArn: "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
      },
      { parent: this },
    );

    const taskRole = new aws.iam.Role(
      `${name}-task-role`,
      {
        assumeRolePolicy: JSON.stringify({
          Version: "2012-10-17",
          Statement: [
            {
              Effect: "Allow",
              Principal: { Service: "ecs-tasks.amazonaws.com" },
              Action: "sts:AssumeRole",
            },
          ],
        }),
        tags: { ...baseTags, Name: `${name}-task-role` },
      },
      { parent: this },
    );

    new aws.iam.RolePolicy(
      `${name}-task-role-s3-policy`,
      {
        role: taskRole.name,
        policy: JSON.stringify({
          Version: "2012-10-17",
          Statement: [
            {
              Effect: "Allow",
              Action: [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket",
              ],
              Resource: ["arn:aws:s3:::*"],
            },
          ],
        }),
      },
      { parent: this },
    );

    const logGroup = new aws.cloudwatch.LogGroup(
      `${name}-logs`,
      {
        retentionInDays: 30,
        tags: { ...baseTags, Name: `${name}-logs` },
      },
      { parent: this },
    );

    const containerImage = args.imageUri ?? pulumi.interpolate`${ecr.repositoryUrl}:latest`;

    const taskDefinition = new aws.ecs.TaskDefinition(
      `${name}-task`,
      {
        family: `${name}-serverpod`,
        networkMode: "awsvpc",
        requiresCompatibilities: ["FARGATE"],
        cpu: serverCpu.toString(),
        memory: serverMemory.toString(),
        executionRoleArn: executionRole.arn,
        taskRoleArn: taskRole.arn,
        containerDefinitions: pulumi
          .all([
            containerImage,
            logGroup.name,
            args.dbHost,
            args.dbPort.apply(String),
            pulumi.output(args.dbName),
            pulumi.output(args.dbUser),
            args.dbPassword,
            args.redisHost,
            args.redisPort.apply(String),
            args.redisPassword ?? pulumi.output(""),
          ])
          .apply(
            ([
              image,
              logGroupName,
              dbHost,
              dbPort,
              dbNameVal,
              dbUserVal,
              dbPasswordVal,
              redisHost,
              redisPort,
              redisPasswordVal,
            ]) => {
              const env = [
                { name: "SERVERPOD_DATABASE_HOST", value: dbHost },
                {
                  name: "SERVERPOD_DATABASE_PORT",
                  value: dbPort,
                },
                { name: "SERVERPOD_DATABASE_NAME", value: dbNameVal },
                { name: "SERVERPOD_DATABASE_USER", value: dbUserVal },
                {
                  name: "SERVERPOD_DATABASE_PASSWORD",
                  value: dbPasswordVal,
                },
                { name: "SERVERPOD_REDIS_HOST", value: redisHost },
                {
                  name: "SERVERPOD_REDIS_PORT",
                  value: redisPort,
                },
                { name: "RUNNING_IN_CLOUD", value: "true" },
              ];

              if (redisPasswordVal) {
                env.push({
                  name: "SERVERPOD_REDIS_PASSWORD",
                  value: redisPasswordVal,
                });
              }

              return JSON.stringify([
                {
                  name: "serverpod",
                  image,
                  essential: true,
                  portMappings: [
                    { containerPort: 8080, protocol: "tcp" },
                    { containerPort: 8081, protocol: "tcp" },
                    { containerPort: 8082, protocol: "tcp" },
                  ],
                  environment: env,
                  logConfiguration: {
                    logDriver: "awslogs",
                    options: {
                      "awslogs-group": logGroupName,
                      "awslogs-region": aws.config.region ?? "us-west-2",
                      "awslogs-stream-prefix": "ecs",
                    },
                  },
                },
              ]);
            },
          ),
        tags: { ...baseTags, Name: `${name}-task` },
      },
      { parent: this },
    );

    const taskSg = new aws.ec2.SecurityGroup(
      `${name}-task-sg`,
      {
        vpcId: args.networkArgs.vpcId,
        description: "Allow traffic from ALB to ECS tasks",
        ingress: [
          {
            protocol: "tcp",
            fromPort: 8080,
            toPort: 8082,
            securityGroups: [args.albSecurityGroupId],
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
        tags: { ...baseTags, Name: `${name}-task-sg` },
      },
      { parent: this },
    );

    const service = new aws.ecs.Service(
      `${name}-service`,
      {
        cluster: cluster.arn,
        taskDefinition: taskDefinition.arn,
        desiredCount: minCapacity,
        launchType: "FARGATE",
        networkConfiguration: {
          subnets: args.networkArgs.privateSubnetIds,
          securityGroups: [taskSg.id],
          assignPublicIp: false,
        },
        loadBalancers: [
          {
            targetGroupArn: args.targetGroupArn,
            containerName: "serverpod",
            containerPort: 8080,
          },
        ],
        tags: { ...baseTags, Name: `${name}-service` },
      },
      { parent: this },
    );

    const scalingTarget = new aws.appautoscaling.Target(
      `${name}-scaling-target`,
      {
        maxCapacity: maxCapacity,
        minCapacity: minCapacity,
        resourceId: pulumi.interpolate`service/${cluster.name}/${service.name}`,
        scalableDimension: "ecs:service:DesiredCount",
        serviceNamespace: "ecs",
      },
      { parent: this },
    );

    new aws.appautoscaling.Policy(
      `${name}-scaling-policy`,
      {
        policyType: "TargetTrackingScaling",
        resourceId: scalingTarget.resourceId,
        scalableDimension: scalingTarget.scalableDimension,
        serviceNamespace: scalingTarget.serviceNamespace,
        targetTrackingScalingPolicyConfiguration: {
          predefinedMetricSpecification: {
            predefinedMetricType: "ECSServiceAverageCPUUtilization",
          },
          targetValue: 70,
        },
      },
      { parent: this },
    );

    this.clusterId = cluster.id;
    this.serviceId = service.id;
    this.ecrRepositoryUrl = ecr.repositoryUrl;
    this.securityGroupId = taskSg.id;

    this.registerOutputs({
      clusterId: this.clusterId,
      serviceId: this.serviceId,
      ecrRepositoryUrl: this.ecrRepositoryUrl,
      securityGroupId: this.securityGroupId,
    });
  }
}
