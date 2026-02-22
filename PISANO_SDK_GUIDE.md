# Pisano Feedback SDK — Developer Guide (All Platforms)

Pisano Feedback SDK allows you to collect in-app surveys and user feedback across **iOS**, **Android**, **React Native**, and **Flutter**. This guide covers everything you need: getting your credentials from the Pisano panel, installing the SDK for each platform, initializing it, displaying surveys, and handling callbacks.

Each platform has a dedicated **sample app** you can clone and run immediately.

| Platform | SDK | Sample app |
|----------|-----|------------|
| **iOS** | [`PisanoFeedback`](https://github.com/Pisano/pisano-ios) | [feedback-sample-ios-app](https://github.com/Pisano/feedback-sample-ios-app) |
| **Android** | [`co.pisano:feedback`](https://github.com/Pisano/feedback-android) | [feedback-sample-android-app](https://github.com/Pisano/feedback-sample-android-app) |
| **React Native** | [`feedback-react-native-sdk`](https://github.com/Pisano/feedback-react-native-sdk) | [feedback-sample-react-native-app](https://github.com/Pisano/feedback-sample-react-native-app) |
| **Flutter** | [`feedback_flutter_sdk`](https://github.com/Pisano/feedback-flutter-sdk) | [feedback-sample-flutter-app](https://github.com/Pisano/feedback-sample-flutter-app) |

---

## Table of contents

- [Where to get credentials (Pisano panel)](#where-to-get-credentials-pisano-panel)
- [Common concepts](#common-concepts)
- [iOS (Native — Swift / Objective-C)](#ios-native--swift--objective-c)
- [Android (Native — Kotlin / Java)](#android-native--kotlin--java)
- [React Native](#react-native)
- [Flutter](#flutter)
- [Callback / Status values](#callback--status-values)
- [Summary tables](#summary-tables)

---

## Where to get credentials (Pisano panel)

All SDKs require these values to initialize:

| Parameter | Where to find | Example |
|-----------|---------------|---------|
| `appId` | Profile → Mobile applications → app card | `N8av-JTpP...` |
| `accessKey` | Profile → Mobile applications → app card | `eEantRilu-s8...` |
| `code` | Mobile Channels → Deploy → Publish Channel Parameters | `PSN-61s6u79` |
| `apiUrl` | Mobile Channels → Deploy → Publish Channel Parameters | `https://api.pisano.com.tr` |
| `feedbackUrl` | Mobile Channels → Deploy → Publish Channel Parameters | `https://web.pisano.com.tr/web_feedback` |
| `eventUrl` (optional) | Mobile Channels → Deploy → Publish Channel Parameters | `https://track.pisano.com.tr/track` |

### Step 1 — Create a Mobile Application (App ID + Access Key)

1. In the Pisano panel, go to **Profile** → **Mobile applications**.
2. Click **Create Mobile Application**.
3. Enter an **Application name** (e.g. "My App").
4. Click **+ Add Bundle Identifier** and add identifiers for each platform:
   - iOS: your app's bundle ID (e.g. `com.yourcompany.yourapp`)
   - Android: your app's package name (e.g. `com.yourcompany.yourapp`)
5. Click **Save**.

The app card now shows **App ID** and **Access Key** with copy buttons.

![Create Mobile Application](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/create-mobile-app.png)

![Edit Mobile Application](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/edit-mobile-app.png)

![App credentials — App ID and Access Key](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/app-credentials.png)

### Step 2 — Create / Deploy a Mobile Channel (Code + URLs)

1. Go to **Mobile Channels**.
2. Create a new channel (**+ Add**) or select an existing one. Configure the survey flow as needed.
3. Click the **Deploy** button (globe icon).
4. The **Publish Channel Parameters** modal shows three values at the top:
   - **Code** — survey/channel code (e.g. `PSN-61s6u79`)
   - **Api Url** — API base URL
   - **Feedback Url** — feedback widget URL

Use these together with the App ID and Access Key from Step 1. The "Legacy Credentials" section in the same modal is for older SDK versions; ignore it.

![Publish Channel Parameters — Code, Api Url, Feedback Url](https://raw.githubusercontent.com/Pisano/feedback-sample-ios-app/main/docs/pisano-platform/publish-channel-params.png)

---

## Common concepts

### Init / Boot once

Call the SDK's initialization method **once** at app startup (before any `show` or `track` call). All SDKs require: `appId`, `accessKey`, `code`, `apiUrl`, `feedbackUrl`. The `eventUrl` parameter is optional (required only if you use event tracking).

**Do not commit** these values to your repository. Use local config files and add them to `.gitignore`.

### The `code` parameter

`code` is **required** at init. It identifies which survey/channel you want to display.

In `show()` and `healthCheck()`, `code` is **optional**:
- If you **omit** it, the SDK uses the default `code` from init.
- If you **pass** a different `code`, it overrides the default **for that call only**.

This allows apps with **multiple surveys** to show different surveys by passing different codes per call.

### Display rate limiting (`display_rate`)

The backend can return a `display_rate` value (0–100) for a survey. The SDK decides whether to show or skip based on this value. When skipped, the callback receives a `displayRateLimited` / `DISPLAY_RATE_LIMITED` status.

### Display once (`display_once`)

If a survey is configured to show only once per user, subsequent calls return `displayOnce` / `DISPLAY_ONCE` and the widget will not open.

---

## iOS (Native — Swift / Objective-C)

**SDK repository:** [github.com/Pisano/pisano-ios](https://github.com/Pisano/pisano-ios)
**Sample app:** [github.com/Pisano/feedback-sample-ios-app](https://github.com/Pisano/feedback-sample-ios-app)

### Requirements

- iOS 12.0+
- Xcode 12.0+
- Swift 5.0+ (Objective-C also supported)

### Installation

#### Swift Package Manager (recommended)

1. In Xcode: **File → Add Package Dependencies...**
2. Enter package URL:

```
https://github.com/Pisano/pisano-ios.git
```

3. Set version rule: **Up to Next Major** → **1.0.17**
4. Select the **`PisanoFeedback`** product and add it to your app target.

#### CocoaPods

Add to your `Podfile`:

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'Pisano', '~> 1.0.17'
end
```

Then run:

```bash
pod install
```

Open the `.xcworkspace` file (not `.xcodeproj`) after installation.

### Usage

```swift
import PisanoFeedback

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. BOOT — call once at app startup (AppDelegate)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#if DEBUG
Pisano.debugMode(true)   // verbose logs in debug builds
#endif

Pisano.boot(appId: "YOUR_APP_ID",
           accessKey: "YOUR_ACCESS_KEY",
           code: "YOUR_CODE",               // required
           apiUrl: "https://api.pisano.co",
           feedbackUrl: "https://web.pisano.co/web_feedback",
           eventUrl: nil) { status in        // optional
    print("Boot status: \(status.description)")
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. SHOW — display the feedback widget
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Minimal — uses boot code, full-screen mode
Pisano.show { status in
    print("Show status: \(status.description)")
}

// Full parameters
Pisano.show(
    mode: .bottomSheet,                                          // .default or .bottomSheet
    title: NSAttributedString(string: "We Value Your Feedback"), // optional
    language: "en",                                              // optional
    customer: [                                                  // optional
        "name": "John Doe",
        "email": "john@example.com",
        "phoneNumber": "+1234567890",
        "externalId": "CRM-12345"
    ],
    payload: ["source": "app", "screen": "home"],                // optional
    code: "ANOTHER_SURVEY_CODE"                                  // optional override
) { status in
    print("Show status: \(status.description)")
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. HEALTH CHECK — verify reachability before show
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pisano.healthCheck(language: "en", customer: nil, payload: nil, code: nil) { ok in
    if ok {
        Pisano.show { status in print(status.description) }
    } else {
        print("Health check failed")
    }
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. TRACK — track a custom event
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pisano.track(event: "purchase_completed",
            payload: ["product_id": "PROD-123"],
            customer: ["externalId": "USER-456"],
            language: "en") { status in
    print("Track status: \(status.description)")
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 5. CLEAR — clear SDK session/state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pisano.clear()
```

### Objective-C

```objc
#import <PisanoFeedback/PisanoFeedback-Swift.h>

// Boot
[Pisano bootWithAppId:@"YOUR_APP_ID"
           accessKey:@"YOUR_ACCESS_KEY"
               code:@"YOUR_CODE"
              apiUrl:@"https://api.pisano.co"
         feedbackUrl:@"https://web.pisano.co/web_feedback"
            eventUrl:nil
          completion:^(enum CloseStatus status) {
    NSLog(@"Boot: %ld", (long)status);
}];

// Show
[Pisano showWithMode:ViewModeBottomSheet
              title:[[NSAttributedString alloc] initWithString:@"Feedback"]
           language:@"en"
           customer:@{@"externalId": @"USER-123"}
            payload:@{@"source": @"app"}
               code:nil
         completion:^(enum CloseStatus status) {
    NSLog(@"Show: %ld", (long)status);
}];
```

---

## Android (Native — Kotlin / Java)

**SDK repository:** [github.com/Pisano/feedback-android](https://github.com/Pisano/feedback-android)
**Sample app:** [github.com/Pisano/feedback-sample-android-app](https://github.com/Pisano/feedback-sample-android-app)

### Requirements

- minSdk 21+
- Kotlin 1.6+ or Java 8+
- Android Gradle Plugin 7.0+

### Installation

#### Gradle (Maven Central)

In your **project-level** `build.gradle`, ensure Maven Central is included:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

In your **app-level** `build.gradle`:

```gradle
dependencies {
    implementation 'co.pisano:feedback:1.3.28'
}
```

Add permissions to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Sync your project and rebuild.

### Usage

```kotlin
import co.pisano.feedback.managers.PisanoSDK
import co.pisano.feedback.managers.PisanoSDKManager
import co.pisano.feedback.data.helper.ActionListener
import co.pisano.feedback.data.helper.PisanoActions
import co.pisano.feedback.data.helper.ViewMode
import co.pisano.feedback.data.model.PisanoCustomer

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. INIT — call once at app startup (Application class)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

val manager = PisanoSDKManager.Builder(context)
    .setApplicationId("YOUR_APP_ID")
    .setAccessKey("YOUR_ACCESS_KEY")
    .setCode("YOUR_CODE")                            // required
    .setApiUrl("https://api.pisano.co")
    .setFeedbackUrl("https://web.pisano.co/web_feedback")
    .setEventUrl("https://track.pisano.co/track")    // optional
    .setDebug(BuildConfig.DEBUG)                      // verbose logs in debug
    .setCloseStatusCallback(object : ActionListener {
        override fun action(action: PisanoActions) {
            when (action) {
                PisanoActions.INIT_SUCCESS -> Log.d("Pisano", "SDK init OK")
                PisanoActions.INIT_FAILED  -> Log.e("Pisano", "SDK init failed")
                PisanoActions.CLOSED       -> Log.d("Pisano", "Widget closed")
                PisanoActions.SEND_FEEDBACK -> Log.d("Pisano", "Feedback sent")
                PisanoActions.DISPLAY_RATE_LIMITED -> Log.d("Pisano", "Rate limited")
                PisanoActions.DISPLAY_ONCE -> Log.d("Pisano", "Already shown once")
                else -> {}
            }
        }
    })
    .build()

PisanoSDK.init(manager)


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. SHOW — display the feedback widget
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Minimal — uses init code, default full-screen mode
PisanoSDK.show()

// Full parameters
PisanoSDK.show(
    viewMode = ViewMode.BOTTOM_SHEET,
    title = Title(text = "We Value Your Feedback", textSize = 18f),
    language = "en",
    payload = hashMapOf("source" to "app", "screen" to "home"),
    pisanoCustomer = PisanoCustomer(
        name = "John Doe",
        email = "john@example.com",
        phoneNumber = "+1234567890",
        externalId = "CRM-12345"
    ),
    code = "ANOTHER_SURVEY_CODE"   // optional override
)


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. HEALTH CHECK — verify reachability
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PisanoSDK.healthCheck(
    language = "en",
    pisanoCustomer = PisanoCustomer(externalId = "USER-123"),
    payload = null,
    code = null   // use init code; or pass a string to override
) { isHealthy ->
    if (isHealthy) PisanoSDK.show()
}


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. TRACK — track a custom event
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PisanoSDK.track(
    event = "purchase_completed",
    payload = hashMapOf("product_id" to "PROD-123"),
    pisanoCustomer = PisanoCustomer(externalId = "USER-456"),
    languageCode = "en"
)


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 5. CLEAR — clear SDK local data
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PisanoSDK.clearAction()
```

#### Java

```java
// Init
PisanoSDKManager manager = new PisanoSDKManager.Builder(context)
    .setApplicationId("YOUR_APP_ID")
    .setAccessKey("YOUR_ACCESS_KEY")
    .setCode("YOUR_CODE")
    .setApiUrl("https://api.pisano.co")
    .setFeedbackUrl("https://web.pisano.co/web_feedback")
    .setDebug(BuildConfig.DEBUG)
    .build();

PisanoSDK.INSTANCE.init(manager);

// Show
PisanoSDK.INSTANCE.show(ViewMode.BOTTOM_SHEET, null, null, "en", null, null);

// Clear
PisanoSDK.INSTANCE.clearAction();
```

---

## React Native

**SDK repository:** [github.com/Pisano/feedback-react-native-sdk](https://github.com/Pisano/feedback-react-native-sdk)
**Sample app:** [github.com/Pisano/feedback-sample-react-native-app](https://github.com/Pisano/feedback-sample-react-native-app)

### Requirements

- Node 18+
- React Native 0.79+
- iOS: Xcode 15+, CocoaPods
- Android: JDK 17, Android SDK

### Installation

```bash
npm install feedback-react-native-sdk
# or
yarn add feedback-react-native-sdk
```

For iOS, install native pods:

```bash
cd ios && pod install && cd ..
```

For Android, no extra steps — Gradle resolves the native dependency automatically.

### Usage

```javascript
import {
  feedbackSDKBoot,
  feedbackSDKShow,
  feedbackSDKTrack,
  feedbackSDKClear,
  feedbackSDKViewMode
} from 'feedback-react-native-sdk';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. BOOT — call once at app startup
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feedbackSDKBoot(
  'YOUR_APP_ID',
  'YOUR_ACCESS_KEY',
  'YOUR_CODE',                                     // required
  'https://api.pisano.co',
  'https://web.pisano.co/web_feedback',
  '',                                              // eventUrl (optional)
  (status) => console.log('Boot:', status)
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. SHOW — display the feedback widget
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Minimal — uses boot code
feedbackSDKShow(
  feedbackSDKViewMode.Default,                     // viewMode
  null,                                            // title
  null,                                            // titleFontSize
  null,                                            // code (null = use boot code)
  'en',                                            // language
  new Map([['email', 'user@example.com']]),         // customer
  new Map([['source', 'app']]),                     // payload
  (result) => console.log('Show:', result)
);

// With code override
feedbackSDKShow(
  feedbackSDKViewMode.BottomSheet,
  'We Value Your Feedback',
  16,
  'ANOTHER_SURVEY_CODE',                           // override boot code
  'en',
  new Map([['externalId', 'USER-123'], ['phoneNumber', '+1234567890']]),
  new Map([['source', 'app'], ['screen', 'home']]),
  (result) => console.log('Show:', result)
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. TRACK — track a custom event
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feedbackSDKTrack(
  'purchase_completed',
  new Map([['product_id', 'PROD-123']]),           // payload
  new Map([['externalId', 'USER-456']]),           // customer
  'en',                                            // language
  (status) => console.log('Track:', status)
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. CLEAR — clear SDK state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

feedbackSDKClear();
```

### Show parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `viewMode` | `feedbackSDKViewMode` | Yes | `Default` (full screen) or `BottomSheet` |
| `title` | `string \| null` | No | Custom widget title |
| `titleFontSize` | `number \| null` | No | Title font size |
| `code` | `string \| null` | No | Override boot code for this call |
| `language` | `string \| null` | No | Language code (`en`, `tr`, ...) |
| `customer` | `Map<string, any>` | No | Customer properties |
| `payload` | `Map<string, string>` | No | Custom key-value payload |
| `callback` | `function` | Yes | Returns `feedbackSDKCallback` value |

---

## Flutter

**SDK repository:** [github.com/Pisano/feedback-flutter-sdk](https://github.com/Pisano/feedback-flutter-sdk)
**Sample app:** [github.com/Pisano/feedback-sample-flutter-app](https://github.com/Pisano/feedback-sample-flutter-app)

### Requirements

- Flutter SDK installed (`flutter --version`)
- iOS: Xcode + CocoaPods
- Android: JDK, Android SDK

### Installation

Add the SDK as a git dependency in `pubspec.yaml`:

```yaml
dependencies:
  feedback_flutter_sdk:
    git:
      url: https://github.com/Pisano/feedback-flutter-sdk.git
      ref: 0.0.17
```

Then:

```bash
flutter pub get
```

For iOS, install native pods:

```bash
cd ios
pod repo update && pod install
cd ..
```

For Android, no extra steps.

Credentials should be passed via `--dart-define-from-file=pisano_defines.json` (gitignored). See the sample app for the full setup.

### Usage

```dart
import 'package:feedback_flutter_sdk/feedback_flutter_sdk.dart';

final feedbackSdk = FeedbackFlutterSdk();

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 1. INIT — call once at app startup
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

await feedbackSdk.init(
  'YOUR_APP_ID',
  'YOUR_ACCESS_KEY',
  'https://api.pisano.co',
  'https://web.pisano.co/web_feedback',
  null,                    // eventUrl (optional)
  debugLogging: false,
  code: 'YOUR_CODE',      // required
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 2. SHOW — display the feedback widget
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Minimal — uses boot code
final callback = await feedbackSdk.show(
  viewMode: ViewMode.bottomSheetMode,
  language: 'en',
);
print('Show: $callback');

// Full parameters
final callback = await feedbackSdk.show(
  viewMode: ViewMode.bottomSheetMode,
  title: 'We Value Your Feedback',
  titleFontSize: 20,
  code: 'ANOTHER_SURVEY_CODE',          // optional override
  language: 'tr',
  customer: {
    'name': 'John Doe',
    'email': 'john@example.com',
    'phoneNumber': '+905001112233',
    'externalId': 'CRM-12345',
  },
  payload: {'source': 'app', 'screen': 'home'},
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 3. TRACK — track a custom event
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

final callback = await feedbackSdk.track(
  'purchase_completed',
  language: 'en',
  customer: {'externalId': 'USER-456'},
  payload: {'product_id': 'PROD-123'},
);


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 4. CLEAR — clear SDK state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

await feedbackSdk.clear();
```

### ViewMode

| Value | Description |
|-------|-------------|
| `ViewMode.defaultMode` | Full-screen overlay |
| `ViewMode.bottomSheetMode` | Bottom sheet |

---

## Callback / Status values

Each platform reports status through callbacks. The table below maps the common statuses across platforms:

| Status | iOS (`CloseStatus`) | Android (`PisanoActions`) | React Native (`feedbackSDKCallback`) | Flutter (`FeedbackCallback`) | Description |
|--------|---------------------|---------------------------|--------------------------------------|------------------------------|-------------|
| Widget opened | — | `OPENED` | `Opened` | `opened` | Widget is visible |
| Widget closed | `.closed` | `CLOSED` | `Closed` | `closed` | User closed the widget |
| Tapped outside | — | `OUTSIDE` | `Outside` | `outside` | Dismissed by tapping outside |
| Feedback sent | — | `SEND_FEEDBACK` | `SendFeedback` | `sendFeedback` | Survey submitted |
| Display rate limited | `.displayRateLimited` | `DISPLAY_RATE_LIMITED` | `DisplayRateLimited` | — | Skipped due to `display_rate` throttling |
| Display once | `.displayOnce` | `DISPLAY_ONCE` | `DisplayOnce` | `displayOnce` | Already shown once, won't repeat |
| Channel passive | — | `CHANNEL_PASSIVE` | `SurveyPassive` | — | Channel is in passive state |
| Health check failed | — | — | `HealthCheckFailed` | — | SDK initialization issue |

---

## Summary tables

### Where credentials come from

| Source | Values | Used in |
|--------|--------|---------|
| Profile → Mobile applications | **App ID**, **Access Key** | Init/boot only |
| Mobile Channels → Deploy → Publish Channel Parameters | **Code**, **Api Url**, **Feedback Url** | Init/boot + optional per-call override |

### `code` parameter across all SDKs

| Method | `code` | When omitted |
|--------|--------|--------------|
| **Init / Boot** | **Required** | SDK cannot initialize |
| **Show** | Optional | Uses init/boot code |
| **Health check** (iOS, Android) | Optional | Uses init/boot code |
| **Track** | N/A | Uses current SDK context |

### SDK versions (current)

| Platform | SDK | Latest version | Package manager |
|----------|-----|----------------|-----------------|
| iOS | `PisanoFeedback` | 1.0.17 | SPM / CocoaPods |
| Android | `co.pisano:feedback` | 1.3.28 | Gradle (Maven Central) |
| React Native | `feedback-react-native-sdk` | 0.2.10 | npm / yarn |
| Flutter | `feedback_flutter_sdk` | 0.0.17 | Git dependency (pubspec) |

### Security reminders

- **Never commit** `appId`, `accessKey`, or other credentials to source control.
- Use local config files:
  - iOS: `PisanoSecrets.plist` (gitignored)
  - Android: `local.properties` (gitignored)
  - React Native: `pisano.config.js` (gitignored)
  - Flutter: `pisano_defines.json` (gitignored)
- Each sample app repo includes an example config file you can copy and fill.
