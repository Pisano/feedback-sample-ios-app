# feedback-sample-ios-app — Release Notes (SDK 1.0.20 / MT-41)

**Sample app release:** aligns with **PisanoFeedback `1.0.20`** (SPM / CocoaPods via [pisano-ios](https://github.com/Pisano/pisano-ios))  
**Branch:** `feat/MT-41-sample` → `main`  
**Ticket:** MT-41 — bottom sheet behaviour + optional `dismissOnDrag`

---

## What changed in this sample repo

| Area | Change |
|------|--------|
| SPM minimum version | **1.0.20** (UIKit + SwiftUI Xcode projects) |
| UIKit sample | **Dismiss on drag** segmented control on form screen |
| SwiftUI sample | **Allow swipe-down dismiss** toggle on form screen |
| `FeedbackManager` | Forwards `dismissOnDrag` to `Pisano.show(...)` |
| Docs | README, `PISANO_SDK_GUIDE.md`, `Package.resolved` |

No credentials are committed. Local keys: `PisanoSecrets.plist` (copy from `PisanoSecrets.example.plist`).

---

## SDK highlights (1.0.20)

### `dismissOnDrag` (optional, default `false`)

| `dismissOnDrag` | Bottom sheet behaviour |
|-----------------|------------------------|
| `false` (default) | `isModalInPresentation = true` — swipe dismiss **disabled** |
| `true` | Swipe-down dismiss **enabled**; grabber visible on iOS 15+ |

---

## Upgrade your app (integrators)

### Swift Package Manager

1. Xcode → **Package Dependencies** → `https://github.com/Pisano/pisano-ios.git`
2. Version rule: **Up to Next Major** from **1.0.20** (or exact **1.0.20**)

### CocoaPods

```ruby
pod 'Pisano', '~> 1.0.20'
```

Then `pod install`.

### API

```swift
Pisano.show(
    mode: .bottomSheet,
    title: title,
    code: nil,
    language: "tr",
    customer: customer,
    payload: payload,
    dismissOnDrag: false  // optional — true enables swipe dismiss
) { status in
    // ...
}
```

**Breaking changes:** None. Existing `Pisano.show(...)` calls work unchanged.

---

## Sample projects in this repo

| Xcode project | Scheme | MT-41 UI |
|---------------|--------|----------|
| `pisano-ios-sdk-sample-app-uikit` | `pisano-feedback` | Segmented: **Drag off / Drag on** |
| `pisano-ios-sdk-sample-app` | SwiftUI app | Toggle: **Allow swipe-down dismiss** |

---

## Run this sample locally

1. Clone repo, checkout `feat/MT-41-sample` (or `main` after merge).
2. Copy credentials (do **not** commit):
   - UIKit: `pisano-ios-sdk-sample-app-uikit/App/Resources/PisanoSecrets.example.plist` → `PisanoSecrets.plist`
   - SwiftUI: `pisano-ios-sdk-sample-app/App/Resources/PisanoSecrets.example.plist` → `PisanoSecrets.plist`
3. Fill `PISANO_APP_ID`, `PISANO_ACCESS_KEY`, `PISANO_CODE`, `PISANO_API_URL`, `PISANO_FEEDBACK_URL`.
4. Open `.xcodeproj` in Xcode → select device → Run.
5. Welcome → Form → set mode + **Dismiss on drag** → **Show**.

---

## Smoke test checklist (MT-41)

| # | Test | Expected |
|---|------|----------|
| 1 | Bottom sheet open | Sheet presents modally |
| 2 | Dismiss on drag **Off** | Swipe down does not dismiss |
| 3 | Dismiss on drag **On** | Swipe down dismisses (grabber on iOS 15+) |
| 4 | Close via web UI | Survey closes normally |

---

## References

- Binary distribution: [pisano-ios `1.0.20`](https://github.com/Pisano/pisano-ios/releases/tag/1.0.20)
- Source & tag: [feedback-ios `1.0.20`](https://github.com/Pisano/feedback-ios)
- Technical doc: [MT-41_BOTTOM_SHEET.md](https://github.com/Pisano/feedback-ios/blob/main/docs/MT-41_BOTTOM_SHEET.md)
- CocoaPods: [Pisano 1.0.20](https://cocoapods.org/pods/Pisano)
