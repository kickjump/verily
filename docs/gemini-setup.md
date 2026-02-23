# Gemini API Setup Guide

## Overview

Verily uses Google's Gemini 2.0 Flash model to verify video submissions. This guide walks through setting up the Gemini API for your development environment.

## Steps

### 1. Create a Google Cloud Project

```bash
gcloud projects create verily-app --name="Verily"
gcloud config set project verily-app
```

Or via the [GCP Console](https://console.cloud.google.com/projectcreate).

### 2. Enable the Generative Language API

```bash
gcloud services enable generativelanguage.googleapis.com
```

### 3. Create an API Key

1. Go to [API Credentials](https://console.cloud.google.com/apis/credentials)
2. Click "Create Credentials" > "API Key"
3. Restrict the key to "Generative Language API" only
4. Copy the key

### 4. Configure Serverpod

Add the API key to `verily_server/config/passwords.yaml`:

```yaml
development:
  # ... existing keys ...
  geminiApiKey: 'YOUR_API_KEY_HERE'
```

### 5. Rate Limits & Billing

- **Free tier**: 60 requests/minute, 1500 requests/day
- **Paid tier**: Higher limits with pay-per-use
- Set up [billing alerts](https://console.cloud.google.com/billing) to avoid unexpected charges

## Without Gemini API Key

The server gracefully handles a missing Gemini API key:

- Action browsing, creation, and all non-verification features work normally
- Video submissions will return a "verification service unavailable" error
- The submission status will show as `error` with an appropriate message

## Testing

To verify your setup:

1. Start the server: `server:start`
2. Submit a video through the app
3. Check server logs for Gemini API responses

## Model Selection

We use `gemini-2.0-flash` for:

- Fast response times (< 5 seconds for most videos)
- Good accuracy for visual content analysis
- Cost-effective for high-volume verification

For higher accuracy needs, you can change the model in `gemini_service.dart` to `gemini-2.0-pro`, though this will increase latency and cost.
