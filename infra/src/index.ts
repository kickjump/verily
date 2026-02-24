import { cloud } from "./config.js";
import type { DeploymentOutputs } from "./types.js";

async function main(): Promise<DeploymentOutputs> {
  switch (cloud) {
    case "aws": {
      const { deployAws } = await import("./aws/index.js");
      return deployAws();
    }
    case "gcp": {
      const { deployGcp } = await import("./gcp/index.js");
      return deployGcp();
    }
    default:
      throw new Error(
        `Unsupported cloud provider: "${cloud}". Must be "aws" or "gcp".`,
      );
  }
}

const outputs = main();

// Re-export all outputs at the stack level.
export const apiUrl = outputs.then((o) => o.apiUrl);
export const appUrl = outputs.then((o) => o.appUrl);
export const insightsUrl = outputs.then((o) => o.insightsUrl);
export const databaseHost = outputs.then((o) => o.databaseHost);
export const redisHost = outputs.then((o) => o.redisHost);
export const imageRepositoryUrl = outputs.then((o) => o.imageRepositoryUrl);
export const storageBucket = outputs.then((o) => o.storageBucket);
