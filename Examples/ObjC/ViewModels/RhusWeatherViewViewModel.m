#import "RhusWeatherViewViewModel.h"


@implementation RhusWeatherViewViewModel {

	NSDateFormatter *_dateFormatter;
	NSString *_sunriseText;
	NSString *_sunsetText;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	if(!_dateFormatter) {
		_dateFormatter = [NSDateFormatter new];
		_dateFormatter.dateFormat = @"HH:mm";
	}

	return self;

}


- (void)updateWeather:(void (^)(NSString *, NSString *, NSString *))completion {

	[[CHWeatherService sharedInstance] fetchWeatherWithCompletion:^(CHWeatherModel *weatherModel) {

		NSString *name = weatherModel.name;
		CGFloat celsiusTemperature = weatherModel.main.temp - 273.15;

		NSDictionary *icons = [[CHWeatherService sharedInstance] icons];

		self.weatherText = [NSString stringWithFormat: @"%@ %@ | %.fº", icons[weatherModel.weather[0].icon], name, celsiusTemperature];
		_sunriseText = [_dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970: weatherModel.sys.sunrise]];
		_sunsetText = [_dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970: weatherModel.sys.sunset]];

		completion(self.weatherText, _sunriseText, _sunsetText);
	}];

}

@end
