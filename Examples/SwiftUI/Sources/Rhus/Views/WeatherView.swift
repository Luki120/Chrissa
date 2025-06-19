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

			if let sunriseText = viewModel.sunriseText, let sunsetText = viewModel.sunsetText {
				HStack(spacing: 4) {
					SunriseSunsetLabel(name: "sunrise.fill", text: sunriseText)
					SunriseSunsetLabel(name: "sunset.fill", text: sunsetText)
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
