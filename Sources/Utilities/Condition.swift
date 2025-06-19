import Foundation

/// Enum that maps every weather code to a weather condition
@objc
public enum Condition: Int {
	case clearSky = 0
	case mainlyClear = 1
	case partlyCloudy = 2
	case overcast = 3
	case fog = 45
	case rimeFog = 48
	case lightDrizzle = 51
	case moderateDrizzle = 53
	case intenseDrizzle = 55
	case lightFreezingDrizzle = 56
	case intenseFreezingDrizzle = 57
	case lightRain = 61
	case moderateRain = 63
	case heavyRain = 65
	case lightFreezingRain = 66
	case heavyFreezingRain = 67
	case slightSnowFall = 71
	case moderateSnowFall = 73
	case heavySnowFall = 75
	case snowGrains = 77
	case slightRainShowers = 80
	case moderateRainShowers = 81
	case violentRainShowers = 82
	case slightSnowShowers = 85
	case heavySnowShowers = 86
	case thunderstorm = 95
	case thunderstormWithSlightHail = 96
	case thunderstormWithHeavyHail = 99

	public func unicode(isDay: Int) -> String {
		switch self {
			case .clearSky, .mainlyClear: return isDay == 1 ? "☀️" : "🌙"
			case .partlyCloudy: return "🌤️"
			case .overcast: return isDay == 1 ? "🌥️" : "☁️"
			case .fog, .rimeFog: return "🌫️"
			case .lightDrizzle, .moderateDrizzle, .intenseDrizzle, .lightRain, .moderateRain, .heavyRain,
				.slightRainShowers, .moderateRainShowers, .violentRainShowers: return isDay == 1 ? "🌦️" : "🌧️"

			case .lightFreezingDrizzle, .intenseFreezingDrizzle, .lightFreezingRain,
				.heavyFreezingRain, .slightSnowShowers, .heavySnowShowers: return "🌨️"

			case .slightSnowFall, .moderateSnowFall, .heavySnowFall, .snowGrains: return "❄️"
			case .thunderstorm, .thunderstormWithSlightHail, .thunderstormWithHeavyHail: return "⛈"
		}
	}
}
