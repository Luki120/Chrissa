import Foundation

/// Weather model struct
public struct WeatherModel: Codable {
	public let currentWeather: CurrentWeather
	public let dailyWeather: DailyWeather

	enum CodingKeys: String, CodingKey {
		case currentWeather = "current_weather"
		case dailyWeather = "daily"
	}
}

/// Current weather model struct
public struct CurrentWeather: Codable {
	public let temperature: Double
	public let weatherCode: Int
	public let isDay: Int

	public enum CodingKeys: String, CodingKey {
		case temperature
		case weatherCode = "weathercode"
		case isDay = "is_day"
	}

	public func unicode(for condition: Condition) -> String {
		return Chrissa.unicode(for: condition, isDay: isDay)
	}
}

/// Daily weather model struct
public struct DailyWeather: Codable {
	public let low: Double
	public let high: Double
	public let sunrise: String
	public let sunset: String

	public enum CodingKeys: String, CodingKey {
		case low = "temperature_2m_min"
		case high = "temperature_2m_max"
		case sunrise
		case sunset
	}

	public init(low: Double, high: Double, sunrise: String, sunset: String) {
		self.low = low
		self.high = high
		self.sunrise = sunrise
		self.sunset = sunset
	}

	public init(from decoder: Decoder) throws {
		let container: KeyedDecodingContainer<DailyWeather.CodingKeys> = try decoder.container(keyedBy: DailyWeather.CodingKeys.self)

		guard let low = try container.decode([Double].self, forKey: DailyWeather.CodingKeys.low).first,
			let high = try container.decode([Double].self, forKey: DailyWeather.CodingKeys.high).first,
			let sunrise = try container.decode([String].self, forKey: DailyWeather.CodingKeys.sunrise).first,
			let sunset = try container.decode([String].self, forKey: DailyWeather.CodingKeys.sunset).first else {
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

extension WeatherModel: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHWeatherModel

	public func _bridgeToObjectiveC() -> CHWeatherModel {
		return CHWeatherModel(currentWeather: currentWeather, dailyWeather: dailyWeather)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHWeatherModel, result: inout WeatherModel?) {
		result = WeatherModel(currentWeather: source.currentWeather, dailyWeather: source.dailyWeather)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHWeatherModel?) -> WeatherModel {
		return WeatherModel(
			currentWeather: source?.currentWeather ?? CurrentWeather(temperature: 0, weatherCode: 0, isDay: 0),
			dailyWeather: source?.dailyWeather ?? DailyWeather(low: 0, high: 0, sunrise: "", sunset: "")
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHWeatherModel, result: inout WeatherModel?) -> Bool {
		result = WeatherModel(currentWeather: source.currentWeather, dailyWeather: source.dailyWeather)
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
			sunrise: source?.sunrise ?? "",
			sunset: source?.sunset ?? ""
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHDailyWeather, result: inout DailyWeather?) -> Bool {
		result = DailyWeather(low: source.low, high: source.high, sunrise: source.sunrise, sunset: source.sunset)
		return true
	}
}

@objcMembers
@objc(CHWeatherModel)
public class CHWeatherModel: NSObject {
	public let currentWeather: CurrentWeather
	public let dailyWeather: DailyWeather

	public init(currentWeather: CurrentWeather, dailyWeather: DailyWeather) {
		self.currentWeather = currentWeather
		self.dailyWeather = dailyWeather
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

	public func unicode(for condition: Condition) -> String {
		return Chrissa.unicode(for: condition, isDay: isDay)
	}
}

@objcMembers
@objc(CHDailyWeather)
public class CHDailyWeather: NSObject {
	public let low: Double
	public let high: Double
	public let sunrise: String
	public let sunset: String

	public init(low: Double, high: Double, sunrise: String, sunset: String) {
		self.low = low
		self.high = high
		self.sunrise = sunrise
		self.sunset = sunset
		super.init()
	}
}
