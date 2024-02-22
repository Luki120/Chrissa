import Foundation


public struct WeatherModel: Codable, _ObjectiveCBridgeable {
	public let name: String
	public let main: Main
	public let weather: [Weather]
	public let sys: Sys

	public typealias _ObjectiveCType = CHWeatherModel

	public func _bridgeToObjectiveC() -> CHWeatherModel {
		return CHWeatherModel(name: name, main: main, weather: weather, sys: sys)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHWeatherModel, result: inout WeatherModel?) {
		result = WeatherModel(name: source.name, main: source.main, weather: source.weather, sys: source.sys)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHWeatherModel?) -> WeatherModel {
		return WeatherModel(
			name: source?.name ?? "",
			main: source?.main ?? Main(temp: 0),
			weather: source?.weather ?? [],
			sys: source?.sys ?? Sys(sunrise: 0, sunset: 0)
		)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHWeatherModel, result: inout WeatherModel?) -> Bool {
		result = WeatherModel(name: source.name, main: source.main, weather: source.weather, sys: source.sys)
		return true
	}
}

public struct Main: Codable, _ObjectiveCBridgeable {
	public let temp: Float

	public typealias _ObjectiveCType = CHMain

	public func _bridgeToObjectiveC() -> CHMain {
		return CHMain(temp: temp)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHMain, result: inout Main?) {
		result = Main(temp: source.temp)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHMain?) -> Main {
		return Main(temp: source?.temp ?? 0)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHMain, result: inout Main?) -> Bool {
		result = Main(temp: source.temp)
		return true
	}
}

public struct Weather: Codable, _ObjectiveCBridgeable {
	public let condition: String
	public let icon: String

	public enum CodingKeys: String, CodingKey {
		case condition = "description"
		case icon
	}

	public typealias _ObjectiveCType = CHWeather

	public func _bridgeToObjectiveC() -> CHWeather {
		return CHWeather(condition: condition, icon: icon)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) {
		result = Weather(condition: source.condition, icon: source.icon)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHWeather?) -> Weather {
		return Weather(condition: source?.condition ?? "", icon: source?.icon ?? "")
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHWeather, result: inout Weather?) -> Bool {
		result = Weather(condition: source.condition, icon: source.icon)
		return true
	}
}

public struct Sys: Codable, _ObjectiveCBridgeable {
	public let sunrise: TimeInterval
	public let sunset: TimeInterval

	public typealias _ObjectiveCType = CHSys

	public func _bridgeToObjectiveC() -> CHSys {
		return CHSys(sunrise: sunrise, sunset: sunset)
	}

	public static func _forceBridgeFromObjectiveC(_ source: CHSys, result: inout Sys?) {
		result = Sys(sunrise: source.sunrise, sunset: source.sunset)
	}

	public static func _unconditionallyBridgeFromObjectiveC(_ source: CHSys?) -> Sys {
		return Sys(sunrise: source?.sunrise ?? 0, sunset: source?.sunset ?? 0)
	}

	public static func _conditionallyBridgeFromObjectiveC(_ source: CHSys, result: inout Sys?) -> Bool {
		result = Sys(sunrise: source.sunrise, sunset: source.sunset)
		return true
	}
}

@objcMembers
@objc(CHWeatherModel)
public class CHWeatherModel: NSObject {
	public let name: String
	public let main: Main
	public let weather: [Weather]
	public let sys: Sys

	public init(name: String, main: Main, weather: [Weather], sys: Sys) {
		self.name = name
		self.main = main
		self.weather = weather
		self.sys = sys
		super.init()
	}

}

@objcMembers
@objc(CHMain)
public class CHMain: NSObject {
	public let temp: Float

	public init(temp: Float) {
		self.temp = temp
		super.init()
	}
}

@objcMembers
@objc(CHWeather)
public class CHWeather: NSObject {
	public let condition: String
	public let icon: String

	public init(condition: String, icon: String) {
		self.condition = condition
		self.icon = icon
		super.init()
	}

	public enum CodingKeys: String, CodingKey {
		case condition = "description"
		case icon
	}
}

@objcMembers
@objc(CHSys)
public class CHSys: NSObject {
	public let sunrise: TimeInterval
	public let sunset: TimeInterval

	public init(sunrise: TimeInterval, sunset: TimeInterval) {
		self.sunrise = sunrise
		self.sunset = sunset
		super.init()
	}
}
