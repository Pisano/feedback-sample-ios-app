# feedback-sample-ios-app — Release Notes (SDK 1.0.21)

**Sample app release:** aligns with **PisanoFeedback `1.0.21`** (SPM / CocoaPods via [pisano-ios](https://github.com/Pisano/pisano-ios))

---

## What changed in this sample repo

| Area | Change |
|------|--------|
| SPM minimum version | **1.0.21** (UIKit + SwiftUI Xcode projects) |
| `Package.resolved` | Pinned to tag **1.0.21** |
| Docs | README, `PISANO_SDK_GUIDE.md`, this file |

UIKit and SwiftUI samples retain **Dismiss on drag** controls from 1.0.20.

No credentials are committed. Use `PisanoSecrets.plist` locally (see README).

---

## SDK highlights (1.0.21)

### WebView zoom control (channel configuration)

From Pisano panel field `disable_zoom`:

- **Enabled** — Pinch-to-zoom disabled in survey WebView
- **Disabled or not set** — Pinch-to-zoom works as before
- **Text inputs** — Auto-zoom on focus always disabled

No app API change; applied after SDK detail fetch.

### Keyboard and viewport

- Keyboard open triggers viewport layout sync in web widget
- Bottom sheet: survey scroll stays inside web content

### Included from 1.0.20

- Optional `dismissOnDrag` on `Pisano.show()` (sample UI: Off / On)
- Required `code` in `Pisano.boot()` (from 1.0.17+)

---

## Upgrade (integrators)

### Swift Package Manager

1. Xcode → Package Dependencies → `https://github.com/Pisano/pisano-ios.git`
2. Version rule: **Up to Next Major** from **1.0.21** (or exact **1.0.21**)

### CocoaPods

```ruby
pod 'Pisano', '~> 1.0.21'
```

**Breaking changes:** None

---

## References

- Binary: [pisano-ios 1.0.21](https://github.com/Pisano/pisano-ios/releases/tag/1.0.21)
- Source: [feedback-ios 1.0.21](https://github.com/Pisano/feedback-ios)
- CocoaPods: [Pisano 1.0.21](https://cocoapods.org/pods/Pisano)
