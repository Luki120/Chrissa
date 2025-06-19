import Foundation

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

// ! _ObjectiveCBridgeable

extension DailyWeather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHDailyWeather

	public func _bridgeToObjectiveC() -> CHDailyWeather {
		return CHDailyWeather(low: low, high: high, sunrise: sunrise, sunset: sunset)
	}

	public
	static func _forceBridgeFromObjectiveC(_ source: CHDailyWeather, result: inout DailyWeather?) {
		result = DailyWeather(low: source.low, high: source.high, sunrise: source.sunrise, sunset: source.sunset)
	}

	public
	static func _unconditionallyBridgeFromObjectiveC(_ source: CHDailyWeather?) -> DailyWeather {
		return DailyWeather(
			low: source?.low ?? 0,
			high: source?.high ?? 0,
			sunrise: source?.sunrise ?? 0,
			sunset: source?.sunset ?? 0
		)
	}

	public
	static func _conditionallyBridgeFromObjectiveC(_ source: CHDailyWeather, result: inout DailyWeather?) -> Bool {
		result = DailyWeather(low: source.low, high: source.high, sunrise: source.sunrise, sunset: source.sunset)
		return true
	}
}
