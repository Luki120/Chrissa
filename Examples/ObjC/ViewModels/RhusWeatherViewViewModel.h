@import Chrissa;
@import UIKit;


@interface RhusWeatherViewViewModel: NSObject
- (void)updateWeather:(void (^)(NSString *, NSString *, NSString *))completion;
@end
