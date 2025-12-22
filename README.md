# Feedback iOS SDK

Pisano Feedback iOS SDK is an SDK that allows you to easily integrate user feedback collection into your iOS applications. With this SDK, you can collect surveys and feedback from your users and improve the user experience.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
  - [CloseStatus](#closestatus)
- [Usage Examples](#usage-examples)
- [Configuration](#configuration)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- ✅ **Web-Based Feedback Forms**: Modern and flexible web-based form support
- ✅ **Native iOS Integration**: Fully native iOS SDK
- ✅ **Objective-C Compatibility**: Can be used in both Swift and Objective-C projects
- ✅ **Flexible View Modes**: Full-screen and bottom sheet view options
- ✅ **Health Check**: Ability to check SDK status
- ✅ **User Information Support**: Ability to send user data
- ✅ **Multi-Language Support**: Ability to display surveys in different languages
- ✅ **Custom Title**: Customizable title support

## 📱 Requirements

- iOS 11.0 or higher
- Xcode 12.0 or higher
- Swift 5.0 or higher

## 📦 Installation

### Installation with CocoaPods

1. Create or edit your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!

target 'YourApp' do
  pod 'Pisano', '~> 1.0.16'
end
```

2. Run the following command in Terminal:

```bash
pod install
```

3. Open the `.xcworkspace` file with Xcode.

### Installation with Swift Package Manager (recommended)

1. In Xcode: **File → Add Package Dependencies...**
2. Enter package URL: `https://github.com/Pisano/pisano-ios.git`
3. Select version rule **Up to Next Major** and set it to **1.0.16**
4. Add the product **`PisanoFeedback`** to your app target

> Note: This repository contains sample iOS apps and is already configured with SPM. There is no `Podfile` in this repo unless you add one.

## 🧩 Native vs Web-Based usage

This repo includes two sample apps:

- **Web-Based sample**: `iOS SDK Web-Based/pisano-feedback.xcodeproj` (imports `PisanoFeedback`)
- **Native sample**: `iOS SDK Native/pisano-feedback.xcodeproj` (imports `PisanoFeedback`)

> Note: In SDK **1.0.16**, both samples use the same module/product (`PisanoFeedback`). The “Web-Based vs Native” naming here is about the **usage style** (web widget URL + boot/show flow vs native-focused sample UI), not different packages.

### Web-Based (Feedback) — boot once, then show

1. Call `Pisano.boot(...)` once at app startup (e.g. `AppDelegate`).
2. Later, call `Pisano.show(...)`.

In this repo’s Web-Based sample, credentials are read from `Info.plist` keys:
`PISANO_APP_ID`, `PISANO_ACCESS_KEY`, `PISANO_API_URL`, `PISANO_FEEDBACK_URL`.

### Native (PisanoFeedback) — create instance, then show

1. Create a `Pisano(appId:accessKey:apiUrl:)` instance when you need it.
2. Call `pisano.show(...)`.

In this repo’s Native sample, credentials are read from `Info.plist` keys:
`PISANO_APP_ID`, `PISANO_ACCESS_KEY`, `PISANO_API_URL`.

## 🚀 Quick Start

### 1. Initializing the SDK

You must initialize the SDK before using it. The SDK initialization should be done either at application startup (usually in `AppDelegate`) or somewhere before calling the `show()` method.

#### Swift

```swift
import PisanoFeedback

// In AppDelegate
func application(_ application: UIApplication, 
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
    Pisano.debugMode(true) // Show logs only in debug mode
    #endif
    
    Pisano.boot(appId: "YOUR_APP_ID",
                accessKey: "YOUR_ACCESS_KEY",
                apiUrl: "https://api.pisano.co",
                feedbackUrl: "https://web.pisano.co/web_feedback") { status in
        print("Boot status: \(status.description)")
    }
    
    return true
}
```

#### Objective-C

```objc
#import <PisanoFeedback/PisanoFeedback-Swift.h>

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #if DEBUG
    [Pisano debugMode:YES];
    #endif
    
    [Pisano bootWithAppId:@"YOUR_APP_ID"
               accessKey:@"YOUR_ACCESS_KEY"
                  apiUrl:@"https://api.pisano.co"
             feedbackUrl:@"https://web.pisano.co/web_feedback"
              completion:^(enum CloseStatus status) {
        NSLog(@"Boot status: %@", @(status));
    }];
    
    return YES;
}
```

### 2. Showing the Feedback Widget

#### Basic Usage

```swift
Pisano.show { status in
    print("Feedback closed with status: \(status.description)")
}
```

#### Advanced Usage

```swift
Pisano.show(mode: .bottomSheet,
           title: NSAttributedString(string: "We Value Your Feedback"),
           flowId: "specific-flow-id",
           language: "en",
           customer: [
               "name": "John Doe",
               "email": "john@example.com",
               "phoneNumber": "+1234567890",
               "externalId": "CRM-12345"
           ],
           payload: ["source": "app", "screen": "home"],
           completion: { status in
               print("Status: \(status.description)")
           })
```

## 📚 API Reference

### CloseStatus

The `CloseStatus` enum is returned by various SDK methods to indicate the result of an operation.

**CloseStatus Values:**
- `.initSucces`: SDK initialized successfully
- `.initFailed`: SDK initialization failed
- `.closed`: Widget closed
- `.opened`: Widget opened
- `.sendFeedback`: Feedback was sent
- `.outside`: Closed by clicking outside
- `.displayOnce`: Already shown before
- `.preventMultipleFeedback`: Multiple feedback prevention triggered
- `.channelQuotaExceeded`: Channel quota exceeded
- `.surveyPassive`: Survey is in passive state
- `.healthCheckSuccessful`: Health check passed
- `.healthCheckFailed`: Health check failed

> Note: Available cases can vary by SDK version. Prefer using `status.description` for logging/UI.

### `Pisano.boot()`

Initializes the SDK. This method must be called either at application startup (usually in `AppDelegate`) or before calling the `show()` method.

**Parameters:**
- `appId: String` - Your application's unique ID (required)
- `accessKey: String` - Your API access key (required)
- `apiUrl: String` - API endpoint URL (required)
- `feedbackUrl: String` - Feedback widget URL (required)
- `eventUrl: String?` - Event tracking URL (optional)
- `completion: ((CloseStatus) -> Void)?` - Initialization result callback (optional)
  
  Returns `.initSucces` or `.initFailed`. See [CloseStatus](#closestatus) for all possible values.

**Example:**

```swift
Pisano.boot(appId: "app-123",
           accessKey: "key-456",
           apiUrl: "https://api.pisano.co",
           feedbackUrl: "https://web.pisano.co/web_feedback",
           eventUrl: "https://event.pisano.co") { status in
    switch status {
    case .initSucces:
        print("SDK initialized successfully")
    case .initFailed:
        print("SDK initialization failed")
    default:
        break
    }
}
```

### `Pisano.show()`

Displays the feedback widget.

**Parameters:**
- `mode: ViewMode` - View mode (default: `.default`)
  - `.default`: Full-screen overlay
  - `.bottomSheet`: Bottom sheet (iOS 13+)
- `title: NSAttributedString?` - Custom title (optional)
- `flowId: String?` - Specific flow ID (optional)
- `language: String?` - Language code (e.g., "en", "tr") (optional)
- `customer: [String: Any]?` - User information (optional)
- `payload: [String: String]?` - Extra data (optional)
- `completion: (CloseStatus) -> Void` - Widget close callback
  
  See [CloseStatus](#closestatus) for all possible return values.

**User Information Keys:**
- `name`: User name
- `email`: Email address
- `phoneNumber`: Phone number
- `externalId`: External system ID (CRM, etc.)
- `customAttrs`: Custom attributes (Dictionary)

**Example:**

```swift
Pisano.show(mode: .bottomSheet,
           title: NSAttributedString(
               string: "We Value Your Feedback",
               attributes: [
                   .font: UIFont.boldSystemFont(ofSize: 18),
                   .foregroundColor: UIColor.systemBlue
               ]
           ),
           language: "en",
           customer: [
               "name": "John Doe",
               "email": "john@example.com",
               "externalId": "USER-123"
           ],
           completion: { status in
               switch status {
               case .sendFeedback:
                   print("Feedback sent!")
               case .closed:
                   print("Widget closed")
               default:
                   break
               }
           })
```

### `Pisano.healthCheck()`

Checks the SDK status. It is recommended to use this before displaying the feedback widget.

**Parameters:**
- `flowId: String?` - Flow ID (optional)
- `language: String?` - Language code (optional)
- `customer: [String: Any]?` - User information (optional)
- `payload: [String: String]?` - Extra data (optional)
- `completion: (Bool) -> Void` - Health check result (true: successful, false: failed)

**Example:**

```swift
Pisano.healthCheck(flowId: "flow-123",
                   customer: ["externalId": "USER-789"]) { isHealthy in
    if isHealthy {
        Pisano.show()
    } else {
        print("SDK health check failed")
    }
}
```

### `Pisano.debugMode()`

Enables or disables debug mode. Detailed logs are displayed in debug mode.

```swift
#if DEBUG
Pisano.debugMode(true)
#else
Pisano.debugMode(false)
#endif
```

### `Pisano.track()`

Tracks an event (if supported by your SDK version).

**Parameters:**
- `event: String` - Event name (required)
- `payload: [String: String]?` - Event payload data (optional)
- `customer: [String: Any]?` - User information (optional)
- `language: String?` - Language code (optional)
- `completion: (CloseStatus) -> Void` - Completion callback

**Example:**

```swift
Pisano.track(event: "purchase_completed",
            payload: ["order_id": "12345", "amount": "99.99"],
            customer: ["email": "john@example.com"],
            language: "en") { status in
    print("Event tracked: \(status.description)")
}
```

### `Pisano.clear()`

Clears saved/session data (if needed by your flow).

```swift
Pisano.clear()
```

## 💡 Usage Examples

### Swift Usage

#### UIKit Project

```swift
import UIKit
import PisanoFeedback

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showFeedback(_ sender: Any) {
        Pisano.show(mode: .bottomSheet,
                   language: "en",
                   customer: ["externalId": "USER-123"],
                   completion: { status in
                       print("Feedback status: \(status.description)")
                   })
    }
}
```

#### SwiftUI Project

```swift
import SwiftUI
import PisanoFeedback

@main
struct MyApp: App {
    init() {
        #if DEBUG
        Pisano.debugMode(true)
        #endif
        
        Pisano.boot(appId: "YOUR_APP_ID",
                   accessKey: "YOUR_ACCESS_KEY",
                   apiUrl: "https://api.pisano.co",
                   feedbackUrl: "https://web.pisano.co/web_feedback")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Feedback") {
                Pisano.show(mode: .bottomSheet,
                           title: NSAttributedString(string: "Your Feedback"),
                           customer: ["email": "user@example.com"],
                           completion: { _ in })
            }
        }
    }
}
```

### Objective-C Usage

```objc
#import <PisanoFeedback/PisanoFeedback-Swift.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showFeedback:(id)sender {
    [Pisano showWithMode:ViewModeBottomSheet
                   title:nil
                  flowId:nil
                language:@"en"
                customer:@{@"externalId": @"USER-123"}
                 payload:nil
              completion:^(enum CloseStatus status) {
        NSLog(@"Feedback status: %@", @(status));
    }];
}

@end
```

### Listening to Events with NotificationCenter

The SDK also notifies about widget close status through NotificationCenter.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(pisanoEventReceived(_:)),
        name: Notification.Name("pisano-actions"),
        object: nil
    )
}

@objc func pisanoEventReceived(_ notification: Notification) {
    if let closeStatus = notification.userInfo?["closeStatus"] as? String {
        switch closeStatus {
        case "button":
            print("Widget closed with button")
        case "sendFeedback":
            print("Feedback sent")
        case "outside":
            print("Closed by clicking outside")
        default:
            break
        }
    }
}
```

## ⚙️ Configuration

### ViewMode

You can select the view mode:

```swift
// Full-screen overlay (default)
Pisano.show(mode: .default)

// Bottom sheet (iOS 13+)
Pisano.show(mode: .bottomSheet)
```

### Custom Title

You can customize the widget title:

```swift
let title = NSAttributedString(
    string: "WE VALUE YOUR FEEDBACK",
    attributes: [
        .font: UIFont.boldSystemFont(ofSize: 18),
        .foregroundColor: UIColor.systemBlue,
        .kern: 1.5
    ]
)

Pisano.show(title: title)
```

### User Information

You can provide a personalized experience by sending user information:

```swift
let customer: [String: Any] = [
    "name": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "externalId": "CRM-12345",
    "customAttrs": [
        "language": "en",
        "city": "New York",
        "gender": "male",
        "birthday": "1990-01-01"
    ]
]

Pisano.show(customer: customer)
```

**Valid user keys:**
- `name`: User name
- `email`: Email address
- `phoneNumber`: Phone number
- `externalId`: External system ID
- `customAttrs`: Custom attributes (Dictionary)

## ❓ Frequently Asked Questions

### When should I initialize the SDK?

You must initialize the SDK either at application startup (in `AppDelegate`) or before calling the `show()` method.

### Should I use health check?

Health check allows you to check the SDK status before displaying the widget. It is recommended to use it before showing the widget on important screens.

### How can I display the widget in different languages?

You can display the widget in different languages using the `language` parameter:

```swift
Pisano.show(language: "en") // English
Pisano.show(language: "tr") // Turkish
```

### What is the display once feature?

This feature ensures that the widget is shown to the user only once. This control is managed by the backend.

## 🔧 Troubleshooting

### SDK won't initialize

1. Make sure `appId` and `accessKey` values are correct
2. Check that API URLs are accessible
3. Enable debug mode to review logs:

```swift
Pisano.debugMode(true)
```

### Widget won't display

1. Make sure `Pisano.boot()` method completed successfully
2. Check SDK status by performing a health check
3. Check internet connection

### Objective-C usage error

Make sure you added the `#import <Feedback/Feedback-Swift.h>` import in Objective-C projects.

### Bottom sheet not working

Bottom sheet feature requires iOS 13+. On versions below iOS 13, bottom sheet mode may not work properly, and it is recommended to use `.default` mode in this case.
