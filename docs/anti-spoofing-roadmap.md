# Anti-Spoofing Hardening Roadmap

## Phase 1: MVP (Current)

- Device metadata capture (camera API confirms live capture)
- GPS verification against action location radius
- Gemini forensic prompt checks:
  - Screen recording artifacts (status bars, Moire patterns)
  - Video editing (jump cuts, lighting changes)
  - Camera perspective consistency
  - Temporal continuity

## Phase 2: Platform Attestation

- **C2PA Content Signing**: Embed cryptographic provenance metadata in videos
- **App Attest (iOS)**: Verify the app binary hasn't been tampered with
- **Play Integrity (Android)**: Verify the device and app are genuine
- Server validates attestation tokens before accepting submissions

## Phase 3: Visual Nonce System

- Server generates a random visual code (e.g., colored shapes, numbers)
- User must display or include the code during recording
- Gemini verifies the nonce appears in the video
- Nonces expire after 5 minutes
- Prevents pre-recorded video submission

## Phase 4: Browser & Web Hardening

- **WebAuthn**: Browser-based biometric/FIDO2 verification
- **Canvas Heartbeat Watermarking**: Invisible watermarks in the camera overlay
- Browser fingerprinting to detect emulators and virtual cameras

## Phase 5: Advanced Techniques

- **Invisible Watermarking**: Integration with Steg.AI or TruePic for steganographic marking
- **Enhanced Moire Detection**: Train Gemini with specific Moire pattern examples
- **Behavioral Analysis**: Movement pattern analysis to detect robotic/automated submissions
- **Multi-frame Consistency**: Cross-reference multiple frames for temporal coherence

## Implementation Priority

Each phase builds on the previous one. Move to the next phase only when the current phase is fully tested and deployed. The MVP forensic checks through Gemini catch the majority of casual spoofing attempts.
