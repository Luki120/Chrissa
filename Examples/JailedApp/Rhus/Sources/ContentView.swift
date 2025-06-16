import Chrissa
import Combine
import SwiftUI

struct ContentView: View {
	@State private var weather: String?
	@State private var locationName = ""
	@State private var subscriptions = Set<AnyCancellable>()

	var body: some View {
		VStack {
			if let weather {
				Text("\(locationName) | \(weather)ºC")

				Button("Refresh") {
					fetchWeather()
				}
			}
		}
		.onAppear {
			fetchWeather()
		}
		.padding()
	}

	private func fetchWeather() {
		do {
			try WeatherService.shared.fetchWeather()
				.map { $0 as Optional<Weather> }
				.replaceError(with: nil)
				.compactMap { $0 }
				.combineLatest(WeatherService.shared.$locationName)
				.receive(on: DispatchQueue.main)
				.sink { weather, locationName in
					withAnimation {
						self.weather = String(describing: weather.current.temperature)
						self.locationName = locationName
					}
				}
				.store(in: &subscriptions)

		}
		catch {
			NSLog("CHRISSA: \(error.localizedDescription)")
		}
	}
}
