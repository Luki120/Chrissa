import Combine
import UIKit

/// Weather manager class to handle API calls
@objc(CHWeatherService)
public final class WeatherService: NSObject, ObservableObject {

	@objc(sharedInstance)
	public static let shared = WeatherService()

	private let locationService = LocationService()
	private var subscriptions = Set<AnyCancellable>()

	private enum Constants {
		static let apiURL = "https://api.openweathermap.org/data/2.5/weather?"
		static let apiKey = "&appid=\(_apiKey)"
	}

	@objc
	public let icons = [
		"01d": "☀️",
		"01n": "🌙",
		"03d": "☁️",
		"03n": "☁️",
		"04d": "☁️",
		"04n": "☁️"
	]

	private override init() {
		super.init()
	}

}

// ! Public

extension WeatherService {

	public func fetchWeather<T: Codable>(expecting type: T.Type = WeatherModel.self) throws -> AnyPublisher<T, Error> {
		locationService.forceEnableLocation()

		let apiURL = "\(Constants.apiURL)lat=\(locationService.latitude)&lon=\(locationService.longitude)\(Constants.apiKey)"
		guard let url = URL(string: apiURL) else { throw URLError(.badURL) }

		return URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, _ in
				return data
			}
			.decode(type: type.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	@objc
	public func fetchWeather(completion: @escaping (WeatherModel) -> Void) {
		try? fetchWeather()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in }) { weather in
				completion(weather)
			}
			.store(in: &subscriptions)
	}

	@objc
	public func updateLocation(_ update: Bool) {
		locationService.startUpdatingLocation(update)
	}

}
