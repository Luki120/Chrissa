import SwiftUI

struct ContentView: View {
	@StateObject
	private var viewModel = WeatherViewViewModel()

	var body: some View {
		NavigationView {
			ZStack {
				Color(.systemGroupedBackground)
					.ignoresSafeArea()

				switch viewModel.weatherState {
					case .loaded: WeatherView(viewModel: viewModel)
					case .loading:
						VStack {
							ProgressView()
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.navigationBarTitle("Rhus", displayMode: .inline)
			.task {
				viewModel.fetchWeather()
			}
		}
	}
}
