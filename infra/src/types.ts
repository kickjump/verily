import type * as pulumi from "@pulumi/pulumi";

/**
 * Outputs that every cloud deployment must produce. These are exported from
 * the stack so that CI/CD pipelines and other stacks can consume them.
 */
export interface DeploymentOutputs {
  /** The API endpoint URL. */
  apiUrl: pulumi.Output<string>;
  /** The web app endpoint URL. */
  appUrl: pulumi.Output<string>;
  /** The Serverpod Insights endpoint URL. */
  insightsUrl: pulumi.Output<string>;
  /** Database connection host (private). */
  databaseHost: pulumi.Output<string>;
  /** Redis connection host (private). */
  redisHost: pulumi.Output<string>;
  /** Container image repository URI. */
  imageRepositoryUrl: pulumi.Output<string>;
  /** File storage bucket name. */
  storageBucket: pulumi.Output<string>;
  /** Recommendation event queue URL (SQS) or topic ID (Pub/Sub). */
  recommendationEventQueue: pulumi.Output<string>;
  /** Recommendation scorer function ARN (Lambda) or URL (Cloud Function). */
  recommendationScorerEndpoint: pulumi.Output<string>;
}
