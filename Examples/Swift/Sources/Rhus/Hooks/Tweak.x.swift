import Orion
import RhusC
import UIKit


private var lsDateVC: SBFLockScreenDateVCHook!

class SBFLockScreenDateVCHook: ClassHook<UIViewController> {

	static let targetName = "SBFLockScreenDateViewController"

	@Property(.nonatomic) private(set) var weatherView = WeatherView()

	func viewDidLoad() {
		orig.viewDidLoad()

		lsDateVC = self

		weatherView.translatesAutoresizingMaskIntoConstraints = false
		target.view.addSubview(weatherView)

		NSLayoutConstraint.activate([
			weatherView.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10),
			weatherView.leadingAnchor.constraint(equalTo: target.view.leadingAnchor),
			weatherView.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
		])
	}

}

class CSCoverSheetVCHook: ClassHook<UIViewController> {

	static let targetName = "CSCoverSheetViewController"

	func viewWillAppear(_ animated: Bool) {
		orig.viewWillAppear(animated)
		lsDateVC.weatherView.updateWeather()
		lsDateVC.weatherView.updateLabel()
	}

}

class SBLockScreenPluginManagerHook: ClassHook<NSObject> {

	static let targetName = "SBLockScreenPluginManager"

	func setEnabled(_ enabled: Bool) {
		orig.setEnabled(enabled)
		ScreenListener.sharedInstance.isScreenOff = !enabled
	}

}

class SBBacklightControllerHook: ClassHook<NSObject> {

	static let targetName = "SBBacklightController"

	func turnOnScreenFullyWithBacklightSource(_ source: Int) {
		orig.turnOnScreenFullyWithBacklightSource(source)
		lsDateVC.weatherView.updateWeather()
	}

}
