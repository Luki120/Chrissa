import SwiftUI


struct WeatherView: View {

	@ObservedObject
	private(set) var viewModel: WeatherViewViewModel

	var body: some View {
		VStack(spacing: 5) {
			Text(viewModel.weatherText)
				.frame(maxWidth: .infinity, alignment: .center)
				.foregroundColor(.primary)
				.onReceive(NotificationCenter.default.publisher(for: .didRefreshWeatherDataNotification)) { _ in
					viewModel.updateWeather()
				}

			if let sunrise = viewModel.sunrise, let sunset = viewModel.sunset {
				HStack(spacing: 4) {
					SunriseSunsetLabel(name: "sunrise.fill", text: sunrise)
					SunriseSunsetLabel(name: "sunset.fill", text: sunset)
				}
			}
		}
	}

	// ! Private

	@ViewBuilder
	private func SunriseSunsetLabel(name: String, text: String) -> some View {
		HStack(spacing: 2) {
			Image(systemName: name)
			Text(text)
		}
	}

}
