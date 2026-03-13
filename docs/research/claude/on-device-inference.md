# On-Device Inference Opportunities Analysis

> **Task slug:** `2026-03-09-on-device-inference`
> **Author:** Claude (Design)
> **Date:** 2026-03-09
> **Status:** Complete — ready for Gemini research handoff

---

## Problem Statement

Verily's current verification pipeline is **cloud-first by design** (CLAUDE.md:43): users record video → upload to server → server sends to Gemini 2.0 Flash → poll 3-second intervals → show pass/fail. This architecture creates three categories of user experience friction:

1. **Wasted round-trips**: Users upload low-quality videos (too dark, blurry, no person visible) only to discover failure after a server round-trip that consumes bandwidth, Gemini API credits, and 10–30 seconds of wait time.

2. **Manual friction in capture flow**: The `VerificationCaptureScreen` already performs automated face/audio/GPS detection (see existing implementation at `verily_app/lib/src/features/submissions/verification_capture_screen.dart:26–32`), but these checks are not integrated with the video review/submit flow, and action-specific checklist items remain manual checkboxes.

3. **Latency in action creation**: AI action creation (`verily_server/lib/src/services/actions/ai_action_service.dart`) requires a server round-trip to Gemini for every text input, even for simple classification (is this a fitness action? a travel action?) that could provide instant local feedback.

**Key insight**: On-device inference ≠ offline data storage. The cloud-first principle (no offline-first data layer) is fully compatible with on-device inference that pre-validates before cloud submission. The device acts as a quality gate, not a data store.

### Current State Inventory

The codebase **already has partial on-device inference** implemented:

| Capability                                    | Status                                        | Location                                                                                           |
| --------------------------------------------- | --------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Video quality analysis (brightness, duration) | ✅ Implemented                                | `video_quality_analyzer.dart:82–290`                                                               |
| Face detection via ML Kit                     | ✅ Implemented (two places)                   | `video_quality_analyzer.dart:202–257` (post-hoc), `verification_capture_screen.dart:73–108` (live) |
| Screen recording artifact detection           | ✅ Implemented (heuristic)                    | `video_quality_analyzer.dart:267–290`                                                              |
| GPS geo-fence validation                      | ✅ Implemented                                | `geo_fence_validator.dart:45–73`                                                                   |
| Live camera face detection                    | ✅ Implemented                                | `verification_capture_utils.dart:96–120`                                                           |
| GPS lock detection                            | ✅ Implemented                                | `verification_capture_utils.dart:143–182`                                                          |
| Audio level estimation                        | ⚠️ Stub only                                   | `verification_capture_utils.dart:128–140` (returns hardcoded values)                               |
| Automated checklist verification              | ⚠️ Partial (3 sensor checks auto, rest manual) | `verification_capture_screen.dart:55–61`                                                           |
| Spoofing pre-detection (moiré/screen)         | ⚠️ Heuristic only                              | `video_quality_analyzer.dart:299–370` (byte entropy, not ML)                                       |
| On-device text classification                 | ❌ Not implemented                            | AI action creation is server-only                                                                  |

This document identifies **6 concrete opportunities** to extend, improve, or newly build on-device inference to reduce server load, improve UX, and catch issues before upload.

---

## Constraints

### Product Constraints

- **Cloud-first architecture must be preserved.** On-device inference is a pre-validation gate, not a replacement for server-side Gemini verification. The server remains the source of truth.
- **Multi-platform target.** Flutter targets iOS, Android, Web, macOS, Windows, Linux. ML Kit is iOS/Android only. Any solution must degrade gracefully on unsupported platforms.
- **No blocking without server confirmation.** On-device checks can warn or suggest retake, but must not make final pass/fail determinations that override server verdicts.
- **Latency budget.** Pre-validation must complete in <2 seconds on mid-range devices to feel instant.
- **Privacy.** All inference runs locally. No video frames, audio samples, or biometric data leave the device for pre-validation.

### Architecture Constraints

- **HookConsumerWidget only.** No StatefulWidget or StatelessWidget (CLAUDE.md:48–52).
- **Riverpod + annotations.** All providers use `@riverpod` (CLAUDE.md:58).
- **Freezed models.** State objects use `@freezed` (CLAUDE.md:62).
- **Localized strings.** All user-visible text from `AppLocalizations` (CLAUDE.md:64).
- **Pinned dependencies.** `verily_app/pubspec.yaml` uses exact versions (CLAUDE.md:75).

### Technical Constraints

- **Google ML Kit** is already a dependency (`google_mlkit_face_detection`). Adding more ML Kit modules (image labeling, text recognition) is low-friction.
- **TensorFlow Lite** (`tflite_flutter`) would add a new dependency but enables custom model deployment.
- **Web platform** lacks ML Kit. Must use `kIsWeb` guards or platform-specific implementations.
- **Model size budget.** On-device models should be <20MB to avoid bloating the app binary. Prefer download-on-first-use for models >5MB.

### Security Constraints

- On-device checks are **advisory, not authoritative.** A sophisticated attacker could bypass client-side checks. Server-side Gemini verification + attestation (per `docs/anti-spoofing-roadmap.md`) remains the security boundary.

---

## Opportunity 1: Video Quality Pre-Validation Enhancement

### Current State

Already implemented in `video_quality_analyzer.dart`. Uses:

- File-size heuristic for duration check (line 149: `< 100KB` → too short)
- JPEG byte sampling for brightness (line 232: heuristic on compressed bytes, not actual pixel luminance)
- `video_thumbnail` package to extract frames at fixed time offsets

### Problem with Current Implementation

1. **Brightness check is inaccurate.** Sampling raw JPEG bytes doesn't correlate well with actual luminance (see comment at line 222–225: "JPEG compressed data doesn't directly map to pixels"). False positives/negatives are likely.
2. **No blur detection.** A completely unfocused video passes all current checks.
3. **Duration check is heuristic.** File size < 100KB is a proxy; a high-compression codec could produce small files for valid 3+ second videos.

### Proposed Approach

- **Replace JPEG byte heuristic** with actual pixel-level analysis using the `image` Dart package to decode frames and compute true average luminance.
- **Add Laplacian variance blur detection.** Compute the variance of the Laplacian operator on grayscale frames. Low variance = blurry. This is a classic CV technique that runs in <50ms per frame.
- **Use `video_player` or `ffprobe_kit`** to extract actual video duration metadata instead of frame extraction heuristics.
- **Add resolution check.** Reject videos below 480p.

### Files to Change

| File                                                                           | Change                                                                                                                                                       |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Replace `_computeLuminance` with decoded-pixel version; add `_computeBlurScore` via Laplacian variance; add `_checkResolution`; add true duration extraction |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Add `QualityCheckType.blur` and `QualityCheckType.resolution` enum values                                                                                    |
| `verily_app/pubspec.yaml`                                                      | Add `image: 4.3.0` dependency (pure Dart, works on all platforms)                                                                                            |
| `verily_app/lib/l10n/app_en.arb`                                               | Add localized strings for blur/resolution check results                                                                                                      |

### Risk

- **Performance on low-end devices.** Decoding JPEG → pixels is heavier than byte sampling. Mitigate by limiting to 1–2 frames for brightness, running in isolate (already using `compute()`).
- **False positive blur detection.** Intentional motion (action videos) may register as "blurry." Mitigate by setting a lenient threshold and using `warning` severity, not `error`.

---

## Opportunity 2: Face/Person Detection Verification

### Current State

Already implemented in two places:

1. **Post-hoc on review screen**: `video_quality_analyzer.dart:202–257` — Extracts frames, writes to temp file, runs ML Kit `FaceDetector`.
2. **Live on capture screen**: `verification_capture_screen.dart:73–108` — Processes camera stream frames through ML Kit in real time at ~2fps.

### Problem with Current Implementation

1. **Face ≠ Person.** Many valid verification videos show a person's body performing an action (push-ups, cooking, running) without a clear face in frame. Current check warns "No face detected" for these valid submissions.
2. **Two separate ML Kit instances.** The capture screen and quality analyzer each create their own `FaceDetector`, wasting resources.
3. **No person detection fallback.** If face detection fails, there's no secondary check for human presence.

### Proposed Approach

- **Add ML Kit Pose Detection** (`google_mlkit_pose_detection`) as a fallback when face detection finds nothing. Pose detection identifies body keypoints (shoulders, hips, knees) and works even when the face is occluded or turned away.
- **Unify ML Kit detector lifecycle** via a shared Riverpod provider that manages FaceDetector and PoseDetector instances.
- **Tiered pass logic**: Face detected → pass (high confidence). No face but pose detected → pass (medium confidence, info message). Neither → warning.

### Files to Change

| File                                                                           | Change                                                       |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------ |
| `verily_app/pubspec.yaml`                                                      | Add `google_mlkit_pose_detection: 0.12.0`                    |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Add `_checkPersonDetection` using pose detection as fallback |
| `verily_app/lib/src/features/submissions/providers/ml_kit_providers.dart`      | New file — shared Riverpod providers for ML Kit detectors    |
| `verily_app/lib/src/features/submissions/verification_capture_screen.dart`     | Refactor to use shared ML Kit providers                      |

### Risk

- **iOS/Android only.** ML Kit Pose Detection doesn't work on web/desktop. Must guard with platform check. Current face detection already has this limitation.
- **Model download size.** Pose detection adds ~3MB to the app. Acceptable within the 20MB budget.

---

## Opportunity 3: Automated Checklist Verification

### Current State

The `VerificationCaptureScreen` (line 55–61) defines 3 automated sensor checks:

1. Face detected in camera feed ✅ automated
2. Ambient audio level detected ⚠️ automated but stub (always returns "detected" when camera is streaming)
3. GPS location locked ✅ automated

Action-specific checklist items (line 288–313) remain **manual checkboxes** that the user must toggle.

### Problem

1. **Audio detection is fake.** `estimateAudioLevel()` in `verification_capture_utils.dart:128–140` returns hardcoded -20 dB when streaming. It doesn't measure actual audio.
2. **Action-specific requirements can't be verified.** If the action says "Wear a red shirt" or "Hold a sign," the user manually checks a box — no verification occurs.
3. **Manual checkboxes are friction.** Users can check boxes without actually meeting criteria, providing false confidence.

### Proposed Approach

#### 3a. Real Audio Level Detection

- Use the `audio_streamer` or `noise_meter` Flutter package to capture actual microphone amplitude levels.
- Replace the stub `estimateAudioLevel()` with real PCM amplitude measurement.
- Display actual dB level on the capture screen.

#### 3b. ML Kit Image Labeling for Action Requirements

- Use `google_mlkit_image_labeling` to detect objects/concepts in live camera frames.
- For action-specific checklist items, parse keywords from the verification criteria and match against ML Kit labels.
- Example: Criteria says "person doing push-ups" → ML Kit detects "exercise," "floor," "person" → auto-check.
- This is **best-effort enrichment**, not a gate. Items auto-check when confidence is high; user can still manually toggle.

### Files to Change

| File                                                                            | Change                                                                                |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `verily_app/pubspec.yaml`                                                       | Add `noise_meter: 5.0.2` (or `audio_streamer`), `google_mlkit_image_labeling: 0.14.0` |
| `verily_app/lib/src/features/submissions/verification_capture_utils.dart`       | Replace `estimateAudioLevel` stub with real implementation                            |
| `verily_app/lib/src/features/submissions/services/checklist_auto_verifier.dart` | New file — ML Kit image labeling → checklist item matching                            |
| `verily_app/lib/src/features/submissions/verification_capture_screen.dart`      | Integrate real audio + auto-verification for action checklist items                   |
| `verily_app/lib/l10n/app_en.arb`                                                | Add strings for auto-verified checklist feedback                                      |

### Risk

- **Keyword extraction from criteria is fuzzy.** "Do 20 push-ups near the park" → which keywords map to which labels? Mitigate by using broad category matching, not exact keyword match.
- **Microphone permission.** Already required for video recording, so no additional permission prompt.
- **Web platform.** `noise_meter` is iOS/Android. On web, keep the stub behavior.

---

## Opportunity 4: Spoofing Pre-Detection Enhancement

### Current State

`video_quality_analyzer.dart:267–370` implements screen recording detection via byte entropy analysis:

- Computes Shannon entropy of the first/last 5% of JPEG bytes.
- Low entropy in both regions → "screen recording" (uniform status bars / nav bars).

### Problem

1. **Heuristic is crude.** Operating on compressed JPEG bytes makes entropy calculations unreliable. A naturally dark scene (night video) could have low entropy and trigger false positives.
2. **No moiré pattern detection.** The anti-spoofing roadmap (`docs/anti-spoofing-roadmap.md`, Phase 5) calls for "Enhanced Moiré Detection" but this hasn't been started.
3. **No edge detection for screen bezels.** Recording another phone's screen would show the phone's bezel as a rectangular frame-within-frame, which is detectable.

### Proposed Approach

- **Replace byte entropy with pixel-level analysis.** After decoding frames (from Opportunity 1), analyze:
  - **Top/bottom band uniformity**: Check if the top 5% and bottom 8% of pixels have near-uniform color (status bar / navigation bar detection).
  - **Aspect ratio anomaly**: A phone recording another phone's screen produces a non-standard aspect ratio with black bars.
  - **Moiré pattern detection**: Apply a high-pass filter (simple Sobel or Laplacian edge detection) and check for periodic interference patterns in the frequency domain. High periodic energy in specific bands indicates moiré from screen pixel grids.
  - **Rectangular frame detection**: Use edge detection to find strong rectangular contours that suggest a screen-within-a-screen.

- **Scoring model**: Each detector contributes a score (0.0–1.0). Weighted average determines spoofing likelihood. Display as "Authenticity: High/Medium/Low" in the quality card.

### Files to Change

| File                                                                           | Change                                                                                                                                            |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Replace `_detectScreenRecordingArtifacts` with pixel-level analysis; add `_detectMoirePattern`, `_detectScreenBezel`, `_detectAspectRatioAnomaly` |
| `verily_app/lib/src/features/submissions/services/spoofing_detector.dart`      | New file — dedicated spoofing detection service with weighted scoring                                                                             |
| `verily_app/lib/l10n/app_en.arb`                                               | Add strings for spoofing detection results                                                                                                        |

### Risk

- **Performance.** Frequency-domain analysis (even simplified) is CPU-intensive. Mitigate by running in isolates and sampling only 1–2 frames. Must stay within the 2-second budget.
- **False positives for legitimate screen-share actions.** Some actions may legitimately involve showing a screen. Mitigate by making spoofing detection a warning, not a blocker — server-side Gemini makes the final call.
- **Sophisticated attacks bypass client-side checks.** By design — client-side is advisory, server-side + attestation is authoritative (per anti-spoofing roadmap).

---

## Opportunity 5: GPS Geo-Fence Pre-Validation

### Current State

Already implemented:

- `geo_fence_validator.dart` computes Haversine distance between user position and action location.
- Returns `GeoFenceResult` with `isWithinFence`, `distanceMeters`, `radiusMeters`.
- `video_review_screen.dart` has `geoFenceResult` state variable but doesn't prominently surface the result.

### Problem

1. **Not visible in the review flow.** The geo-fence result exists but isn't shown to the user before submission. They might submit from the wrong location.
2. **Not integrated with the quality card.** The `_VideoQualityCard` shows brightness/face/screen-recording checks but not geo-fence status.
3. **Capture screen has GPS lock but no geo-fence.** The `VerificationCaptureScreen` acquires GPS and shows "GPS locked" but doesn't compare against the action's required location.

### Proposed Approach

- **Integrate geo-fence into the VideoQualityReport.** Add a `QualityCheckType.geoFence` check that compares user position against the action's location requirement.
- **Show geo-fence status in the quality card** on the video review screen, including distance and required radius.
- **Add geo-fence to capture screen.** When an active action has a location requirement, compare the GPS fix against the action's lat/lng and radius. Show "Within range ✓" or "X km outside required area."
- **Surface a map snippet** (using static map URL) showing the user's position relative to the geo-fence circle.

### Files to Change

| File                                                                           | Change                                                                                  |
| ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Add `QualityCheckType.geoFence`; add `_checkGeoFence` method                            |
| `verily_app/lib/src/features/submissions/video_review_screen.dart`             | Pass action location data to quality analysis; display geo-fence result in quality card |
| `verily_app/lib/src/features/submissions/verification_capture_screen.dart`     | Compare GPS fix against active action location; show distance-to-fence                  |
| `verily_app/lib/l10n/app_en.arb`                                               | Add geo-fence result strings ("Within required area", "X km outside required area")     |

### Risk

- **GPS accuracy.** Urban environments / indoors can produce 30-100m accuracy. The existing 200m default radius (`geo_fence_validator.dart:61`) mitigates this.
- **Actions without location.** Many actions don't have location requirements. Must gracefully skip geo-fence check when `actionLat`/`actionLng` are null (already handled in `geo_fence_validator.dart:47`).

---

## Opportunity 6: On-Device Action Text Classification

### Current State

Action creation uses `AiActionService` on the server (`verily_server/lib/src/services/actions/ai_action_service.dart`) which calls Gemini 2.5 Flash Lite to:

1. Parse natural language → structured action (title, description, type, criteria, category)
2. Generate verification criteria
3. Generate step breakdowns

Every keystroke or text change that triggers generation requires a full server round-trip.

### Problem

1. **No instant feedback.** The user types "Run 5K in Central Park every morning for a month" and must wait for the server to classify it as a habit action with fitness category.
2. **Category prediction delay.** Simple classification (Fitness vs. Creative vs. Travel) could be instant.
3. **Action type prediction delay.** Determining oneOff vs. sequential vs. habit from keywords is often obvious.

### Proposed Approach

- **Keyword-based local classifier** (no ML model needed for MVP). Build a simple Dart utility that:
  - Extracts keywords from user text input.
  - Matches against category keyword dictionaries (e.g., "run," "push-up," "gym" → Fitness; "paint," "draw," "photo" → Creative).
  - Matches against type patterns (e.g., "every day," "times a week," "for X days" → habit; "then," "step 1," "first... then" → sequential).
  - Returns predicted category, type, and confidence.

- **Display instant suggestions** in the action creation UI as the user types (debounced 300ms).
- **Server Gemini call still runs.** The local prediction pre-fills form fields; the server response confirms or corrects.
- **Future: TFLite text classification model.** For v2, train a lightweight text classification model (<2MB) on action descriptions to replace keyword matching with actual NLP. Could use the Universal Sentence Encoder Lite or a fine-tuned MobileBERT.

### Files to Change

| File                                                                                     | Change                                                                                                                             |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `verily_core/lib/src/services/action_text_classifier.dart`                               | New file — keyword-based classifier with category + type prediction (in `verily_core` since it's pure Dart, no Flutter dependency) |
| `verily_core/test/src/services/action_text_classifier_test.dart`                         | New file — unit tests for classifier                                                                                               |
| `verily_app/lib/src/features/actions/providers/action_text_classification_provider.dart` | New file — Riverpod provider wrapping the classifier, debounced                                                                    |
| `verily_app/lib/src/features/actions/screens/create_action_screen.dart`                  | Integrate instant category/type suggestions from local classifier                                                                  |
| `verily_app/lib/l10n/app_en.arb`                                                         | Add strings for "Suggested category: X" / "Detected type: Y"                                                                       |

### Risk

- **Keyword matching is simplistic.** "I want to draw a picture of someone running" → Fitness or Creative? Mitigate by showing low confidence and not auto-selecting.
- **Localization.** Keyword dictionaries are English-only initially. For multi-language support, the dictionaries need per-locale variants or the TFLite model approach.
- **Scope creep.** Start with keyword matching only. TFLite text classification is a separate, future task.

---

## Rejected Alternatives

### 1. Full On-Device Verification (Replace Gemini)

**Rejected.** On-device models cannot match Gemini 2.0 Flash's multimodal video understanding quality. The verification task requires nuanced judgment ("did they actually do 20 push-ups with proper form?") that exceeds current on-device model capabilities. Server-side Gemini remains the source of truth.

### 2. TensorFlow Lite for All Checks

**Rejected for MVP.** TFLite adds a new dependency, requires model management (download, versioning, platform-specific binaries), and is overkill for checks that ML Kit or simple image processing can handle. Reserve TFLite for future specialized models (moiré detection, text classification v2).

### 3. Firebase ML Custom Models

**Rejected.** Adds Firebase dependency and cloud coupling. The goal is fully on-device inference with no network calls for pre-validation.

### 4. MediaPipe for All Detection

**Rejected.** MediaPipe's Flutter bindings are less mature than ML Kit for the specific tasks needed (face detection, pose estimation, image labeling). ML Kit has official Google support and is already in the dependency tree.

### 5. Blocking Submission on Pre-Validation Failure

**Rejected.** The only check that should block submission is screen-recording detection (`QualityCheckSeverity.error`). All other pre-validation failures should be warnings/suggestions. Reason: false positives would prevent legitimate submissions, and the server-side Gemini check is the authoritative verdict.

---

## Consolidated File Plan

### New Files

| File                                                                                     | Description                                                            |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `verily_app/lib/src/features/submissions/providers/ml_kit_providers.dart`                | Shared Riverpod providers for ML Kit detector lifecycle                |
| `verily_app/lib/src/features/submissions/services/spoofing_detector.dart`                | Pixel-level spoofing detection (moiré, screen bezels, band uniformity) |
| `verily_app/lib/src/features/submissions/services/checklist_auto_verifier.dart`          | ML Kit image labeling → action checklist auto-verification             |
| `verily_core/lib/src/services/action_text_classifier.dart`                               | Keyword-based action text classifier                                   |
| `verily_core/test/src/services/action_text_classifier_test.dart`                         | Unit tests for text classifier                                         |
| `verily_app/lib/src/features/actions/providers/action_text_classification_provider.dart` | Riverpod provider for on-device text classification                    |

### Modified Files

| File                                                                           | Description                                                                                                                         |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `verily_app/lib/src/features/submissions/services/video_quality_analyzer.dart` | Enhance brightness (pixel-level), add blur detection, add resolution check, add geo-fence check, improve screen recording detection |
| `verily_app/lib/src/features/submissions/verification_capture_screen.dart`     | Integrate shared ML Kit providers, add geo-fence display, integrate auto-checklist verification                                     |
| `verily_app/lib/src/features/submissions/verification_capture_utils.dart`      | Replace audio level stub with real implementation                                                                                   |
| `verily_app/lib/src/features/submissions/video_review_screen.dart`             | Pass action location to quality analysis, surface geo-fence in quality card                                                         |
| `verily_app/lib/src/features/actions/screens/create_action_screen.dart`        | Integrate instant text classification suggestions                                                                                   |
| `verily_app/pubspec.yaml`                                                      | Add dependencies: `image`, `google_mlkit_pose_detection`, `google_mlkit_image_labeling`, `noise_meter`                              |
| `verily_app/lib/l10n/app_en.arb`                                               | Add all new localized strings                                                                                                       |

---

## Risk Checklist

| Risk                                                | Likelihood | Impact | Mitigation                                                                                                     |
| --------------------------------------------------- | ---------- | ------ | -------------------------------------------------------------------------------------------------------------- |
| Performance regression on low-end devices           | Medium     | High   | Run all analysis in isolates; limit frame sampling to 1–2; measure with DevTools profiling                     |
| False positive spoofing detection                   | Medium     | Medium | All spoofing checks are warnings, not blockers; server Gemini is authoritative                                 |
| ML Kit unavailable on web/desktop                   | Certain    | Medium | Platform guards (`!kIsWeb && (Platform.isIOS                                                                   |
| App size increase from ML Kit modules               | Low        | Low    | ML Kit models are ~3MB each; total well within 20MB budget                                                     |
| Keyword classifier accuracy for text classification | Medium     | Low    | Low-confidence predictions shown as suggestions, not auto-selections; server Gemini corrects                   |
| Audio permission issues                             | Low        | Low    | Already required for video recording; shared permission                                                        |
| Breaking the cloud-first principle                  | Low        | High   | Explicitly documented: on-device = pre-validation gate only; no data stored locally; server is source of truth |

---

## Implementation Phases

### Phase A: Foundation Enhancements (Opportunities 1, 5)

- Upgrade video quality analyzer with pixel-level brightness, blur detection, resolution check
- Integrate geo-fence into quality card and capture screen
- **Estimated effort:** 2–3 hours
- **Dependencies:** `image` package only

### Phase B: Person Detection & Shared ML Kit (Opportunity 2)

- Add pose detection fallback
- Unify ML Kit provider lifecycle
- **Estimated effort:** 2 hours
- **Dependencies:** `google_mlkit_pose_detection`

### Phase C: Spoofing Detection Upgrade (Opportunity 4)

- Pixel-level screen recording detection
- Moiré pattern detection
- Aspect ratio anomaly detection
- **Estimated effort:** 3–4 hours
- **Dependencies:** `image` package (from Phase A)

### Phase D: Automated Checklist (Opportunity 3)

- Real audio level detection
- ML Kit image labeling for action requirements
- **Estimated effort:** 3 hours
- **Dependencies:** `noise_meter`, `google_mlkit_image_labeling`

### Phase E: Action Text Classification (Opportunity 6)

- Keyword-based classifier in `verily_core`
- Integration with action creation UI
- **Estimated effort:** 2 hours
- **Dependencies:** None (pure Dart)

**Recommended execution order:** A → E → B → C → D (Phase E is pure Dart with no platform constraints, making it a good parallel track)

---

## Definition of Done

### Per Opportunity

- [ ] Implementation passes `dart analyze` with zero warnings
- [ ] All new files have corresponding unit tests (>80% coverage)
- [ ] Widget tests verify the UI integration (quality card shows new checks, capture screen shows new badges)
- [ ] On unsupported platforms (web, desktop), checks gracefully return "skipped" without errors
- [ ] All user-visible strings are in `app_en.arb` (no hardcoded strings)
- [ ] New providers use `@riverpod` annotation
- [ ] New state objects use `@freezed`
- [ ] Performance profiled: pre-validation completes in <2 seconds on a Pixel 6a / iPhone 12 equivalent
- [ ] No change to server-side verification logic — on-device is purely advisory

### Overall Feature Complete

- [ ] All 6 opportunities implemented across Phases A–E
- [ ] Integration test: full capture → review → submit flow with all pre-checks visible
- [ ] Documentation updated: this design doc + Gemini research notes in `docs/research/gemini/on-device-inference.md`
- [ ] PR checklist per `docs/llm-provider-strategy.md` fully satisfied
- [ ] `docs/anti-spoofing-roadmap.md` updated to reference on-device pre-detection as "Phase 1.5"

---

## Gemini Research Handoff

The following questions should be addressed in `docs/research/gemini/on-device-inference.md`:

1. **ML Kit vs. MediaPipe:** Which Google ML solution is recommended for Flutter in 2026 for face detection, pose detection, and image labeling? Are there deprecation concerns with the `google_mlkit_*` packages?
2. **Model recommendations:** For future TFLite text classification (Opportunity 6 v2), what's the recommended model architecture and size for on-device action text classification?
3. **Moiré detection:** Are there published Google research papers or pre-trained models for screen-capture moiré pattern detection that could be deployed on-device?
4. **Performance benchmarks:** What are the expected latency numbers for ML Kit face detection + pose detection on mid-range Android/iOS devices?
5. **Cost/latency impact:** How much server-side Gemini API cost reduction can be estimated from pre-filtering ~20% of submissions that would fail quality checks?
