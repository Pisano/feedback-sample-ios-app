# Pisano Feedback iOS SDK — MT-41 (`dismissOnDrag`)

**SDK version:** `PisanoFeedback` **1.0.20+**

## What's new

- **`Pisano.show(dismissOnDrag:)`** — Optional parameter (default `false`).
- **Default bottom sheet:** `isModalInPresentation = true` (swipe dismiss disabled).
- **`dismissOnDrag: true`:** Swipe-down dismiss enabled; grabber visible on iOS 15+.

## Sample apps in this repo

| Project | Control |
|---------|---------|
| `pisano-ios-sdk-sample-app-uikit` | **Dismiss on drag** segmented control on form screen |
| `pisano-ios-sdk-sample-app` (SwiftUI) | **Toggle** on form screen |

```swift
Pisano.show(mode: .bottomSheet, dismissOnDrag: true) { status in
    // ...
}
```

See also: [feedback-ios/docs/MT-41_BOTTOM_SHEET.md](https://github.com/Pisano/feedback-ios/blob/main/docs/MT-41_BOTTOM_SHEET.md)
