import Foundation

/// Weather model struct
public struct Weather: Codable {
	public let current: CurrentWeather
	public let daily: DailyWeather
}

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

/// Daily weather model struct
public struct DailyWeather: Codable {
	public let low: Double
	public let high: Double
	public let sunrise: TimeInterval
	public let sunset: TimeInterval

	public enum CodingKeys: String, CodingKey {
		case low = "temperature_2m_min"
		case high = "temperature_2m_max"
		case sunrise
		case sunset
	}

	public init(low: Double, high: Double, sunrise: TimeInterval, sunset: TimeInterval) {
		self.low = low
		self.high = high
		self.sunrise = sunrise
		self.sunset = sunset
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: DailyWeather.CodingKeys.self)

		guard let low = try container.decode([Double].self, forKey: DailyWeather.CodingKeys.low).first,
			let high = try container.decode([Double].self, forKey: DailyWeather.CodingKeys.high).first,
			let sunrise = try container.decode([TimeInterval].self, forKey: DailyWeather.CodingKeys.sunrise).first,
			let sunset = try container.decode([TimeInterval].self, forKey: DailyWeather.CodingKeys.sunset).first else {
				throw URLError(.cannotDecodeRawData)
			}

		self.low = low
		self.high = high
		self.sunrise = sunrise
		self.sunset = sunset
	}
}

// ! _ObjectiveCBridgeable

// This is just great, by conforming to this secret shady private protocol Swift gets a struct & ObjC a class :tm:

extension Weather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHWeather

	public func _bridgeToObjectiveC() -> CHWeather {
		return CHWeather(current: current, daily: daily)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) {
		result = Weather(current: source.current, daily: source.daily)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHWeather?) -> Weather {
		return Weather(
			current: source?.current ?? CurrentWeather(temperature: 0, weatherCode: 0, isDay: 0),
			daily: source?.daily ?? DailyWeather(low: 0, high: 0, sunrise: 0, sunset: 0)
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) -> Bool {
		result = Weather(current: source.current, daily: source.daily)
		return true
	}
}

extension CurrentWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHCurrentWeather

	public func _bridgeToObjectiveC() -> CHCurrentWeather {
		return CHCurrentWeather(temperature: temperature, weatherCode: weatherCode, isDay: isDay)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) {
		result = CurrentWeather(temperature: source.temperature, weatherCode: source.weatherCode, isDay: source.isDay)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather?) -> CurrentWeather {
		return CurrentWeather(
			temperature: source?.temperature ?? 0,
			weatherCode: source?.weatherCode ?? 0,
			isDay: source?.isDay ?? 0
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHCurrentWeather, result: inout CurrentWeather?) -> Bool {
		result = CurrentWeather(temperature: source.temperature, weatherCode: source.weatherCode, isDay: source.isDay)
		return true
	}
}

extension DailyWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHDailyWeather

	public func _bridgeToObjectiveC() -> CHDailyWeather {
		return CHDailyWeather(low: low, high: high, sunrise: sunrise, sunset: sunset)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHDailyWeather, result: inout DailyWeather?) {
		result = DailyWeather(low: source.low, high: source.high, sunrise: source.sunrise, sunset: source.sunset)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHDailyWeather?) -> DailyWeather {
		return DailyWeather(
			low: source?.low ?? 0,
			high: source?.high ?? 0,
			sunrise: source?.sunrise ?? 0,
			sunset: source?.sunset ?? 0
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHDailyWeather, result: inout DailyWeather?) -> Bool {
		result = DailyWeather(low: source.low, high: source.high, sunrise: source.sunrise, sunset: source.sunset)
		return true
	}
}

@objcMembers
@objc(CHWeather)
public class CHWeather: NSObject {
	public let current: CurrentWeather
	public let daily: DailyWeather

	public init(current: CurrentWeather, daily: DailyWeather) {
		self.current = current
		self.daily = daily
		super.init()
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

@objcMembers
@objc(CHDailyWeather)
public class CHDailyWeather: NSObject {
	public let low: Double
	public let high: Double
	public let sunrise: TimeInterval
	public let sunset: TimeInterval

	public init(low: Double, high: Double, sunrise: TimeInterval, sunset: TimeInterval) {
		self.low = low
		self.high = high
		self.sunrise = sunrise
		self.sunset = sunset
		super.init()
	}
}
