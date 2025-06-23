import SwiftUI

/// Main wether view
struct WeatherView: View {
	@ObservedObject
	private(set) var viewModel: WeatherViewViewModel

	var body: some View {
		ScrollView {
			VStack(spacing: 18) {
				CurrentWeatherView()
					.background(
						RoundedRectangle(cornerRadius: 20, style: .continuous)
							.fill(Color(.secondarySystemGroupedBackground))
					)

				HourlyWeatherView()
				SunriseSunsetView()
			}
			.animation(.easeInOut, value: viewModel.weatherState)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.opacity(viewModel.weatherState == .loading ? 0 : 1)
			.padding()
		}
	}

	@ViewBuilder
	private func CurrentWeatherView() -> some View {
		HStack {
			TimelineView(.everyMinute) { context in
				VStack(alignment: .leading, spacing: 5) {
					Text(viewModel.format(date: context.date, includeWeekDay: true))
						.font(.caption)

					Text(viewModel.weatherTemperature)
						.font(.title)

					Text(viewModel.locationName)
						.font(.title)
				}
				.padding()
			}

			Spacer()

			Image(systemName: viewModel.condition)
				.renderingMode(.original)
				.font(.largeTitle)
				.frame(width: 80, height: 80)
				.shadow(radius: 5)
		}
	}

	@ViewBuilder
	private func HourlyWeatherView() -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(viewModel.hours.indices, id: \.self) { index in
					let hour = viewModel.hours[index]
					let isDay = viewModel.isDay[index]
					let temperature = viewModel.temperatures[index]
					let weatherCode = viewModel.weatherCodes[index]
					let precipitationProbability = viewModel.precipitationProbabilities[index]

					let condition = viewModel.getCondition(for: weatherCode, isDay: isDay)

					VStack(spacing: 8) {
						Text(viewModel.format(date: Date(timeIntervalSince1970: hour)))
							.font(.caption)

						Image(systemName: condition)
							.renderingMode(.original)
							.frame(width: 30, height: 30)
							.shadow(radius: 3)	

							Text(viewModel.format(temperature: temperature))
								.fontWeight(.bold)

						HStack(spacing: 5) {
							Image(systemName: "drop.fill")
								.renderingMode(.original)
								.foregroundColor(.blue)

							Text(precipitationProbability.formatted(.percent.scale(1)))
						}
					}
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 10, style: .continuous)
							.fill(Color(.secondarySystemGroupedBackground))
					)
				}
			}
		}
	}

	@ViewBuilder
	private func SunriseSunsetView() -> some View {
		HStack {
			Group {
				Image(systemName: "sun.max.fill")
					.renderingMode(.original)

				Text(viewModel.sunrise)	

				Image(systemName: "moon.fill")
					.foregroundColor(.indigo)	

				Text(viewModel.sunset)
			}
		}
		.padding()
		.background(Color(.secondarySystemGroupedBackground), in: Capsule(style: .continuous))
		.cornerRadius(20)
	}
}
