import Chrissa
import Combine
import Foundation


final class WeatherViewViewModel: ObservableObject {

	@Published private(set) var weatherText = ""
	@Published private(set) var sunrise: String?
	@Published private(set) var sunset: String?

	private var lastRefreshDate: Date = .distantPast
	private var subscriptions = Set<AnyCancellable>()

	static private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	static private let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 0
		return formatter
	}()

	init() {
		updateLocation()
		updateWeather()
	}

	func updateLocation() {
		ScreenListener.sharedInstance.$isScreenOff
			.sink { state in
				if state == false { WeatherService.shared.updateLocation(false) }
			}
			.store(in: &subscriptions)
	}

	func updateWeather() {
		NSLog("AZURE: should refresh ⇝ \(shouldRefresh())")
		guard shouldRefresh() else { return }

		try? WeatherService.shared.fetchWeather()
				.receive(on: DispatchQueue.main)
				.sink(receiveCompletion: { _ in }) { [weak self] weatherModel in
					guard let self, let weather = weatherModel.weather.first else { return }

					WeatherService.shared.condition = weather.condition

					let temperature = weatherModel.main.temp - 273.15
					let celsiusTemperature = WeatherViewViewModel.numberFormatter.string(from: temperature as NSNumber) ?? "0º"

					let sunriseDate = Date(timeIntervalSince1970: weatherModel.sys.sunrise)
					let sunsetDate = Date(timeIntervalSince1970: weatherModel.sys.sunset)

					self.sunrise = WeatherViewViewModel.dateFormatter.string(from: sunriseDate)
					self.sunset = WeatherViewViewModel.dateFormatter.string(from: sunsetDate)

					guard let icon = WeatherService.shared.icons[weather.icon] else {
						self.weatherText = "\(WeatherService.shared.condition.capitalized) | \(weatherModel.name) | \(celsiusTemperature)º"
						return
					}

					self.weatherText = "\(icon) \(weatherModel.name) | \(celsiusTemperature)º"
				}
				.store(in: &subscriptions)

		lastRefreshDate = Date()
	}

	func shouldRefresh() -> Bool {
		NSLog("AZURE: lastRefreshDate ⇝ \(lastRefreshDate)")
		return -(lastRefreshDate.timeIntervalSinceNow) > 300
	}

}

final class ScreenListener: ObservableObject {

	static let sharedInstance = ScreenListener()
	@Published var isScreenOff = false {
		didSet {
			NotificationCenter.default.post(name: .didRefreshWeatherDataNotification, object: nil)
		}
	}

}

extension Notification.Name {
	static let didRefreshWeatherDataNotification = Notification.Name("didRefreshWeatherDataNotification")
}

extension String {
	var capitalized: String {
		let firstLetter = self.prefix(1).capitalized
		let remainingLetters = self.dropFirst().lowercased()
		return firstLetter + remainingLetters
	}
}
