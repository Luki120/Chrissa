import Combine
import UIKit

/// Weather manager class to handle API calls
@objc(CHWeatherService)
public final class WeatherService: NSObject, ObservableObject {

	/// Shared instance
	@objc(sharedInstance)
	public static let shared = WeatherService()

	private let locationService = LocationService()
	private var subscriptions = Set<AnyCancellable>()

	private enum Constants {
		static let apiURL = "https://api.openweathermap.org/data/2.5/weather?"
		static let apiKey = "&appid=\(_apiKey)"
	}

	private enum Condition: String {
		case fog
		case haze
		case mist
		case smoke
		case tornado

		var name: String {
			switch self {
				case .fog, .haze, .mist: return "🌫️"
				case .smoke: return "💨"
				case .tornado: return "🌪️"
			}
		}
	}

	/// String that represents the current weather condition
	@objc
	@Published public var condition = ""

	/// Dictionary that sets a weather emoji for the current weather condition code
	@objc
	public private(set) var icons = [
		"01d": "☀️",
		"01n": "🌙",
		"02d": "🌤️",
		"02n": "☁️",
		"03d": "☁️",
		"03n": "☁️",
		"04d": "☁️",
		"04n": "☁️",
		"09d": "🌧️",
		"09n": "🌧️",
		"10d": "🌦️",
		"10n": "🌧️",
		"11d": "⛈",
		"11n": "⛈",
		"13d": "❄️",
		"13n": "❄️"
	]

	private override init() {
		super.init()
	}

}

extension WeatherService {

	// ! Public

	/// Combine function to make API calls
	/// - Parameters:
	///		- expecting: The type that conforms to Codable
	/// Returns: AnyPublisher of generic type T & Error
	public func fetchWeather<T: Codable>(expecting type: T.Type = WeatherModel.self) throws -> AnyPublisher<T, Error> {
		locationService.forceEnableLocation()

		let apiURL = "\(Constants.apiURL)lat=\(locationService.latitude)&lon=\(locationService.longitude)\(Constants.apiKey)"
		guard let url = URL(string: apiURL) else { throw URLError(.badURL) }

		icons["50d"] = Condition(rawValue: condition)?.name ?? ""
		icons["50n"] = Condition(rawValue: condition)?.name ?? ""

		return URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, _ in
				return data
			}
			.decode(type: type.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	/// Function to make API calls
	/// - Parameters:
	///		- completion: Escaping closure that takes a WeatherModel object as argument & returns nothing
	@objc
	public func fetchWeather(completion: @escaping (WeatherModel) -> Void) {
		try? fetchWeather()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in }) { weather in
				completion(weather)
			}
			.store(in: &subscriptions)
	}

}
