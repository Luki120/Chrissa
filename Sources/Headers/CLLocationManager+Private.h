@import CoreLocation;


@interface CLLocationManager (Chrissa)
+ (instancetype)sharedManager;
+ (void)setAuthorizationStatus:(BOOL)status forBundleIdentifier:(NSString *)bundleIdentifier;
@end
