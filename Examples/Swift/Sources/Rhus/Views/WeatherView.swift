import SwiftUI


struct WeatherView: View {

	@StateObject private var viewModel = WeatherViewModel()

	@State private var text = ""

	var body: some View {
		VStack(spacing: 2) {
			Button("\(text != "" ? text : viewModel.condition.capitalized) | \(viewModel.temperature)º") {}
			.frame(maxWidth: .infinity, alignment: .center)
			.foregroundColor(.primary)
			.onReceive(NotificationCenter.default.publisher(for: Notification.Name("me.luki.refresh"))) { _ in
				text = viewModel.name
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

	@ViewBuilder
	private func SunriseSunsetLabel(name: String, text: String) -> some View {
		HStack(spacing: 2) {
			Image(systemName: name)
			Text(text)
		}
	}

}
