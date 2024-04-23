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
	private var fetchWeatherSubscription: AnyCancellable?

	private enum Constants {
		static let baseURL = "https://api.open-meteo.com/v1/forecast?"
	}

	/// String that represents the current location name
	@Published private(set) public var locationName = ""

	private override init() {
		super.init()
	}

}

extension WeatherService {

	// ! Public

	/// Combine function to make API calls
	/// - Parameters:
	///		- expecting: The type that conforms to Codable
	/// - Returns: AnyPublisher of generic type T & Error
	/// - Throws: An error of type URLError
	public func fetchWeather<T: Codable>(expecting type: T.Type = Weather.self) throws -> AnyPublisher<T, Error> {
		locationService.forceEnableLocation()
		locationService.$locationName
			.sink { [weak self] name in
				self?.locationName = name
			}
			.store(in: &subscriptions)

		let apiURL = "\(Constants.baseURL)latitude=\(locationService.latitude)&longitude=\(locationService.longitude)&current=temperature_2m,apparent_temperature,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&forecast_days=1&timeformat=unixtime&timezone=auto"
		guard let url = URL(string: apiURL) else { throw URLError(.badURL) }

		return URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, response in
				guard let response = response as? HTTPURLResponse,
					(200..<300).contains(response.statusCode) else {
						throw(URLError(.badServerResponse))
					}
				return data
			}
			.decode(type: type.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	/// Function to make API calls
	/// - Parameters:
	///		- completion: Escaping closure that takes a WeatherModel object & a String as argument & returns nothing
	/// - Throws: An error of type URLError
	@objc
	public func fetchWeather(completion: @escaping (Weather, String) -> Void) throws {
		fetchWeatherSubscription = nil
		fetchWeatherSubscription = try fetchWeather()
			.map { $0 as Optional<Weather> }
			.replaceError(with: nil)
			.compactMap { $0 }
			.combineLatest($locationName)
			.receive(on: DispatchQueue.main)
			.sink { weather, locationName in
				completion(weather, locationName)
			}
	}

}
