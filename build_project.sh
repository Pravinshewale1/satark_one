#!/bin/bash
cd /home/claude/satark_one_mvp

# ============ PUBSPEC.YAML ============
cat > pubspec.yaml << 'EOF'
name: satark_one
description: Satark One - Anti-Scam Protection App
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
  provider: ^6.1.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
EOF

# ============ GITIGNORE ============
cat > .gitignore << 'EOF'
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub/
build/
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
EOF

# ============ README ============
cat > README.md << 'EOF'
# Satark One - Scam Protection App

Anti-scam protection for India with real-time verification.

## Features
- Check phone numbers, UPI IDs, and URLs
- Report scams to community database
- Real-time scam alerts
- Firebase Firestore backend

## Setup
1. Add google-services.json to android/app/
2. Run: flutter pub get
3. Run: flutter run

## Build
flutter build apk --release
EOF

# ============ CODEMAGIC.YAML ============
cat > codemagic.yaml << 'EOF'
workflows:
  android-workflow:
    name: Android Workflow
    max_build_duration: 60
    instance_type: mac_mini_m1
    environment:
      flutter: 3.16.9
      groups:
        - firebase
    scripts:
      - name: Get packages
        script: flutter pub get
      - name: Inject Firebase
        script: echo "$GOOGLE_SERVICES_JSON" | base64 --decode > android/app/google-services.json
      - name: Build APK
        script: flutter build apk --debug
    artifacts:
      - build/app/outputs/flutter-apk/*.apk
EOF

echo "✅ Config files created"
