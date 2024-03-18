import Orion
import RhusC
import UIKit


private var weatherView: WeatherView!

class SBFLockScreenDateVCHook: ClassHook<UIViewController> {

	static let targetName = "SBFLockScreenDateViewController"

	@Property(.nonatomic, .retain) private var _weatherView = WeatherView()

	func viewDidLoad() {
		orig.viewDidLoad()

		weatherView = _weatherView

		_weatherView.translatesAutoresizingMaskIntoConstraints = false
		target.view.addSubview(_weatherView)

		_weatherView.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10).isActive = true
		_weatherView.centerXAnchor.constraint(equalTo: target.view.centerXAnchor).isActive = true
	}

	func viewWillAppear(_ animated: Bool) {
		orig.viewWillAppear(animated)
		weatherView.updateWeather()
	}

}

class SBBacklightControllerHook: ClassHook<NSObject> {

	static let targetName = "SBBacklightController"

	func turnOnScreenFullyWithBacklightSource(_ source: Int) {
		orig.turnOnScreenFullyWithBacklightSource(source)

		if !SBLockScreenManager.sharedInstance().isLockScreenVisible() { return }
		weatherView.updateWeather()
	}

}
