import * as gcp from "@pulumi/gcp";
import * as pulumi from "@pulumi/pulumi";

import { environment, isProduction } from "../config.js";

const gcpConfig = new pulumi.Config("gcp");
const region = gcpConfig.require("region");
const project = gcpConfig.require("project");

export interface RecommendationArgs {
  networkSelfLink: pulumi.Input<string>;
  redisHost: pulumi.Output<string>;
  redisPort: pulumi.Output<number>;
  dbConnectionName: pulumi.Input<string>;
  dbHost: pulumi.Input<string>;
  dbName: string;
  dbUser: string;
  dbPassword: pulumi.Input<string>;
}

export interface RecommendationOutputs {
  eventTopicId: pulumi.Output<string>;
  scoreCollectionId: string;
  scorerFunctionUrl: pulumi.Output<string>;
}

/**
 * Recommendation engine infrastructure (Tier 2) — GCP variant.
 *
 * Provisions:
 * - Pub/Sub topic + subscription for recommendation events
 * - Firestore database for user preferences and action scores
 * - Cloud Function (2nd gen) that processes events and updates scores
 * - Dead-letter topic for failed event processing
 */
export class Recommendation
  extends pulumi.ComponentResource
  implements RecommendationOutputs
{
  public readonly eventTopicId: pulumi.Output<string>;
  public readonly scoreCollectionId: string;
  public readonly scorerFunctionUrl: pulumi.Output<string>;

  constructor(
    name: string,
    args: RecommendationArgs,
    opts?: pulumi.ComponentResourceOptions,
  ) {
    super("verily:gcp:Recommendation", name, {}, opts);

    const labels = {
      project: "verily",
      environment,
      managed_by: "pulumi",
    };

    // -----------------------------------------------------------------------
    // Dead-letter topic — captures events that fail processing.
    // -----------------------------------------------------------------------
    const dlTopic = new gcp.pubsub.Topic(
      `${name}-dl-topic`,
      {
        name: `verily-${environment}-recommendation-dlq`,
        messageRetentionDuration: "1209600s", // 14 days
        labels,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Event topic — receives recommendation events from Serverpod.
    // -----------------------------------------------------------------------
    const eventTopic = new gcp.pubsub.Topic(
      `${name}-events`,
      {
        name: `verily-${environment}-recommendation-events`,
        messageRetentionDuration: "86400s", // 1 day
        labels,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Subscription with dead-letter policy and retry.
    // -----------------------------------------------------------------------
    new gcp.pubsub.Subscription(
      `${name}-events-sub`,
      {
        name: `verily-${environment}-recommendation-events-sub`,
        topic: eventTopic.name,
        ackDeadlineSeconds: 60,
        retryPolicy: {
          minimumBackoff: "10s",
          maximumBackoff: "600s",
        },
        deadLetterPolicy: {
          deadLetterTopic: dlTopic.id,
          maxDeliveryAttempts: 5,
        },
        labels,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Firestore database for recommendation scores.
    //
    // Collections:
    //   - userPreferences/{userId}  — category weights, recent history
    //   - actionScores/{actionId}   — trending score, view/completion counts
    // -----------------------------------------------------------------------
    const firestoreDb = new gcp.firestore.Database(
      `${name}-firestore`,
      {
        name: `verily-${environment}-recommendations`,
        locationId: region,
        type: "FIRESTORE_NATIVE",
        concurrencyMode: "PESSIMISTIC",
        deleteProtectionState: isProduction
          ? "DELETE_PROTECTION_ENABLED"
          : "DELETE_PROTECTION_DISABLED",
      },
      { parent: this },
    );

    // TTL policy on action scores so stale entries self-clean.
    new gcp.firestore.Field(
      `${name}-action-scores-ttl`,
      {
        database: firestoreDb.name,
        collection: "actionScores",
        field: "expiresAt",
        ttlConfig: {},
      },
      { parent: this },
    );

    // Composite index: query action scores ordered by trending score.
    new gcp.firestore.Index(
      `${name}-action-scores-trending-idx`,
      {
        database: firestoreDb.name,
        collection: "actionScores",
        fields: [
          { fieldPath: "status", order: "ASCENDING" },
          { fieldPath: "trendingScore", order: "DESCENDING" },
        ],
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Service account for the scorer function.
    // -----------------------------------------------------------------------
    const scorerSa = new gcp.serviceaccount.Account(
      `${name}-scorer-sa`,
      {
        accountId: `verily-${environment}-scorer`,
        displayName: `Verily ${environment} recommendation scorer`,
      },
      { parent: this },
    );

    // Pub/Sub subscriber — read events.
    new gcp.projects.IAMMember(
      `${name}-scorer-pubsub`,
      {
        project,
        role: "roles/pubsub.subscriber",
        member: scorerSa.email.apply((email) => `serviceAccount:${email}`),
      },
      { parent: this },
    );

    // Firestore read/write — update scores.
    new gcp.projects.IAMMember(
      `${name}-scorer-firestore`,
      {
        project,
        role: "roles/datastore.user",
        member: scorerSa.email.apply((email) => `serviceAccount:${email}`),
      },
      { parent: this },
    );

    // Cloud SQL client — read action/user data for scoring.
    new gcp.projects.IAMMember(
      `${name}-scorer-sql`,
      {
        project,
        role: "roles/cloudsql.client",
        member: scorerSa.email.apply((email) => `serviceAccount:${email}`),
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Cloud Storage bucket for function source code.
    // -----------------------------------------------------------------------
    const functionBucket = new gcp.storage.Bucket(
      `${name}-fn-source`,
      {
        name: `verily-${environment}-recommendation-fn-source`,
        location: region,
        uniformBucketLevelAccess: true,
        labels,
      },
      { parent: this },
    );

    // Placeholder source — replaced by CI/CD on first real deploy.
    const functionSource = new gcp.storage.BucketObject(
      `${name}-fn-source-obj`,
      {
        bucket: functionBucket.name,
        name: "recommendation-scorer-placeholder.zip",
        content: "placeholder",
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Cloud Function (2nd gen) — recommendation scorer.
    // -----------------------------------------------------------------------
    const scorerFunction = new gcp.cloudfunctionsv2.Function(
      `${name}-scorer`,
      {
        name: `verily-${environment}-recommendation-scorer`,
        location: region,
        buildConfig: {
          runtime: "nodejs20",
          entryPoint: "handleEvent",
          source: {
            storageSource: {
              bucket: functionBucket.name,
              object: functionSource.name,
            },
          },
        },
        serviceConfig: {
          maxInstanceCount: isProduction ? 10 : 2,
          minInstanceCount: 0,
          availableMemory: "256Mi",
          timeoutSeconds: 60,
          serviceAccountEmail: scorerSa.email,
          environmentVariables: pulumi
            .all([
              args.redisHost,
              args.redisPort.apply(String),
              args.dbHost,
              pulumi.output(args.dbName),
              pulumi.output(args.dbUser),
              args.dbPassword,
              args.dbConnectionName,
              firestoreDb.name,
              pulumi.output(environment),
            ])
            .apply(
              ([
                redisHost,
                redisPort,
                dbHost,
                dbName,
                dbUser,
                dbPassword,
                dbConnectionName,
                firestoreDbName,
                env,
              ]) => ({
                REDIS_HOST: redisHost,
                REDIS_PORT: redisPort,
                DB_HOST: dbHost,
                DB_NAME: dbName,
                DB_USER: dbUser,
                DB_PASSWORD: dbPassword,
                DB_CONNECTION_NAME: dbConnectionName,
                FIRESTORE_DATABASE: firestoreDbName,
                ENVIRONMENT: env,
              }),
            ),
          vpcConnector: `projects/${project}/locations/${region}/connectors/verily-${environment}`,
          vpcConnectorEgressSettings: "PRIVATE_RANGES_ONLY",
        },
        eventTrigger: {
          triggerRegion: region,
          eventType: "google.cloud.pubsub.topic.v1.messagePublished",
          pubsubTopic: eventTopic.id,
          retryPolicy: "RETRY",
          serviceAccountEmail: scorerSa.email,
        },
        labels,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Monitoring — alert on DLQ message buildup.
    // -----------------------------------------------------------------------
    new gcp.monitoring.AlertPolicy(
      `${name}-dlq-alert`,
      {
        displayName: `Verily ${environment} — Recommendation DLQ depth`,
        combiner: "OR",
        conditions: [
          {
            displayName: "DLQ messages > 10",
            conditionThreshold: {
              filter: pulumi.interpolate`resource.type="pubsub_topic" AND resource.labels.topic_id="${dlTopic.name}"`,
              comparison: "COMPARISON_GT",
              thresholdValue: 10,
              duration: "300s",
              aggregations: [
                {
                  alignmentPeriod: "300s",
                  perSeriesAligner: "ALIGN_RATE",
                },
              ],
            },
          },
        ],
        enabled: true,
      },
      { parent: this },
    );

    // -----------------------------------------------------------------------
    // Outputs
    // -----------------------------------------------------------------------
    this.eventTopicId = eventTopic.id;
    this.scoreCollectionId = `verily-${environment}-recommendations`;
    this.scorerFunctionUrl = scorerFunction.serviceConfig.apply(
      (sc) => sc?.uri ?? "",
    );

    this.registerOutputs({
      eventTopicId: this.eventTopicId,
      scoreCollectionId: this.scoreCollectionId,
      scorerFunctionUrl: this.scorerFunctionUrl,
    });
  }
}
