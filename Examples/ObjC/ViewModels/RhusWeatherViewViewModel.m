#import "RhusWeatherViewViewModel.h"


@implementation RhusWeatherViewViewModel {

	NSDate *_lastRefreshDate;
	NSDateFormatter *_dateFormatter;
	NSString *_sunriseText;
	NSString *_sunsetText;
	NSString *_weatherText;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	if(!_dateFormatter) {
		_dateFormatter = [NSDateFormatter new];
		_dateFormatter.dateFormat = @"HH:mm";
	}

	_lastRefreshDate = [NSDate distantPast];

	return self;

}


- (void)updateWeather:(void (^)(NSString *, NSString *, NSString *))completion {

	if(![self _shouldRefresh]) return;

	[[CHWeatherService sharedInstance] fetchWeatherWithCompletion:^(CHWeatherModel *weatherModel) {

		NSString *name = weatherModel.name;
		CGFloat celsiusTemperature = weatherModel.main.temp - 273.15;

		NSDictionary *icons = [[CHWeatherService sharedInstance] icons];

		_sunriseText = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: weatherModel.sys.sunrise]];
		_sunsetText = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: weatherModel.sys.sunset]];
		_weatherText = [NSString stringWithFormat: @"%@ %@ | %.fº", icons[weatherModel.weather[0].icon], name, celsiusTemperature];

		completion(_weatherText, _sunriseText, _sunsetText);
	}];

	_lastRefreshDate = [NSDate new];

}

// ! Private

- (BOOL)_shouldRefresh {

	return -[_lastRefreshDate timeIntervalSinceNow] > 300;

}

@end
