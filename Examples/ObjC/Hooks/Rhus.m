#import "../Views/RhusWeatherView.h"
@import CydiaSubstrate;


@interface SBFLockScreenDateViewController : UIViewController
@end

@interface SBLockScreenManager: NSObject
+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;
@end

@class SBBacklightController;
static RhusWeatherView *_weatherView;

static void (*origVDL)(SBFLockScreenDateViewController *, SEL);
static void overrideVDL(SBFLockScreenDateViewController *self, SEL _cmd) {
	origVDL(self, _cmd);

	if(!_weatherView) _weatherView = [RhusWeatherView new];
	[self.view addSubview: _weatherView];

	[_weatherView.topAnchor constraintEqualToAnchor: self.view.bottomAnchor constant: 10].active = YES;
	[_weatherView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = YES;
	[_weatherView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = YES;
}

static void (*origVWA)(SBFLockScreenDateViewController *, SEL, BOOL);
static void overrideVWA(SBFLockScreenDateViewController *self, SEL _cmd, BOOL animated) {
	origVWA(self, _cmd, animated);
	[_weatherView updateWeather];
}

static void (*origTOSFWBS)(SBBacklightController *, SEL, NSInteger);
static void overrideTOSFWBS(SBBacklightController *self, SEL _cmd, NSInteger source) {
	origTOSFWBS(self, _cmd, source);

	if(![[SBLockScreenManager sharedInstance] isLockScreenVisible]) return;
	[_weatherView updateWeather];
}

__attribute__((constructor)) static void init(void) {
	MSHookMessageEx(NSClassFromString(@"SBFLockScreenDateViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);
	MSHookMessageEx(NSClassFromString(@"SBFLockScreenDateViewController"), @selector(viewWillAppear:), (IMP) &overrideVWA, (IMP *) &origVWA);
	MSHookMessageEx(NSClassFromString(@"SBBacklightController"), @selector(turnOnScreenFullyWithBacklightSource:), (IMP) &overrideTOSFWBS, (IMP *) &origTOSFWBS);
}
