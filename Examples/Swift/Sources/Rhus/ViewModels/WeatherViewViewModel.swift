import Chrissa
import Combine

/// View model class for `WeatherView`
final class WeatherViewViewModel: ObservableObject {
	@Published private(set) var weatherText = ""
	@Published private(set) var sunriseText = ""
	@Published private(set) var sunsetText = ""

	// ! Private

	private var lastRefreshDate: Date = .distantPast
	private var updateWeatherSubscription: AnyCancellable?

	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	private static let measurementFormatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.numberFormatter.numberStyle = .decimal
		formatter.numberFormatter.maximumFractionDigits = 0
		return formatter
	}()

	private func shouldRefresh() -> Bool {
		return -lastRefreshDate.timeIntervalSinceNow > 300
	}
}

// ! Public

extension WeatherViewViewModel {
	/// Function to fetch weather data
	func updateWeather() {
		guard shouldRefresh() else { return }
		updateWeatherSubscription = nil

		do {
			updateWeatherSubscription = try WeatherService.shared.fetchWeather()
				.map { $0 as Optional<Weather> }
				.replaceError(with: nil)
				.compactMap { $0 }
				.combineLatest(WeatherService.shared.$locationName)
				.receive(on: DispatchQueue.main)
				.sink { [weak self] weather, locationName in
					guard let self else { return }

					let measurement = Measurement(value: weather.current.temperature, unit: UnitTemperature.celsius)
					let temperature = WeatherViewViewModel.measurementFormatter.string(from: measurement)

					let sunriseDate = Date(timeIntervalSince1970: weather.daily.sunrise)
					let sunsetDate = Date(timeIntervalSince1970: weather.daily.sunset)

					self.sunriseText = WeatherViewViewModel.dateFormatter.string(from: sunriseDate)
					self.sunsetText = WeatherViewViewModel.dateFormatter.string(from: sunsetDate)

					guard let condition = Condition(rawValue: weather.current.weatherCode) else { return }

					let unicode = condition.unicode(isDay: weather.current.isDay) 
					weatherText = "\(unicode) \(locationName) | \(temperature)"
				}
		}
		catch {
			NSLog("CHRISSA: \(error.localizedDescription)")
		}

		lastRefreshDate = Date()
	}	
}
