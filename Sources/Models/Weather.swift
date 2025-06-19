import Foundation

/// Weather model struct
public struct Weather: Codable {
	public let current: CurrentWeather
	public let daily: DailyWeather
	public let hourly: HourlyWeather
}

// ! _ObjectiveCBridgeable

// This is just great, by conforming to this secret shady private protocol Swift gets a struct & ObjC a class :tm:

extension Weather: _ObjectiveCBridgeable {
	public typealias _ObjectiveCType = CHWeather

	public func _bridgeToObjectiveC() -> CHWeather {
		return CHWeather(current: current, daily: daily, hourly: hourly)
	}

	public
	static func _forceBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) {
		result = Weather(current: source.current, daily: source.daily, hourly: source.hourly)
	}

	public
	static func _unconditionallyBridgeFromObjectiveC(_ source: CHWeather?) -> Weather {
		return Weather(
			current: source?.current ?? CurrentWeather(
				temperature: 0,
				weatherCode: 0,
				feelsLike: 0,
				windSpeed: 0,
				humidity: 0,
				isDay: 0
			),
			daily: source?.daily ?? DailyWeather(low: 0, high: 0, sunrise: 0, sunset: 0),
			hourly: source?.hourly ?? HourlyWeather(
				hours: [],
				temperatures: [],
				weatherCodes: [],
				precipitationProbabilities: [],
				isDay: []
			)
		)
	}

	public
	static func _conditionallyBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) -> Bool {
		result = Weather(current: source.current, daily: source.daily, hourly: source.hourly)
		return true
	}
}

@objcMembers
@objc(CHWeather)
public class CHWeather: NSObject {
	public let current: CurrentWeather
	public let daily: DailyWeather
	public let hourly: HourlyWeather

	public init(current: CurrentWeather, daily: DailyWeather, hourly: HourlyWeather) {
		self.current = current
		self.daily = daily
		self.hourly = hourly
		super.init()
	}
}
