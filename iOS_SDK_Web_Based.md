## How to use Feedback SDK

### Supported iOS Versions
Pisano iOS SDK supports iOS 12+ and min Xcode 12 is required to build Pisano iOS SDK.

## Installation Methods

### Manual Installation
You can install Pisano iOS SDK in your mobile application by include xcframework library provided by Pisano. Please visit the following link to download the xcframework file.

https://github.com/Pisano/pisano-ios/tree/master/iOS%20SDK%20Web-Based

### CocoaPods

Alternatively, you can install Pisano iOS SDK via CocoaPods
Cocoapods 1.10 or above is required to install Pisano. Add the Pisano pod into your Podfile and run pod install.

```yaml
target :YourTargetName do 
  pod 'Pisano', '~> 0.2.4'
end
```

### Swift Package Manager
Last method is Swift Package Manager.
Add https://github.com/Pisano/pisano-ios as a Swift Package Repository in Xcode and follow the instructions and set Up To Next Major Version as "**0.2.4**" to add Pisano as a Swift Package.

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

Pisano.boot(appId: String, 
            accessKey: String,
            apiUrl: String,
            feedbackUrl: String) { status in
            print(status.description)
  }
```

### Objective-C

```yaml
#import <Feedback/Feedback-Swift.h>

[Pisano bootWithAppId:NSString
                accessKey:NSString
                   apiUrl:NSString
              feedbackUrl:NSString
                 eventUrl:(NSString * _Nullable)
               completion:^(enum CloseStatus status) {
        
    }];
```

| Parameter Name | Type  | Description  |
| ------- | --- | --- |
| appId  | String | The application ID that can be obtained from Pisano Dashboard  |
| accessKey  | String | The access key can be obtained from Pisano Dashboard |
| apiUrl  | String | The URL of API that will be accessed |
| feedbackUrl  | String | Base URL for survey |
| completion | Closure | CloseStatus Enum |

## Show Method

### Swift

```yaml
import Feedback

Pisano.show(mode: ViewMode.default
            title: nil,
            flowId: "",
            language: "TR",
            customer: ["email": "",
                       "name": "",
                       "phone": "",
                       "externalId": ""],
            payload: ["key" : "value", "key2":"value2"],
            completion: { closeStatus in
              print(closeStatus) // CloseStatus Enum
              print(closeStatus.description) // CloseStatus Enum Case Description
            })
```

### Objective-C

```yaml
#import <Feedback/Feedback-Swift.h>

[Pisano showWithMode:ViewModeDefault
                   title:NULL
                   flowId:@"flow-id-that-can-be-obtained-from-dashboard"
                  language:@"TR"
                  customer:@{
                      @"email": @"leo@pisano.co",
                      @"externalId": @"123"
                  }
                   payload:@{
                    @"question": @"transactionAmount",
                    @"answer": @"100.20"
                  }
                completion:^(CloseStatus result) {
        CloseStatus status = result;
        NSLog(@"%ld", (long)status);
    }];
```

| Parameter  Name | Type  | Description  |
| ------- | --- | --- |
| mode | Enum | View Mode Enum to set presentation style (Default - BottomSheet) |
| title | NSAttributedString | The Navigation Bar Title |
| flowId | String | The ID of related flow. Can be obtained from Pisano Dashboard. Can be sent as empty string "" for default flow |
| language | String | Language code |
| payload | Dictionary  | Question and related answer in an array (mostly uses for pre-loaded responses to take transactional data(s))  |
| customer | Dictionary | Customer Properties |
| completion | Closure | CloseStatus Enum |

## Pisano Show Callback CloseStatus

| Enum  Name | Description  |
| ------- | --- | 
| Closed | Closed Survey  |
| Opened | Opened Survey | 
| SendFeedback  | Send Feedback   |
| DisplayOnce  | Survey won't be shown due to the customer saw it before.  |
| PreventMultipleFeedback  | Survey won't be shown due to customer already submitted a feedback in a given time period.  |
| ChannelQuotaExceeded | Survey won’t be shown due to the channel quota limit has been exceeded. |
| Outside | Others |
| InitFailed | The SDK init is failed |
| InitSucces | The SDK init is successful |

## Clear Method
Clear all saved data related to feedback flows.

### Swift

```yaml
import Feedback

Pisano.clear()
```

### Objective-C

```yaml
#import <Feedback/Feedback-Swift.h>

[Pisano clear:];
```
