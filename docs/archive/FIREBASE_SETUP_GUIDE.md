# 🔥 Firebase Setup Guide - Sport Kick

**Date:** 2025-12-06
**Status:** Pending User Action
**Time Required:** ~15 minutes

---

## 📋 Overview

Your app is **fully configured** for Firebase Crashlytics in the code. You just need to complete the Firebase Console setup and add the configuration file.

---

## ✅ What's Already Done

- ✅ Firebase dependencies added to `pubspec.yaml`
- ✅ Android Gradle configuration complete
- ✅ Firebase initialization in `main.dart`
- ✅ Crashlytics integration in `ErrorLoggingService`
- ✅ Global error handlers configured
- ✅ Local error logging implemented

**You're 90% done!** Just need the Firebase configuration file.

---

## 🚀 Step-by-Step Setup

### Step 1: Create/Access Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. Click **"Add project"** or select existing project
   - Project name: `Sport Kick` (or any name you prefer)
   - Accept terms and click Continue
   - Disable Google Analytics (optional for this app)
   - Click **Create project**

### Step 2: Register Android App

1. In your Firebase project, click the **Android icon** (⚙️ Settings > Project settings > Your apps)
2. Click **"Add app"** and select Android
3. Fill in the registration form:
   - **Android package name:** `com.example.spo_kick`
     - ⚠️ **CRITICAL:** Must match exactly!
   - **App nickname (optional):** `Sport Kick`
   - **Debug signing certificate (optional):** Skip for now
4. Click **"Register app"**

### Step 3: Download Configuration File

1. Click **"Download google-services.json"**
2. Save the file to your computer

### Step 4: Add Configuration File to Project

**CRITICAL:** Place the file in the correct location!

```
spo_kick/
└── android/
    └── app/
        └── google-services.json  ← Put it here!
```

**PowerShell Commands:**
```powershell
# Navigate to your project
cd C:\Users\moham\StudioProjects\spo_kick

# Copy the downloaded file (adjust source path)
cp ~/Downloads/google-services.json android/app/
```

**File Explorer:**
1. Navigate to: `C:\Users\moham\StudioProjects\spo_kick\android\app\`
2. Paste the `google-services.json` file there
3. Verify the file is in the correct location

### Step 5: Enable Crashlytics in Firebase Console

1. In Firebase Console, go to **Build > Crashlytics**
2. Click **"Get started"**
3. Follow the setup instructions (most are already done in code)
4. Click **"Finish setup"**

### Step 6: Verify Setup

1. **Build the app:**
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

2. **Run on device:**
```bash
flutter run
```

3. **Trigger a test crash** (optional):
Add this button temporarily to your app:
```dart
ElevatedButton(
  onPressed: () {
    FirebaseCrashlytics.instance.crash(); // Force crash for testing
  },
  child: Text('Test Crash'),
)
```

4. **Check Firebase Console:**
   - Wait 5-10 minutes after crash
   - Go to Crashlytics dashboard
   - You should see the crash report

---

## 🔧 Troubleshooting

### Issue: "google-services.json not found"
**Solution:**
- Verify file is in `android/app/` (NOT `android/`)
- Run `flutter clean` and rebuild

### Issue: "Build fails with Firebase error"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Package name mismatch"
**Solution:**
- In Firebase Console, verify package name is `com.example.spo_kick`
- Check `android/app/build.gradle.kts` has:
  ```kotlin
  applicationId = "com.example.spo_kick"
  ```

### Issue: "Crashlytics not receiving reports"
**Solution:**
- Wait 5-10 minutes (reports aren't instant)
- Ensure internet connection when crash occurs
- Verify Crashlytics is enabled in Firebase Console
- Check if `setCrashlyticsCollectionEnabled(true)` is called in main.dart

---

## 📊 Verify Crashlytics Integration

### Method 1: Check Logs
Run the app and look for these messages in logs:
```
🔄 Initializing Firebase...
✅ Firebase initialized successfully
```

### Method 2: Force Test Crash
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Add this anywhere in your code temporarily
FirebaseCrashlytics.instance.crash();
```

### Method 3: Log Test Error
```dart
import 'package:spo_kick/core/services/error_logging_service.dart';

// Log a test error
ErrorLoggingService().logError(
  'Test error from app',
  context: 'Testing Crashlytics',
  severity: ErrorSeverity.error,
);
```

After 5-10 minutes, check Firebase Console > Crashlytics dashboard.

---

## 🎯 Expected Results

After successful setup:

1. **Firebase Dashboard:** Shows your app is connected
2. **Crashlytics Dashboard:** Shows crash reports and errors
3. **App Logs:** Shows Firebase initialization success
4. **Error Tracking:** All app errors automatically logged to Firebase

---

## 📱 iOS Setup (Optional - If Supporting iOS)

If you plan to support iOS:

1. In Firebase Console, click **Add app** and select iOS
2. Bundle ID: `com.example.spo-kick` (convert underscores to hyphens)
3. Download `GoogleService-Info.plist`
4. Place in: `ios/Runner/GoogleService-Info.plist`
5. Open Xcode and add file to Runner target
6. Update `ios/Runner/Info.plist` as instructed by Firebase

---

## 🔐 Security Notes

### Important:
- ✅ `google-services.json` is already in `.gitignore` (if not, add it)
- ✅ This file contains API keys (safe for client apps)
- ✅ Never commit to public repositories if project is sensitive
- ✅ Use Firebase App Check for production (optional but recommended)

### Check .gitignore:
```bash
# Verify google-services.json is ignored
grep "google-services.json" .gitignore
```

If not found, add to `.gitignore`:
```
# Firebase
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

---

## 📈 Monitoring & Analytics

### Crashlytics Dashboard Features:
- 📊 Crash-free users percentage
- 🐛 Most common crashes
- 📍 Affected devices and OS versions
- 🔍 Stack traces with file/line numbers
- 👥 User impact metrics
- ⏱️ Time to resolution tracking

### Custom Keys (Already Implemented):
Your error logging automatically adds:
- `context` - Where the error occurred
- `severity` - Error severity level (info, warning, error, fatal)
- Any additional metadata you provide

### Example Dashboard View:
```
Crashlytics Overview:
- Crash-free users: 99.5%
- Crashes: 12 events
- Affected users: 3

Top Issues:
1. NetworkException in BookingCubit (8 events)
   - Last seen: 2 hours ago
   - Affected: 2 users
   - Context: Create Booking
```

---

## 🎓 Best Practices

### 1. Log Meaningful Errors:
```dart
// Good
ErrorLoggingService().logNetworkError(
  error,
  endpoint: '/api/bookings/create',
  statusCode: 500,
);

// Better
ErrorLoggingService().logNetworkError(
  error,
  endpoint: '/api/bookings/create',
  statusCode: 500,
  requestData: {
    'fieldId': fieldId,
    'userId': userId,
  },
);
```

### 2. Set User Context:
```dart
// When user logs in
FirebaseCrashlytics.instance.setUserIdentifier(userId);

// Add custom attributes
FirebaseCrashlytics.instance.setCustomKey('role', userRole);
FirebaseCrashlytics.instance.setCustomKey('plan', 'premium');
```

### 3. Log Breadcrumbs:
```dart
// Track user journey
FirebaseCrashlytics.instance.log('User viewed field details');
FirebaseCrashlytics.instance.log('User selected time slot');
FirebaseCrashlytics.instance.log('User submitted booking');
// If crash occurs, you'll see the full journey
```

### 4. Handle Sensitive Data:
```dart
// Never log passwords, tokens, or personal data
// Bad:
ErrorLoggingService().logError(
  'Login failed',
  additionalData: {'password': password}, // ❌ NEVER DO THIS
);

// Good:
ErrorLoggingService().logError(
  'Login failed',
  additionalData: {'email': email}, // ✅ OK
);
```

---

## 🆘 Support

### Firebase Documentation:
- [Get Started with Crashlytics](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)
- [Customize Crash Reports](https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=flutter)
- [Test Implementation](https://firebase.google.com/docs/crashlytics/test-implementation?platform=flutter)

### Common Questions:

**Q: How long until I see crash reports?**
A: Usually 5-10 minutes after a crash occurs.

**Q: Can I test without crashing the app?**
A: Yes, use `logError()` - non-fatal errors appear in Crashlytics too.

**Q: Does this work offline?**
A: Yes! Crashes are cached and uploaded when internet is available.

**Q: Will this affect performance?**
A: Minimal impact. Crashlytics is optimized for production use.

**Q: How much does it cost?**
A: Firebase Crashlytics is **FREE** with unlimited crash reports!

---

## ✅ Setup Checklist

Before considering Firebase setup complete:

- [ ] Created Firebase project
- [ ] Registered Android app with correct package name
- [ ] Downloaded `google-services.json`
- [ ] Placed file in `android/app/` directory
- [ ] Enabled Crashlytics in Firebase Console
- [ ] Rebuilt app with `flutter clean && flutter pub get`
- [ ] Ran app successfully
- [ ] Triggered test error
- [ ] Verified error appears in Firebase Console (wait 10 min)
- [ ] (Optional) Added `google-services.json` to `.gitignore`
- [ ] (Optional) Set up iOS configuration

---

## 🎉 Success Indicators

You'll know Firebase is working when:

1. ✅ App builds without errors
2. ✅ Console shows: "✅ Firebase initialized successfully"
3. ✅ Firebase Console shows app is connected
4. ✅ Test crashes/errors appear in Crashlytics dashboard
5. ✅ No Firebase-related warnings in build output

---

## 🚀 Next Steps After Setup

Once Firebase is working:

1. **Monitor Crashes:** Check Crashlytics dashboard regularly
2. **Fix Issues:** Prioritize based on user impact
3. **Add Analytics:** Consider adding Firebase Analytics
4. **Remote Config:** Use for feature flags (optional)
5. **Performance:** Add Firebase Performance Monitoring (optional)

---

**Last Updated:** 2025-12-06
**Status:** Waiting for `google-services.json` file
**Completion Time:** ~15 minutes

---

**Need Help?** The code is ready - just follow the steps above! 🚀
