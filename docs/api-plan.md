# Verily Expanded API Plan — Backend & Frontend

## Vision

Verily is a two-sided marketplace for real-world action verification with blockchain-backed rewards. Users create actions (challenges) with reward pools; performers complete them and submit video proof; Gemini 2.0 Flash AI verifies the video; verified performers receive Solana-based rewards (SPL tokens, NFTs, or badge points).

---

## 1. Solana Integration

### 1.1 Architecture

```
┌─────────────┐      ┌──────────────────┐      ┌────────────────┐
│  Flutter App │─────▶│  Serverpod API   │─────▶│  Solana RPC    │
│  (solana_kit)│◀─────│  (SolanaService) │◀─────│  (devnet/main) │
└─────────────┘      └──────────────────┘      └────────────────┘
       │                      │
       ▼                      ▼
  Mobile Wallet          Server Wallet
  Adapter (MWA)         (Custodial keypair)
```

### 1.2 Backend API — SolanaService

**New Model: `SolanaWallet` (.spy.yaml)**

| Field | Type | Description |
|-------|------|-------------|
| id | int (PK) | Auto-increment |
| userId | UuidValue | FK to auth user |
| publicKey | String | Solana public key (base58) |
| walletType | String | `custodial` or `external` |
| isDefault | bool | Default wallet for rewards |
| label | String? | User-defined label |
| createdAt | DateTime | |

**New Model: `RewardPool` (.spy.yaml)**

| Field | Type | Description |
|-------|------|-------------|
| id | int (PK) | Auto-increment |
| actionId | int | FK to action |
| creatorId | UuidValue | Who funded the pool |
| rewardType | String | `sol`, `spl_token`, `nft`, `points` |
| tokenMintAddress | String? | SPL token mint (null for SOL/points) |
| totalAmount | double | Total pool size |
| remainingAmount | double | Remaining to distribute |
| perPersonAmount | double | Amount per verified performer |
| maxRecipients | int? | Cap on total recipients |
| expiresAt | DateTime? | Pool expiration |
| platformFeePercent | double | Marketplace cut (default 5%) |
| status | String | `active`, `depleted`, `expired`, `cancelled` |
| fundingTxSignature | String? | On-chain funding tx |
| createdAt | DateTime | |

**New Model: `RewardDistribution` (.spy.yaml)**

| Field | Type | Description |
|-------|------|-------------|
| id | int (PK) | Auto-increment |
| rewardPoolId | int | FK to reward_pool |
| recipientId | UuidValue | User who earned it |
| submissionId | int | FK to action_submission |
| amount | double | Amount distributed |
| txSignature | String? | On-chain tx signature |
| status | String | `pending`, `sent`, `confirmed`, `failed` |
| createdAt | DateTime | |

**SolanaService Methods:**

```dart
class SolanaService {
  /// Generate a custodial keypair for a new user.
  static Future<SolanaWallet> createCustodialWallet(Session, {UuidValue userId});

  /// Link an external wallet (user provides public key).
  static Future<SolanaWallet> linkExternalWallet(Session, {UuidValue userId, String publicKey});

  /// Get user's default wallet.
  static Future<SolanaWallet?> getDefaultWallet(Session, {UuidValue userId});

  /// Get SOL balance for a wallet.
  static Future<double> getBalance(Session, {String publicKey});

  /// Get SPL token balance.
  static Future<double> getTokenBalance(Session, {String publicKey, String mintAddress});

  /// Distribute reward from pool to performer.
  static Future<RewardDistribution> distributeReward(Session, {
    int rewardPoolId, UuidValue recipientId, int submissionId,
  });

  /// Fund a reward pool (creator sends SOL/tokens to escrow).
  static Future<String> fundRewardPool(Session, {int rewardPoolId, String fundingTxSignature});

  /// Mint an NFT badge for action completion.
  static Future<String> mintBadgeNft(Session, {
    UuidValue recipientId, int actionId, String metadataUri,
  });

  /// Check pool status and expire if needed.
  static Future<void> processExpiredPools(Session);
}
```

**SolanaEndpoint:**

| Method | Description |
|--------|-------------|
| `createWallet()` | Create custodial wallet for authenticated user |
| `linkWallet(publicKey)` | Link external wallet |
| `getWallets()` | List user's wallets |
| `setDefaultWallet(walletId)` | Set default reward wallet |
| `getBalance()` | Get default wallet balance |

**RewardPoolEndpoint:**

| Method | Description |
|--------|-------------|
| `create(actionId, rewardType, ...)` | Create and fund a reward pool |
| `get(poolId)` | Get pool details |
| `listByAction(actionId)` | List pools for an action |
| `listByCreator()` | List pools created by user |
| `cancel(poolId)` | Cancel and refund remaining |
| `getDistributions(poolId)` | List all distributions |

### 1.3 Frontend API — Solana Providers

```dart
// Wallet management
@riverpod
Future<List<SolanaWallet>> userWallets(ref);

@riverpod
Future<double> walletBalance(ref, {String? publicKey});

// Reward pools
@riverpod
Future<List<RewardPool>> actionRewardPools(ref, {required int actionId});

@riverpod
Future<RewardPool> rewardPool(ref, {required int poolId});

// Distribution status
@riverpod
Future<List<RewardDistribution>> rewardDistributions(ref, {required int poolId});
```

### 1.4 Frontend Screens

| Screen | Purpose |
|--------|---------|
| `WalletScreen` | View balances, manage wallets, link external |
| `CreateRewardPoolScreen` | Fund action with SOL/tokens/NFT rewards |
| `RewardPoolDetailScreen` | View pool status, distributions |
| `WalletSetupScreen` | Initial wallet creation during onboarding |

---

## 2. AI Action Creation

### 2.1 Backend API — AiActionService

Uses Gemini to transform natural language descriptions into structured actions.

```dart
class AiActionService {
  /// Generate a structured action from natural language.
  static Future<AiGeneratedAction> generateAction(Session, {
    required String description,
    double? latitude,
    double? longitude,
  });

  /// Generate verification criteria for an action.
  static Future<String> generateVerificationCriteria(Session, {
    required String actionTitle,
    required String actionDescription,
  });

  /// Suggest nearby locations for an action.
  static Future<List<SuggestedLocation>> suggestLocations(Session, {
    required String actionDescription,
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  });

  /// Generate step breakdown for sequential actions.
  static Future<List<AiGeneratedStep>> generateSteps(Session, {
    required String actionTitle,
    required String actionDescription,
    required int numberOfSteps,
  });
}
```

**Response Models (in verily_core):**

```dart
@freezed
class AiGeneratedAction with _$AiGeneratedAction {
  const factory AiGeneratedAction({
    required String title,
    required String description,
    required String actionType,         // oneOff or sequential
    required String verificationCriteria,
    required String suggestedCategory,
    int? suggestedSteps,
    int? suggestedIntervalDays,
    List<String>? suggestedTags,
    AiGeneratedLocation? suggestedLocation,
  }) = _AiGeneratedAction;
}

@freezed
class AiGeneratedLocation with _$AiGeneratedLocation {
  const factory AiGeneratedLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double suggestedRadiusMeters,
  }) = _AiGeneratedLocation;
}

@freezed
class AiGeneratedStep with _$AiGeneratedStep {
  const factory AiGeneratedStep({
    required int stepNumber,
    required String title,
    required String description,
    required String verificationCriteria,
  }) = _AiGeneratedStep;
}
```

**AiActionEndpoint:**

| Method | Description |
|--------|-------------|
| `generate(description, lat?, lng?)` | Generate action from text |
| `generateCriteria(title, description)` | Generate verification criteria |
| `suggestLocations(description, lat, lng)` | Suggest nearby locations |
| `generateSteps(title, description, count)` | Generate sequential steps |

### 2.2 Frontend — AI Action Creation Flow

```
[Text Input] → [AI generates action] → [User reviews/edits] → [Add reward pool] → [Publish]
```

**Providers:**

```dart
@riverpod
class AiActionGenerator extends _$AiActionGenerator {
  Future<AiGeneratedAction> generate(String description, {GeoPoint? location});
  Future<List<SuggestedLocation>> suggestLocations(String description, GeoPoint location);
  Future<List<AiGeneratedStep>> generateSteps(String title, String description, int count);
}
```

**Updated CreateActionScreen Flow:**

1. User types natural language description (e.g., "Do 20 push-ups at the park near Tower Bridge")
2. AI parses → title, description, category, location, verification criteria
3. User reviews and edits the generated fields
4. User optionally adds a reward pool (SOL/tokens/NFT)
5. User publishes the action

---

## 3. Device Attestation

### 3.1 Backend API — AttestationService

```dart
class AttestationService {
  /// Generate a server nonce for video recording session.
  static Future<AttestationChallenge> createChallenge(Session, {
    required UuidValue userId,
    required int actionId,
  });

  /// Verify Play Integrity token (Android).
  static Future<AttestationResult> verifyPlayIntegrity(Session, {
    required String integrityToken,
    required String nonce,
  });

  /// Verify App Attest assertion (iOS).
  static Future<AttestationResult> verifyAppAttest(Session, {
    required String attestationObject,
    required String clientDataHash,
    required String keyId,
  });

  /// Validate video nonce presence (via Gemini).
  static Future<bool> verifyVideoNonce(Session, {
    required String videoUrl,
    required String expectedNonce,
  });
}
```

**New Model: `AttestationChallenge` (.spy.yaml)**

| Field | Type | Description |
|-------|------|-------------|
| id | int (PK) | |
| userId | UuidValue | |
| actionId | int | |
| nonce | String | Random 6-char code |
| visualNonce | String? | Color/shape description for video |
| expiresAt | DateTime | 5 minutes from creation |
| used | bool | Whether challenge was consumed |
| createdAt | DateTime | |

**New Model: `DeviceAttestation` (.spy.yaml)**

| Field | Type | Description |
|-------|------|-------------|
| id | int (PK) | |
| submissionId | int | FK to action_submission |
| platform | String | `ios` or `android` |
| attestationType | String | `play_integrity` or `app_attest` |
| verified | bool | |
| rawResult | String? | JSON attestation response |
| createdAt | DateTime | |

**AttestationEndpoint:**

| Method | Description |
|--------|-------------|
| `createChallenge(actionId)` | Get nonce for recording session |
| `submitAttestation(submissionId, token, platform)` | Submit platform attestation |

### 3.2 Frontend — Attestation Flow

1. Before recording, app requests challenge nonce from server
2. Nonce displayed as overlay during video recording
3. After recording, app collects Play Integrity / App Attest token
4. Token submitted alongside video
5. Server verifies attestation + Gemini verifies nonce in video

**Providers:**

```dart
@riverpod
class AttestationManager extends _$AttestationManager {
  Future<AttestationChallenge> requestChallenge(int actionId);
  Future<void> submitAttestation(int submissionId);
}
```

---

## 4. Updated Verification Pipeline

### 4.1 Enhanced Flow

```
1. User taps "Record" on action
2. App requests attestation challenge (nonce) from server
3. Nonce overlay displayed during recording
4. After recording:
   a. Collect device attestation token (Play Integrity / App Attest)
   b. Collect GPS coordinates
   c. Collect device metadata
5. Upload video to server
6. Submit: video + attestation token + nonce + GPS + metadata
7. Server pipeline:
   a. Verify device attestation (Play Integrity / App Attest)
   b. Verify GPS against action location
   c. Send video to Gemini with enhanced prompt:
      - Standard action verification
      - Nonce verification (look for displayed code)
      - Forensic analysis
   d. Create VerificationResult
   e. If passed:
      - Grant badge rewards
      - Distribute Solana rewards from pool
      - Update pool remaining amount
   f. Update submission status
```

### 4.2 Updated ActionSubmission Model

Add fields to existing model:

| New Field | Type | Description |
|-----------|------|-------------|
| attestationChallengeId | int? | FK to attestation_challenge |
| attestationVerified | bool? | Platform attestation passed |
| nonceVerified | bool? | Visual nonce found in video |

### 4.3 Updated VerificationResult Model

Add fields:

| New Field | Type | Description |
|-----------|------|-------------|
| nonceDetected | bool? | Whether nonce was seen |
| attestationStatus | String? | Platform attestation status |

---

## 5. Updated Reward System

### 5.1 Reward Types

| Type | Description | Backend | Blockchain |
|------|-------------|---------|------------|
| `points` | Platform points (leaderboard) | Database only | No |
| `badge` | Achievement badge | Database + optional NFT | Optional |
| `sol` | SOL transfer | Database + on-chain | Yes |
| `spl_token` | SPL token transfer | Database + on-chain | Yes |
| `nft` | NFT mint | Database + on-chain | Yes |

### 5.2 Reward Distribution Flow

```
Verification passes
       │
       ▼
 Grant badge rewards (existing)
       │
       ▼
 Check reward pools for action
       │
       ▼
 For each active, non-depleted pool:
   ├─ Deduct perPersonAmount from remaining
   ├─ Deduct platformFeePercent to platform wallet
   ├─ Send remaining to performer's default wallet
   ├─ Record RewardDistribution
   └─ If pool depleted, update status
```

---

## 6. API Summary

### 6.1 New Endpoints

| Endpoint | Auth | Methods |
|----------|------|---------|
| `SolanaEndpoint` | Required | createWallet, linkWallet, getWallets, setDefaultWallet, getBalance |
| `RewardPoolEndpoint` | Required | create, get, listByAction, listByCreator, cancel, getDistributions |
| `AiActionEndpoint` | Required | generate, generateCriteria, suggestLocations, generateSteps |
| `AttestationEndpoint` | Required | createChallenge, submitAttestation |

### 6.2 New Models (Serverpod .spy.yaml)

| Model | Table |
|-------|-------|
| `SolanaWallet` | `solana_wallet` |
| `RewardPool` | `reward_pool` |
| `RewardDistribution` | `reward_distribution` |
| `AttestationChallenge` | `attestation_challenge` |
| `DeviceAttestation` | `device_attestation` |

### 6.3 New Core Models (Freezed)

| Model | Package |
|-------|---------|
| `AiGeneratedAction` | verily_core |
| `AiGeneratedLocation` | verily_core |
| `AiGeneratedStep` | verily_core |
| `SuggestedLocation` | verily_core |
| `RewardType` enum | verily_core |
| `PoolStatus` enum | verily_core |
| `DistributionStatus` enum | verily_core |
| `AttestationType` enum | verily_core |

### 6.4 New Services

| Service | Responsibility |
|---------|---------------|
| `SolanaService` | Wallet ops, token transfers, NFT minting |
| `RewardPoolService` | Pool lifecycle, distribution logic |
| `AiActionService` | Gemini-powered action generation |
| `AttestationService` | Challenge creation, platform verification |

### 6.5 New Flutter Providers

| Provider | Type |
|----------|------|
| `userWalletsProvider` | AsyncNotifier |
| `walletBalanceProvider` | Future (family) |
| `actionRewardPoolsProvider` | Future (family) |
| `aiActionGeneratorProvider` | AsyncNotifier |
| `attestationManagerProvider` | AsyncNotifier |

### 6.6 New/Updated Flutter Screens

| Screen | Status |
|--------|--------|
| `WalletScreen` | New |
| `WalletSetupScreen` | New |
| `CreateRewardPoolScreen` | New |
| `RewardPoolDetailScreen` | New |
| Updated `CreateActionScreen` | AI generation flow |
| Updated `VideoRecordingScreen` | Nonce overlay, attestation |
| Updated `SubmissionStatusScreen` | Reward distribution status |
| Updated `ProfileScreen` | Wallet balance, token rewards |

---

## 7. Dependencies

### 7.1 Server

```yaml
# Existing
google_generative_ai: ^0.4.6
serverpod: 3.3.1

# New
solana_kit:
  git:
    url: https://github.com/openbudgetfun/solana_kit
    path: packages/solana_kit
```

### 7.2 App

```yaml
# Existing
camera: 0.11.1
geolocator: 14.0.0

# New
solana_kit:
  git:
    url: https://github.com/openbudgetfun/solana_kit
    path: packages/solana_kit
solana_kit_mobile_wallet_adapter:
  git:
    url: https://github.com/openbudgetfun/solana_kit
    path: packages/solana_kit_mobile_wallet_adapter
```

---

## 8. Implementation Sequence

1. Add new core enums and Freezed models (verily_core)
2. Add new .spy.yaml models (verily_server)
3. Add solana_kit dependency to server and app
4. Implement SolanaService
5. Implement RewardPoolService
6. Implement AiActionService
7. Implement AttestationService
8. Add new endpoints (Solana, RewardPool, AiAction, Attestation)
9. Update existing services (SubmissionService, VerificationService, RewardService)
10. Add Flutter providers for new features
11. Add new screens (Wallet, RewardPool, AI creation)
12. Update existing screens (CreateAction, VideoRecording, Profile)
13. Add tests for all new services and screens
14. Update CI workflows
