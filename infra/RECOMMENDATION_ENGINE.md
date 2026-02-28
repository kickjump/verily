# Recommendation Engine — Design & Infrastructure

## Overview

A world-class recommendation engine for Verily's two-sided marketplace, designed
to surface the most relevant actions to each user. The system progresses through
three tiers — each building on the previous — so the MVP ships fast while the
architecture scales gracefully.

---

## Tier 1 — Weighted Scoring (MVP, no new infra)

Uses existing PostgreSQL + Redis to compute a composite relevance score per
action. This runs entirely inside Serverpod and requires **zero** new
infrastructure.

### Scoring Formula

```
score = w_proximity  * proximity_score
      + w_recency    * recency_score
      + w_reward     * reward_score
      + w_popularity * popularity_score
      + w_category   * category_affinity_score
      + w_social     * social_score
```

| Signal             | Source                    | How to Compute                                                    |
| ------------------ | ------------------------- | ----------------------------------------------------------------- |
| **Proximity**      | PostGIS `ST_DWithin`      | `1 - (distance / max_radius)`, clamped to [0, 1]                 |
| **Recency**        | `action.createdAt`        | Exponential decay: `exp(-λ * hours_since_creation)`               |
| **Reward value**   | `reward_pool.totalAmount` | Log-normalized: `log(1 + amount) / log(1 + max_amount)`          |
| **Popularity**     | `action_submission` count | `min(submission_count / saturation_point, 1.0)`                   |
| **Category affinity** | User's past completions | Fraction of user's completions in this category                   |
| **Social**         | `user_follow` graph       | `1.0` if created by someone the user follows, `0.0` otherwise    |

Default weights (tune with A/B tests):

```
w_proximity  = 0.30
w_recency    = 0.20
w_reward     = 0.15
w_popularity = 0.15
w_category   = 0.10
w_social     = 0.10
```

### Implementation

1. **PostgreSQL materialized view** — pre-computes popularity and reward scores
   for all active actions, refreshed every 5 minutes via `REFRESH MATERIALIZED
   VIEW CONCURRENTLY`.
2. **Redis sorted sets** — `trending:{region}` keys hold action IDs scored by
   rolling 24-hour interaction counts. The existing ElastiCache / Memorystore
   cluster handles this with no new resources.
3. **Serverpod scheduled task** — runs every 5 minutes, refreshes the
   materialized view and updates Redis sorted sets.

---

## Tier 2 — Event-Driven Scoring (MVP+, minimal new infra)

Adds real-time signal processing so recommendations update within seconds of
user interactions instead of waiting for the 5-minute refresh cycle.

### New Infrastructure

| Resource                     | AWS                                 | GCP                                   |
| ---------------------------- | ----------------------------------- | ------------------------------------- |
| **Event queue**              | SQS FIFO queue                      | Pub/Sub topic + subscription          |
| **Event processor**          | Lambda (Node.js / Python)           | Cloud Functions (2nd gen)             |
| **Score store**              | DynamoDB table                      | Firestore collection                  |
| **Scorer IAM**               | Lambda execution role + policies    | Service account + IAM bindings        |

### Event Flow

```
User interaction (view, complete, bookmark)
  → Serverpod publishes event to SQS / Pub/Sub
  → Lambda / Cloud Function processes event
    → Updates user preference vector in DynamoDB / Firestore
    → Updates action popularity counters in DynamoDB / Firestore
    → Writes updated scores to Redis sorted sets
  → Next feed request reads from Redis (fast path)
    or falls back to DynamoDB / Firestore (cold start)
```

### Event Schema

```json
{
  "eventType": "action_viewed | action_completed | action_bookmarked | action_shared",
  "userId": "uuid",
  "actionId": 123,
  "categoryId": 4,
  "location": { "lat": 37.78, "lng": -122.41 },
  "timestamp": "2026-02-28T12:00:00Z",
  "metadata": {}
}
```

### DynamoDB / Firestore Schema

**UserPreferences** (partition key: `userId`)
```json
{
  "userId": "uuid",
  "categoryWeights": { "fitness": 0.4, "environment": 0.3, ... },
  "recentCategories": ["fitness", "community"],
  "homeLocation": { "lat": 37.78, "lng": -122.41 },
  "completedActionIds": [1, 5, 23],
  "lastUpdated": "2026-02-28T12:00:00Z"
}
```

**ActionScores** (partition key: `actionId`)
```json
{
  "actionId": 123,
  "viewCount24h": 42,
  "completionCount24h": 7,
  "totalCompletions": 156,
  "trendingScore": 0.87,
  "lastUpdated": "2026-02-28T12:00:00Z"
}
```

---

## Tier 3 — ML Personalization (Scale Phase)

When there are enough users and actions to justify it, add embedding-based
personalization. Not needed for MVP but the Tier 2 event pipeline feeds directly
into this.

| Resource                     | AWS                                | GCP                                |
| ---------------------------- | ---------------------------------- | ---------------------------------- |
| **Embedding model**          | SageMaker (real-time endpoint)     | Vertex AI (online prediction)      |
| **Vector store**             | OpenSearch Serverless               | Vertex AI Vector Search            |
| **Training pipeline**        | SageMaker Pipeline                 | Vertex AI Pipeline                 |

### How It Works

1. Train a two-tower model: user embedding + action embedding.
2. Pre-compute action embeddings, store in vector index.
3. At request time, compute user embedding → ANN lookup → re-rank with Tier 1
   scoring signals.
4. Retrain weekly on new interaction data from the Tier 2 event store.

---

## Tips for a World-Class Recommendation Engine

### 1. Start Simple, Measure Everything

Ship the weighted scoring formula first. Instrument every recommendation
surface with impression and click tracking. You need data before ML adds value.

### 2. Diversity > Pure Relevance

Always mix in exploration actions (random high-quality actions the user hasn't
seen). A feed of 100% "relevant" content creates filter bubbles and kills
discovery. Target ~20% exploration in the MVP feed.

### 3. Use PostGIS Aggressively

The `listNearby` method currently fetches all locations into memory. Switch to
`ST_DWithin` queries — they use spatial indexes and are orders of magnitude
faster. Proximity is the single strongest signal for a location-based
marketplace.

### 4. Time-Decay Is Critical

Actions in a marketplace have a shelf life. An action posted 30 days ago with
no completions is stale. Use exponential decay (`exp(-0.05 * hours)`) so the
feed naturally refreshes.

### 5. Reward Value Is a Quality Signal

Actions with funded reward pools have skin-in-the-game creators. Weight
reward-backed actions higher — they convert better and attract more performers.

### 6. Social Graph = Trust Layer

"Someone you follow created this action" is one of the strongest engagement
signals on any marketplace. The `user_follow` table is already there — use it.

### 7. Redis Sorted Sets for Real-Time Trending

Your existing Redis cluster can power trending feeds with zero additional cost.
Use `ZINCRBY` on view/completion events, `ZRANGEBYSCORE` to fetch, and
`ZREMRANGEBYSCORE` to expire old entries.

### 8. A/B Test the Weights

The scoring weights are the most important tuning knob. Build a simple A/B
framework that assigns users to weight configurations and measures
completion rate (not click rate — you want actions completed, not just viewed).

### 9. Cold Start Strategy

New users have no history. Use these fallbacks in order:
1. Location-based (nearby actions)
2. Trending (globally popular)
3. Reward-backed (highest reward pool)
4. Category diversity (one from each top category)

### 10. Candidate Generation + Re-Ranking

Even at scale, use a two-phase approach:
1. **Candidate generation**: PostgreSQL query pulls ~200 eligible actions
   (active, nearby, not completed by user)
2. **Re-ranking**: Apply the scoring formula to rank the 200 candidates
3. **Diversification**: Ensure no single category dominates the top 10

---

## Infrastructure Mapping Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    Pulumi Resources                          │
├──────────────────────┬──────────────────────────────────────┤
│  Tier 1 (MVP)        │  No new infra — uses existing:       │
│                      │  • PostgreSQL (materialized views)    │
│                      │  • Redis (sorted sets for trending)   │
│                      │  • ECS / Cloud Run (Serverpod tasks)  │
├──────────────────────┼──────────────────────────────────────┤
│  Tier 2 (MVP+)       │  New Pulumi components:               │
│                      │  • SQS FIFO / Pub/Sub (event queue)   │
│                      │  • Lambda / Cloud Function (scorer)   │
│                      │  • DynamoDB / Firestore (score store) │
│                      │  • IAM roles + policies               │
├──────────────────────┼──────────────────────────────────────┤
│  Tier 3 (Scale)      │  Future additions:                    │
│                      │  • SageMaker / Vertex AI (embeddings) │
│                      │  • OpenSearch / Vector Search (ANN)   │
│                      │  • Training pipeline infra            │
└──────────────────────┴──────────────────────────────────────┘
```
