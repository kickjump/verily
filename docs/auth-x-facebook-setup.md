# X (Twitter) and Facebook Authentication Setup

## Status: Coming Soon

These OAuth providers require API keys and app registration that are not yet configured. The login screen shows these buttons as disabled with "Coming soon" labels.

## X (Twitter) OAuth 2.0 PKCE Flow

### Prerequisites

1. Create a [Twitter Developer Account](https://developer.twitter.com/)
2. Create a new App in the Developer Portal
3. Enable OAuth 2.0 with PKCE
4. Set callback URLs:
   - `http://localhost:8082/auth/x/callback` (development)
   - `https://app.verily.fun/auth/x/callback` (production)

### Configuration

Add to `verily_server/config/passwords.yaml`:

```yaml
development:
  xClientId: "YOUR_X_CLIENT_ID"
  xClientSecret: "YOUR_X_CLIENT_SECRET"
```

### Implementation Steps

1. Create `XIdpEndpoint` in `verily_server/lib/src/auth/`
2. Implement PKCE authorization code flow
3. Exchange code for access token
4. Fetch user profile from X API
5. Create/link Serverpod auth account
6. Add callback route to `server.dart`

## Facebook OAuth Flow

### Prerequisites

1. Create a [Facebook Developer Account](https://developers.facebook.com/)
2. Create a new App (Consumer type)
3. Add Facebook Login product
4. Set valid OAuth redirect URIs:
   - `http://localhost:8082/auth/facebook/callback` (development)
   - `https://app.verily.fun/auth/facebook/callback` (production)

### Configuration

Add to `verily_server/config/passwords.yaml`:

```yaml
development:
  facebookAppId: "YOUR_FACEBOOK_APP_ID"
  facebookAppSecret: "YOUR_FACEBOOK_APP_SECRET"
```

### Implementation Steps

1. Create `FacebookIdpEndpoint` in `verily_server/lib/src/auth/`
2. Implement OAuth 2.0 authorization code flow
3. Exchange code for access token
4. Fetch user profile from Graph API
5. Create/link Serverpod auth account
6. Add callback route to `server.dart`

## Flutter Client Integration

Both providers will use `url_launcher` to open the OAuth consent page, then handle the callback via deep links or a custom URI scheme.

```dart
// Pattern for both providers:
// 1. Build authorization URL with PKCE challenge
// 2. Launch URL in browser
// 3. Handle callback with authorization code
// 4. Send code to server endpoint for token exchange
```

## Timeline

These will be implemented once the core verification flow is stable and the app has its initial user base.
