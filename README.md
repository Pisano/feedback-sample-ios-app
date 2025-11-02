# Feedback iOS SDK

Pisano Feedback iOS SDK is an SDK that allows you to easily integrate user feedback collection into your iOS applications. With this SDK, you can collect surveys and feedback from your users and improve the user experience.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Usage Examples](#usage-examples)
- [Configuration](#configuration)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- ✅ **Web-Based Feedback Forms**: Modern and flexible web-based form support
- ✅ **Native iOS Integration**: Fully native iOS SDK
- ✅ **Objective-C Compatibility**: Can be used in both Swift and Objective-C projects
- ✅ **Flexible View Modes**: Full-screen and bottom sheet view options
- ✅ **Event Tracking**: Ability to track user activities
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
  pod 'Pisano', '~> [VERSION]'
end
```

2. Run the following command in Terminal:

```bash
pod install
```

3. Open the `.xcworkspace` file with Xcode.

## 🚀 Quick Start

### 1. Initializing the SDK

You must initialize the SDK before using it. The SDK initialization should be done either at application startup (usually in `AppDelegate`) or somewhere before calling the `show()` method.

#### Swift

```swift
import Feedback

// In AppDelegate
func application(_ application: UIApplication, 
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
    Pisano.debugMode(true) // Show logs only in debug mode
    #endif
    
    Pisano.boot(appId: "YOUR_APP_ID",
                accessKey: "YOUR_ACCESS_KEY",
                apiUrl: "https://api.pisano.co",
                feedbackUrl: "https://web.pisano.co/web_feedback",
                eventUrl: "https://track.pisano.co/track") { status in
        print("Boot status: \(status.description)")
    }
    
    return true
}
```

#### Objective-C

```objc
#import <Feedback/Feedback-Swift.h>

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #if DEBUG
    [Pisano debugMode:YES];
    #endif
    
    [Pisano bootWithAppId:@"YOUR_APP_ID"
               accessKey:@"YOUR_ACCESS_KEY"
                  apiUrl:@"https://api.pisano.co"
             feedbackUrl:@"https://web.pisano.co/web_feedback"
                eventUrl:@"https://track.pisano.co/track"
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

### `Pisano.boot()`

Initializes the SDK. This method must be called either at application startup (usually in `AppDelegate`) or before calling the `show()` method.

**Parameters:**
- `appId: String` - Your application's unique ID (required)
- `accessKey: String` - Your API access key (required)
- `apiUrl: String` - API endpoint URL (required)
- `feedbackUrl: String` - Feedback widget URL (required)
- `eventUrl: String?` - Event tracking URL (optional)
- `completion: ((CloseStatus) -> Void)?` - Initialization result callback (optional)
  - `.initSucces`: SDK initialized successfully
  - `.initFailed`: SDK initialization failed

**Example:**

```swift
Pisano.boot(appId: "app-123",
           accessKey: "key-456",
           apiUrl: "https://api.pisano.co",
           feedbackUrl: "https://web.pisano.co/web_feedback",
           eventUrl: "https://track.pisano.co/track") { status in
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

**User Information Keys:**
- `name`: User name
- `email`: Email address
- `phoneNumber`: Phone number
- `externalId`: External system ID (CRM, etc.)
- `customAttrs`: Custom attributes (Dictionary)

**CloseStatus Values:**
- `.closed`: User clicked the close button
- `.sendFeedback`: Feedback was sent
- `.outside`: Closed by clicking outside
- `.displayOnce`: Already shown before
- `.surveyPassive`: Survey is in passive state
- `.healthCheckFailed`: Health check failed

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

### `Pisano.track()`

Tracks user activities and automatically triggers the feedback widget if needed.

**Parameters:**
- `event: String` - Event name (required)
- `payload: [String: String]?` - Event data (optional)
- `customer: [String: Any]?` - User information (optional)
- `language: String?` - Language code (optional)
- `completion: (CloseStatus) -> Void` - Result callback

**Example:**

```swift
Pisano.track(event: "purchase_completed",
            payload: [
                "product_id": "PROD-123",
                "price": "99.99",
                "currency": "USD"
            ],
            customer: [
                "externalId": "USER-456",
                "email": "user@example.com"
            ],
            completion: { status in
                print("Track completed: \(status.description)")
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

## 💡 Usage Examples

### Swift Usage

#### UIKit Project

```swift
import UIKit
import Feedback

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
    
    @IBAction func trackEvent(_ sender: Any) {
        Pisano.track(event: "button_clicked",
                    payload: ["button_name": "feedback_button"],
                    completion: { _ in })
    }
}
```

#### SwiftUI Project

```swift
import SwiftUI
import Feedback

@main
struct MyApp: App {
    init() {
        #if DEBUG
        Pisano.debugMode(true)
        #endif
        
        Pisano.boot(appId: "YOUR_APP_ID",
                   accessKey: "YOUR_ACCESS_KEY",
                   apiUrl: "https://api.pisano.co",
                   feedbackUrl: "https://web.pisano.co/web_feedback",
                   eventUrl: "")
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
#import <Feedback/Feedback-Swift.h>

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

- (IBAction)trackEvent:(id)sender {
    [Pisano trackWithEvent:@"button_clicked"
                    payload:@{@"button_name": @"feedback_button"}
                   customer:nil
                   language:nil
                 completion:^(enum CloseStatus status) {
        NSLog(@"Track completed");
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
