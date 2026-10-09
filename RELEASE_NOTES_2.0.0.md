# Release 2.0.0

Events, a clear result rule, a typed customer and iOS 15 as the minimum.

This is a **major** release: it raises the minimum iOS version, replaces the customer dictionary with `PisanoCustomer`, renames two `CloseStatus` values in Swift and changes some results (see [Breaking changes](#breaking-changes)).

## Highlights

### Events: `Pisano.subscribe`

Follow what happens while a survey is on screen. The `show()` completion still reports the result once; events add the steps on the way, in this order and before the completion:

| Event | When |
|---|---|
| `opened` | The survey widget is on screen |
| `feedbackSubmitted` | The user submitted the survey, the moment the survey reports it (also in chat surveys); `hasChat` |
| `redirectedToStore` | The survey asked for the store review flow; `handledBySDK` |
| `closed` | The widget left the screen; `closeReason`: `closeButton`, `drag`, `outside`, `afterSubmit`, `clear`, `loadFailed`, `hostDismissed` |

```swift
let subscription = Pisano.subscribe { event in
    if event.type == .feedbackSubmitted { /* thank the user, analytics */ }
}
subscription.cancel()
```

### One result per call, and it says whether feedback was sent

- `completion` is called **exactly once** for a shown survey, and also when the survey is not shown: no boot data, no connection, a failed request or nothing to present on end the call with `.none` (before, no callback).
- Once the survey was submitted the result is `.sendFeedback`, however the widget closes: the thank-you screen timing out, the close button, a drag or an outside tap on the thank-you screen, or closing a chat survey later.
- `clear()` still ends the call with `.none`, now at every stage: also while the request is failing or the widget is about to be presented. That survey is not shown afterwards.

### Typed customer: `PisanoCustomer`

The customer is now passed as a `PisanoCustomer` with fixed fields, the same as on Android. In 1.x a misspelled dictionary key (for example `phone` instead of `phoneNumber`) was dropped without any sign; a misspelled field now does not compile.

```swift
let customer = PisanoCustomer(name: "Ada", phoneNumber: "+90555...", customAttributes: ["plan": "gold"])
Pisano.show(mode: .bottomSheet, pisanoCustomer: customer) { status in }
```

`show`, `healthCheck` and `track` take it as `pisanoCustomer:` (Objective-C too). Fields: `name`, `email`, `phoneNumber`, `externalId`, `customAttributes`. Only the fields you set are sent.

### App Store review: `Pisano.automaticStoreReview`

When a survey redirects to the store review flow, the SDK asks for the App Store review prompt by default, as before. Set `Pisano.automaticStoreReview = false` to run your own flow on the `redirectedToStore` event (`handledBySDK` is `false`). The prompt is now asked in the widget's window scene.

### Swift 6 ready

The SDK is built in the Swift 6 language mode with complete strict concurrency checking, and an app in the Swift 6 language mode uses it without warnings. Completions and event handlers are `@MainActor`; `PisanoTask`, `PisanoSubscription`, `PisanoEvent` and the enums are `Sendable`, so they can cross actors and tasks. Nothing changes for Swift 5 or Objective-C apps.

## Breaking changes

- **Minimum iOS 15.0**, Xcode 16. Apps that still support iOS 12–14 can stay on 1.1.0.
- **Customer:** the `customer: [String: Any]` parameter of `show`, `healthCheck` and `track` is replaced by `pisanoCustomer: PisanoCustomer`. In Objective-C the selectors change from `…customer:…` to `…pisanoCustomer:…`.
- **Swift renames:** `CloseStatus.initSucces` → `.initSuccess`, `.surveyPassive` → `.channelPassive`. The old names still compile with a deprecation warning, except in a `switch` that lists them without `default`. Objective-C names (`CloseStatusInitSucces`, `CloseStatusSurveyPassive`) and all raw values are unchanged.
- **Results:**
  - a submitted chat survey reports `.sendFeedback` (was `.closed`);
  - closing the thank-you screen early reports `.sendFeedback` once (was `.closed`, then `.sendFeedback` 3 seconds later);
  - your app dismissing the widget ends `show` with `.closed` (was: no callback);
  - a survey page that cannot load closes the widget and ends `show` with `.none` (was: an empty widget and no callback);
  - a survey that is not shown — no boot data, no connection, a failed detail or trigger request, nothing to present on — ends `show` with `.none` (was: no callback);
  - `clear()` while a survey is about to be presented ends `show` with `.none` and the survey is not shown (was: it could appear after `clear()`, with the ended session).
- **`track`** sends the customer in the same format as `show` (snake case, like Android); it used to send the dictionary unchanged.

## Fixes

- Dragging the bottom sheet away (`dismissOnDrag: true`) now reports `.closed`; before, the completion was never called.
- The close-on-outside-click recognizer no longer goes on your app's window and no longer turns on `isUserInteractionEnabled` on your view.
- The widget is released when it closes in any way, including when your app dismisses it.
- The old drag line image no longer shows above the bottom sheet; the system grabber shows only with `dismissOnDrag: true`.
- The bottom sheet no longer stays blank while the survey loads: the survey's own loader shows right away, centered in the visible part of the sheet.

## Migrating from 1.1.0

1. Raise the deployment target to iOS 15.0 and update to 2.0.0 (SPM: Up to Next Major from 2.0.0; CocoaPods: `pod 'Pisano', '~> 2.0'`).
2. Replace `.initSucces` / `.surveyPassive` with `.initSuccess` / `.channelPassive` in Swift.
3. Replace the customer dictionary with `PisanoCustomer`:

   | 1.x dictionary key | `PisanoCustomer` field |
   |---|---|
   | `name` | `name` |
   | `email` | `email` |
   | `phoneNumber` | `phoneNumber` |
   | `externalId` | `externalId` |
   | `customAttrs` | `customAttributes` |

   ```swift
   // 1.x
   Pisano.show(customer: ["name": "Ada", "customAttrs": ["plan": "gold"]]) { _ in }
   // 2.0
   Pisano.show(pisanoCustomer: PisanoCustomer(name: "Ada", customAttributes: ["plan": "gold"])) { _ in }
   ```

4. If you count `.closed` as "not submitted", note that submitted chat surveys and early-closed thank-you screens now report `.sendFeedback`.
5. Optional: subscribe to events, set `automaticStoreReview`.
6. Remove any `pisano-actions` NotificationCenter observer: the SDK has not posted it for several releases.

## Known limitations

- The survey page shows its thank-you screen 2–3 seconds before it reports the submit. If the user closes it in that time, the call ends with `.closed` and no `feedbackSubmitted` event. A fix on the survey side is planned.
- `track`'s `completion` is still only called on `cancel()`.
- `show` has no overall timeout yet: a request that never answers ends only by `Pisano.requestTimeout`, `cancel()` or `clear()`.
