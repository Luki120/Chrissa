import Orion
import RhusC
import UIKit


private var lsDateVC: SBFLockScreenDateVCHook!

class SBFLockScreenDateVCHook: ClassHook<UIViewController> {

	static let targetName = "SBFLockScreenDateViewController"

	private let weatherViewModel = WeatherViewModel()

	@Property(.nonatomic) private var weatherLabel = UILabel()

	func viewDidLoad() {
		orig.viewDidLoad()

		lsDateVC = self
		drawContent()

		weatherLabel.numberOfLines = 0
		weatherLabel.textAlignment = .center
		weatherLabel.translatesAutoresizingMaskIntoConstraints = false
		target.view.addSubview(weatherLabel)

		NSLayoutConstraint.activate([
			weatherLabel.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10),
			weatherLabel.leadingAnchor.constraint(equalTo: target.view.leadingAnchor),
			weatherLabel.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
		])
	}

	// orion:new
	func drawContent() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.weatherViewModel.updateWeather()
			self.weatherLabel.text = "\(self.weatherViewModel.name) | \(self.weatherViewModel.temperature)º"
		}
	}

	// orion:new
	func refreshContent() {
		DispatchQueue.main.async {
			self.weatherViewModel.updateWeather()
			self.weatherLabel.text = ""
			self.weatherLabel.text = "\(self.weatherViewModel.name) | \(self.weatherViewModel.temperature)º"
		}
	}

}

class CSCoverSheetVCHook: ClassHook<UIViewController> {

	static let targetName = "CSCoverSheetViewController"

	func viewWillAppear(_ animated: Bool) {
		orig.viewWillAppear(animated)
		lsDateVC.refreshContent()
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
		lsDateVC.refreshContent()
	}

}

// SwiftUI

/*
final class HostingController<Content>: UIHostingController<Content> where Content: View {

	override func _canShowWhileLocked() -> Bool {
		return true
	}

}

let vc = HostingController(rootView: WeatherView())
vc.view.backgroundColor = .clear
vc.view.translatesAutoresizingMaskIntoConstraints = false

target.addChild(vc)
target.view.addSubview(vc.view)

NSLayoutConstraint.activate([
	vc.view.topAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 10),
	vc.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor),
	vc.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor)
])
*/
