# Release 2.0.0

Events, a clear result rule, a typed customer and iOS 15 as the minimum.

This is a **major** release: it raises the minimum iOS version, renames two `CloseStatus` values in Swift and changes some results (see [Breaking changes](#breaking-changes)). Most apps only need to raise their deployment target.

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

- `completion` is called **exactly once** for a shown survey.
- Once the survey was submitted the result is `.sendFeedback`, however the widget closes: the thank-you screen timing out, the close button, a drag or an outside tap on the thank-you screen, or closing a chat survey later.
- `clear()` still ends the call with `.none`.

### Typed customer: `PisanoCustomer`

Same fields as Android. A misspelled field is a compile error instead of data that never arrives.

```swift
let customer = PisanoCustomer(name: "Ada", phoneNumber: "+90555...", customAttributes: ["plan": "gold"])
Pisano.show(mode: .bottomSheet, pisanoCustomer: customer) { status in }
```

`show`, `healthCheck` and `track` have `pisanoCustomer:` variants (Objective-C too). The `customer:` dictionary variants keep working and now:

- map the spellings in use to the right field, ignoring case and `_` / `-`: `phone`, `phone_number` → `phoneNumber`; `external_id` → `externalId`; `customAttrs`, `custom_attrs`, `custom_attributes` → `customAttributes`;
- log `Pisano: Customer keys not supported and not sent: …` for anything else, always (not only in debug mode).

### App Store review: `Pisano.automaticStoreReview`

When a survey redirects to the store review flow, the SDK asks for the App Store review prompt by default, as before. Set `Pisano.automaticStoreReview = false` to run your own flow on the `redirectedToStore` event (`handledBySDK` is `false`). The prompt is now asked in the widget's window scene.

### Swift 6 ready

The SDK is built in the Swift 6 language mode with complete strict concurrency checking, and an app in the Swift 6 language mode uses it without warnings. Completions and event handlers are `@MainActor`; `PisanoTask`, `PisanoSubscription`, `PisanoEvent` and the enums are `Sendable`, so they can cross actors and tasks. Nothing changes for Swift 5 or Objective-C apps.

## Breaking changes

- **Minimum iOS 15.0**, Xcode 16. Apps that still support iOS 12–14 can stay on 1.1.0.
- **Swift renames:** `CloseStatus.initSucces` → `.initSuccess`, `.surveyPassive` → `.channelPassive`. The old names still compile with a deprecation warning, except in a `switch` that lists them without `default`. Objective-C names (`CloseStatusInitSucces`, `CloseStatusSurveyPassive`) and all raw values are unchanged.
- **Results:**
  - a submitted chat survey reports `.sendFeedback` (was `.closed`);
  - closing the thank-you screen early reports `.sendFeedback` once (was `.closed`, then `.sendFeedback` 3 seconds later);
  - your app dismissing the widget ends `show` with `.closed` (was: no callback);
  - a survey page that cannot load closes the widget and ends `show` with `.none` (was: an empty widget and no callback).
- **`track`** sends the customer in the same format as `show` (snake case, like Android); it used to send the dictionary unchanged.
- **`customAttributes`** is the canonical custom attributes key. `customAttrs` is still accepted.

## Fixes

- Dragging the bottom sheet away (`dismissOnDrag: true`) now reports `.closed`; before, the completion was never called.
- The close-on-outside-click recognizer no longer goes on your app's window and no longer turns on `isUserInteractionEnabled` on your view.
- The widget is released when it closes in any way, including when your app dismisses it.
- The old drag line image no longer shows above the bottom sheet; the system grabber shows only with `dismissOnDrag: true`.
- The bottom sheet no longer stays blank while the survey loads: the survey's own loader shows right away, centered in the visible part of the sheet.

## Migrating from 1.1.0

1. Raise the deployment target to iOS 15.0 and update to 2.0.0 (SPM: Up to Next Major from 2.0.0; CocoaPods: `pod 'Pisano', '~> 2.0'`).
2. Replace `.initSucces` / `.surveyPassive` with `.initSuccess` / `.channelPassive` in Swift.
3. If you count `.closed` as "not submitted", note that submitted chat surveys and early-closed thank-you screens now report `.sendFeedback`.
4. Optional: move to `PisanoCustomer`, subscribe to events, set `automaticStoreReview`.
5. Remove any `pisano-actions` NotificationCenter observer: the SDK has not posted it for several releases.

## Known limitations

- The survey page shows its thank-you screen 2–3 seconds before it reports the submit. If the user closes it in that time, the call ends with `.closed` and no `feedbackSubmitted` event. A fix on the survey side is planned.
- `track`'s `completion` is still only called on `cancel()`.
- Some `show` failures before the widget is presented (for example no boot data or a network error) still do not call `completion`; use `cancel()`.
