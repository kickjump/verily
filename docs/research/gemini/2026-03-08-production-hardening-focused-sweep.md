# Gemini Research Artifact — 2026-03-08-production-hardening-focused-sweep

## Recommended model(s) and why
- **Primary for low-latency verification/extraction:** `gemini-2.5-flash-lite`
  - Best fit for frequent verification jobs where latency/cost pressure is high.
- **Fallback/legacy compatibility path:** `gemini-2.0-flash`
  - Keep temporary compatibility while rolling out newer model config safely.

## Prompt structure and output contract recommendations
- Use strict JSON contracts with explicit keys and value types.
- Include deterministic rubric fields:
  - `passed` (bool)
  - `confidenceScore` (0..1)
  - `spoofingDetected` (bool)
  - `analysisText` (string)
  - optional `spoofingIndicators` (array)
- Instruct “JSON only, no markdown fences.”
- Keep parser tolerant to markdown-fenced output for resilience.

## Grounding / tool-use recommendations
- Prefer direct media input (uploaded bytes or API-supported media references) over plain URL-only prompt text when feasible.
- If external metadata is used (GPS/device/nonce), present it as structured context fields rather than free text paragraphs.

## Safety policy notes
- Avoid including raw user PII in prompts unless strictly required.
- Never send secrets/tokens/private keys/auth headers.
- Apply server-side redaction on logs storing model requests/responses.
- Treat user free-text content as sensitive by default in telemetry and logs.

## Reliability / evaluation notes
- Validate response schema server-side before persistence.
- Retry transient failures with bounded retries and idempotency guards.
- Track parsing failures and fallback rates as operational metrics.
- Keep fail-closed behavior for malformed responses (`passed=false` unless validated).

## Cost and latency guidance
- Use lower-latency flash-tier models for synchronous UX-critical verification paths.
- Batch asynchronous secondary analysis where possible.
- Set conservative timeouts and avoid unbounded retries.

## Migration / deprecation watchouts
- Keep model names configurable (do not hardcode only one provider/model in multiple files).
- Maintain periodic review of Google model lifecycle announcements and update roll-forward plan proactively.
- Record model versions used in persisted verification results for post-hoc auditability.
