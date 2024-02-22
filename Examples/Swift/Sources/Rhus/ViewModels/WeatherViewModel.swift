import Chrissa
import Combine
import Foundation


final class WeatherViewModel: ObservableObject {

	private var subscriptions = Set<AnyCancellable>()

	@Published private(set) var name = ""
	@Published private(set) var condition = ""
	@Published private(set) var temperature = ""

	@Published private(set) var sunrise: String?
	@Published private(set) var sunset: String?

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
		try? WeatherService.shared.fetchWeather()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in }) { [weak self] weather in
				guard let self, let _weather = weather.weather.first else { return }
				self.name = weather.name
				self.condition = _weather.condition

				let temperature = weather.main.temp - 273.15
				self.temperature = WeatherViewModel.numberFormatter.string(from: temperature as NSNumber) ?? "0º"

				let sunriseDate = Date(timeIntervalSince1970: weather.sys.sunrise)
				let sunsetDate = Date(timeIntervalSince1970: weather.sys.sunset)

				self.sunrise = WeatherViewModel.dateFormatter.string(from: sunriseDate)
				self.sunset = WeatherViewModel.dateFormatter.string(from: sunsetDate)
			}
			.store(in: &subscriptions)
	}

}

final class ScreenListener: ObservableObject {

	static let sharedInstance = ScreenListener()
	@Published var isScreenOff = false

}

extension String {
	var capitalized: String {
		let firstLetter = self.prefix(1).capitalized
		let remainingLetters = self.dropFirst().lowercased()
		return firstLetter + remainingLetters
	}
}
