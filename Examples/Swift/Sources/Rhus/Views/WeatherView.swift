import Combine
import UIKit

/// View that represents the weather
final class WeatherView: UIView {
	private let weatherViewModel = WeatherViewViewModel()

	private lazy var weatherLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		return label
	}()

	private lazy var sunriseSunsetStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 5
		stackView.alignment = .center
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		return stackView
	}()

	private var subscriptions = Set<AnyCancellable>()

	private var sunriseImageView, sunsetImageView: UIImageView!
	private var sunriseLabel, sunsetLabel: UILabel!

	// ! Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupSubscriptions()
	}

	// ! Private

	private func setupSubscriptions() {
		weatherViewModel.$weatherText
			.sink { [weak self] in self?.weatherLabel.text = $0 }
			.store(in: &subscriptions)

		weatherViewModel.$sunriseText
			.sink { [weak self] in self?.sunriseLabel.text = $0 }
			.store(in: &subscriptions)

		weatherViewModel.$sunsetText
			.sink { [weak self] in self?.sunsetLabel.text = $0 }
			.store(in: &subscriptions)
	}

	private func setupUI() {
		sunriseImageView = createImageView(withImage: UIImage(systemName: "sunrise.fill"))
		sunsetImageView = createImageView(withImage: UIImage(systemName: "sunset.fill"))

		sunriseLabel = createLabel()
		sunsetLabel = createLabel()

		[sunriseImageView, sunriseLabel, sunsetImageView, sunsetLabel].forEach {
			sunriseSunsetStackView.addArrangedSubview($0)
		}

		layoutUI()
	}

	private func layoutUI() {
		NSLayoutConstraint.activate([
			weatherLabel.topAnchor.constraint(equalTo: topAnchor),
			weatherLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			weatherLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

			sunriseSunsetStackView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5),
			sunriseSunsetStackView.centerXAnchor.constraint(equalTo: weatherLabel.centerXAnchor)
		])

		[sunriseImageView, sunsetImageView].forEach {
			$0.widthAnchor.constraint(equalToConstant: 25).isActive = true
			$0.heightAnchor.constraint(equalToConstant: 25).isActive = true
		}
	}

	// ! Reusable

	private func createImageView(withImage image: UIImage!) -> UIImageView {
		let imageView = UIImageView()
		imageView.image = image
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}

	private func createLabel() -> UILabel {
		let label = UILabel()
		return label
	}
}

// ! Public

extension WeatherView {
	/// Function to fetch weather data
	func updateWeather() {
		self.weatherViewModel.updateWeather()
	}
}
