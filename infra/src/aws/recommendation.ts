import * as aws from "@pulumi/aws";
import * as pulumi from "@pulumi/pulumi";

import { baseTags, environment, isProduction } from "../config.js";

export interface RecommendationArgs {
  networkArgs: {
    vpcId: pulumi.Output<string>;
    privateSubnetIds: pulumi.Output<string>[];
    vpcCidrBlock: pulumi.Output<string>;
  };
  redisHost: pulumi.Output<string>;
  redisPort: pulumi.Output<number>;
  redisPassword?: pulumi.Output<string>;
  dbHost: pulumi.Output<string>;
  dbPort: pulumi.Output<number>;
  dbName: string;
  dbUser: string;
  dbPassword: pulumi.Output<string>;
}

export interface RecommendationOutputs {
  eventQueueUrl: pulumi.Output<string>;
  eventQueueArn: pulumi.Output<string>;
  scoreTableName: pulumi.Output<string>;
  scorerFunctionArn: pulumi.Output<string>;
}

/**
 * Recommendation engine infrastructure (Tier 2).
 *
 * Provisions:
 * - SQS FIFO queue for recommendation events (views, completions, bookmarks)
 * - DynamoDB tables for user preferences and action scores
 * - Lambda function that processes events and updates scores
 * - Dead-letter queue for failed event processing
 */
export class Recommendation
  extends pulumi.ComponentResource
  implements RecommendationOutputs
{
  public readonly eventQueueUrl: pulumi.Output<string>;
  public readonly eventQueueArn: pulumi.Output<string>;
  public readonly scoreTableName: pulumi.Output<string>;
  public readonly scorerFunctionArn: pulumi.Output<string>;

  constructor(
    name: string,
    args: RecommendationArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:aws:Recommendation", name, {}, opts);

    // -----------------------------------------------------------------------
    // Dead-letter queue — captures events that fail processing 3 times.
    // -----------------------------------------------------------------------
    const dlq = new aws.sqs.Queue(
      `${name}-dlq`,
      {
        fifoQueue: true,
        contentBasedDeduplication: true,
        messageRetentionSeconds: 1209600, // 14 days
        tags: { ...baseTags, Name: `${name}-dlq` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Event queue — receives recommendation events from Serverpod.
    // -----------------------------------------------------------------------
    const eventQueue = new aws.sqs.Queue(
      `${name}-events`,
      {
        fifoQueue: true,
        contentBasedDeduplication: true,
        visibilityTimeoutSeconds: 60,
        messageRetentionSeconds: 86400, // 1 day
        redrivePolicy: dlq.arn.apply((arn) =>
          JSON.stringify({
            deadLetterTargetArn: arn,
            maxReceiveCount: 3,
          }),
        ),
        tags: { ...baseTags, Name: `${name}-events` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // DynamoDB — user preferences table.
    // -----------------------------------------------------------------------
    const userPreferencesTable = new aws.dynamodb.Table(
      `${name}-user-prefs`,
      {
        billingMode: "PAY_PER_REQUEST",
        hashKey: "userId",
        attributes: [{ name: "userId", type: "S" }],
        pointInTimeRecovery: { enabled: isProduction },
        tags: { ...baseTags, Name: `${name}-user-prefs` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // DynamoDB — action scores table.
    // -----------------------------------------------------------------------
    const actionScoresTable = new aws.dynamodb.Table(
      `${name}-action-scores`,
      {
        billingMode: "PAY_PER_REQUEST",
        hashKey: "actionId",
        attributes: [
          { name: "actionId", type: "N" },
          { name: "trendingScore", type: "N" },
        ],
        globalSecondaryIndexes: [
          {
            name: "trending-index",
            hashKey: "actionId",
            rangeKey: "trendingScore",
            projectionType: "ALL",
          },
        ],
        pointInTimeRecovery: { enabled: isProduction },
        ttl: {
          attributeName: "expiresAt",
          enabled: true,
        },
        tags: { ...baseTags, Name: `${name}-action-scores` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Lambda execution role.
    // -----------------------------------------------------------------------
    const lambdaRole = new aws.iam.Role(
      `${name}-scorer-role`,
      {
        assumeRolePolicy: JSON.stringify({
          Version: "2012-10-17",
          Statement: [
            {
              Effect: "Allow",
              Principal: { Service: "lambda.amazonaws.com" },
              Action: "sts:AssumeRole",
            },
          ],
        }),
        tags: { ...baseTags, Name: `${name}-scorer-role` },
      },
      { parent: this },
    );

    new aws.iam.RolePolicyAttachment(
      `${name}-scorer-basic-exec`,
      {
        role: lambdaRole.name,
        policyArn:
          "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
      },
      { parent: this },
    );

    new aws.iam.RolePolicyAttachment(
      `${name}-scorer-vpc-access`,
      {
        role: lambdaRole.name,
        policyArn:
          "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
      },
      { parent: this },
    );

    new aws.iam.RolePolicy(
      `${name}-scorer-policy`,
      {
        role: lambdaRole.name,
        policy: pulumi
          .all([
            eventQueue.arn,
            dlq.arn,
            userPreferencesTable.arn,
            actionScoresTable.arn,
          ])
          .apply(([queueArn, dlqArn, userPrefsArn, actionScoresArn]) =>
            JSON.stringify({
              Version: "2012-10-17",
              Statement: [
                {
                  Effect: "Allow",
                  Action: [
                    "sqs:ReceiveMessage",
                    "sqs:DeleteMessage",
                    "sqs:GetQueueAttributes",
                  ],
                  Resource: [queueArn, dlqArn],
                },
                {
                  Effect: "Allow",
                  Action: [
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                    "dynamodb:UpdateItem",
                    "dynamodb:Query",
                    "dynamodb:BatchWriteItem",
                  ],
                  Resource: [
                    userPrefsArn,
                    actionScoresArn,
                    `${actionScoresArn}/index/*`,
                  ],
                },
              ],
            }),
          ),
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Security group for Lambda (VPC-attached for Redis access).
    // -----------------------------------------------------------------------
    const lambdaSg = new aws.ec2.SecurityGroup(
      `${name}-scorer-sg`,
      {
        vpcId: args.networkArgs.vpcId,
        description: "Allow recommendation scorer Lambda to reach Redis and RDS",
        egress: [
          {
            protocol: "-1",
            fromPort: 0,
            toPort: 0,
            cidrBlocks: ["0.0.0.0/0"],
          },
        ],
        tags: { ...baseTags, Name: `${name}-scorer-sg` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Log group for the scorer function.
    // -----------------------------------------------------------------------
    const logGroup = new aws.cloudwatch.LogGroup(
      `${name}-scorer-logs`,
      {
        retentionInDays: isProduction ? 30 : 7,
        tags: { ...baseTags, Name: `${name}-scorer-logs` },
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Lambda scorer function.
    //
    // The actual handler code is deployed separately (CI/CD builds a zip
    // from verily_server/functions/recommendation_scorer/). The Pulumi
    // resource defines the runtime envelope and permissions.
    // -----------------------------------------------------------------------
    const scorerFunction = new aws.lambda.Function(
      `${name}-scorer`,
      {
        runtime: "nodejs20.x",
        handler: "index.handler",
        role: lambdaRole.arn,
        timeout: 30,
        memorySize: 256,
        // Placeholder code — replaced by CI/CD pipeline on first deploy.
        code: new pulumi.asset.AssetArchive({
          "index.mjs": new pulumi.asset.StringAsset(
            `export const handler = async (event) => {
  console.log("Recommendation scorer placeholder — deploy handler via CI/CD");
  return { statusCode: 200, body: "ok" };
};`,
          ),
        }),
        environment: {
          variables: pulumi
            .all([
              args.redisHost,
              args.redisPort.apply(String),
              args.redisPassword ?? pulumi.output(""),
              args.dbHost,
              args.dbPort.apply(String),
              pulumi.output(args.dbName),
              pulumi.output(args.dbUser),
              args.dbPassword,
              userPreferencesTable.name,
              actionScoresTable.name,
              pulumi.output(environment),
            ])
            .apply(
              ([
                redisHost,
                redisPort,
                redisPassword,
                dbHost,
                dbPort,
                dbName,
                dbUser,
                dbPassword,
                userPrefsTable,
                actionScoresTableName,
                env,
              ]) => {
                const vars: Record<string, string> = {
                  REDIS_HOST: redisHost,
                  REDIS_PORT: redisPort,
                  DB_HOST: dbHost,
                  DB_PORT: dbPort,
                  DB_NAME: dbName,
                  DB_USER: dbUser,
                  DB_PASSWORD: dbPassword,
                  USER_PREFS_TABLE: userPrefsTable,
                  ACTION_SCORES_TABLE: actionScoresTableName,
                  ENVIRONMENT: env,
                };
                if (redisPassword) {
                  vars["REDIS_PASSWORD"] = redisPassword;
                }
                return vars;
              },
            ),
        },
        vpcConfig: {
          subnetIds: args.networkArgs.privateSubnetIds,
          securityGroupIds: [lambdaSg.id],
        },
        tags: { ...baseTags, Name: `${name}-scorer` },
      },
      { parent: this, dependsOn: [logGroup] },
    );

    // -----------------------------------------------------------------------
    // SQS → Lambda event source mapping.
    // -----------------------------------------------------------------------
    new aws.lambda.EventSourceMapping(
      `${name}-scorer-trigger`,
      {
        eventSourceArn: eventQueue.arn,
        functionName: scorerFunction.arn,
        batchSize: 10,
        maximumBatchingWindowInSeconds: 5,
        enabled: true,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // CloudWatch alarm for DLQ depth (ops visibility).
    // -----------------------------------------------------------------------
    new aws.cloudwatch.MetricAlarm(
      `${name}-dlq-alarm`,
      {
        comparisonOperator: "GreaterThanThreshold",
        evaluationPeriods: 1,
        metricName: "ApproximateNumberOfMessagesVisible",
        namespace: "AWS/SQS",
        period: 300,
        statistic: "Sum",
        threshold: 10,
        alarmDescription:
          "Recommendation event DLQ has unprocessed messages — check scorer Lambda logs",
        dimensions: { QueueName: dlq.name },
        tags: baseTags,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Outputs
    // -----------------------------------------------------------------------
    this.eventQueueUrl = eventQueue.url;
    this.eventQueueArn = eventQueue.arn;
    this.scoreTableName = actionScoresTable.name;
    this.scorerFunctionArn = scorerFunction.arn;

    this.registerOutputs({
      eventQueueUrl: this.eventQueueUrl,
      eventQueueArn: this.eventQueueArn,
      scoreTableName: this.scoreTableName,
      scorerFunctionArn: this.scorerFunctionArn,
    });
  }
}
