import Chrissa
import Combine


final class WeatherViewViewModel: ObservableObject {

	@Published private(set) var weatherText = ""
	@Published private(set) var sunriseText = ""
	@Published private(set) var sunsetText = ""

	private var lastRefreshDate: Date = .distantPast
	private var updateWeatherSubscription: AnyCancellable?

	static private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	static private let measurementFormatter: MeasurementFormatter = {
		let formatter = MeasurementFormatter()
		formatter.numberFormatter.numberStyle = .decimal
		formatter.numberFormatter.maximumFractionDigits = 0
		return formatter
	}()

	func updateWeather() {
		guard shouldRefresh() else { return }
		updateWeatherSubscription = nil

		do {
			updateWeatherSubscription = try WeatherService.shared.fetchWeather()
				.map { $0 as Optional<WeatherModel> }
				.replaceError(with: nil)
				.compactMap { $0 }
				.combineLatest(WeatherService.shared.$locationName)
				.receive(on: DispatchQueue.main)
				.sink { [weak self] weatherModel, locationName in
					guard let self else { return }

					let measurement = Measurement(value: weatherModel.currentWeather.temperature, unit: UnitTemperature.celsius)
					let temperature = WeatherViewViewModel.measurementFormatter.string(from: measurement)

					let sunriseDate = Date(timeIntervalSince1970: weatherModel.dailyWeather.sunrise)
					let sunsetDate = Date(timeIntervalSince1970: weatherModel.dailyWeather.sunset)

					self.sunriseText = WeatherViewViewModel.dateFormatter.string(from: sunriseDate)
					self.sunsetText = WeatherViewViewModel.dateFormatter.string(from: sunsetDate)

					guard let condition = Condition(rawValue: weatherModel.currentWeather.weatherCode) else {
						return
					}

					let unicode = condition.unicode(isDay: weatherModel.currentWeather.isDay) 
					weatherText = "\(unicode) \(locationName) | \(temperature)"
				}
		}
		catch {
			NSLog("CHRISSA: \(error.localizedDescription)")
		}

		lastRefreshDate = Date()
	}

	private func shouldRefresh() -> Bool {
		return -lastRefreshDate.timeIntervalSinceNow > 300
	}

}
