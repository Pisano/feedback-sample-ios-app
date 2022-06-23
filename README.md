# Pisano Feedback Sample Application

It is a sample iOS application using the Feedback SDK.

## How to use Feedback SDK

You can check the latest releases [here](https://github.com/Pisano/pisano-ios).

### Supported iOS Versions
Pisano iOS SDK supports iOS 10+ and Xcode 12 is required to build Pisano iOS SDK.

## Installation Methods

### Manual Installation
You can install Pisano iOS SDK in your mobile application by include xcframework library provided by Pisano. Please visit the following link to download the xcframework file.
https://pisano-engineering.s3-eu-west-1.amazonaws.com/Feedback-CC.xcframework.zip

### CocoaPods

Alternatively, you can install Pisano i
OS SDK via CocoaPods
Cocoapods 1.10 or above is required to install Pisano. Add the Pisano pod into your Podfile and run pod install.

```yaml
target :YourTargetName do 
  pod 'Pisano'
end
```

### Swift Package Manager
Last method is Swift Package Manager.
Add https://github.com/Pisano/pisano-ios as a Swift Package Repository in Xcode and follow the instructions to add Pisano as a Swift Package.

## Permissions

In order to use Pisano iOS SDK, you should add the following permissions in Info.plist file

| Permission Key Value | | |
| ------- | --- | --- |
| Camera | Privacy - Camera Usage Description | $(PRODUCT_NAME) camera use |
| Gallery Access | Privacy - Photo Library Usage Description | $(PRODUCT_NAME) photo use |
| Saving Photo to Gallery | Privacy - Photo Library Additions Usage Description | $(PRODUCT_NAME) photo save |


## Booting Pisano iOS SDK

After adding the dependencies and permissions, you are now able to call the methods of Pisano iOS SDK.

### Swift

```yaml
import Feedback

Pisano.boot(appId: "", 
            accessKey: "",
            apiUrl: "",
            feedbackUrl: "")
```

### Objective-C

```yaml
#import <Feedback/Feedback-Swift.h>

[Pisano bootWithAppId: @""
        accessKey:@""
        apiUrl: @""
        feedbackUrl: @""];
```

| Parameter Name | Type  | Description  |
| ------- | --- | --- |
| appId  | String | The application ID that can be obtained from Pisano Dashboard  |
| accessKey  | String | The access key can be obtained from Pisano Dashboard |
| apiUrl  | String | The URL of API that will be accessed |
| feedbackUrl  | String | Base URL for survey |

## Show Method

### Swift

```yaml
import Feedback

Pisano.show(flowId: "",
            language: "",
            customer: ["email": "",
                       "name": "",
                       "phone": "",
                       "externalId": ""],
            payload: ["key" : "value", "key2":"value2"]
)
```

### Objective-C

```yaml
# import <Feedback-Swift.h>

[Pisano showWithFlowId: @"flow-id-that-can-be-obtained-from-dashboard"
        language: @"TR"
        customer: @{@"email": @"leo@pisano.co", @"externalId": @"123"},
        payload:
          @[@{@"question": @"transactionAmount", @"answer": @"100.20"]},
          @{@"question":
          @"BranchCode", @"answer": @"990"}]];
```

| Parameter  Name | Type  | Description  |
| ------- | --- | --- |
| flowId | String | The ID of related flow. Can be obtained from Pisano Dashboard. Can be sent as empty string "" for default flow |
| language | String | Language code |
| payload | Dictionary  | Question and related answer in an array (mostly uses for pre-loaded responses to take transactional data(s))  |
| customer | Dictionary | Customer Properties |

## Pisano Action Callbacks

```yaml
NotificationCenter.default.addObserver(forName: Notification.Name("pisano-actions"), 
  object: nil, queue: .main) { notification in
    if let userInfo = notification.userInfo,
       let closeStatus = userInfo["closeStatus"] as? String {
        
        switch closeStatus {
        case "closed":
            print("sdk is closed")
        case "sendFeedback":
            print("send feedback")
        case "opened":
            print("sdk is opened")
        case "displayOnce":
            print("Survey won't be shown due to the customer saw it before.")
        case "preventMultipleFeedback":
            print("Survey won't be shown due to customer already submitted a feedback in a given time period.")
        case "outside":
            print("other case")
        default:
            break;
        }
    }
}
```

| Event  Name | Description  |
| ------- | --- | 
| closed | Closed Survey  |
| opened | Opened Survey | 
| sendFeedback  | Send Feedback   |
| displayOnce  | Survey won't be shown due to the customer saw it before.  |
| preventMultipleFeedback  | Survey won't be shown due to customer already submitted a feedback in a given time period.  |
| outside | Others |

