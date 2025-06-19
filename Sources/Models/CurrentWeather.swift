import Foundation

/// Current weather model struct
public struct CurrentWeather: Codable {
	public let temperature: Double
	public let weatherCode: Int
	public let feelsLike: Double
	public let windSpeed: Double
	public let humidity: Int
	public let isDay: Int

	public enum CodingKeys: String, CodingKey {
		case temperature = "temperature_2m"
		case weatherCode = "weather_code"
		case feelsLike = "apparent_temperature"
		case windSpeed = "wind_speed_10m"
		case humidity = "relative_humidity_2m"
		case isDay = "is_day"
	}
}

@objcMembers
@objc(CHCurrentWeather)
public class CHCurrentWeather: NSObject {
	public let temperature: Double
	public let weatherCode: Int
	public let feelsLike: Double
	public let windSpeed: Double
	public let humidity: Int
	public let isDay: Int

	public init(
		temperature: Double,
		weatherCode: Int,
		feelsLike: Double,
		windSpeed: Double,
		humidity: Int,
		isDay: Int
	) {
		self.temperature = temperature
		self.weatherCode = weatherCode
		self.feelsLike = feelsLike
		self.windSpeed = windSpeed
		self.humidity = humidity
		self.isDay = isDay
		super.init()
	}
}

// ! _ObjectiveCBridgeable

extension CurrentWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHCurrentWeather

	public func _bridgeToObjectiveC() -> CHCurrentWeather {
		return CHCurrentWeather(
			temperature: temperature,
			weatherCode: weatherCode,
			feelsLike: feelsLike,
			windSpeed: windSpeed,
			humidity: humidity,
			isDay: isDay
		)
	}

	public
	static func _forceBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) {
		result = CurrentWeather(
			temperature: source.temperature,
			weatherCode: source.weatherCode,
			feelsLike: source.feelsLike,
			windSpeed: source.windSpeed,
			humidity: source.humidity,
			isDay: source.isDay
		)
	}

	public
	static func _unconditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather?) -> CurrentWeather {
		return CurrentWeather(
			temperature: source?.temperature ?? 0,
			weatherCode: source?.weatherCode ?? 0,
			feelsLike: source?.feelsLike ?? 0,
			windSpeed: source?.windSpeed ?? 0,
			humidity: source?.humidity ?? 0,
			isDay: source?.isDay ?? 0
		)
	}

	public
	static func _conditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) -> Bool {
		result = CurrentWeather(
			temperature: source.temperature,
			weatherCode: source.weatherCode,
			feelsLike: source.feelsLike,
			windSpeed: source.windSpeed,
			humidity: source.humidity,
			isDay: source.isDay
		)
		return true
	}
}
