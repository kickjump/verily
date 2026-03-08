# Verily MVP Implementation Plan

## Goal

## LLM Provider Strategy Gate (Mandatory for 1-hour production tasks)

Before implementation starts for any ~1 hour production-impacting task, complete and attach:

1. Claude design artifact: `docs/research/claude/<task-slug>.md`
2. Gemini Google-model best-practice notes: `docs/research/gemini/<task-slug>.md`
3. Codex implementation + verification evidence in PR checklist

Workflow details and checklist source of truth: `docs/llm-provider-strategy.md`.

Build a fully polished MVP with two core flows: (1) Performers browse/complete actions and earn crypto rewards, (2) Creators build actions via voice/text and fund them with crypto. Target: Android Seeker (Solana phone) as primary device.

---

## Phase 1: Solana Kit Integration & Wallet Auth

### 1.1 Add `solana_kit` dependency

- Add `solana_kit: 0.2.1` to `verily_app/pubspec.yaml` (exact version, no caret)
- Add `solana_kit: ^0.2.1` to `verily_server/pubspec.yaml`
- Run `dart pub get` in workspace root

### 1.2 Mobile Wallet Adapter (Android-only)

- Create `verily_app/lib/src/features/auth/solana_wallet_auth_provider.dart`:
  - Riverpod provider wrapping MWA protocol from `solana_kit_mobile_wallet_adapter_protocol`
  - Platform check: only expose on Android (`Platform.isAndroid` or `defaultTargetPlatform == TargetPlatform.android`)
  - Connect to wallet app → authorize → get public key
  - On iOS/web/desktop: provider returns null/unsupported state
- Create `verily_app/lib/src/features/auth/wallet_login_button.dart`:
  - "Connect Wallet" button only visible on Android
  - Uses `solana_wallet_auth_provider` to initiate MWA flow
  - On success: calls server endpoint to register/login via public key

### 1.3 Server: Wallet-based auth

- Add `auth_wallet_endpoint.dart` in server endpoints:
  - `loginWithWallet(session, publicKey, signedMessage, signature)` — verify signature, create/find user, return session
  - Challenge-response: server sends nonce, client signs with wallet, server verifies Ed25519 signature
- Extend `SolanaService` to use `solana_kit` for:
  - Ed25519 signature verification
  - Real keypair generation for custodial wallets
  - RPC connection for balance queries

### 1.4 Update Auth UI

- `login_screen.dart`: Add "Connect Wallet" button (Android-only, guarded by platform check)
- Keep Google Sign-In and Apple Sign-In for all platforms
- Keep email/password for all platforms
- Update `auth_provider.dart` with `loginWithWallet(publicKey)` method

---

## Phase 2: Wire Up Real Data — Action Discovery

### 2.1 Action feed provider

- Create `verily_app/lib/src/features/feed/feed_provider.dart`:
  - `@riverpod` async provider that fetches actions from server
  - Support filters: nearby (with user location), quick, high-reward, all
  - Pagination support with cursor/offset

### 2.2 Update feed/home screens

- `home_screen.dart` / `feed_screen.dart`: Replace hardcoded mock data with real provider data
- Show action cards with: title, description, reward amount (SOL/token), distance, category
- Pull-to-refresh, infinite scroll
- Empty states when no actions available

### 2.3 Search screen

- Wire `search_screen.dart` to search endpoint
- Text search + category filters
- Location-based results

### 2.4 Action detail screen

- Wire `action_detail_screen.dart` to real server data
- Show: full description, verification criteria, steps (if sequential), reward pool info, location on map
- "Start Action" button → sets active action and navigates to verification capture

---

## Phase 3: Action Creation Flow

### 3.1 Voice-to-Action (AI creation)

- Create `verily_app/lib/src/features/actions/voice_action_creator.dart`:
  - Uses `speech_to_text` package for voice transcription
  - Sends transcribed text to `AiActionEndpoint.generate()` on server
  - Returns structured action (title, description, type, criteria, category, steps)
- Add `speech_to_text: 7.0.0` to app dependencies (exact version)

### 3.2 Update CreateActionScreen

- Add voice input mode toggle (microphone button)
- When voice mode: show transcription UI → send to AI → populate form fields
- When text mode: existing form flow
- Step 4 (Review): show AI-generated content for user editing before submit
- Add reward pool creation as Step 5:
  - Reward type selector (SOL, SPL token)
  - Amount per person
  - Total amount / max recipients
  - Fund button → triggers wallet signing

### 3.3 Action types support

- One-off actions: single verification
- Sequential actions: ordered steps, each verified
- Habit actions: add `habitDays` field to action model
  - Server model update: add `habit_days` (int, nullable) and `habit_frequency` (string, nullable) to `action.spy.yaml`
  - Track per-day completion in submissions

### 3.4 Server: AI Action Generation improvements

- Update `AiActionService` to handle habit-type actions
- Generate verification criteria automatically based on action description
- Generate step breakdowns for sequential actions

---

## Phase 4: Verification & Submission Flow

### 4.1 Camera capture

- Wire `verification_capture_screen.dart` to actual camera
- Use `camera` package (already in deps) for video recording
- Display attestation challenge nonce as overlay on camera preview
- Record GPS coordinates during recording
- Max 60 second recordings

### 4.2 Video upload

- Create `verily_app/lib/src/features/submissions/upload_service.dart`:
  - Compress video client-side before upload
  - Upload to server (Serverpod file upload or signed URL to cloud storage)
  - Show upload progress
- Server: store video URL in `ActionSubmission.videoUrl`

### 4.3 AI Verification

- Update `verily_server` verification service:
  - Switch from Gemini 2.0 Flash to `gemini-2.5-flash-lite` (as per research)
  - Upload video bytes to Gemini API (not just URL in prompt text)
  - Parse structured JSON response: pass/fail, confidence, criteria matches, spoofing signals
  - Store `VerificationResult` with full analysis

### 4.4 Submission status

- Wire `submission_status_screen.dart` to real-time verification status
- Show: pending → processing → passed/failed
- On pass: show reward claim UI

---

## Phase 5: Reward Distribution (Crypto)

### 5.1 Reward pool funding (Creator side)

- When creator creates action with rewards:
  - Build Solana transaction transferring `totalAmount` to escrow/program account
  - On Android: sign via Mobile Wallet Adapter
  - On web: sign via browser wallet extension (Phantom, Solflare — future)
  - On iOS: sign via custodial wallet (server-side signing)
  - Record `fundingTxSignature` in `RewardPool`
- Server validates transaction on-chain before activating pool

### 5.2 Reward claim (Performer side)

- After AI verification passes:
  - Server creates `RewardDistribution` record (status: pending)
  - Server initiates SOL/SPL transfer from escrow to performer's wallet
  - Uses `solana_kit` RPC to build and send transaction
  - Updates distribution status: sent → confirmed
- App shows reward in wallet screen

### 5.3 Wallet screen improvements

- Wire to real balance via `solana_kit` RPC `getBalance()`
- Show token balances via `getTokenAccountsByOwner()`
- Activity tab: show distribution history from server
- "Receive" shows QR code with wallet address
- "Send" allows basic SOL transfer

---

## Phase 6: Polish & Integration

### 6.1 Localization

- Add any missing ARB strings for new features (wallet auth, voice creation, habit actions)
- Ensure all new UI uses `AppLocalizations`

### 6.2 Platform guards

- Wrap all MWA code in platform checks: `if (Platform.isAndroid)`
- iOS fallback: email/Google/Apple auth only, custodial wallet for rewards
- Web: email auth, future browser wallet support

### 6.3 Error handling

- Proper error states in all providers
- User-friendly error messages
- Retry logic for failed transactions
- Network connectivity handling

### 6.4 Testing

- Unit tests for new providers (wallet auth, feed, action creation)
- Widget tests for updated screens
- Integration tests for critical flows

---

## File Changes Summary

### New Files

| File                                                                | Purpose              |
| ------------------------------------------------------------------- | -------------------- |
| `verily_app/lib/src/features/auth/solana_wallet_auth_provider.dart` | MWA auth provider    |
| `verily_app/lib/src/features/auth/wallet_login_button.dart`         | Connect wallet UI    |
| `verily_app/lib/src/features/feed/feed_provider.dart`               | Action feed data     |
| `verily_app/lib/src/features/actions/voice_action_creator.dart`     | Voice-to-action      |
| `verily_app/lib/src/features/submissions/upload_service.dart`       | Video upload         |
| `verily_app/lib/src/features/wallet/wallet_provider.dart`           | Wallet data provider |
| `verily_server/lib/src/endpoints/auth_wallet_endpoint.dart`         | Wallet auth endpoint |

### Modified Files

| File                                                                       | Changes                            |
| -------------------------------------------------------------------------- | ---------------------------------- |
| `verily_app/pubspec.yaml`                                                  | Add `solana_kit`, `speech_to_text` |
| `verily_server/pubspec.yaml`                                               | Add `solana_kit`                   |
| `verily_app/lib/src/features/auth/auth_provider.dart`                      | Add wallet login                   |
| `verily_app/lib/src/features/auth/login_screen.dart`                       | Add wallet button                  |
| `verily_app/lib/src/features/home/home_screen.dart`                        | Wire to real data                  |
| `verily_app/lib/src/features/feed/feed_screen.dart`                        | Wire to real data                  |
| `verily_app/lib/src/features/actions/create_action_screen.dart`            | Add voice + reward step            |
| `verily_app/lib/src/features/actions/action_detail_screen.dart`            | Wire to real data                  |
| `verily_app/lib/src/features/submissions/verification_capture_screen.dart` | Wire camera                        |
| `verily_app/lib/src/features/wallet/wallet_screen.dart`                    | Wire to real balance               |
| `verily_app/lib/src/features/wallet/wallet_setup_screen.dart`              | Wire to endpoints                  |
| `verily_app/lib/src/features/rewards/create_reward_pool_screen.dart`       | Add tx signing                     |
| `verily_server/lib/src/services/wallet/solana_service.dart`                | Real solana_kit integration        |
| `verily_server/lib/src/services/verification/verification_service.dart`    | Gemini 2.5 upgrade                 |
| `verily_server/lib/src/models/action.spy.yaml`                             | Add habit fields                   |
| `verily_app/lib/l10n/app_en.arb`                                           | New strings                        |

---

## Priority Order (for today)

1. **Phase 1** — Solana Kit + Wallet Auth (critical path, everything depends on wallet)
2. **Phase 2** — Action Discovery (users need to see actions)
3. **Phase 5** — Reward Distribution basics (crypto is the core value prop)
4. **Phase 3** — Action Creation (creators need to make actions)
5. **Phase 4** — Verification Flow (connect camera + AI)
6. **Phase 6** — Polish

## Key Technical Decisions

- **MWA on Android only**: Use `defaultTargetPlatform` check, not `dart:io` Platform (web-safe)
- **Custodial wallet fallback**: For iOS/web users, server generates and manages keypair
- **Exact dependency versions**: Per CI rules, all new deps in `verily_app` use exact versions
- **solana_kit 0.2.1**: Latest stable version with MWA protocol support
- **Gemini 2.5 Flash Lite**: Per research, switch from deprecated 2.0 Flash
- **No StatefulWidget**: All new widgets use `HookConsumerWidget` or `HookWidget`
