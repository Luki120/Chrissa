#import "../Views/RhusWeatherView.h"


@interface SBFLockScreenDateViewController : UIViewController
@end


static RhusWeatherView *_weatherView;

%hook SBFLockScreenDateViewController

- (void)viewDidLoad {

	%orig;

	if(!_weatherView) _weatherView = [RhusWeatherView new];
	[self.view addSubview: _weatherView];

	[NSLayoutConstraint activateConstraints:@[
		[_weatherView.topAnchor constraintEqualToAnchor: self.view.bottomAnchor constant: 10],
		[_weatherView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor],
		[_weatherView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor]
	]];

}


- (void)viewWillAppear:(BOOL)animated {

	%orig(animated);

	[_weatherView updateWeather];
	[_weatherView updateLabel];

}

%end


%hook SBBacklightController

- (void)turnOnScreenFullyWithBacklightSource:(NSInteger)source {

	%orig;
	[_weatherView updateWeather];

}

%end
