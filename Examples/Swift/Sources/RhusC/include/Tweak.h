@import Foundation.NSObject;
@import UIKit.UIViewController;


@interface SBLockScreenManager : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isLockScreenVisible;
@end


@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end
