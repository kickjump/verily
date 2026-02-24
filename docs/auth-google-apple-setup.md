# Google + Apple Login Setup

This project now has concrete Serverpod IDP endpoints and app-side auth wiring for:

- Email/password (`authEmail` endpoint)
- Google (`authGoogle` endpoint)
- Apple (`authApple` endpoint)

To finish setup in your environment, provide the credentials below.

## 1. Server Secrets (`verily_server/config/passwords.yaml`)

Add these keys (at least in `development`, and in `staging` / `production` as needed):

### Google

- `googleClientSecret`: JSON payload from Google OAuth client credentials file (`client_secret_*.json`), stored as a JSON string.

### Apple

- `appleServiceIdentifier`: Apple Services ID (client id for web / Android flows).
- `appleBundleIdentifier`: iOS bundle identifier.
- `appleRedirectUri`: Redirect URI registered in Apple Developer (must match app + server setup).
- `appleTeamId`: Apple Developer Team ID.
- `appleKeyId`: Sign in with Apple key ID.
- `appleKey`: Full contents of the `.p8` private key.

## 2. Flutter `--dart-define` Values

The app reads these compile-time defines:

- `GOOGLE_CLIENT_ID`
- `GOOGLE_SERVER_CLIENT_ID`
- `APPLE_SERVICE_IDENTIFIER`
- `APPLE_REDIRECT_URI`

Example run command:

```bash
devenv shell bash -lc 'cd verily_app && flutter run \
  --dart-define=GOOGLE_CLIENT_ID=... \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=... \
  --dart-define=APPLE_SERVICE_IDENTIFIER=... \
  --dart-define=APPLE_REDIRECT_URI=...'
```

## 3. Google Console Requirements

Provide/configure:

- OAuth Web client (used by server for token verification).
- OAuth iOS client (bundle id must match app).
- OAuth Android client (package name + SHA-1/SHA-256).
- Authorized redirect URIs for any web auth flow.

What I need from you:

- OAuth client credentials JSON for the Web client.
- iOS client id.
- Android client id.
- Confirmation of package name + iOS bundle id + SHA fingerprints used in Google Cloud.

## 4. Apple Developer Requirements

Provide/configure:

- Sign in with Apple key (`.p8`), key id, team id.
- Service ID and redirect URI.
- App ID capability: Sign in with Apple enabled.

What I need from you:

- `appleServiceIdentifier`
- `appleBundleIdentifier`
- `appleRedirectUri`
- `appleTeamId`
- `appleKeyId`
- `appleKey` (full `.p8` content)

## 5. Validation Checklist

After you provide these values:

1. Start backend (`devenv up`, then `server:start`).
2. Run app with required `--dart-define` values.
3. Verify Google login succeeds and user session persists on restart.
4. Verify Apple login succeeds on an Apple-capable platform.
5. Verify logout clears session (`settings -> logout` or equivalent action).
