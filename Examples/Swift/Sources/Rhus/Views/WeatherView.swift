import UIKit


final class WeatherView: UIView {

	private let weatherViewModel = WeatherViewModel()

	private lazy var weatherLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		return label
	}()

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		NSLayoutConstraint.activate([
			weatherLabel.topAnchor.constraint(equalTo: topAnchor),
			weatherLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			weatherLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		])		
	}

	func updateWeather() {
		self.weatherViewModel.updateWeather()
	}

	func updateLabel() {
		DispatchQueue.main.async {
			self.weatherLabel.text = ""
			self.weatherLabel.text = "\(self.weatherViewModel.name) | \(self.weatherViewModel.temperature)º"
		}
	}

}
