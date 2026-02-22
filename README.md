# Satark One - Scam Protection App

Anti-scam protection app for India with Firebase Firestore backend.

## Features
- Phone number scam checker
- UPI ID verification
- URL/link scanner
- Community scam reporting
- Real-time scam database

## Setup for Codemagic

### 1. Add Firebase Config
Replace `android/app/google-services.json` with your Firebase configuration:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Add Android app (package: `com.satarkone.app`)
4. Download `google-services.json`
5. Replace the placeholder file

### 2. Configure Codemagic
In Codemagic settings, add environment variable:
- **Variable name:** `GOOGLE_SERVICES_JSON`
- **Value:** Base64-encoded content of your `google-services.json`

```bash
# To get base64:
cat android/app/google-services.json | base64
```

### 3. Build
Run the `android-debug` or `android-release` workflow in Codemagic.

## Local Build

```bash
flutter pub get
flutter build apk --debug
```

APK location: `build/app/outputs/flutter-apk/app-debug.apk`

## Firestore Database

Create collection: `scam_database`

Sample document:
```json
{
  "type": "phone",
  "value": "9876543210",
  "status": "scam",
  "risk_score": 95,
  "created_at": Timestamp
}
```

---

**Version:** 1.0.0  
**Package:** com.satarkone.app
