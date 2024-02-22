#import "../ViewModels/RhusWeatherViewViewModel.h"


@interface RhusWeatherView : UIView
@end


@interface RhusWeatherView (Public)
- (void)updateLabel;
- (void)updateWeather;
@end
