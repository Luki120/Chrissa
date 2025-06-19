import Chrissa
import Combine
import func SwiftUI.withAnimation

/// View model class for `WeatherView`
final class WeatherViewViewModel: ObservableObject {
	// Current weather properties
	@Published private(set) var sunrise = ""
	@Published private(set) var sunset = ""
	@Published private(set) var condition = ""
	@Published private(set) var locationName = ""
	@Published private(set) var weatherTemperature = ""

	// Hourly weather properties	
	@Published private(set) var isDay = [Int]()
	@Published private(set) var hours = [TimeInterval]()
	@Published private(set) var temperatures = [Double]()
	@Published private(set) var weatherCodes = [Int]()
	@Published private(set) var precipitationProbabilities = [Double]()

	private(set) var weatherState: WeatherState = .loading
	private var subscriptions = Set<AnyCancellable>()

	enum WeatherState {
		case loading, loaded
	}
}

// ! Public

extension WeatherViewViewModel {
	/// Function to fetch weather data
	func fetchWeather() {
		do {
			weatherState = .loading

			try WeatherService.shared.fetchWeather()
				.map { $0 as Optional<Weather> }
				.replaceError(with: nil)
				.compactMap { $0 }
				.combineLatest(WeatherService.shared.$locationName)
				.receive(on: DispatchQueue.main)
				.sink { [weak self] weather, locationName in
					guard let self else { return }

					let sunriseDate = Date(timeIntervalSince1970: weather.daily.sunrise)
					let sunsetDate = Date(timeIntervalSince1970: weather.daily.sunset)					

					withAnimation {
						self.weatherTemperature = self.format(temperature: weather.current.temperature)
						self.locationName = locationName
						self.weatherState = .loaded

						if let index = weather.hourly.hours.firstIndex(where: {
							let hour = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: $0))
							return hour == Calendar.current.component(.hour, from: .now)
						}) {
							self.hours = weather.hourly.hours.rotated(startingAt: index)
							self.temperatures = weather.hourly.temperatures.rotated(startingAt: index)
							self.weatherCodes = weather.hourly.weatherCodes.rotated(startingAt: index)
							self.precipitationProbabilities = weather.hourly.precipitationProbabilities.rotated(startingAt: index)
							self.isDay = weather.hourly.isDay.rotated(startingAt: index)
						}

						self.sunrise = self.format(date: sunriseDate)
						self.sunset = self.format(date: sunsetDate)

						self.condition = self.getCondition(
							for: weather.current.weatherCode,
							isDay: weather.current.isDay
						)
					}
				}
				.store(in: &subscriptions)

		}
		catch {
			NSLog("CHRISSA: \(error.localizedDescription)")
		}
	}

	/// Function to get the current weather condition
	///
	/// - Parameters:
	///		- weatherCode: An `Int` that represents the weather code
	///		- isDay: An `Int` that represents wether it's day or night
	/// - Returns: `String`
	func getCondition(for weatherCode: Int, isDay: Int) -> String {
		guard let condition = Condition(rawValue: weatherCode) else { return "" }
		return condition.weatherImage(isDay: isDay)	
	}

	/// Function to format dates, either as "Sat, 1:00 AM" or just "1:00 AM"
	///
	/// - Parameters:
	///		- date: The `Date` object to format
	///		- includeWeekDay: `Bool` to include the weekday in the format or not
	/// - Returns: `String`
	func format(date: Date, includeWeekDay: Bool = false) -> String {
		let weekDay = date.formatted(.dateTime.weekday(.abbreviated))
		let time = date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute())

		return includeWeekDay ? weekDay + ", " + time : time
	}

	/// Function to format temperatures
	///
	/// - Parameter temperature: A `Double` that represents the temperature to format
	/// - Returns: `String`
	func format(temperature: Double) -> String {
		let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
		return measurement.formatted(
			.measurement(
				width: .abbreviated,
				usage: .weather,
				numberFormatStyle: .number.precision(.fractionLength(0))
			)
		)
	}
}

extension Condition {
	/// Function to get a system image name depending on the weather condition
	///
	/// - Parameter isDay: An `Int` that represents wether it's day or night
	/// - Returns: `String`
	func weatherImage(isDay: Int) -> String {
		switch self {
			case .clearSky, .mainlyClear: return isDay == 1 ? "sun.max.fill" : "moon.fill"
			case .partlyCloudy, .overcast: return isDay == 1 ? "cloud.sun.fill" : "cloud.moon.fill"
			case .fog, .rimeFog: return "cloud.fog.fill"
			case .lightDrizzle, .moderateDrizzle, .intenseDrizzle, .lightRain, .moderateRain, .heavyRain,
				.slightRainShowers, .moderateRainShowers, .violentRainShowers:
				return isDay == 1 ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill"

			case .lightFreezingDrizzle, .intenseFreezingDrizzle, .lightFreezingRain,
				.heavyFreezingRain, .slightSnowShowers, .heavySnowShowers: return "cloud.snow.fill"

			case .slightSnowFall, .moderateSnowFall, .heavySnowFall, .snowGrains: return "snowflake"
			case .thunderstorm, .thunderstormWithSlightHail, .thunderstormWithHeavyHail: return "cloud.bolt.rain.fill"
		}
	}
}

private extension Array {
	func rotated(startingAt index: Int) -> [Element] {
		guard !isEmpty, index >= 0, index < count else { return self }
		return Array(self[index...] + self[..<index])
	}
}
