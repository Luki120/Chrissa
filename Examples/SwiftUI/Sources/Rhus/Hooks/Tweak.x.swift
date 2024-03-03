import Orion
import RhusC
import UIKit
import protocol SwiftUI.View
import class SwiftUI.UIHostingController


private var lsDateVC: SBFLockScreenDateVCHook!

class SBFLockScreenDateVCHook: ClassHook<UIViewController> {

	static let targetName = "SBFLockScreenDateViewController"

	@Property(.nonatomic) private(set) var weatherViewViewModel = WeatherViewViewModel()

	func viewDidLoad() {
		orig.viewDidLoad()

		lsDateVC = self

		let vc = HostingController(rootView: WeatherView(viewModel: weatherViewViewModel))
		vc.view.backgroundColor = .clear
		vc.view.translatesAutoresizingMaskIntoConstraints = false

		target.addChild(vc)
		target.view.addSubview(vc.view)

		NSLayoutConstraint.activate([
			vc.view.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10),
			vc.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor),
			vc.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
		])
	}

}

class CSCoverSheetVCHook: ClassHook<UIViewController> {

	static let targetName = "CSCoverSheetViewController"

	func viewWillAppear(_ animated: Bool) {
		orig.viewWillAppear(animated)
		lsDateVC.weatherViewViewModel.updateWeather()
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

		guard let SBLockScreenManager = NSClassFromString("SBLockScreenManager") else { return }

		if !SBLockScreenManager.sharedInstance().isLockScreenVisible() { return }
		NotificationCenter.default.post(name: .didRefreshWeatherDataNotification, object: nil)
	}

}

final class HostingController<Content>: UIHostingController<Content> where Content: View {

	override func _canShowWhileLocked() -> Bool {
		return true
	}

}
