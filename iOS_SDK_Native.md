## How to use Feedback SDK

### Supported iOS Versions
Pisano iOS SDK supports iOS 11+ and Xcode 13 is required to build Pisano iOS SDK.

## Installation Methods

### Manual Installation
You can install Pisano iOS SDK in your mobile application by include xcframework library provided by Pisano. Please visit the following link to download the xcframework file.

https://github.com/Pisano/pisano-ios/tree/master/iOS%20SDK%20Native

### CocoaPods

Alternatively, you can install Pisano iOS SDK via CocoaPods
Cocoapods 1.10 or above is required to install Pisano. Add the Pisano pod into your Podfile and run pod install.

```yaml
target :YourTargetName do 
  pod 'Pisano', '~> 1.0.0'
end
```

### Swift Package Manager
Last method is Swift Package Manager.
Add https://github.com/Pisano/pisano-ios as a Swift Package Repository in Xcode and follow the instructions and set Up To Next Major Version as "**1.0.0**" to add Pisano as a Swift Package.

## Permissions

In order to use Pisano iOS SDK, you should add the following permissions in Info.plist file

| Permission Key Value | | |
| ------- | --- | --- |
| Camera | Privacy - Camera Usage Description | $(PRODUCT_NAME) camera use |
| Gallery Access | Privacy - Photo Library Usage Description | $(PRODUCT_NAME) photo use |
| Saving Photo to Gallery | Privacy - Photo Library Additions Usage Description | $(PRODUCT_NAME) photo save |


## Usage Pisano iOS SDK

After adding the dependencies and permissions, you are now able to call the methods of Pisano iOS SDK.

### Swift

```yaml
import PisanoFeedback

let pisano = Pisano(appId: String, 
                    accessKey: String, 
                    apiUrl: String)
                    
pisano.show(viewMode: PSNViewMode,
            flowId: String?, 
            customer: PisanoFeedback.PisanoCustomer?, 
            payload: [String : String]?) { callback in
    
}
```

### Objective-C

```yaml
#import <PisanoFeedback/PisanoFeedback-Swift.h>

Pisano *pisano = [[Pisano alloc] initWithAppId:NSString
                                     accessKey:NSString
                                        apiUrl:NSString];
                                        
[pisano showWithViewMode:PSNViewModeDefault
                  flowId:(NSString * _Nullable)
                customer:(PisanoCustomer * _Nullable)
                 payload:(NSDictionary<NSString *, NSString *> * _Nullable)
        feedbackCallback:^(enum FeedbackCallback callback) {
      NSLog(@"%@", [FeedbackCallbackHelper descriptionFrom:callback]);
}];
```
| Init Parameter Name | Type  | Description  |
| ------- | --- | --- |
| appId  | String | The application ID that can be obtained from Pisano Dashboard  |
| accessKey  | String | The access key can be obtained from Pisano Dashboard |
| apiUrl  | String | The URL of API that will be accessed |

| Show Parameter  Name | Type  | Description  |
| ------- | --- | --- |
| viewMode | PSNViewMode | View Mode Enum to set presentation style (Default - BottomSheet)
| flowId | String | The ID of related flow. Can be obtained from Pisano Dashboard. Can be sent as empty string "" for default flow |
| customer | PisanoCustomer | PisanoCustomer Object |
| payload | Dictionary  | Question and related answer in an array (mostly uses for pre-loaded responses to take transactional data(s))  |
| callback | FeedbackCallback | FeedbackCallback Enum |

## Pisano Show FeedbackCallback Enum

| Enum  Name | Description  |
| ------- | --- | 
| FeedbackCallbackUnknown  | Unknown |
| FeedbackCallbackClosed  | Closed |
| FeedbackCallbackSuccess  | Success |
| FeedbackCallbackSendFeedback  | Feedback sent |
| FeedbackCallbackInvalidCredentials  | Missing or Invalid Credentials |
| FeedbackCallbackInvalidApiUrl  | Missing or Invalid ApiUrl |
| FeedbackCallbackInvalidEventUrl  | Missing or Invalid EventUrl |
| FeedbackCallbackNetworkError  | Network error |
| FeedbackCallbackMultipleFeedback  | Survey won't be shown due to customer already submitted a feedback in a given time period |
| FeedbackCallbackDisplayOnce  | Survey won't be shown due to the customer saw it before |
| FeedbackCallbackChannelQuota  | The survey won't be shown due to the channel quota limit has been exceeded |
