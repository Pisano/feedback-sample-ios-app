# feedback-sample-ios-app — Release Notes (SDK 1.1.0)

**Sample app release:** aligns with **PisanoFeedback `1.1.0`** (SPM / CocoaPods via [pisano-ios](https://github.com/Pisano/pisano-ios))

---

## What changed in this sample repo

| Area | Change |
|------|--------|
| SPM minimum version | **1.1.0** (UIKit + SwiftUI Xcode projects) |
| `Package.resolved` | Pinned to tag **1.1.0** |
| Deployment target | **iOS 15.0** (was 13.0). Xcode 27 builds only for iOS 15.0 and later. The SDK itself still supports **iOS 12.0+**. |
| Docs | README (1.1.0 notes, threading / timeout / cancellation, logout and user / tenant switch, Objective-C return types), `PISANO_SDK_GUIDE.md`, this file |

The sample code needs no changes for 1.1.0: existing `Pisano.boot`, `show`, `healthCheck`, `track` and `clear` calls compile and behave as documented.

No credentials are committed. Use `PisanoSecrets.plist` locally (see README).

---

## SDK 1.1.0 in short

- **Non-blocking:** SDK calls never block the calling thread; every `completion` is called asynchronously on the main thread.
- **Timeout and cancellation:** `Pisano.requestTimeout`; `boot`, `healthCheck`, `show` and `track` return a cancellable `PisanoTask`.
- **Logout / user or tenant switch:** `Pisano.clear()` cancels running calls, closes an open survey and removes all SDK data of the session.
- **Security / privacy:** credentials in the Keychain, no cached API responses, isolated cookies and survey web data, privacy manifest.
- **Swift 6:** clean under strict concurrency.

Full SDK notes, behaviour changes and known limitations: [pisano-ios RELEASE_NOTES_1.1.0.md](https://github.com/Pisano/pisano-ios/blob/master/RELEASE_NOTES_1.1.0.md)

---

## Verification

Both sample apps were built and run against the published `pisano-ios` tag `1.1.0` (Swift Package Manager). An end-to-end suite (boot, health check, show, bottom sheet, cancel, timeout, clear, Keychain / cookie / web data isolation) passed against a live environment on iOS 18.2 and 27.0 simulators, and on 18.6, 26.0, 26.2 and iPad 27 with the same SDK code.

---

## Upgrade (integrators)

### Swift Package Manager
1. Xcode → Package Dependencies → `https://github.com/Pisano/pisano-ios.git`
2. Version rule: **Up to Next Major** from **1.1.0**

### CocoaPods
```ruby
pod 'Pisano', '~> 1.1'
```
