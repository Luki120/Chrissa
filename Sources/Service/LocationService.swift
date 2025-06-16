import CoreLocation

/// Singleton class to handle fetching the user's location
internal
final class LocationService: NSObject, ObservableObject {
	private let geoCoder = CLGeocoder()
	private let manager = CLLocationManager.shared()

	private var isSpringBoard: Bool {
		return Bundle.main.bundleIdentifier == "com.apple.springboard"
	}

	private lazy var locationManager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.allowsBackgroundLocationUpdates = true
		manager.pausesLocationUpdatesAutomatically = false
		return manager
	}()

	@Published private(set) internal var latitude: CLLocationDegrees = 0
	@Published private(set) internal var longitude: CLLocationDegrees = 0
	@Published private(set) internal var locationName = ""

	internal
	override init() {
		super.init()
		isSpringBoard ? forceEnableLocation() : fetchLocation()
	}

	internal func forceEnableLocation() {
		CLLocationManager.setAuthorizationStatus(true, forBundleIdentifier: "com.apple.springboard")

		guard let manager, let location = manager.location else { return }
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.startUpdatingLocation()

		latitude = location.coordinate.latitude
		longitude = location.coordinate.longitude

		manager.stopUpdatingLocation()
		fetchLocationName(for: location)
	}

	// ! Private

	private func fetchLocation() {
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
	}

	private func fetchLocationName(for location: CLLocation) {
		geoCoder.reverseGeocodeLocation(location) { placemarks, error in
			guard error == nil, let placemarks, let placemark = placemarks.first else { return }
			self.locationName = placemark.locality ?? "N/A"
		}
	}
}

// ! CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		latitude = location.coordinate.latitude
		longitude = location.coordinate.longitude

		locationManager.stopUpdatingLocation()
		fetchLocationName(for: location)
	}
}
