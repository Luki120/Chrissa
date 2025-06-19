import Foundation

/// Hourly weather model struct
public struct HourlyWeather: Codable {
	public let hours: [TimeInterval]
	public let temperatures: [Double]
	public let weatherCodes: [Int]
	public let precipitationProbabilities: [Double]
	public let isDay: [Int]

	public enum CodingKeys: String, CodingKey {
		case hours = "time"
		case temperatures = "temperature_2m"
		case weatherCodes = "weather_code"
		case precipitationProbabilities = "precipitation_probability"
		case isDay = "is_day"
	}
}

@objcMembers
@objc(CHHourlyWeather)
public class CHHourlyWeather: NSObject {
	public let hours: [TimeInterval]
	public let temperatures: [Double]
	public let weatherCodes: [Int]
	public let precipitationProbabilities: [Double]
	public let isDay: [Int]

	public init(
		hours: [TimeInterval],
		temperatures: [Double],
		weatherCodes: [Int],
		precipitationProbabilities: [Double],
		isDay: [Int]
	) {
		self.hours = hours
		self.temperatures = temperatures
		self.weatherCodes = weatherCodes
		self.precipitationProbabilities = precipitationProbabilities
		self.isDay = isDay
		super.init()
	}
}

// ! _ObjectiveCBridgeable

extension HourlyWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHHourlyWeather

	public func _bridgeToObjectiveC() -> CHHourlyWeather {
		return .init(
			hours: hours,
			temperatures: temperatures,
			weatherCodes: weatherCodes,
			precipitationProbabilities: precipitationProbabilities,
			isDay: isDay
		)
	}

	public
	static func _forceBridgeFromObjectiveC(_ source: CHHourlyWeather, result: inout HourlyWeather?) {
		result = .init(
			hours: source.hours,
			temperatures: source.temperatures,
			weatherCodes: source.weatherCodes,
			precipitationProbabilities: source.precipitationProbabilities,
			isDay: source.isDay
		)
	}

	public
	static func _unconditionallyBridgeFromObjectiveC(_ source: CHHourlyWeather?) -> HourlyWeather {
		return .init(
			hours: source?.hours ?? [],
			temperatures: source?.temperatures ?? [],
			weatherCodes: source?.weatherCodes ?? [],
			precipitationProbabilities: source?.precipitationProbabilities ?? [],
			isDay: source?.isDay ?? []
		)
	}

	public
	static func _conditionallyBridgeFromObjectiveC(_ source: CHHourlyWeather, result: inout HourlyWeather?) -> Bool {
		result = .init(
			hours: source.hours,
			temperatures: source.temperatures,
			weatherCodes: source.weatherCodes,
			precipitationProbabilities: source.precipitationProbabilities,
			isDay: source.isDay
		)
		return true
	}
}
