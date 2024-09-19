#import "RhusWeatherViewViewModel.h"


@implementation RhusWeatherViewViewModel {

	NSDate *_lastRefreshDate;
	NSDateFormatter *_dateFormatter;
	NSMeasurementFormatter *_measurementFormatter;
	NSString *_sunriseText;
	NSString *_sunsetText;
	NSString *_weatherText;

}

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self _setupFormatters];

	_lastRefreshDate = [NSDate distantPast];

	return self;

}


- (void)updateWeather:(void (^)(NSString *, NSString *, NSString *))completion {

	if(![self _shouldRefresh]) return;

	NSError *weatherError;

	BOOL success = [[CHWeatherService sharedInstance] fetchWeatherAndReturnError:&weatherError completion:^(CHWeather *weather, NSString *locationName) {

		NSMeasurement *measurement = [[NSMeasurement alloc]
			initWithDoubleValue:weather.current.temperature
			unit:[NSUnitTemperature celsius]
		];

		NSString *temperature = [_measurementFormatter stringFromMeasurement: measurement];

		NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970: weather.daily.sunrise];
		NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970: weather.daily.sunset];

		_sunriseText = [_dateFormatter stringFromDate: sunriseDate];
		_sunsetText = [_dateFormatter stringFromDate: sunsetDate];

		NSString *unicode = [self _unicodeForCondition:weather.current.weatherCode isDay: weather.current.isDay];

		_weatherText = [NSString stringWithFormat: @"%@ %@ | %@", unicode, locationName, temperature];

		completion(_weatherText, _sunriseText, _sunsetText);

	}];

	if(!success) NSLog(@"CHRISSA: %@", weatherError.localizedDescription);

	_lastRefreshDate = [NSDate new];

}

// ! Private

- (void)_setupFormatters {

	if(!_dateFormatter) {
		_dateFormatter = [NSDateFormatter new];
		_dateFormatter.dateFormat = @"HH:mm";
	}

	if(!_measurementFormatter) {
		_measurementFormatter = [NSMeasurementFormatter new];
		_measurementFormatter.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
		_measurementFormatter.numberFormatter.maximumFractionDigits = 0;
	}

}

- (BOOL)_shouldRefresh {

	return -[_lastRefreshDate timeIntervalSinceNow] > 300;

}


- (NSString *)_unicodeForCondition:(Condition)condition isDay:(BOOL)isDay {

	switch(condition) {
		case ConditionClearSky: return isDay == 1 ? @"☀️" : @"🌙";
		case ConditionPartlyCloudy: return @"🌤️";
		case ConditionOvercast: return isDay == 1 ? @"🌥️" : @"☁️";

		case ConditionFog:
		case ConditionRimeFog: return @"🌫️";

		case ConditionLightDrizzle:
		case ConditionModerateDrizzle:
		case ConditionIntenseDrizzle:
		case ConditionLightRain:
		case ConditionModerateRain:
		case ConditionHeavyRain:
		case ConditionSlightRainShowers:
		case ConditionModerateRainShowers:
		case ConditionViolentRainShowers: return isDay == 1 ? @"🌦️" : @"🌧️";

		case ConditionLightFreezingDrizzle:
		case ConditionIntenseFreezingDrizzle:
		case ConditionLightFreezingRain:
		case ConditionHeavyFreezingRain:
		case ConditionSlightSnowShowers:
		case ConditionHeavySnowShowers: return @"🌨️";

		case ConditionSlightSnowFall:
		case ConditionModerateSnowFall:
		case ConditionHeavySnowFall:
		case ConditionSnowGrains: return @"❄️";

		case ConditionThunderstorm:
		case ConditionThunderstormWithSlightHail:
		case ConditionThunderstormWithHeavyHail: return @"⛈";
	}

}

@end
