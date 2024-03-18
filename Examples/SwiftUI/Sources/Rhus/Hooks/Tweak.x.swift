import Orion
import RhusC
import UIKit
import protocol SwiftUI.View
import class SwiftUI.UIHostingController


private var weatherViewViewModel: WeatherViewViewModel!

class SBFLockScreenDateVCHook: ClassHook<UIViewController> {

	static let targetName = "SBFLockScreenDateViewController"

	@Property(.nonatomic, .retain) private var _weatherViewViewModel = WeatherViewViewModel()

	func viewDidLoad() {
		orig.viewDidLoad()

		let vc = HostingController(rootView: WeatherView(viewModel: _weatherViewViewModel))
		vc.view.backgroundColor = .clear
		vc.view.translatesAutoresizingMaskIntoConstraints = false

		target.addChild(vc)
		target.view.addSubview(vc.view)

		vc.view.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10).isActive = true
		vc.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor).isActive = true
		vc.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor).isActive = true

		weatherViewViewModel = _weatherViewViewModel
	}

}

class CSCoverSheetVCHook: ClassHook<UIViewController> {

	static let targetName = "CSCoverSheetViewController"

	func viewWillAppear(_ animated: Bool) {
		orig.viewWillAppear(animated)
		weatherViewViewModel.updateWeather()
	}

}

class SBBacklightControllerHook: ClassHook<NSObject> {

	static let targetName = "SBBacklightController"

	func turnOnScreenFullyWithBacklightSource(_ source: Int) {
		orig.turnOnScreenFullyWithBacklightSource(source)

		if !SBLockScreenManager.sharedInstance().isLockScreenVisible() { return }
		NotificationCenter.default.post(name: .didRefreshWeatherDataNotification, object: nil)
	}

}

final class HostingController<Content>: UIHostingController<Content> where Content: View {

	override func _canShowWhileLocked() -> Bool {
		return true
	}

}
