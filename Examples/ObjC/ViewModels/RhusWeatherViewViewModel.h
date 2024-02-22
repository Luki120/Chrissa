@import Chrissa;
@import UIKit;


@interface RhusWeatherViewViewModel: NSObject
@property (nonatomic, copy) NSString *weatherText;
- (void)updateWeather:(void (^)(NSString *, NSString *, NSString *))completion;
@end
