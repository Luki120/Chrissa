#import "RhusWeatherView.h"


@implementation RhusWeatherView {

	UILabel *_weatherLabel;
	UIStackView *_sunriseSunsetStackView;
	UIImageView *_sunriseImageView;
	UIImageView *_sunsetImageView;
	UILabel *_sunriseLabel;
	UILabel *_sunsetLabel;
	RhusWeatherViewViewModel *_viewModel;

}

// ! Lifecycle

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self _setupUI];
	if(!_viewModel) _viewModel = [RhusWeatherViewViewModel new];

	return self;

}

// ! Private

- (void)_setupUI {

	self.translatesAutoresizingMaskIntoConstraints = NO;

	if(!_weatherLabel) {
		_weatherLabel = [UILabel new];
		_weatherLabel.numberOfLines = 0;
		_weatherLabel.textAlignment = NSTextAlignmentCenter;
		_weatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview: _weatherLabel];
	}

	if(!_sunriseSunsetStackView) {
		_sunriseSunsetStackView = [UIStackView new];
		_sunriseSunsetStackView.spacing = 5;
		_sunriseSunsetStackView.alignment = UIStackViewAlignmentCenter;
		_sunriseSunsetStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview: _sunriseSunsetStackView];
	}

	if(!_sunriseImageView)
		_sunriseImageView = [self _createImageViewWithImage: [UIImage systemImageNamed: @"sunrise.fill"]];

	if(!_sunsetImageView)
		_sunsetImageView = [self _createImageViewWithImage: [UIImage systemImageNamed: @"sunset.fill"]];

	if(!_sunriseLabel) _sunriseLabel = [self _createLabel];
	if(!_sunsetLabel) _sunsetLabel = [self _createLabel];

	for(UIView *view in @[_sunriseImageView, _sunriseLabel, _sunsetImageView, _sunsetLabel])
		[_sunriseSunsetStackView addArrangedSubview: view];

}


- (void)layoutSubviews {

	[super layoutSubviews];

	[NSLayoutConstraint activateConstraints:@[
		[_weatherLabel.topAnchor constraintEqualToAnchor: self.topAnchor],
		[_weatherLabel.bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
		[_weatherLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
		[_weatherLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],

		[_sunriseSunsetStackView.topAnchor constraintEqualToAnchor: _weatherLabel.bottomAnchor constant: 5],
		[_sunriseSunsetStackView.centerXAnchor constraintEqualToAnchor: _weatherLabel.centerXAnchor],
	]];

	for(UIImageView *imageView in @[_sunriseImageView, _sunsetImageView]) {
		[imageView.widthAnchor constraintEqualToConstant: 25].active = YES;
		[imageView.heightAnchor constraintEqualToConstant: 25].active = YES;
	}

}

// ! Reusable

- (UIImageView *)_createImageViewWithImage:(UIImage *)image {

	UIImageView *imageView = [UIImageView new];
	imageView.image = image;
	imageView.tintColor = UIColor.whiteColor;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	return imageView;

}


- (UILabel *)_createLabel {

	UILabel *label = [UILabel new];
	return label;

}

@end


@implementation RhusWeatherView (Public)

- (void)updateLabel {

	_weatherLabel.text = @"";

	[UIView transitionWithView:_weatherLabel duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		_weatherLabel.text = _viewModel.weatherText;

	} completion:nil];

}


- (void)updateWeather {

	[_viewModel updateWeather: ^(NSString *weatherText, NSString *sunriseText, NSString *sunsetText) {
		dispatch_async(dispatch_get_main_queue(), ^{
			_weatherLabel.text = weatherText;
			_sunriseLabel.text = sunriseText;
			_sunsetLabel.text = sunsetText;
		});
	}];

}

@end
