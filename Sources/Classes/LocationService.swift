import CoreLocation

/// Manager class to handle fetching the user's location
internal final class LocationService: ObservableObject {

	private let manager = CLLocationManager.shared()

	@Published private(set) internal var latitude: CLLocationDegrees = 0
	@Published private(set) internal var longitude: CLLocationDegrees = 0

	/// Designated initializer
	internal init() {
		forceEnableLocation()
	}

	internal func startUpdatingLocation(_ startUpdating: Bool) {
		if startUpdating {
			manager?.startUpdatingLocation()
		}
		else {
			manager?.stopUpdatingLocation()
		}
	}

	internal func forceEnableLocation() {
		CLLocationManager.setAuthorizationStatus(true, forBundleIdentifier: "com.apple.springboard")

		guard let manager, let location = manager.location else { return }
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.startUpdatingLocation()

		latitude = location.coordinate.latitude
		longitude = location.coordinate.longitude

		manager.stopUpdatingLocation()
	}

}
