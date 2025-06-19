import Foundation

/// Current weather model struct
public struct CurrentWeather: Codable {
	public let temperature: Double
	public let weatherCode: Int
	public let isDay: Int

	public enum CodingKeys: String, CodingKey {
		case temperature = "temperature_2m"
		case weatherCode = "weather_code"
		case isDay = "is_day"
	}
}

@objcMembers
@objc(CHCurrentWeather)
public class CHCurrentWeather: NSObject {
	public let temperature: Double
	public let weatherCode: Int
	public let isDay: Int

	public init(temperature: Double, weatherCode: Int, isDay: Int) {
		self.temperature = temperature
		self.weatherCode = weatherCode
		self.isDay = isDay
		super.init()
	}
}

// ! _ObjectiveCBridgeable

extension CurrentWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHCurrentWeather

	public func _bridgeToObjectiveC() -> CHCurrentWeather {
		return CHCurrentWeather(temperature: temperature, weatherCode: weatherCode, isDay: isDay)
	}

	public
	static func _forceBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) {
		result = CurrentWeather(temperature: source.temperature, weatherCode: source.weatherCode, isDay: source.isDay)
	}

	public
	static func _unconditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather?) -> CurrentWeather {
		return CurrentWeather(
			temperature: source?.temperature ?? 0,
			weatherCode: source?.weatherCode ?? 0,
			isDay: source?.isDay ?? 0
		)
	}

	public
	static func _conditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) -> Bool {
		result = CurrentWeather(temperature: source.temperature, weatherCode: source.weatherCode, isDay: source.isDay)
		return true
	}
}
