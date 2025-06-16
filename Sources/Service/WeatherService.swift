import Combine
import UIKit

/// Singleton class to make weather API calls
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

	/// `String` that represents the current location name
	@Published
	private(set) public var locationName = ""

	private
	override init() {
		super.init()
	}

	// ! Reusable

	private func weatherPublisher<T: Codable>(
		latitude: CLLocationDegrees,
		longitude: CLLocationDegrees,
		expecting type: T.Type
	) -> AnyPublisher<T, Error> {
		locationService.$locationName
			.sink { [weak self] name in
				self?.locationName = name
			}
			.store(in: &subscriptions)

		let apiURL = "\(Constants.baseURL)latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,apparent_temperature,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&forecast_days=1&timeformat=unixtime&timezone=auto"

		guard let url = URL(string: apiURL) else {
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}

		return URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, response in
				guard let response = response as? HTTPURLResponse,
					(200..<300).contains(response.statusCode) else {
						throw URLError(.badServerResponse)
					}
				return data
			}
			.decode(type: type, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

// ! Public

extension WeatherService {
	/// Function to fetch weather data, leveraging Combine pipelines
	/// - Parameter expecting: The type that conforms to `Codable`, defaults to `Weather`
	/// - Returns: `AnyPublisher<T, Error>`
	/// - Throws: `URLError`
	public func fetchWeather<T: Codable>(expecting type: T.Type = Weather.self) throws -> AnyPublisher<T, Error> {
		locationService.forceEnableLocation()
		return weatherPublisher(
			latitude: locationService.latitude,
			longitude: locationService.longitude,
			expecting: type
		)
	}

	/// Function to fetch weather data after getting valid location coordinates
	/// - Returns: `AnyPublisher<Weather, Error>`
	/// - Throws: `URLError`
	public func fetchWeather() throws -> AnyPublisher<Weather, Error> {
		return locationService.$latitude
			.combineLatest(locationService.$longitude)
			.filter { latitude, longitude in
				return latitude != 0 && longitude != 0
			}
			.flatMap { [weak self] latitude, longitude -> AnyPublisher<Weather, Error> in
				guard let self else {
					return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
				}
				return self.weatherPublisher(
					latitude: latitude,
					longitude: longitude,
					expecting: Weather.self
				)
			}
			.eraseToAnyPublisher()
	}

	/// Function to fetch weather data
	/// - Parameter completion: `@escaping` closure that takes a `Weather` object & a `String` as argument & returns nothing
	/// - Throws: `URLError`
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
