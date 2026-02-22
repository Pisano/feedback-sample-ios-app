# Pisano Feedback SDK — Developer Guide (All Platforms)

This guide explains how to integrate **Pisano Feedback** into your mobile apps. The same concepts apply across **iOS**, **Android**, **React Native**, and **Flutter**. Credentials come from the **Pisano panel**; each platform has a sample app you can clone and run.

---

## Where to get credentials (Pisano panel)

All SDKs need these values: **App ID**, **Access Key**, **Code**, **Api Url**, and **Feedback Url**. You get them from the Pisano panel in two places.

### 1. App ID and Access Key

Go to **Profile → Mobile applications → Create Mobile Application**. Enter an application name, add your bundle identifiers for each platform (iOS, Android), and click **Save**. After the app is created, the card shows your **App ID** and **Access Key** with copy buttons.

![Create Mobile Application](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/create-mobile-app.png)

![Edit Mobile Application](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/edit-mobile-app.png)

![App credentials](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/app-credentials.png)

### 2. Code, API URL, and Feedback URL

Go to **Mobile Channels**, create or select a channel, then click **Deploy**. In the **Publish Channel Parameters** modal, the top section shows:

- **Code** — your survey/channel code (e.g. `PSN-61s6u79`)
- **Api Url** — base API URL
- **Feedback Url** — feedback widget URL

Use these three values together with the App ID and Access Key from step 1. The "Legacy credentials" section below in the modal is for the old structure; ignore it for the current SDKs.

![Publish Channel Parameters](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/publish-channel-params.png)

---

## Common concepts

**Init/Boot once** — Call the SDK's init (or boot) once at app startup with `appId`, `accessKey`, `code`, `apiUrl`, `feedbackUrl` (and optionally `eventUrl`). Do not commit these values; use local config files.

**`code` parameter** — Required at init. This is your survey/channel code from the Pisano panel. In `show()` and `healthCheck()` you can optionally pass a different `code` to override the boot default for that specific call (useful for multi-survey apps).

**Display rate limiting** — The backend can return a `display_rate` value (0–100). When the SDK skips showing the widget due to throttling, it reports `displayRateLimited` / `DISPLAY_RATE_LIMITED`.

**Display once** — If the survey is configured to show only once per user, subsequent calls return `displayOnce` / `DISPLAY_ONCE` and the widget will not open again.

---

## iOS (Native)

**Sample app:** [Pisano/feedback-sample-ios-app](https://github.com/Pisano/feedback-sample-ios-app)
**SDK:** `PisanoFeedback` via Swift Package Manager or CocoaPods — iOS 12.0+

**Installation (SPM):** In Xcode → File → Add Package Dependencies → URL: `https://github.com/Pisano/pisano-ios.git` → Version 1.0.17 → Add `PisanoFeedback` product.

**Installation (CocoaPods):** `pod 'Pisano', '~> 1.0.17'`

```swift
// ──────────────────────────────────────────────
// BOOT (once at app startup, e.g. AppDelegate)
// ──────────────────────────────────────────────

import PisanoFeedback

#if DEBUG
Pisano.debugMode(true)
#endif

Pisano.boot(appId: "YOUR_APP_ID",
           accessKey: "YOUR_ACCESS_KEY",
           code: "YOUR_CODE",           // required — from Pisano panel
           apiUrl: "https://api.pisano.co",
           feedbackUrl: "https://web.pisano.co/web_feedback",
           eventUrl: nil) { status in
    print(status.description)
}

// ──────────────────────────────────────────────
// SHOW WIDGET
// ──────────────────────────────────────────────

// Basic — uses boot code
Pisano.show { status in
    print(status.description)
}

// Advanced — override code for this call (e.g. different survey)
Pisano.show(mode: .bottomSheet,
           title: NSAttributedString(string: "We Value Your Feedback"),
           language: "en",
           customer: ["externalId": "USER-123", "phoneNumber": "+1234567890"],
           payload: ["source": "app"],
           code: "ANOTHER_SURVEY_CODE") { status in
    print(status.description)
}

// ──────────────────────────────────────────────
// HEALTH CHECK
// ──────────────────────────────────────────────

Pisano.healthCheck(language: "en", customer: nil, payload: nil, code: nil) { ok in
    if ok {
        Pisano.show { status in print(status.description) }
    }
}
```

**Full docs and release notes:** [iOS sample app README](https://github.com/Pisano/feedback-sample-ios-app/blob/main/README.md)

---

## Android (Native)

**Sample app:** [Pisano/feedback-sample-android-app](https://github.com/Pisano/feedback-sample-android-app)
**SDK:** `co.pisano:feedback` via Gradle — e.g. version 1.3.28

**Installation:** Add `implementation 'co.pisano:feedback:1.3.28'` to your app `build.gradle`.

```kotlin
// ──────────────────────────────────────────────
// INIT (once at app startup, e.g. Application class)
// ──────────────────────────────────────────────

import co.pisano.feedback.managers.PisanoSDK
import co.pisano.feedback.managers.PisanoSDKManager

val manager = PisanoSDKManager.Builder(context)
    .setApplicationId("YOUR_APP_ID")
    .setAccessKey("YOUR_ACCESS_KEY")
    .setCode("YOUR_CODE")                    // required — from Pisano panel
    .setApiUrl("https://api.pisano.co")
    .setFeedbackUrl("https://web.pisano.co/web_feedback")
    .setEventUrl("https://track.pisano.co/track")  // optional
    .setDebug(BuildConfig.DEBUG)
    .build()

PisanoSDK.init(manager)

// ──────────────────────────────────────────────
// SHOW WIDGET
// ──────────────────────────────────────────────

// Basic — uses init code
PisanoSDK.show()

// Advanced — override code for this call
PisanoSDK.show(
    viewMode = ViewMode.BOTTOM_SHEET,
    language = "en",
    pisanoCustomer = PisanoCustomer(externalId = "USER-123"),
    code = "ANOTHER_SURVEY_CODE"
)

// ──────────────────────────────────────────────
// HEALTH CHECK
// ──────────────────────────────────────────────

PisanoSDK.healthCheck(
    language = "en",
    pisanoCustomer = PisanoCustomer(externalId = "USER-123"),
    code = null  // use init code; or pass a string to check another survey
) { isHealthy ->
    if (isHealthy) {
        PisanoSDK.show()
    }
}
```

**Full docs:** [Android sample app README](https://github.com/Pisano/feedback-sample-android-app)

---

## React Native

**Sample app:** [Pisano/feedback-sample-react-native-app](https://github.com/Pisano/feedback-sample-react-native-app)
**SDK:** `feedback-react-native-sdk` via npm/yarn

**Installation:** Add the `feedback-react-native-sdk` dependency as documented in the repo. For iOS: `cd ios && pod install && cd ..`

```javascript
// ──────────────────────────────────────────────
// BOOT (once at app startup)
// ──────────────────────────────────────────────

import { feedbackSDKBoot } from 'feedback-react-native-sdk';

feedbackSDKBoot(
  appId,
  accessKey,
  code,        // required — channel code (e.g. "PSN-xxxxx")
  apiUrl,
  feedbackUrl,
  eventUrl,    // optional
  (status) => console.log('Boot:', status)
);

// ──────────────────────────────────────────────
// SHOW WIDGET
// ──────────────────────────────────────────────

import { feedbackSDKShow, feedbackSDKViewMode } from 'feedback-react-native-sdk';

// Basic — uses boot code
feedbackSDKShow(
  feedbackSDKViewMode.Default,
  null, null, null, 'en',
  new Map([['email', 'user@example.com']]),
  new Map([['source', 'app']]),
  (result) => console.log('Show:', result)
);

// Advanced — override code for this call
feedbackSDKShow(
  feedbackSDKViewMode.BottomSheet,
  'Title', 16, 'ANOTHER_CODE', 'en',
  new Map([['externalId', 'USER-123']]),
  new Map([['source', 'app']]),
  (result) => console.log('Show:', result)
);
```

**Full docs:** [React Native sample app README](https://github.com/Pisano/feedback-sample-react-native-app)

---

## Flutter

**Sample app:** [Pisano/feedback-sample-flutter-app](https://github.com/Pisano/feedback-sample-flutter-app)
**SDK:** `feedback_flutter_sdk` via git dependency

**Installation:** Add the SDK dependency in `pubspec.yaml`, then `flutter pub get`. Credentials are typically passed via `--dart-define-from-file=pisano_defines.json` (gitignored).

```dart
// ──────────────────────────────────────────────
// INIT (once at app startup)
// ──────────────────────────────────────────────

import 'package:feedback_flutter_sdk/feedback_flutter_sdk.dart';

final feedbackSdk = FeedbackFlutterSdk();

await feedbackSdk.init(
  applicationId,
  accessKey,
  apiUrl,
  feedbackUrl,
  eventUrl,   // optional, null to disable
  debugLogging: false,
  code: code, // required — survey/channel code from Pisano panel
);

// ──────────────────────────────────────────────
// SHOW WIDGET
// ──────────────────────────────────────────────

// Basic — uses boot code
final callback = await feedbackSdk.show(
  viewMode: ViewMode.bottomSheetMode,
  title: 'We Value Your Feedback',
  titleFontSize: 20,
  language: 'tr',
  customer: {'externalId': 'CRM-12345', 'phoneNumber': '+905001112233'},
  payload: {'source': 'app', 'screen': 'home'},
);

// Advanced — override code for this call
final callback = await feedbackSdk.show(
  viewMode: ViewMode.bottomSheetMode,
  title: 'Survey',
  code: 'ANOTHER_SURVEY_CODE',
  language: 'en',
  customer: {'externalId': 'USER-123'},
  payload: {'source': 'app'},
);
```

**Full docs:** [Flutter sample app README](https://github.com/Pisano/feedback-sample-flutter-app)

---

## Summary

**Where credentials come from:**

| Source | What you get | Use in SDK |
|--------|--------------|------------|
| Profile → Mobile applications | App ID, Access Key | Init/boot only |
| Mobile Channels → Deploy | Code, Api Url, Feedback Url | Init/boot + optional override per show/healthCheck |

**`code` parameter behavior:**

| Method | `code` | When omitted |
|--------|--------|--------------|
| Init / Boot | **Required** | SDK cannot initialize |
| Show | Optional | Uses init/boot code |
| Health check (iOS, Android) | Optional | Uses init/boot code |

**Important:** Do not commit App ID, Access Key, or other secrets. Use local config files (`PisanoSecrets.plist`, `local.properties`, `pisano_defines.json`) and add them to `.gitignore`. For multiple surveys in one app, always pass `code` in each `show()` call.

---

## Quick links

| Platform | Sample app |
|----------|------------|
| iOS | [feedback-sample-ios-app](https://github.com/Pisano/feedback-sample-ios-app) |
| Android | [feedback-sample-android-app](https://github.com/Pisano/feedback-sample-android-app) |
| React Native | [feedback-sample-react-native-app](https://github.com/Pisano/feedback-sample-react-native-app) |
| Flutter | [feedback-sample-flutter-app](https://github.com/Pisano/feedback-sample-flutter-app) |
